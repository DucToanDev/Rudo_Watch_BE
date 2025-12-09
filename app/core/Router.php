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
        'POST auth/reset-password' => ['AuthController', 'resetPassword'],
        'GET facebook'      => ['SocialAuthController', 'facebookStart'],
        'GET facebook-callback' => ['SocialAuthController', 'facebookCallback'],
        'GET google'        => ['SocialAuthController', 'googleStart'],
        'GET google-callback' => ['SocialAuthController', 'googleCallback'],
        // Forgot password
        'POST forgot-password/send-code' => ['ForgotPasswordController', 'sendCode'],
        'POST forgot-password/reset'     => ['ForgotPasswordController', 'resetPassword'],
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
        // Home
        'GET home'                      => ['HomeController', 'index'],

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
        'GET cart'          => ['CartsController', 'index'],
        'POST cart/add'     => ['CartsController', 'add'],
        'PUT cart/update'   => ['CartsController', 'update'],
        'DELETE cart/remove' => ['CartsController', 'remove'],
        'POST cart/sync'    => ['CartsController', 'sync'],
        'DELETE cart/clear' => ['CartsController', 'clear'],
        'GET cart/count'    => ['CartsController', 'count'],

        // Shipping
        'GET shipping-methods'            => ['ShippingMethodsController', 'index'],
        'GET shipping-methods/{id}'       => ['ShippingMethodsController', 'show'],
        'POST shipping-methods'           => ['ShippingMethodsController', 'store'],
        'PUT shipping-methods/{id}'       => ['ShippingMethodsController', 'update'],
        'DELETE shipping-methods/{id}'    => ['ShippingMethodsController', 'destroy'],
        'POST shipping-methods/calculate' => ['ShippingMethodsController', 'calculate'],
        'GET shipping-methods/admin'      => ['ShippingMethodsController', 'admin'],

        // Products
        'GET products/featured'           => ['ProductsController', 'featured'],
        'GET products/latest'             => ['ProductsController', 'latest'],
        'GET products/category/{id}'      => ['ProductsController', 'category'],
        'GET products/brand/{id}'         => ['ProductsController', 'brand'],

        // Product Variants
        'GET product-variants/product/{id}' => ['ProductVariantsController', 'byProduct'],

        // Vouchers
        'POST vouchers/validate' => ['VouchersController', 'validate'],
        'POST vouchers/apply'    => ['VouchersController', 'apply'],
        'GET vouchers/check/{id}' => ['VouchersController', 'check'],

        // Categories
        'GET categories/active'  => ['CategoriesController', 'active'],

        // Brands
        'GET brands/active'      => ['BrandsController', 'active'],

        // Reviews
        'GET reviews/product/{id}'    => ['ReviewsController', 'byProduct'],
        'GET reviews/stats/{id}'      => ['ReviewsController', 'stats'],
        'GET reviews/my-review/{id}'  => ['ReviewsController', 'myReview'],

        // Post Categories
        'GET post-categories/active'  => ['PostCategoriesController', 'active'],

        // Payments
        'POST payments/create'        => ['PaymentController', 'create'],
        'POST payments/webhook'        => ['PaymentController', 'webhook'],
        'GET payments/status/{id}'    => ['PaymentController', 'status'],

        // Upload
        'POST upload/image'            => ['UploadController', 'image'],
        'POST upload/images'           => ['UploadController', 'images'],
        'DELETE upload/{key}'          => ['UploadController', 'delete'],
    ];

    // Chuyển đổi resource số ít -> số nhiều
    private const PLURAL_MAP = [
        'cart' => 'Carts',
        'category' => 'Categories',
        'categories' => 'Categories',
        'brand' => 'Brands',
        'brands' => 'Brands',
        'address' => 'Addresses',
        'addresses' => 'Addresses',
        'order' => 'Orders',
        'orders' => 'Orders',
        'users' => 'User',
        'user' => 'User',
        'product' => 'Products',
        'products' => 'Products',
        'product-variants' => 'ProductVariants',
        'voucher' => 'Vouchers',
        'vouchers' => 'Vouchers',
        'shipping-methods' => 'ShippingMethods',
        'review' => 'Reviews',
        'reviews' => 'Reviews',
        'payment' => 'Payment',
        'payments' => 'Payment',
        'post-category' => 'PostCategories',
        'post-categories' => 'PostCategories',
        'post' => 'Posts',
        'posts' => 'Posts',
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
        // Kiểm tra route đơn giản trước (không có sub-action)
        $authKey = "{$this->method} {$this->resource}";
        if (isset(self::AUTH_ROUTES[$authKey])) {
            return $this->call(self::AUTH_ROUTES[$authKey]);
        }

        // 1b. Auth routes với sub-action: POST /forgot-password/send-code, POST /forgot-password/reset
        if ($this->resource && $this->id) {
            $authKeyWithAction = "{$this->method} {$this->resource}/{$this->id}";
            if (isset(self::AUTH_ROUTES[$authKeyWithAction])) {
                return $this->call(self::AUTH_ROUTES[$authKeyWithAction]);
            }
        }
        
        // 1c. Kiểm tra lại với resource có dấu gạch ngang (forgot-password)
        // Đảm bảo route được match đúng
        if ($this->resource === 'forgot-password' && $this->id) {
            $authKeyWithAction = "{$this->method} {$this->resource}/{$this->id}";
            if (isset(self::AUTH_ROUTES[$authKeyWithAction])) {
                return $this->call(self::AUTH_ROUTES[$authKeyWithAction]);
            }
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
        } catch (\Exception $e) {
            error_log('Router execute exception: ' . $e->getMessage());
            error_log('Stack trace: ' . $e->getTraceAsString());
            $this->response->json(['error' => 'Lỗi: ' . $e->getMessage()], 500);
            return true;
        } catch (\Throwable $e) {
            error_log('Router execute throwable: ' . $e->getMessage());
            error_log('Stack trace: ' . $e->getTraceAsString());
            $this->response->json(['error' => 'Lỗi: ' . $e->getMessage()], 500);
            return true;
        }
    }

    /**
     * Load controller file
     */
    private function loadController($name)
    {
        try {
            $file = __DIR__ . "/../api/controllers/{$this->version}/{$name}.php";
            if (!file_exists($file)) {
                error_log("Controller file not found: $file");
                return null;
            }

            require_once $file;
            
            if (!class_exists($name)) {
                error_log("Controller class not found: $name");
                return null;
            }
            
            return new $name();
        } catch (\Exception $e) {
            error_log("Error loading controller $name: " . $e->getMessage());
            error_log("Stack trace: " . $e->getTraceAsString());
            return null;
        } catch (\Throwable $e) {
            error_log("Error loading controller $name: " . $e->getMessage());
            error_log("Stack trace: " . $e->getTraceAsString());
            return null;
        }
    }

    /**
     * Lấy tên Controller từ resource
     */
    private function getControllerName()
    {
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