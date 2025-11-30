<?php
require_once __DIR__ . '/../../../models/LoginWithFacebook.php';
require_once __DIR__ . '/../../../core/Response.php';

class SocialAuthController
{
    private $fbModel;
    private $response;

    public function __construct()
    {
        $this->fbModel = new LoginWithFacebook();
        $this->response = new Response();
    }

    // Lấy Facebook login URL
    public function facebookStart($data)
    {
        try {
            $loginUrl = $this->fbModel->getLoginUrl();
            return $this->response->json([
                'success' => true,
                'needsRedirect' => true,
                'login_url' => $loginUrl
            ]);
        } catch (Exception $e) {
            return $this->response->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // Xử lý callback từ Facebook
    public function facebookCallback($data)
    {
        // URL frontend
        $frontendUrl = $_ENV['FRONTEND_URL'] ?? 'https://rudo-watch.vercel.app';

        try {
            // 1. Lấy token
            $token = $this->fbModel->getAccessToken();
            if (!$token) {
                header("Location: {$frontendUrl}/login.html?error=no_token");
                exit;
            }

            // 2. Lấy thông tin FB user
            $fbUser = $this->fbModel->getFacebookUser($token);
            if (empty($fbUser['email'])) {
                header("Location: {$frontendUrl}/login.html?error=no_email");
                exit;
            }

            // 3. Tìm hoặc tạo user
            $result = $this->fbModel->findOrCreateUser($fbUser);
            if (isset($result['error'])) {
                header("Location: {$frontendUrl}/login.html?error=create_failed");
                exit;
            }

            // 4. Redirect về frontend với token
            $userToken = $result['user']['api_token'];
            $userData = urlencode(json_encode($result['user']));
            header("Location: {$frontendUrl}/login.html?token={$userToken}&user={$userData}");
            exit;
        } catch (Exception $e) {
            header("Location: {$frontendUrl}/login.html?error=" . urlencode($e->getMessage()));
            exit;
        }
    }
}
