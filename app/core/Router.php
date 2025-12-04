<?php

class Router
{
    private $response;
    private $version;
    private $resource;
    private $id;
    private $subAction;
    private $method;

    // ===== CẤU HÌNH ROUTES =====

    // Routes không cần ID (public)
    private const AUTH_ROUTES = [
        'POST register'     => ['AuthController', 'register'],
        'POST login'        => ['AuthController', 'login'],
        'GET facebook'      => ['SocialAuthController', 'facebookStart'],
        'GET facebook-callback' => ['SocialAuthController', 'facebookCallback'],
        'GET google'        => ['SocialAuthController', 'googleStart'],
        'GET google-callback' => ['SocialAuthController', 'googleCallback'],
    ];

    // Routes /user/{action}
    private const USER_ROUTES = [
        'GET profile'       => ['UserController', 'profile'],
        'PUT update'        => ['UserController', 'update'],
        'PUT change-password' => ['UserController', 'changePassword'],
        'PUT update-role'   => ['UserController', 'updateRole'],
    ];

    // Routes đặc biệt có pattern riêng
    private const SPECIAL_ROUTES = [
        // Addresses
        'GET addresses/default'         => ['AddressesController', 'default'],
        'PUT addresses/{id}/set-default' => ['AddressesController', 'setDefault'],

        // Orders (Admin)
        'GET orders/admin'              => ['OrdersController', 'admin'],
        'GET orders/statistics'         => ['OrdersController', 'statistics'],
        'PUT orders/{id}/cancel'        => ['OrdersController', 'cancel'],
        'PUT orders/{id}/status'        => ['OrdersController', 'updateStatus'],
        'PUT orders/{id}/payment-status' => ['OrdersController', 'updatePaymentStatus'],

        // Users (Admin)
        'GET users'                     => ['UserController', 'index'],
        'GET users/{id}'                => ['UserController', 'show'],
        'PUT users/{id}/status'         => ['UserController', 'updateUserStatus'],

        // Cart
        'POST cart/add'     => ['CartsController', 'add'],
        'PUT cart/update'   => ['CartsController', 'update'],
        'DELETE cart/remove' => ['CartsController', 'remove'],
        'POST cart/sync'    => ['CartsController', 'sync'],
        'DELETE cart/clear' => ['CartsController', 'clear'],
        'GET cart/count'    => ['CartsController', 'count'],

        // Shipping
        'POST shipping-methods/calculate' => ['ShippingMethodsController', 'calculate'],
        'GET shipping-methods/admin'      => ['ShippingMethodsController', 'admin'],

        // Products
        'GET products/featured' => ['ProductsController', 'featured'],
        'GET products/latest'   => ['ProductsController', 'latest'],
    ];

    // Chuyển đổi resource số ít -> số nhiều
    private const PLURAL_MAP = [
        'cart' => 'Carts',
        'category' => 'Categories',
        'brand' => 'Brands',
        'address' => 'Addresses',
        'order' => 'Orders',
        'orders' => 'Orders',
        'users' => 'User',
    ];

    // ===== CONSTRUCTOR =====

    public function __construct($uriSegments, $response)
    {
        $this->response = $response;
        $this->version = $uriSegments[1] ?? null;     // v1
        $this->resource = $uriSegments[2] ?? null;    // products, users, etc
        $this->id = $uriSegments[3] ?? null;          // ID hoặc sub-action
        $this->subAction = $uriSegments[4] ?? null;   // action phụ
        $this->method = $_SERVER['REQUEST_METHOD'];

        // Hỗ trợ method override cho form-data (POST với _method=PUT/DELETE)
        if ($this->method === 'POST' && isset($_POST['_method'])) {
            $this->method = strtoupper($_POST['_method']);
        }
    }

    // ===== XỬ LÝ ROUTES ĐẶC BIỆT =====

    public function handleSpecialRoute()
    {
        // 1. Auth routes: POST /register, POST /login, GET /facebook...
        $authKey = "{$this->method} {$this->resource}";
        if (isset(self::AUTH_ROUTES[$authKey])) {
            return $this->call(self::AUTH_ROUTES[$authKey]);
        }

        // 2. User routes: GET /user/profile, PUT /user/update...
        if ($this->resource === 'user' && $this->id) {
            $userKey = "{$this->method} {$this->id}";
            if (isset(self::USER_ROUTES[$userKey])) {
                return $this->call(self::USER_ROUTES[$userKey]);
            }
        }

        // 3. Special routes với patterns
        $routeKey = $this->buildRouteKey();
        if (isset(self::SPECIAL_ROUTES[$routeKey])) {
            return $this->call(self::SPECIAL_ROUTES[$routeKey], $this->extractId($routeKey));
        }

        return false;
    }

    // ===== XỬ LÝ ROUTES CRUD CHUẨN =====

    public function handleStandardRoute()
    {
        if (!$this->resource) return false;

        $controller = $this->loadController($this->getControllerName());
        if (!$controller) return false;

        // Xử lý sub-resource: GET /products/category/1
        if ($this->id && in_array($this->id, ['category', 'brand']) && $this->subAction) {
            return $this->execute($controller, $this->id, $this->subAction);
        }

        // CRUD chuẩn
        $action = $this->getCrudAction();
        if (!$action || !method_exists($controller, $action)) {
            return false;
        }

        return $this->execute($controller, $action, $this->id);
    }

    // ===== HELPER METHODS =====

    /**
     * Build route key từ URL hiện tại
     * VD: "GET orders/admin", "PUT users/{id}/status"
     */
    private function buildRouteKey()
    {
        $parts = [$this->method, $this->resource];

        if ($this->id) {
            // Nếu id là số -> thay bằng {id}
            $parts[] = is_numeric($this->id) ? '{id}' : $this->id;
        }

        if ($this->subAction) {
            $parts[] = $this->subAction;
        }

        return $parts[0] . ' ' . implode('/', array_slice($parts, 1));
    }

    /**
     * Lấy ID từ URL nếu route có {id}
     */
    private function extractId($routeKey)
    {
        return strpos($routeKey, '{id}') !== false ? $this->id : null;
    }

    /**
     * Gọi controller/action
     */
    private function call($route, $param = null)
    {
        [$controllerName, $action] = $route;

        $controller = $this->loadController($controllerName);
        if (!$controller || !method_exists($controller, $action)) {
            return false;
        }

        return $this->execute($controller, $action, $param);
    }

    /**
     * Thực thi action
     */
    private function execute($controller, $action, $param = null)
    {
        try {
            if ($param !== null) {
                $controller->$action($param);
            } else {
                $data = json_decode(file_get_contents("php://input"));
                $controller->$action($data);
            }
            return true;
        } catch (Exception $e) {
            $this->response->json(['error' => 'Lỗi: ' . $e->getMessage()], 500);
            return true;
        }
    }

    /**
     * Load controller file
     */
    private function loadController($name)
    {
        $file = __DIR__ . "/../api/controllers/{$this->version}/{$name}.php";
        if (!file_exists($file)) return null;

        require_once $file;
        return new $name();
    }

    /**
     * Lấy tên Controller từ resource
     */
    private function getControllerName()
    {
        // Check plural map
        if (isset(self::PLURAL_MAP[$this->resource])) {
            return self::PLURAL_MAP[$this->resource] . 'Controller';
        }

        // product-variants -> ProductVariantsController
        $name = str_replace('-', '', ucwords($this->resource, '-'));
        return ucfirst($name) . 'Controller';
    }

    /**
     * Map HTTP method -> CRUD action
     */
    private function getCrudAction()
    {
        $map = [
            'GET'    => $this->id ? 'show' : 'index',
            'POST'   => 'store',
            'PUT'    => $this->id ? 'update' : null,
            'DELETE' => $this->id ? 'destroy' : null,
        ];

        return $map[$this->method] ?? null;
    }
}
