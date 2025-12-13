<?php

class Router
{
    private $response;
    private $version;      // v1
    private $resource;     // products, users, upload, etc.
    private $id;           // ID hoặc sub-action
    private $subAction;    // action phụ
    private $method;       // GET, POST, PUT, DELETE

    // ===== DANH SÁCH ROUTES =====

    // Routes xác thực (không cần đăng nhập)
    private const AUTH_ROUTES = [
        'GET health' => ['HomeController', 'health'],
        'POST register' => ['AuthController', 'register'],
        'POST login' => ['AuthController', 'login'],
        'GET facebook' => ['SocialAuthController', 'facebookStart'],
        'GET facebook-callback' => ['SocialAuthController', 'facebookCallback'],
        'GET google' => ['SocialAuthController', 'googleStart'],
        'GET google-callback' => ['SocialAuthController', 'googleCallback'],
        'POST forgot-password/send-code' => ['ForgotPasswordController', 'sendCode'],
        'POST forgot-password/reset' => ['ForgotPasswordController', 'resetPassword'],
    ];

    // Routes user 
    private const USER_ROUTES = [
        'GET profile' => ['UserController', 'profile'],
        'PUT update' => ['UserController', 'update'],
        'PUT change-password' => ['UserController', 'changePassword'],
        'PUT update-role' => ['UserController', 'updateRole'],
    ];

    // Routes đặc biệt có pattern riêng
    private const SPECIAL_ROUTES = [
        // Home
        'GET home' => ['HomeController', 'index'],

        // Addresses
        'GET addresses/default' => ['AddressesController', 'default'],
        'PUT addresses/{id}/set-default' => ['AddressesController', 'setDefault'],

        // Orders
        'GET orders/admin' => ['OrdersController', 'admin'],
        'GET orders/statistics' => ['OrdersController', 'statistics'],
        'PUT orders/{id}/cancel' => ['OrdersController', 'cancel'],
        'PUT orders/{id}/status' => ['OrdersController', 'updateStatus'],
        'PUT orders/{id}/payment-status' => ['OrdersController', 'updatePaymentStatus'],

        // Users (Admin)
        'GET users' => ['UserController', 'index'],
        'GET users/{id}' => ['UserController', 'show'],
        'PUT users/{id}/status' => ['UserController', 'updateUserStatus'],

        // Cart
        'GET cart' => ['CartsController', 'index'],
        'POST cart/add' => ['CartsController', 'add'],
        'PUT cart/update' => ['CartsController', 'update'],
        'DELETE cart/remove' => ['CartsController', 'remove'],
        'POST cart/sync' => ['CartsController', 'sync'],
        'DELETE cart/clear' => ['CartsController', 'clear'],
        'GET cart/count' => ['CartsController', 'count'],

        // Shipping
        'GET shipping-methods' => ['ShippingMethodsController', 'index'],
        'GET shipping-methods/{id}' => ['ShippingMethodsController', 'show'],
        'POST shipping-methods' => ['ShippingMethodsController', 'store'],
        'PUT shipping-methods/{id}' => ['ShippingMethodsController', 'update'],
        'DELETE shipping-methods/{id}' => ['ShippingMethodsController', 'destroy'],
        'POST shipping-methods/calculate' => ['ShippingMethodsController', 'calculate'],
        'GET shipping-methods/admin' => ['ShippingMethodsController', 'admin'],

        // Products
        'GET products/featured' => ['ProductsController', 'featured'],
        'GET products/latest' => ['ProductsController', 'latest'],
        'GET products/category/{id}' => ['ProductsController', 'category'],
        'GET products/brand/{id}' => ['ProductsController', 'brand'],

        // Product Variants
        'GET product-variants/product/{id}' => ['ProductVariantsController', 'byProduct'],

        // Vouchers
        'POST vouchers/validate' => ['VouchersController', 'validate'],
        'POST vouchers/apply' => ['VouchersController', 'apply'],
        'GET vouchers/check/{id}' => ['VouchersController', 'check'],

        // Categories
        'GET categories/active' => ['CategoriesController', 'active'],

        // Brands
        'GET brands/active' => ['BrandsController', 'active'],

        // Reviews
        'GET reviews/product/{id}' => ['ReviewsController', 'byProduct'],
        'GET reviews/stats/{id}' => ['ReviewsController', 'stats'],
        'GET reviews/my-review/{id}' => ['ReviewsController', 'myReview'],

        // Post Categories
        'GET post-categories/active' => ['PostCategoriesController', 'active'],

        // Payments
        'POST payments/create' => ['PaymentController', 'create'],
        'POST payments/webhook' => ['PaymentController', 'webhook'],
        'GET payments/status/{id}' => ['PaymentController', 'status'],

        // Upload
        'POST upload/image' => ['UploadController', 'image'],
        'POST upload/images' => ['UploadController', 'images'],
        'DELETE upload/{key}' => ['UploadController', 'delete'],

        // Favorites
        'GET favorites/count' => ['FavoritesController', 'count'],
        'GET favorites/check/{id}' => ['FavoritesController', 'check'],
        'DELETE favorites/product/{id}' => ['FavoritesController', 'deleteByProduct'],
    ];

    // Map resource name -> Controller name
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
        'favorite' => 'Favorites',
        'favorites' => 'Favorites',
        'payment' => 'Payment',
        'payments' => 'Payment',
        'post-category' => 'PostCategories',
        'post-categories' => 'PostCategories',
        'post' => 'Posts',
        'posts' => 'Posts',
    ];


    public function __construct($uriSegments, $response)
    {
        $this->response = $response;
        $this->version = $uriSegments[1] ?? null;     // v1
        $this->resource = $uriSegments[2] ?? null;    // products
        $this->id = $uriSegments[3] ?? null;          // 123 hoặc action
        $this->subAction = $uriSegments[4] ?? null;   // action phụ
        $this->method = $_SERVER['REQUEST_METHOD'];   // GET, POST, PUT, DELETE

        if ($this->method === 'POST' && isset($_POST['_method'])) {
            $this->method = strtoupper($_POST['_method']);
        }
    }

    public function handleSpecialRoute()
    {
        $authKey = "{$this->method} {$this->resource}";
        if (isset(self::AUTH_ROUTES[$authKey])) {
            return $this->call(self::AUTH_ROUTES[$authKey]);
        }

        if ($this->resource && $this->id) {
            $authKeyWithAction = "{$this->method} {$this->resource}/{$this->id}";
            if (isset(self::AUTH_ROUTES[$authKeyWithAction])) {
                return $this->call(self::AUTH_ROUTES[$authKeyWithAction]);
            }
        }

        if ($this->resource === 'forgot-password' && $this->id) {
            $authKeyWithAction = "{$this->method} {$this->resource}/{$this->id}";
            if (isset(self::AUTH_ROUTES[$authKeyWithAction])) {
                return $this->call(self::AUTH_ROUTES[$authKeyWithAction]);
            }
        }

        if ($this->resource === 'user' && $this->id) {
            $userKey = "{$this->method} {$this->id}";
            if (isset(self::USER_ROUTES[$userKey])) {
                return $this->call(self::USER_ROUTES[$userKey]);
            }
        }

        $routeKey = $this->buildRouteKey();
        if (isset(self::SPECIAL_ROUTES[$routeKey])) {
            return $this->call(self::SPECIAL_ROUTES[$routeKey], $this->extractId($routeKey));
        }

        return false;
    }

    public function handleStandardRoute()
    {
        if (!$this->resource) return false;

        $controllerName = $this->getControllerName();
        $controller = $this->loadController($controllerName);
        if (!$controller) {
            return false;
        }

        if ($this->id && in_array($this->id, ['category', 'brand']) && $this->subAction) {
            return $this->execute($controller, $this->id, $this->subAction);
        }

        $action = $this->getCrudAction();
        if (!$action) {
            return false;
        }
        
        // Kiểm tra method tồn tại
        if (!method_exists($controller, $action)) {
            return false;
        }

        return $this->execute($controller, $action, $this->id);
    }


    private function buildRouteKey()
    {
        $parts = [$this->method, $this->resource];

        if ($this->id) {
            $parts[] = is_numeric($this->id) ? '{id}' : $this->id;
        }

        if ($this->subAction) {
            $parts[] = is_numeric($this->subAction) ? '{id}' : $this->subAction;
        }

        return $parts[0] . ' ' . implode('/', array_slice($parts, 1));
    }

    private function extractId($routeKey)
    {
        if (strpos($routeKey, '{id}') === false) {
            return null;
        }

        if ($this->subAction && is_numeric($this->subAction)) {
            return $this->subAction;
        }

        if ($this->id && is_numeric($this->id)) {
            return $this->id;
        }

        return null;
    }

    private function call($route, $param = null)
    {
        [$controllerName, $action] = $route;

        $controller = $this->loadController($controllerName);
        if (!$controller || !method_exists($controller, $action)) {
            return false;
        }

        return $this->execute($controller, $action, $param);
    }

    private function execute($controller, $action, $param = null)
    {
        try {
            if ($param !== null) {
                $controller->$action($param);
            } else {
                $data = $this->getRequestData();
                $controller->$action($data);
            }
            return true;
        } catch (\Exception $e) {
            $this->response->json(['error' => 'Lỗi: ' . $e->getMessage()], 500);
            return true;
        } catch (\Throwable $e) {
            $this->response->json(['error' => 'Lỗi: ' . $e->getMessage()], 500);
            return true;
        }
    }

    private function loadController($name)
    {
        try {
            $file = __DIR__ . "/../api/controllers/{$this->version}/{$name}.php";

            if (!file_exists($file)) {
                return null;
            }

            require_once $file;

            if (!class_exists($name)) {
                return null;
            }

            return new $name();
        } catch (\Exception $e) {
            return null;
        } catch (\Throwable $e) {
            return null;
        }
    }

    private function getControllerName()
    {
        if (isset(self::PLURAL_MAP[$this->resource])) {
            return self::PLURAL_MAP[$this->resource] . 'Controller';
        }

        $name = str_replace('-', '', ucwords($this->resource, '-'));
        return ucfirst($name) . 'Controller';
    }

    private function getCrudAction()
    {
        $map = [
            'GET' => $this->id ? 'show' : 'index',
            'POST' => 'store',
            'PUT' => $this->id ? 'update' : null,
            'DELETE' => $this->id ? 'destroy' : null,
        ];

        return $map[$this->method] ?? null;
    }


    private function getRequestData()
    {
        $contentType = $_SERVER['CONTENT_TYPE'] ?? '';
        $isJsonRequest = strpos(strtolower($contentType), 'application/json') !== false;

        $rawInput = file_get_contents("php://input");

        if (empty($rawInput)) {
            return null;
        }

        $data = json_decode($rawInput, true);
        if (json_last_error() === JSON_ERROR_NONE && $data !== null) {
            return $data;
        }

        if ($isJsonRequest) {
            $this->response->json(['error' => 'Invalid JSON: ' . json_last_error_msg()], 400);
            return null;
        }

        if (!empty($_POST)) {
            return (object)$_POST;
        }

        parse_str($rawInput, $data);
        return empty($data) ? null : (object)$data;
    }

}