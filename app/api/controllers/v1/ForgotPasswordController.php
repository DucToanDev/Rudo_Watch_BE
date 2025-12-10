<?php
require_once __DIR__ . '/../../../models/UserModel.php';
require_once __DIR__ . '/../../../models/PasswordResetModel.php';
require_once __DIR__ . '/../../../core/Response.php';
require_once __DIR__ . '/../../../services/MailService.php';

class ForgotPasswordController
{
    private $userModel;
    private $passwordResetModel;
    private $response;
    private $mailService;

    public function __construct()
    {
        try {
            $this->userModel = new Users();
            $this->passwordResetModel = new PasswordResetModel();
            $this->response = new Response();
            $this->mailService = new MailService();
        } catch (\Exception $e) {
            throw $e;
        } catch (\Throwable $e) {
            throw $e;
        }
    }

    /**
     * Gửi mã xác thực về email để đặt lại mật khẩu
     */
    public function sendCode($data)
    {
        try {
            if (!$data || empty($data->email)) {
                $this->response->json(['error' => 'Vui lòng nhập email'], 400);
                return;
            }

            if (!filter_var($data->email, FILTER_VALIDATE_EMAIL)) {
                $this->response->json(['error' => 'Email không hợp lệ'], 400);
                return;
            }

            $recentCount = $this->passwordResetModel->getRecentRequestCount($data->email, 5);
            if ($recentCount >= 3) {
                $this->response->json([
                    'error' => 'Bạn đã yêu cầu quá nhiều lần. Vui lòng đợi 5 phút trước khi thử lại.'
                ], 429);
                return;
            }

            $user = $this->userModel->findByEmail($data->email);
            if (!$user) {
                $this->response->json([
                    'message' => 'Địa chỉ email không tồn tại!'
                ], 200);
                return;
            }

            $code = str_pad(rand(0, 999999), 6, '0', STR_PAD_LEFT);
            $tokenResult = $this->passwordResetModel->createToken($data->email, $code);
            
            if (!$tokenResult || !$tokenResult['success']) {
                $errorMsg = isset($tokenResult['message']) ? $tokenResult['message'] : 'Không thể tạo mã xác thực';
                $this->response->json(['error' => $errorMsg], 500);
                return;
            }

            try {
                $subject = 'Mã xác thực đặt lại mật khẩu - Rudo Watch';
                $body = $this->mailService->getPasswordResetEmailTemplate($user['fullname'], $code);
                
                $result = $this->mailService->send($data->email, $subject, $body);
                
                if ($result === true) {
                    $this->response->json([
                        'message' => 'Đã gửi mã xác thực về email của bạn. Vui lòng kiểm tra hộp thư.'
                    ], 200);
                } else {
                    $this->response->json([
                        'error' => 'Gửi email thất bại. Vui lòng thử lại sau.'
                    ], 500);
                }
            } catch (Exception $mailException) {
                $this->response->json([
                    'error' => 'Gửi email thất bại. Vui lòng thử lại sau.'
                ], 500);
            }
        } catch (\Exception $e) {
            $this->response->json([
                'error' => 'Đã có lỗi xảy ra. Vui lòng thử lại sau.',
                'debug' => getenv('APP_ENV') === 'development' ? $e->getMessage() : null
            ], 500);
        } catch (\Throwable $e) {
            $this->response->json([
                'error' => 'Đã có lỗi xảy ra. Vui lòng thử lại sau.',
                'debug' => getenv('APP_ENV') === 'development' ? $e->getMessage() : null
            ], 500);
        }
    }

    /**
     * Xác thực mã và đặt lại mật khẩu
     */
    public function resetPassword($data)
    {
        try {
            if (!$data || empty($data->email) || empty($data->code) || empty($data->new_password)) {
                $this->response->json(['error' => 'Vui lòng điền đầy đủ thông tin'], 400);
                return;
            }

            if (!filter_var($data->email, FILTER_VALIDATE_EMAIL)) {
                $this->response->json(['error' => 'Email không hợp lệ'], 400);
                return;
            }

            if (strlen($data->new_password) < 6) {
                $this->response->json(['error' => 'Mật khẩu phải có ít nhất 6 ký tự'], 400);
                return;
            }

            $resetRecord = $this->passwordResetModel->findByEmailAndCode($data->email, $data->code);
            
            if (!$resetRecord) {
                $this->response->json([
                    'error' => 'Mã xác thực không đúng hoặc đã hết hạn. Vui lòng yêu cầu mã mới.'
                ], 400);
                return;
            }

            if ($resetRecord['used_at'] !== null) {
                $this->response->json([
                    'error' => 'Mã xác thực đã được sử dụng. Vui lòng yêu cầu mã mới.'
                ], 400);
                return;
            }

            $result = $this->userModel->updatePasswordByEmail($data->email, $data->new_password);
            
            if ($result === true) {
                $this->passwordResetModel->markAsUsed($resetRecord['id']);
                
                $this->passwordResetModel->deleteByEmail($data->email);
                
                $this->response->json([
                    'message' => 'Đặt lại mật khẩu thành công. Vui lòng đăng nhập lại.'
                ], 200);
            } else {
                $this->response->json([
                    'error' => 'Đặt lại mật khẩu thất bại. Vui lòng thử lại.'
                ], 500);
            }
        } catch (Exception $e) {
            $this->response->json([
                'error' => 'Đã có lỗi xảy ra. Vui lòng thử lại sau.'
            ], 500);
        }
    }
}
