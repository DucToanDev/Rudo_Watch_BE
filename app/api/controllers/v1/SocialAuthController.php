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
        try {
            // 1. Lấy token
            $token = $this->fbModel->getAccessToken();
            if (!$token) {
                return $this->response->json([
                    'success' => false,
                    'login_url' => $this->fbModel->getLoginUrl(),
                    'message' => 'Cần đăng nhập Facebook'
                ]);
            }

            // 2. Lấy thông tin FB user
            $fbUser = $this->fbModel->getFacebookUser($token);
            if (empty($fbUser['email'])) {
                return $this->response->json([
                    'success' => false,
                    'message' => 'Không có email từ Facebook'
                ], 400);
            }

            // 3. Tìm hoặc tạo user
            $result = $this->fbModel->findOrCreateUser($fbUser);
            if (isset($result['error'])) {
                return $this->response->json([
                    'success' => false,
                    'message' => $result['error']
                ], 500);
            }

            // 4. Trả về user
            return $this->response->json([
                'success' => true,
                'message' => $result['is_new'] ? 'Đăng ký thành công' : 'Đăng nhập thành công',
                'user' => $result['user'],
                'token' => $result['user']['api_token']
            ], $result['is_new'] ? 201 : 200);
        } catch (Exception $e) {
            return $this->response->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
