<?php
require_once __DIR__ . '/../../../models/UserModel.php';
require_once __DIR__ . '/../../../core/Response.php';
require_once __DIR__ . '/../../../middleware/AuthMiddleware.php';

class UserController
{
    private $userModel;
    private $response;
    private $auth;

    public function __construct()
    {
        $this->userModel = new Users();
        $this->response = new Response();
        $this->auth = new AuthMiddleware();
    }

    //Lấy thông tin user
    public function profile()
    {
        $user = $this->auth->authenticate();
        if (!$user) {
            return;
        }

        $this->response->json([
            'user' => $user
        ], 200);
    }

    /**
     * GET /api/v1/users
     * Admin lấy tất cả users
     * Query params: page, limit, search, role, status
     */
    public function index()
    {
        $user = $this->auth->authenticate();
        if (!$user) {
            return;
        }

        // Kiểm tra quyền admin
        if ($user['role'] != 1) {
            $this->response->json([
                'error' => 'Bạn không có quyền thực hiện chức năng này'
            ], 403);
            return;
        }

        $params = [
            'page' => $_GET['page'] ?? 1,
            'limit' => $_GET['limit'] ?? 10,
            'search' => $_GET['search'] ?? null,
            'role' => $_GET['role'] ?? null,
            'status' => $_GET['status'] ?? null
        ];

        $result = $this->userModel->getAllUsers($params);

        if ($result['success']) {
            $this->response->json($result['data'], 200);
        } else {
            $this->response->json(['error' => $result['message']], 500);
        }
    }

    /**
     * GET /api/v1/users/{id}
     * Admin lấy chi tiết user
     */
    public function show($id)
    {
        $user = $this->auth->authenticate();
        if (!$user) {
            return;
        }

        // Kiểm tra quyền admin
        if ($user['role'] != 1) {
            $this->response->json([
                'error' => 'Bạn không có quyền thực hiện chức năng này'
            ], 403);
            return;
        }

        $userData = $this->userModel->getById($id);

        if ($userData) {
            $userData['role_name'] = $userData['role'] == 1 ? 'Admin' : 'User';
            $userData['status_name'] = $userData['status'] == 1 ? 'Hoạt động' : 'Bị khóa';
            unset($userData['api_token']);
            $this->response->json($userData, 200);
        } else {
            $this->response->json(['error' => 'Không tìm thấy người dùng'], 404);
        }
    }

    /**
     * PUT /api/v1/users/{id}/status
     * Admin cập nhật trạng thái user
     * Body: { status: 0 | 1 }
     */
    public function updateUserStatus($id)
    {
        $user = $this->auth->authenticate();
        if (!$user) {
            return;
        }

        // Kiểm tra quyền admin
        if ($user['role'] != 1) {
            $this->response->json([
                'error' => 'Bạn không có quyền thực hiện chức năng này'
            ], 403);
            return;
        }

        $data = json_decode(file_get_contents("php://input"));
        $status = isset($data->status) ? (int)$data->status : null;

        if ($status === null) {
            $this->response->json(['error' => 'Vui lòng cung cấp trạng thái'], 400);
            return;
        }

        $result = $this->userModel->updateStatus($user['id'], $id, $status);

        if ($result['success']) {
            $this->response->json([
                'message' => $result['message'],
                'user' => $result['user']
            ], 200);
        } else {
            $statusCode = $result['message'] === 'Bạn không có quyền thực hiện chức năng này' ? 403 : 400;
            $this->response->json(['error' => $result['message']], $statusCode);
        }
    }

    // Cập nhật user 
    public function update($data)
    {
        $user = $this->auth->authenticate();
        if (!$user) {
            return;
        }

        // Convert object to array if needed
        if (is_object($data)) {
            $data = json_decode(json_encode($data), true);
        }

        // Validate data is array
        if (!is_array($data)) {
            $this->response->json([
                'error' => 'Dữ liệu không hợp lệ'
            ], 400);
            return;
        }

        $updateData = [];

        // Cho phép update fullname (bắt buộc phải có giá trị)
        if (isset($data['fullname'])) {
            if (empty(trim($data['fullname']))) {
                $this->response->json([
                    'error' => 'Họ tên không được để trống'
                ], 400);
                return;
            }
            $updateData['fullname'] = trim($data['fullname']);
        }

        // Cho phép update phone (có thể để trống)
        if (isset($data['phone'])) {
            $updateData['phone'] = $data['phone'] ? trim($data['phone']) : null;
        }

        // Cho phép update email (bắt buộc phải hợp lệ)
        if (isset($data['email'])) {
            if (empty(trim($data['email']))) {
                $this->response->json([
                    'error' => 'Email không được để trống'
                ], 400);
                return;
            }
            if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
                $this->response->json([
                    'error' => 'Email không hợp lệ'
                ], 400);
                return;
            }
            $updateData['email'] = trim($data['email']);
        }

        if (empty($updateData)) {
            $this->response->json([
                'error' => 'Không có dữ liệu để cập nhật.'
            ], 400);
            return;
        }

        $result = $this->userModel->update($user['id'], $updateData);

        if ($result['success']) {
            $this->response->json([
                'message' => $result['message'],
                'user' => $result['user']
            ], 200);
        } else {
            $this->response->json([
                'error' => $result['message']
            ], 400);
        }
    }

    // Đổi mật khẩu
    public function changePassword($data)
    {
        $user = $this->auth->authenticate();
        if (!$user) {
            return;
        }

        // Convert object to array if needed
        if (is_object($data)) {
            $data = json_decode(json_encode($data), true);
        }

        if (!isset($data['old_password']) || empty($data['old_password'])) {
            $this->response->json([
                'error' => 'Vui lòng nhập mật khẩu cũ'
            ], 400);
            return;
        }

        if (!isset($data['new_password']) || empty($data['new_password'])) {
            $this->response->json([
                'error' => 'Vui lòng nhập mật khẩu mới'
            ], 400);
            return;
        }

        if (strlen($data['new_password']) < 6) {
            $this->response->json([
                'error' => 'Mật khẩu mới phải có ít nhất 6 ký tự'
            ], 400);
            return;
        }

        if (isset($data['confirm_password']) && $data['new_password'] !== $data['confirm_password']) {
            $this->response->json([
                'error' => 'Mật khẩu xác nhận không khớp'
            ], 400);
            return;
        }

        $result = $this->userModel->changePassword(
            $user['id'],
            $data['old_password'],
            $data['new_password']
        );

        if ($result['success']) {
            $this->response->json([
                'message' => $result['message']
            ], 200);
        } else {
            $this->response->json([
                'error' => $result['message']
            ], 400);
        }
    }

    // Cập nhật role - chỉ admin
    public function updateRole($data)
    {
        // Xác thực admin
        $admin = $this->auth->authenticate();
        if (!$admin) {
            return;
        }


        // Convert object to array if needed
        if (is_object($data)) {
            $data = json_decode(json_encode($data), true);
        }

        // Validate input
        if (!isset($data['user_id']) || empty($data['user_id'])) {
            $this->response->json([
                'error' => 'Vui lòng cung cấp user_id'
            ], 400);
            return;
        }

        if (!isset($data['role']) && $data['role'] !== 0 && $data['role'] !== 1) {
            $this->response->json([
                'error' => 'Vui lòng cung cấp role (0: User, 1: Admin)'
            ], 400);
            return;
        }

        $result = $this->userModel->updateRole(
            $admin['id'],
            $data['user_id'],
            $data['role']
        );

        if ($result['success']) {
            $this->response->json([
                'message' => $result['message'],
                'user' => $result['user']
            ], 200);
        } else {
            $statusCode = $result['message'] === 'Bạn không có quyền thực hiện chức năng này' ? 403 : 400;
            $this->response->json([
                'error' => $result['message']
            ], $statusCode);
        }
    }
}
