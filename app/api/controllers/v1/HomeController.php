<?php 
require_once __DIR__ . '/../../../models/ProductModel.php';
require_once __DIR__ . '/../../../models/PostModel.php';
require_once __DIR__ . '/../../../core/Response.php';

class HomeController
{
    private $productModel;
    private $postModel;
    private $response;

    public function __construct()
    {
        $this->productModel = new Products();
        $this->postModel = new Posts();
        $this->response = new Response();
    }

    public function health()
    {
        $this->response->json([
            'status' => 'ok',
            'message' => 'Server is running',
            'timestamp' => date('Y-m-d H:i:s'),
            'php_version' => PHP_VERSION
        ], 200);
    }

    public function index()
    {
        try {
            $latestLimit = isset($_GET['latest_limit']) ? (int)$_GET['latest_limit'] : 8;
            $featuredLimit = isset($_GET['featured_limit']) ? (int)$_GET['featured_limit'] : 8;
            $topLimit = isset($_GET['top_limit']) ? (int)$_GET['top_limit'] : 8;
            $postsLimit = isset($_GET['posts_limit']) ? (int)$_GET['posts_limit'] : 4;

            $latestProducts = $this->productModel->getLatest($latestLimit);
            $featuredProducts = $this->productModel->getFeatured($featuredLimit);
            $topProducts = $this->productModel->getTopProducts($topLimit);
            $posts = $this->postModel->getAll($postsLimit);

            $this->response->json([
                'latest_products' => $latestProducts,
                'featured_products' => $featuredProducts,
                'top_products' => $topProducts,
                'posts' => $posts
            ], 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }
}