<?php
require_once __DIR__ . '/../../../models/AddressModel.php';
require_once __DIR__ . '/../../../core/Response.php';
require_once __DIR__ . '/../../../middleware/AuthMiddleware.php';

class AddressesController
{
    private $addressModel;
    private $response;
    private $auth;

    public function __construct()
    {
        $this->addressModel = new Addresses();
        $this->response = new Response();
        $this->auth = new AuthMiddleware();
    }

    /**
     * Lấy danh sách địa chỉ của user hiện tại
     */
    public function index()
    {
        $user = $this->auth->authenticate();
        if (!$user) {
            return;
        }

        try {
            $addresses = $this->addressModel->getAllByUserId($user['id']);
            $this->response->json([
                'success' => true,
                'data' => $addresses
            ], 200);
        } catch (Exception $e) {
            $this->response->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Lấy chi tiết địa chỉ theo ID
     */
    public function show($id)
    {
        $user = $this->auth->authenticate();
        if (!$user) {
            return;
        }

        try {
            if (!is_numeric($id)) {
                $this->response->json([
                    'success' => false,
                    'error' => 'ID không hợp lệ'
                ], 400);
                return;
            }

            if (!$this->addressModel->belongsToUser($id, $user['id'])) {
                $this->response->json([
                    'success' => false,
                    'error' => 'Địa chỉ không tồn tại!'
                ], 404);
                return;
            }

            $address = $this->addressModel->getById($id);
            $this->response->json([
                'success' => true,
                'data' => $address
            ], 200);
        } catch (Exception $e) {
            $this->response->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Lấy địa chỉ mặc định của user
     */
    public function default()
    {
        $user = $this->auth->authenticate();
        if (!$user) {
            return;
        }

        try {
            $address = $this->addressModel->getDefaultByUserId($user['id']);

            if (!$address) {
                $this->response->json([
                    'success' => false,
                    'error' => 'Chưa có địa chỉ mặc định!'
                ], 404);
                return;
            }

            $this->response->json([
                'success' => true,
                'data' => $address
            ], 200);
        } catch (Exception $e) {
            $this->response->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Tạo địa chỉ mới
     */
    public function store($data)
    {
        $user = $this->auth->authenticate();
        if (!$user) {
            return;
        }

        try {
            if (is_object($data)) {
                $data = json_decode(json_encode($data), true);
            }

            $errors = $this->validateAddressData($data);
            if (!empty($errors)) {
                $this->response->json([
                    'success' => false,
                    'errors' => $errors
                ], 400);
                return;
            }

            $maxAddresses = 10;
            $currentCount = $this->addressModel->countByUserId($user['id']);
            if ($currentCount >= $maxAddresses) {
                $this->response->json([
                    'success' => false,
                    'error' => "Bạn chỉ có thể lưu tối đa {$maxAddresses} địa chỉ"
                ], 400);
                return;
            }

            $data['user_id'] = $user['id'];
            $result = $this->addressModel->create($data);

            if ($result['success']) {
                $this->response->json([
                    'success' => true,
                    'message' => $result['message'],
                    'data' => $result['data']
                ], 201);
            } else {
                $this->response->json([
                    'success' => false,
                    'error' => $result['message']
                ], 400);
            }
        } catch (Exception $e) {
            $this->response->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Cập nhật địa chỉ
     */
    public function update($id)
    {
        $user = $this->auth->authenticate();
        if (!$user) {
            return;
        }

        try {
            if (!is_numeric($id)) {
                $this->response->json([
                    'success' => false,
                    'error' => 'ID không hợp lệ'
                ], 400);
                return;
            }

            if (!$this->addressModel->belongsToUser($id, $user['id'])) {
                $this->response->json([
                    'success' => false,
                    'error' => 'Địa chỉ không tồn tại!'
                ], 404);
                return;
            }

            $data = json_decode(file_get_contents("php://input"), true);

            if (empty($data)) {
                $this->response->json([
                    'success' => false,
                    'error' => 'Không có dữ liệu để cập nhật'
                ], 400);
                return;
            }

            $errors = $this->validateAddressData($data, false);
            if (!empty($errors)) {
                $this->response->json([
                    'success' => false,
                    'errors' => $errors
                ], 400);
                return;
            }

            $result = $this->addressModel->update($id, $data);

            if ($result['success']) {
                $this->response->json([
                    'success' => true,
                    'message' => $result['message'],
                    'data' => $result['data']
                ], 200);
            } else {
                $this->response->json([
                    'success' => false,
                    'error' => $result['message']
                ], 400);
            }
        } catch (Exception $e) {
            $this->response->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Xóa địa chỉ
     */
    public function destroy($id)
    {
        $user = $this->auth->authenticate();
        if (!$user) {
            return;
        }

        try {
            if (!is_numeric($id)) {
                $this->response->json([
                    'success' => false,
                    'error' => 'ID không hợp lệ'
                ], 400);
                return;
            }

            if (!$this->addressModel->belongsToUser($id, $user['id'])) {
                $this->response->json([
                    'success' => false,
                    'error' => 'Địa chỉ không tồn tại!'
                ], 404);
                return;
            }

            $result = $this->addressModel->delete($id);

            if ($result['success']) {
                $this->response->json([
                    'success' => true,
                    'message' => $result['message']
                ], 200);
            } else {
                $this->response->json([
                    'success' => false,
                    'error' => $result['message']
                ], 400);
            }
        } catch (Exception $e) {
            $this->response->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Đặt địa chỉ làm mặc định
     */
    public function setDefault($id)
    {
        $user = $this->auth->authenticate();
        if (!$user) {
            return;
        }

        try {
            if (!is_numeric($id)) {
                $this->response->json([
                    'success' => false,
                    'error' => 'ID không hợp lệ'
                ], 400);
                return;
            }

            $result = $this->addressModel->setDefault($id, $user['id']);

            if ($result['success']) {
                $this->response->json([
                    'success' => true,
                    'message' => $result['message'],
                    'data' => $result['data']
                ], 200);
            } else {
                $this->response->json([
                    'success' => false,
                    'error' => $result['message']
                ], 400);
            }
        } catch (Exception $e) {
            $this->response->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Validate dữ liệu địa chỉ
     */
    private function validateAddressData($data, $isCreate = true)
    {
        $errors = [];

        if ($isCreate) {
            if (empty($data['receiver_name'])) {
                $errors['receiver_name'] = 'Tên người nhận không được để trống';
            }

            if (empty($data['receiver_phone'])) {
                $errors['receiver_phone'] = 'Số điện thoại người nhận không được để trống';
            }

            if (empty($data['province'])) {
                $errors['province'] = 'Tỉnh/Thành phố không được để trống';
            }

            if (empty($data['street'])) {
                $errors['street'] = 'Địa chỉ cụ thể không được để trống';
            }
        }

        if (!empty($data['receiver_phone'])) {
            $phone = preg_replace('/\s+/', '', $data['receiver_phone']);
            if (!preg_match('/^(0|\+84)[0-9]{9,10}$/', $phone)) {
                $errors['receiver_phone'] = 'Số điện thoại không hợp lệ';
            }
        }

        if (isset($data['receiver_name']) && !empty($data['receiver_name'])) {
            if (strlen($data['receiver_name']) > 150) {
                $errors['receiver_name'] = 'Tên người nhận không được quá 150 ký tự';
            }
        }

        if (isset($data['street']) && !empty($data['street'])) {
            if (strlen($data['street']) > 255) {
                $errors['street'] = 'Địa chỉ không được quá 255 ký tự';
            }
        }

        return $errors;
    }
}