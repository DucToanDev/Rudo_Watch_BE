<?php
require_once __DIR__ . '/../../../models/UserModel.php';
require_once __DIR__ . '/../../../models/PasswordResetModel.php';
require_once __DIR__ . '/../../../core/Response.php';

class AuthController
{
    private $userModel;
    private $passwordResetModel;
    private $response;

    public function __construct()
    {
        try {
            $this->userModel = new Users();
            $this->passwordResetModel = new PasswordResetModel();
            $this->response = new Response();
        } catch (\Exception $e) {
            error_log('AuthController constructor error: ' . $e->getMessage());
            error_log('Stack trace: ' . $e->getTraceAsString());
            throw $e;
        }
    }

    //register
    public function register($data)
    {
        if (empty($data->fullname) || empty($data->email) || empty($data->password)) {
            $this->response->json([
                'error' => 'Vui lòng điền đầy đủ thông tin'
            ], 400);
            return;
        }

        if (!filter_var($data->email, FILTER_VALIDATE_EMAIL)) {
            $this->response->json([
                'error' => 'Email không hợp lệ'
            ], 400);
            return;
        }

        if (strlen($data->password) < 6) {
            $this->response->json([
                'error' => 'Mật khẩu phải có ít nhất 6 ký tự'
            ], 400);
            return;
        }

        $result = $this->userModel->create([
            'fullname' => $data->fullname,
            'email' => $data->email,
            'password' => $data->password,
            'phone' => $data->phone ?? null
        ]);

        if ($result['success']) {
            $this->response->json([
                'message' => $result['message'],
                'user' => $result['user'],
                'token' => $result['token']
            ], 201);
        } else {
            $this->response->json([
                'error' => $result['message']
            ], 400);
        }
    }

    // login
    public function login($data)
    {
        if (empty($data->email) || empty($data->password)) {
            $this->response->json([
                'error' => 'Vui lòng điền đầy đủ thông tin'
            ], 400);
            return;
        }

        $result = $this->userModel->login($data->email, $data->password);

        if ($result['success']) {
            $this->response->json([
                'message' => $result['message'],
                'user' => $result['user'],
                'token' => $result['token']
            ], 200);
        } else {
            $this->response->json([
                'error' => $result['message']
            ], 401);
        }
    }

    /**
     * Reset password using token (from email link)
     */
    public function resetPassword($data)
    {
        try {
            // Log để debug
            error_log('AuthController::resetPassword called with data: ' . json_encode($data));
            
            if (!$data) {
                error_log('AuthController::resetPassword - data is null or empty');
                $this->response->json(['error' => 'Vui lòng điền đầy đủ thông tin'], 400);
                return;
            }

            if (empty($data->token) || empty($data->password)) {
                error_log('AuthController::resetPassword - missing token or password');
                $this->response->json(['error' => 'Vui lòng điền đầy đủ thông tin'], 400);
                return;
            }

            if (isset($data->password_confirmation) && $data->password !== $data->password_confirmation) {
                $this->response->json(['error' => 'Mật khẩu xác nhận không khớp'], 400);
                return;
            }

            if (strlen($data->password) < 8) {
                $this->response->json(['error' => 'Mật khẩu phải có ít nhất 8 ký tự'], 400);
                return;
            }

            // Find reset record by token
            error_log('AuthController::resetPassword - looking for token: ' . $data->token);
            $resetRecord = $this->passwordResetModel->findByToken($data->token);
            
            if (!$resetRecord) {
                error_log('AuthController::resetPassword - token not found or expired');
                $this->response->json([
                    'error' => 'Token không hợp lệ hoặc đã hết hạn. Vui lòng yêu cầu link mới.'
                ], 400);
                return;
            }

            error_log('AuthController::resetPassword - token found for email: ' . $resetRecord['email']);

            // Update password
            $result = $this->userModel->updatePasswordByEmail($resetRecord['email'], $data->password);
            
            if ($result === true) {
                error_log('AuthController::resetPassword - password updated successfully');
                
                // Mark token as used
                $this->passwordResetModel->markAsUsed($resetRecord['id']);
                
                // Delete all reset tokens for this email
                $this->passwordResetModel->deleteByEmail($resetRecord['email']);
                
                $this->response->json([
                    'message' => 'Password reset successful'
                ], 200);
            } else {
                error_log('AuthController::resetPassword - failed to update password');
                $this->response->json([
                    'error' => 'Đặt lại mật khẩu thất bại. Vui lòng thử lại.'
                ], 500);
            }
        } catch (\Exception $e) {
            error_log('AuthController::resetPassword exception: ' . $e->getMessage());
            error_log('Stack trace: ' . $e->getTraceAsString());
            $this->response->json([
                'error' => 'Lỗi server: ' . $e->getMessage()
            ], 500);
        } catch (\Throwable $e) {
            error_log('AuthController::resetPassword throwable: ' . $e->getMessage());
            error_log('Stack trace: ' . $e->getTraceAsString());
            $this->response->json([
                'error' => 'Lỗi server: ' . $e->getMessage()
            ], 500);
        }
    }
}