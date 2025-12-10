<?php
/**
 * Script test webhook SePay
 * Chạy script này để test webhook endpoint
 */

require_once __DIR__ . '/../vendor/autoload.php';

// Load environment variables
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

// Webhook URL
$webhookUrl = 'http://localhost/backend/api/v1/payments/webhook';
// Hoặc nếu deploy: https://yourdomain.com/api/v1/payments/webhook

// Dữ liệu webhook mẫu từ SePay
$webhookData = [
    'gateway' => 'MBBank',
    'transactionDate' => date('Y-m-d\TH:i:s\Z'),
    'accountNumber' => '0903252427',
    'subAccount' => null,
    'transferType' => 'in',
    'transferAmount' => 3500000,
    'accumulated' => 10000000,
    'code' => 'TEST' . time(),
    'content' => 'DH21', // Thay bằng order_id thực tế
    'referenceCode' => 'REF' . time(),
    'description' => 'Thanh toan don hang'
];

// Gửi POST request
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $webhookUrl);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($webhookData));
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json',
    'Accept: application/json'
]);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

echo "=== WEBHOOK TEST ===\n";
echo "URL: $webhookUrl\n";
echo "HTTP Code: $httpCode\n";
echo "Response: $response\n";
echo "\n";

$responseData = json_decode($response, true);
if ($responseData) {
    echo "Response Data:\n";
    print_r($responseData);
} else {
    echo "Response không phải JSON hợp lệ\n";
}

