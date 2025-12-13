<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require_once __DIR__ . '/../../vendor/autoload.php';
require_once __DIR__ . '/../../vendor/phpmailer/phpmailer/src/PHPMailer.php';
require_once __DIR__ . '/../../vendor/phpmailer/phpmailer/src/Exception.php';



class MailService
{
    private $mailer;
    private $initialized = false;

    public function __construct()
    {
        try {
            $this->mailer = new PHPMailer(true);
        } catch (\Exception $e) {
            throw $e;
        }
    }

    
    // Khởi tạo PHPMailer 
    private function initialize()
    {
        if ($this->initialized) {
            return;
        }

        try {
            $smtpHost = getenv('SMTP_HOST') ?: ($_ENV['SMTP_HOST'] ?? null);
            $smtpUser = getenv('SMTP_USER') ?: ($_ENV['SMTP_USER'] ?? null);
            $smtpPass = getenv('SMTP_PASS') ?: ($_ENV['SMTP_PASS'] ?? null);
            $smtpPort = getenv('SMTP_PORT') ?: ($_ENV['SMTP_PORT'] ?? 587);
            $from = getenv('SMTP_FROM') ?: ($_ENV['SMTP_FROM'] ?? null);
            $fromName = getenv('SMTP_FROM_NAME') ?: ($_ENV['SMTP_FROM_NAME'] ?? null);

            if (empty($smtpHost) || empty($smtpUser) || empty($smtpPass)) {
                $error = 'Thiếu cấu hình SMTP!';
                throw new Exception($error);
            }

            if (empty($from) || empty($fromName)) {
                $from = $from ?: $smtpUser;
                $fromName = $fromName ?: 'Rudo Watch';
            }

            $this->mailer->isSMTP();
            $this->mailer->Host = $smtpHost;
            $this->mailer->SMTPAuth = true;
            $this->mailer->Username = $smtpUser;
            $this->mailer->Password = $smtpPass;
            $this->mailer->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
            $this->mailer->Port = (int)$smtpPort;
            $this->mailer->CharSet = 'UTF-8';
            $this->mailer->setFrom($from, $fromName);
            $this->mailer->SMTPDebug = 0;
            
            // Cấu hình timeout để tránh Gateway Timeout
            $this->mailer->Timeout = 10; // 10 giây timeout cho SMTP connection
            $this->mailer->SMTPKeepAlive = false; // Không giữ kết nối
            $this->mailer->SMTPOptions = [
                'ssl' => [
                    'verify_peer' => false,
                    'verify_peer_name' => false,
                    'allow_self_signed' => true
                ]
            ];

            $this->initialized = true;
        } catch (\Exception $e) {
            throw $e;
        } catch (\Throwable $e) {
            throw $e;
        }
    }

    public function send($to, $subject, $body)
    {
        try {
            $this->initialize();
            
            $this->mailer->clearAddresses();
            $this->mailer->clearAttachments();
            $this->mailer->addAddress($to);
            $this->mailer->Subject = $subject;
            $this->mailer->Body = $body;
            $this->mailer->isHTML(true);
            $this->mailer->AltBody = strip_tags($body);
            
            $result = $this->mailer->send();
            if ($result) {
                return true;
            } else {
                $error = $this->mailer->ErrorInfo;
                return $error;
            }
        } catch (Exception $e) {
            return $e->getMessage();
        }
    }

    /**
     * Tạo template email đặt lại mật khẩu
     */
    public function getPasswordResetEmailTemplate($fullname, $code)
    {
        $appName = 'Rudo Watch';
        try {
            $envAppName = $_ENV['APP_NAME'];
            if ($envAppName !== false && !empty($envAppName)) {
                $appName = $envAppName;
            }
        } catch (Exception $e) {
        }
        
        return '
        <!DOCTYPE html>
        <html lang="vi">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đặt lại mật khẩu</title>
        </head>
        <body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;">
            <table role="presentation" style="width: 100%; border-collapse: collapse;">
                <tr>
                    <td style="padding: 20px 0; text-align: center;">
                        <table role="presentation" style="width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                            <tr>
                                <td style="padding: 40px 40px 20px; text-align: center; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 8px 8px 0 0;">
                                    <h1 style="margin: 0; color: #ffffff; font-size: 28px; font-weight: bold;">' . htmlspecialchars($appName) . '</h1>
                                </td>
                            </tr>
                            
                            <tr>
                                <td style="padding: 40px;">
                                    <h2 style="margin: 0 0 20px; color: #333333; font-size: 24px;">Xin chào ' . htmlspecialchars($fullname) . '!</h2>
                                    
                                    <p style="margin: 0 0 20px; color: #666666; font-size: 16px; line-height: 1.6;">
                                        Bạn đã yêu cầu đặt lại mật khẩu cho tài khoản của mình. 
                                        Vui lòng sử dụng mã xác thực bên dưới để hoàn tất quá trình đặt lại mật khẩu.
                                    </p>
                                    
                                    <table role="presentation" style="width: 100%; margin: 30px 0;">
                                        <tr>
                                            <td style="text-align: center;">
                                                <div style="display: inline-block; padding: 20px 40px; background-color: #f8f9fa; border: 2px dashed #667eea; border-radius: 8px;">
                                                    <p style="margin: 0; font-size: 14px; color: #666666; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 10px;">Mã xác thực</p>
                                                    <p style="margin: 0; font-size: 32px; font-weight: bold; color: #667eea; letter-spacing: 8px; font-family: monospace;">' . htmlspecialchars($code) . '</p>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                    
                                    <p style="margin: 20px 0 0; color: #999999; font-size: 14px; line-height: 1.6;">
                                        <strong>Lưu ý:</strong>
                                    </p>
                                    <ul style="margin: 10px 0 0; padding-left: 20px; color: #666666; font-size: 14px; line-height: 1.8;">
                                        <li>Mã xác thực có hiệu lực trong <strong>10 phút</strong></li>
                                        <li>Không chia sẻ mã này với bất kỳ ai</li>
                                        <li>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này</li>
                                    </ul>
                                </td>
                            </tr>
                            
                            <tr>
                                <td style="padding: 30px 40px; background-color: #f8f9fa; border-radius: 0 0 8px 8px; text-align: center;">
                                    <p style="margin: 0 0 10px; color: #999999; font-size: 12px;">
                                        Email này được gửi tự động, vui lòng không trả lời.
                                    </p>
                                    <p style="margin: 0; color: #999999; font-size: 12px;">
                                        &copy; ' . date('Y') . ' ' . htmlspecialchars($appName) . '. All rights reserved.
                                    </p>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </body>
        </html>';
    }
}