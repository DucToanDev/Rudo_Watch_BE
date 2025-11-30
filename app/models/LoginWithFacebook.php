<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../core/Response.php';
require_once __DIR__ . '/../../config/function.php';
require_once __DIR__ . '/UserModel.php';

require_once __DIR__ . '/../../vendor/facebook/graph-sdk/src/Facebook/autoload.php';
//them thu vien
use Facebook\Facebook;
use Facebook\Exceptions\FacebookResponseException;
use Facebook\Exceptions\FacebookSDKException;

class LoginWithFacebook
{
    private $conn;
    public $response;

    public function __construct()
    {
        $databse = new Database();
        $this->conn = $databse->getConnection();

        $this->response = new Response();
    }

    public function facebookLogin()
    {
        $fb = new Facebook(array(
            'app_id' => $_ENV['FB_APP_ID'],
            'app_secret' => $_ENV['FB_APP_SECRET'],
            'default_graph_version' => 'v3.2',
        ));

        $helper = $fb->getRedirectLoginHelper();

        try {
            if (session_status() !== PHP_SESSION_ACTIVE) {
                session_start();
            }

            if (isset($_SESSION['facebook_access_token'])) {
                $accessToken = $_SESSION['facebook_access_token'];
            } else {
                $accessToken = $helper->getAccessToken();
            }

            // If no token available, return the FB login url so controller can redirect
            if (empty($accessToken)) {
                $permissions = ['email']; // request email access
                $loginUrl = $helper->getLoginUrl((isset($_ENV['FB_REDIRECT_URI']) ? $_ENV['FB_REDIRECT_URI'] : ''), $permissions);

                return $this->response->json([
                    'success' => false,
                    'needsRedirect' => true,
                    'login_url' => (string)$loginUrl,
                    'message' => 'Cần chuyển hướng tới Facebook để đăng nhập'
                ], 200);
            }

            // Make token long-lived if necessary
            $oAuth2Client = $fb->getOAuth2Client();
            if (!$accessToken->isLongLived()) {
                try {
                    $accessToken = $oAuth2Client->getLongLivedAccessToken($accessToken);
                } catch (FacebookSDKException $e) {
                    // if we can't exchange, continue with short lived token
                }
            }

            // Persist token in session
            $_SESSION['facebook_access_token'] = (string)$accessToken;

            // Set default access token for future requests
            $fb->setDefaultAccessToken((string)$accessToken);

            // Fetch basic profile data
            $profileResponse = $fb->get('/me?fields=id,name,email,picture.width(300).height(300)');
            $fbUser = $profileResponse->getGraphUser();

            $fbId = $fbUser->getId() ?? null;
            $fullname = $fbUser->getName() ?? '';
            $email = $fbUser->getEmail() ?? null;
            $picture = null;
            if ($fbUser->getField('picture')) {
                $picture = $fbUser->getField('picture')->getUrl() ?? null;
            }

            if (empty($email)) {
                return $this->response->json([
                    'success' => false,
                    'message' => 'Không tìm thấy email từ Facebook. Vui lòng cấp quyền email cho ứng dụng.'
                ], 400);
            }

            // Check existing user by email
            $query = "SELECT id, fullname, email, phone, role, status, api_token FROM users WHERE email = :email LIMIT 1";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':email', $email);
            $stmt->execute();

            if ($stmt->rowCount() > 0) {
                $user = $stmt->fetch(PDO::FETCH_ASSOC);

                if (empty($user['api_token'])) {
                    $apiToken = bin2hex(random_bytes(32));
                    update($this->conn, 'users', ['api_token' => $apiToken], $user['id']);
                    $user['api_token'] = $apiToken;
                }

                // Return existing user
                return $this->response->json([
                    'success' => true,
                    'message' => 'Đăng nhập thành công',
                    'user' => $user,
                    'token' => $user['api_token']
                ], 200);
            } else {
                // Create new user
                $newToken = bin2hex(random_bytes(32));
                // generate a random password (not meaningful) so DB non-null constraint satisfied
                $randomPassword = bin2hex(random_bytes(8));

                $insertData = [
                    'fullname' => $fullname ?: 'Facebook User',
                    'email' => $email,
                    'password' => password_hash($randomPassword, PASSWORD_DEFAULT),
                    'phone' => null,
                    'role' => 0,
                    'status' => 1,
                    'api_token' => $newToken
                ];

                $userId = insert($this->conn, 'users', $insertData);

                if ($userId) {
                    $createdUser = (new Users())->getById($userId);
                    return $this->response->json([
                        'success' => true,
                        'message' => 'Tạo tài khoản và đăng nhập thành công',
                        'user' => $createdUser,
                        'token' => $newToken
                    ], 201);
                }

                return $this->response->json([
                    'success' => false,
                    'message' => 'Không thể tạo người dùng mới'
                ], 500);
            }
        } catch (FacebookResponseException $e) {
            return $this->response->json(['success' => false, 'message' => 'Facebook response error: ' . $e->getMessage()], 500);
        } catch (FacebookSDKException $e) {
            return $this->response->json(['success' => false, 'message' => 'Facebook SDK error: ' . $e->getMessage()], 500);
        } catch (Exception $e) {
            return $this->response->json(['success' => false, 'message' => 'Lỗi hệ thống: ' . $e->getMessage()], 500);
        }
    }
}