<?php
require_once __DIR__ . '/../../../models/VoucherModel.php';
require_once __DIR__ . '/../../../core/Response.php';

class VouchersController
{
    private $vouchersModel;
    private $response;

    public function __construct()
    {
        $this->vouchersModel = new Vouchers();
        $this->response = new Response();
    }

    /**
     * GET /vouchers - Lấy danh sách vouchers
     */
    public function index()
    {
        try {
            $params = [
                'search' => $_GET['search'] ?? null,
                'type' => $_GET['type'] ?? null,
                'valid' => $_GET['valid'] ?? null,
                'page' => $_GET['page'] ?? null,
                'limit' => $_GET['limit'] ?? null
            ];

            $result = $this->vouchersModel->getAll($params);
            $this->response->json($result, 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * GET /vouchers/{id} - Lấy chi tiết voucher
     */
    public function show($id)
    {
        try {
            if (!is_numeric($id)) {
                $this->response->json(['error' => 'ID không hợp lệ'], 400);
                return;
            }

            $voucher = $this->vouchersModel->getById($id);

            if (!$voucher) {
                $this->response->json(['error' => 'Voucher không tồn tại'], 404);
                return;
            }

            // Thêm số lần sử dụng
            $voucher['usage_count'] = $this->vouchersModel->countUsage($id);
            $this->response->json($voucher, 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * POST /vouchers - Tạo voucher mới
     */
    public function store($data)
    {
        try {
            // Xử lý dữ liệu từ form-data hoặc JSON
            if (empty($data)) {
                $data = (object)$_POST;
            } else {
                // Chuyển đổi data thành object nếu là array (JSON request)
                if (is_array($data)) {
                    $data = (object)$data;
                }
            }

            $errors = $this->validateVoucherData($data, false);

            if (!empty($errors)) {
                $this->response->json(['errors' => $errors], 400);
                return;
            }

            // Kiểm tra code trùng
            if ($this->vouchersModel->codeExists($data->code)) {
                $this->response->json(['error' => 'Mã voucher đã tồn tại'], 400);
                return;
            }

            $result = $this->vouchersModel->create($data);

            if ($result) {
                $this->response->json([
                    'message' => 'Tạo voucher thành công',
                    'data' => $result
                ], 201);
            } else {
                $this->response->json(['error' => 'Không thể tạo voucher'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * PUT /vouchers/{id} - Cập nhật voucher
     */
    public function update($id)
    {
        try {
            if (!is_numeric($id)) {
                $this->response->json(['error' => 'ID không hợp lệ'], 400);
                return;
            }

            $voucher = $this->vouchersModel->getById($id);
            if (!$voucher) {
                $this->response->json(['error' => 'Voucher không tồn tại'], 404);
                return;
            }

            // Xử lý dữ liệu từ form-data hoặc JSON
            $contentType = $_SERVER['CONTENT_TYPE'] ?? '';
            if (strpos($contentType, 'multipart/form-data') !== false) {
                $data = (object)$_POST;
            } else {
                $data = json_decode(file_get_contents("php://input"));
            }

            if (!$data) {
                $this->response->json(['error' => 'Dữ liệu không hợp lệ'], 400);
                return;
            }

            $errors = $this->validateVoucherData($data, true);
            if (!empty($errors)) {
                $this->response->json(['errors' => $errors], 400);
                return;
            }

            // Kiểm tra code trùng (nếu đổi code)
            if (isset($data->code) && $data->code !== $voucher['code']) {
                if ($this->vouchersModel->codeExists($data->code, $id)) {
                    $this->response->json(['error' => 'Mã voucher đã tồn tại'], 400);
                    return;
                }
            }

            $result = $this->vouchersModel->update($id, $data);

            if ($result) {
                $this->response->json([
                    'message' => 'Cập nhật voucher thành công',
                    'data' => $result
                ], 200);
            } else {
                $this->response->json(['error' => 'Không thể cập nhật voucher'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * DELETE /vouchers/{id} - Xóa voucher
     */
    public function destroy($id)
    {
        try {
            if (!is_numeric($id)) {
                $this->response->json(['error' => 'ID không hợp lệ'], 400);
                return;
            }

            $voucher = $this->vouchersModel->getById($id);
            if (!$voucher) {
                $this->response->json(['error' => 'Voucher không tồn tại'], 404);
                return;
            }

            // Kiểm tra xem voucher có đang được sử dụng không
            $usageCount = $this->vouchersModel->countUsage($id);
            if ($usageCount > 0) {
                $confirm = isset($_GET['confirm']) && $_GET['confirm'] === 'true';

                if (!$confirm) {
                    $this->response->json([
                        'message' => "Voucher này đã được sử dụng trong {$usageCount} đơn hàng. Bạn có chắc muốn xóa?",
                        'usage_count' => $usageCount,
                        'requires_confirmation' => true,
                        'voucher' => $voucher
                    ], 200);
                    return;
                }
            }

            $result = $this->vouchersModel->delete($id);
            if ($result) {
                $this->response->json(['message' => 'Xóa voucher thành công'], 200);
            } else {
                $this->response->json(['error' => 'Không thể xóa voucher'], 500);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * POST /vouchers/apply - Áp dụng mã giảm giá
     */
    public function apply($data)
    {
        try {
            if (empty($data)) {
                $data = json_decode(file_get_contents("php://input"));
            }

            // Chuyển đổi data thành object nếu là array
            if (is_array($data)) {
                $data = (object)$data;
            }

            if (empty($data) || empty($data->code)) {
                $this->response->json(['error' => 'Vui lòng nhập mã giảm giá'], 400);
                return;
            }

            if (empty($data->total) || $data->total <= 0) {
                $this->response->json(['error' => 'Tổng tiền không hợp lệ'], 400);
                return;
            }

            $result = $this->vouchersModel->apply($data->code, (float)$data->total);

            if ($result['success']) {
                $this->response->json([
                    'message' => 'Áp dụng mã giảm giá thành công',
                    'data' => $result
                ], 200);
            } else {
                $this->response->json(['error' => $result['message']], 400);
            }
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * GET /vouchers/check/{code} - Kiểm tra mã giảm giá
     */
    public function check($code)
    {
        try {
            if (empty($code)) {
                $this->response->json(['error' => 'Mã giảm giá không hợp lệ'], 400);
                return;
            }

            $voucher = $this->vouchersModel->getByCode(strtoupper($code));

            if (!$voucher) {
                $this->response->json(['error' => 'Mã giảm giá không tồn tại'], 404);
                return;
            }

            if ($voucher['is_expired']) {
                $this->response->json([
                    'valid' => false,
                    'message' => 'Mã giảm giá đã hết hạn',
                    'voucher' => $voucher
                ], 200);
                return;
            }

            $this->response->json([
                'valid' => true,
                'message' => 'Mã giảm giá hợp lệ',
                'voucher' => $voucher
            ], 200);
        } catch (Exception $e) {
            $this->response->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * Validate dữ liệu voucher
     */
    private function validateVoucherData($data, $isUpdate = false)
    {
        $errors = [];

        if (!$isUpdate) {
            // Validate code
            if (empty($data->code)) {
                $errors['code'] = 'Mã voucher là bắt buộc';
            } elseif (strlen($data->code) > 50) {
                $errors['code'] = 'Mã voucher không được vượt quá 50 ký tự';
            } elseif (!preg_match('/^[A-Za-z0-9]+$/', $data->code)) {
                $errors['code'] = 'Mã voucher chỉ được chứa chữ và số';
            }

            // Validate type
            if (empty($data->type)) {
                $errors['type'] = 'Loại voucher là bắt buộc';
            } elseif (!in_array($data->type, ['percent', 'money'])) {
                $errors['type'] = 'Loại voucher không hợp lệ (percent hoặc money)';
            }

            // Validate discount/amount theo type
            if (isset($data->type)) {
                if ($data->type === 'percent') {
                    if (!isset($data->discount) || $data->discount === '') {
                        $errors['discount'] = 'Phần trăm giảm giá là bắt buộc';
                    } elseif ($data->discount < 1 || $data->discount > 100) {
                        $errors['discount'] = 'Phần trăm giảm giá phải từ 1 đến 100';
                    }
                } else if ($data->type === 'money') {
                    if (!isset($data->amount) || $data->amount === '') {
                        $errors['amount'] = 'Số tiền giảm là bắt buộc';
                    } elseif ($data->amount <= 0) {
                        $errors['amount'] = 'Số tiền giảm phải lớn hơn 0';
                    }
                }
            }
        } else {
            // Validate khi update
            if (isset($data->code)) {
                if (empty(trim($data->code))) {
                    $errors['code'] = 'Mã voucher không được để trống';
                } elseif (strlen($data->code) > 50) {
                    $errors['code'] = 'Mã voucher không được vượt quá 50 ký tự';
                } elseif (!preg_match('/^[A-Za-z0-9]+$/', $data->code)) {
                    $errors['code'] = 'Mã voucher chỉ được chứa chữ và số';
                }
            }

            if (isset($data->type) && !in_array($data->type, ['percent', 'money'])) {
                $errors['type'] = 'Loại voucher không hợp lệ (percent hoặc money)';
            }

            if (isset($data->discount) && ($data->discount < 1 || $data->discount > 100)) {
                $errors['discount'] = 'Phần trăm giảm giá phải từ 1 đến 100';
            }

            if (isset($data->amount) && $data->amount <= 0) {
                $errors['amount'] = 'Số tiền giảm phải lớn hơn 0';
            }
        }

        // Validate expired_at
        if (isset($data->expired_at) && !empty($data->expired_at)) {
            $expiredAt = strtotime($data->expired_at);
            if ($expiredAt === false) {
                $errors['expired_at'] = 'Ngày hết hạn không hợp lệ';
            }
        }

        return $errors;
    }
}