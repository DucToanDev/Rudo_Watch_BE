<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../core/Response.php';
require_once __DIR__ . '/../../config/function.php';

class Users
{
    // Tìm user theo email
    public function findByEmail($email)
    {
        try {
            $query = "SELECT * FROM {$this->table_name} WHERE email = :email LIMIT 1";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':email', $email);
            $stmt->execute();
            $user = $stmt->fetch(PDO::FETCH_ASSOC);
            return $user ?: null;
        } catch (PDOException $e) {
            return null;
        }
    }

    // Đổi mật khẩu theo email (không cần mật khẩu cũ)
    public function updatePasswordByEmail($email, $newPassword)
    {
        try {
            $hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);
            $newToken = bin2hex(random_bytes(32));
            $query = "UPDATE {$this->table_name} SET password = :password, api_token = :token WHERE email = :email";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':password', $hashedPassword);
            $stmt->bindParam(':token', $newToken);
            $stmt->bindParam(':email', $email);
            $result = $stmt->execute();
            return $result === true;
        } catch (Exception $e) {
            return false;
        }
    }
    private $conn;
    private $table_name = 'users';
    public $response;

    // Cache để tránh query lặp lại - dùng SplObjectStorage hoặc array
    private static $userCache = [];
    private static $cacheExpiry = [];
    private const CACHE_TTL = 300; // 5 phút

    // Lookup tables - O(1) access thay vì if-else
    private static $roleLookup = [
        0 => 'User',
        1 => 'Admin'
    ];

    private static $statusLookup = [
        0 => 'Bị khóa',
        1 => 'Hoạt động'
    ];

    // Columns cần select - tránh lặp lại string
    private const USER_COLUMNS = 'id, fullname, email, phone, role, status, api_token, created_at';
    private const USER_COLUMNS_NO_TOKEN = 'id, fullname, email, phone, role, status, created_at';

    public $id;
    public $fullname;
    public $email;
    public $password;
    public $phone;
    public $role;
    public $status;
    public $api_token;
    public $created_at;

    public function __construct()
    {
        try {
            $this->conn = Database::getInstance()->getConnection();
            if (!$this->conn) {
                throw new Exception('Database connection is null');
            }
            $this->response = new Response();
        } catch (Exception $e) {
            error_log('UserModel constructor error: ' . $e->getMessage());
            throw $e;
        }
    }

    /**
     * Lấy từ cache hoặc null nếu hết hạn
     */
    private function getFromCache($key)
    {
        if (isset(self::$userCache[$key]) && isset(self::$cacheExpiry[$key])) {
            if (time() < self::$cacheExpiry[$key]) {
                return self::$userCache[$key];
            }
            // Hết hạn - xóa cache
            unset(self::$userCache[$key], self::$cacheExpiry[$key]);
        }
        return null;
    }

    /**
     * Lưu vào cache
     */
    private function setCache($key, $value)
    {
        self::$userCache[$key] = $value;
        self::$cacheExpiry[$key] = time() + self::CACHE_TTL;
    }

    /**
     * Xóa cache của user
     */
    private function clearCache($userId)
    {
        unset(self::$userCache["user_$userId"], self::$cacheExpiry["user_$userId"]);
    }

    /**
     * Format user data - dùng lookup table O(1)
     */
    private function formatUser(array &$user): void
    {
        $user['role'] = (int)$user['role'];
        $user['status'] = (int)$user['status'];
        $user['role_name'] = self::$roleLookup[$user['role']] ?? 'Unknown';
        $user['status_name'] = self::$statusLookup[$user['status']] ?? 'Unknown';
    }

    /**
     * Format nhiều users - dùng array_walk nhanh hơn foreach
     */
    private function formatUsers(array &$users): void
    {
        array_walk($users, [$this, 'formatUser']);
    }

    // register
    public function create($data)
    {
        try {
            // check email ton tai chua
            $checkQuery = "SELECT id FROM " . $this->table_name . " USE INDEX (idx_email) WHERE email = :email LIMIT 1";
            $checkStmt = $this->conn->prepare($checkQuery);
            $checkStmt->bindParam(':email', $data['email']);
            $checkStmt->execute();

            if ($checkStmt->rowCount() > 0) {
                return [
                    'success' => false,
                    'message' => 'Email đã tồn tại'
                ];
            }

            $insertData = [
                'fullname' => $data['fullname'],
                'email' => $data['email'],
                'password' => password_hash($data['password'], PASSWORD_DEFAULT),
                'phone' => $data['phone'] ?? null,
                'role' => $data['role'] ?? 0,
                'status' => $data['status'] ?? 1,
                'api_token' => bin2hex(random_bytes(32))
            ];

            $userId = insert($this->conn, $this->table_name, $insertData);

            if ($userId) {
                return [
                    'success' => true,
                    'message' => 'Đăng ký thành công',
                    'user' => $this->getById($userId),
                    'token' => $insertData['api_token']
                ];
            }

            return [
                'success' => false,
                'message' => 'Đăng ký thất bại'
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => 'Lỗi: ' . $e->getMessage()
            ];
        }
    }

    // login
    public function login($email, $password)
    {
        try {
            $query = "SELECT id, fullname, email, password, phone, role, status, api_token 
                     FROM " . $this->table_name . " USE INDEX (idx_email_status) 
                     WHERE email = :email AND status = 1 LIMIT 1";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':email', $email);
            $stmt->execute();

            if ($stmt->rowCount() > 0) {
                $user = $stmt->fetch(PDO::FETCH_ASSOC);

                if (password_verify($password, $user['password'])) {
                    if (empty($user['api_token'])) {
                        $apiToken = bin2hex(random_bytes(32));
                        $this->updateToken($user['id'], $apiToken);
                        $user['api_token'] = $apiToken;
                    }

                    unset($user['password']);

                    return [
                        'success' => true,
                        'message' => 'Đăng nhập thành công',
                        'user' => $user,
                        'token' => $user['api_token']
                    ];
                } else {
                    return [
                        'success' => false,
                        'message' => 'Mật khẩu không đúng'
                    ];
                }
            } else {
                return [
                    'success' => false,
                    'message' => 'Email không tồn tại hoặc tài khoản đã bị khóa'
                ];
            }
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi: ' . $e->getMessage()
            ];
        }
    }

    // update token
    private function updateToken($userId, $token)
    {
        update($this->conn, $this->table_name, ['api_token' => $token], $userId);
        $this->clearCache($userId);
    }

    // Lấy user theo ID - có cache
    public function getById($id)
    {
        try {
            $cacheKey = "user_$id";

            // Kiểm tra cache trước
            $cached = $this->getFromCache($cacheKey);
            if ($cached !== null) {
                return $cached;
            }

            $query = "SELECT " . self::USER_COLUMNS . " 
                     FROM " . $this->table_name . " 
                     WHERE id = :id LIMIT 1";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            $stmt->execute();

            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($user) {
                $this->setCache($cacheKey, $user);
                return $user;
            }
            return null;
        } catch (PDOException $e) {
            return null;
        }
    }

    // Lấy user theo token - có cache
    public function getByToken($token)
    {
        try {
            $cacheKey = "token_$token";

            // Kiểm tra cache trước
            $cached = $this->getFromCache($cacheKey);
            if ($cached !== null) {
                return $cached;
            }

            $query = "SELECT " . self::USER_COLUMNS_NO_TOKEN . " 
                     FROM " . $this->table_name . " 
                     WHERE api_token = :token AND status = 1 LIMIT 1";

            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':token', $token);
            $stmt->execute();

            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($user) {
                $this->setCache($cacheKey, $user);
                return $user;
            }
            return null;
        } catch (PDOException $e) {
            return null;
        }
    }

    // Cập nhật user
    public function update($userId, $data)
    {
        try {
            $updateData = [];

            if (isset($data['fullname'])) {
                $updateData['fullname'] = $data['fullname'];
            }

            if (isset($data['phone'])) {
                $updateData['phone'] = $data['phone'];
            }

            if (isset($data['email'])) {
                $checkQuery = "SELECT id FROM " . $this->table_name . " USE INDEX (idx_email) WHERE email = :email AND id != :id LIMIT 1";
                $checkStmt = $this->conn->prepare($checkQuery);
                $checkStmt->bindParam(':email', $data['email']);
                $checkStmt->bindParam(':id', $userId);
                $checkStmt->execute();

                if ($checkStmt->rowCount() > 0) {
                    return [
                        'success' => false,
                        'message' => 'Email đã được sử dụng bởi tài khoản khác'
                    ];
                }

                $updateData['email'] = $data['email'];
            }

            if (isset($data['password']) && !empty($data['password'])) {
                $updateData['password'] = password_hash($data['password'], PASSWORD_DEFAULT);
            }

            if (empty($updateData)) {
                return [
                    'success' => false,
                    'message' => 'Không có dữ liệu để cập nhật'
                ];
            }

            $result = update($this->conn, $this->table_name, $updateData, $userId);

            if ($result) {
                $this->clearCache($userId); // Clear cache sau khi update
                return [
                    'success' => true,
                    'message' => 'Cập nhật thành công',
                    'user' => $this->getById($userId)
                ];
            }

            return [
                'success' => false,
                'message' => 'Cập nhật thất bại'
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => 'Lỗi: ' . $e->getMessage()
            ];
        }
    }

    // Đổi mật khẩu
    public function changePassword($userId, $oldPassword, $newPassword)
    {
        try {
            $query = "SELECT password FROM " . $this->table_name . " USE INDEX (PRIMARY) WHERE id = :id LIMIT 1";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':id', $userId);
            $stmt->execute();

            if ($stmt->rowCount() === 0) {
                return [
                    'success' => false,
                    'message' => 'Người dùng không tồn tại'
                ];
            }

            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!password_verify($oldPassword, $user['password'])) {
                return [
                    'success' => false,
                    'message' => 'Mật khẩu cũ không đúng'
                ];
            }

            if (password_verify($newPassword, $user['password'])) {
                return [
                    'success' => false,
                    'message' => 'Mật khẩu mới không được trùng với mật khẩu cũ'
                ];
            }

            // Cập nhật mật khẩu mới và reset token để đăng xuất tất cả phiên
            $hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);
            $newToken = bin2hex(random_bytes(32));

            $result = update($this->conn, $this->table_name, [
                'password' => $hashedPassword,
                'api_token' => $newToken
            ], $userId);

            if ($result) {
                return [
                    'success' => true,
                    'message' => 'Đổi mật khẩu thành công. Vui lòng đăng nhập lại',
                    'token' => $newToken
                ];
            }

            return [
                'success' => false,
                'message' => 'Đổi mật khẩu thất bại'
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => 'Lỗi: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Lấy tất cả users (Admin) - Tối ưu tốc độ cao
     */
    public function getAllUsers($params = [])
    {
        try {
            $page = max(1, (int)($params['page'] ?? 1));
            $limit = min(100, max(1, (int)($params['limit'] ?? 10)));
            $search = !empty($params['search']) ? trim($params['search']) : null;
            $role = $params['role'] ?? null;
            $status = $params['status'] ?? null;
            $offset = ($page - 1) * $limit;

            $where = "1=1";
            $bindParams = [];

            if ($search !== null) {
                $where .= " AND (fullname LIKE ? OR email LIKE ? OR phone LIKE ?)";
                $searchVal = "%$search%";
                $bindParams[] = $searchVal;
                $bindParams[] = $searchVal;
                $bindParams[] = $searchVal;
            }

            if ($role !== null && $role !== '') {
                $where .= " AND role = ?";
                $bindParams[] = (int)$role;
            }

            if ($status !== null && $status !== '') {
                $where .= " AND status = ?";
                $bindParams[] = (int)$status;
            }

            // Count
            $countSql = "SELECT COUNT(*) FROM {$this->table_name} WHERE {$where}";
            $countStmt = $this->conn->prepare($countSql);
            $countStmt->execute($bindParams);
            $total = (int)$countStmt->fetchColumn();

            // Query lấy data
            $sql = "SELECT id, fullname, email, phone, role, status, created_at 
                    FROM {$this->table_name} 
                    WHERE {$where} 
                    ORDER BY id DESC 
                    LIMIT {$offset}, {$limit}";

            $stmt = $this->conn->prepare($sql);
            $stmt->execute($bindParams);
            $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

            // Format inline
            foreach ($users as &$u) {
                $u['role'] = (int)$u['role'];
                $u['status'] = (int)$u['status'];
                $u['role_name'] = $u['role'] === 1 ? 'Admin' : 'User';
                $u['status_name'] = $u['status'] === 1 ? 'Hoạt động' : 'Bị khóa';
            }

            return [
                'success' => true,
                'data' => [
                    'users' => $users,
                    'pagination' => [
                        'current_page' => $page,
                        'per_page' => $limit,
                        'total' => $total,
                        'total_pages' => $total > 0 ? (int)ceil($total / $limit) : 0
                    ]
                ]
            ];
        } catch (PDOException $e) {
            return [
                'success' => false,
                'message' => 'Lỗi: ' . $e->getMessage()
            ];
        }
    }

    /**
     * Cập nhật trạng thái user (Admin)
     */
    public function updateStatus($adminId, $userId, $status)
    {
        try {
            // Kiểm tra admin có quyền không
            $admin = $this->getById($adminId);
            if (!$admin || $admin['role'] != 1) {
                return [
                    'success' => false,
                    'message' => 'Bạn không có quyền thực hiện chức năng này'
                ];
            }

            // Không cho phép admin tự khóa chính mình
            if ($adminId == $userId) {
                return [
                    'success' => false,
                    'message' => 'Không thể thay đổi trạng thái của chính mình'
                ];
            }

            // Validate status
            if (!in_array($status, [0, 1])) {
                return [
                    'success' => false,
                    'message' => 'Trạng thái không hợp lệ. Chỉ chấp nhận 0 (Khóa) hoặc 1 (Hoạt động)'
                ];
            }

            $result = update($this->conn, $this->table_name, ['status' => $status], $userId);

            if ($result) {
                $this->clearCache($userId); // Clear cache
                $statusName = self::$statusLookup[$status] ?? 'Unknown';
                return [
                    'success' => true,
                    'message' => "Đã cập nhật trạng thái thành {$statusName}",
                    'user' => $this->getById($userId)
                ];
            }

            return [
                'success' => false,
                'message' => 'Cập nhật trạng thái thất bại'
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => 'Lỗi: ' . $e->getMessage()
            ];
        }
    }

    // Cập nhật role - tối ưu với cache
    public function updateRole($adminId, $userId, $newRole)
    {
        try {
            // Dùng getById có cache thay vì query riêng
            $admin = $this->getById($adminId);

            if (!$admin || $admin['status'] != 1) {
                return [
                    'success' => false,
                    'message' => 'Admin không tồn tại hoặc đã bị khóa'
                ];
            }

            if ($admin['role'] != 1) {
                return [
                    'success' => false,
                    'message' => 'Bạn không có quyền thực hiện chức năng này'
                ];
            }

            // Dùng getById có cache
            $user = $this->getById($userId);

            if (!$user) {
                return [
                    'success' => false,
                    'message' => 'Người dùng không tồn tại'
                ];
            }

            // Validate role dùng isset với lookup table - O(1)
            if (!isset(self::$roleLookup[$newRole])) {
                return [
                    'success' => false,
                    'message' => 'Role không hợp lệ. Chỉ chấp nhận 0 (User) hoặc 1 (Admin)'
                ];
            }

            // Không cho phép admin tự thay đổi role của chính mình
            if ($adminId == $userId) {
                return [
                    'success' => false,
                    'message' => 'Không thể thay đổi role của chính mình'
                ];
            }

            // Cập nhật role 
            $updateQuery = "UPDATE " . $this->table_name . " SET role = :role WHERE id = :id";
            $updateStmt = $this->conn->prepare($updateQuery);
            $updateStmt->bindValue(':role', $newRole, PDO::PARAM_INT);
            $updateStmt->bindValue(':id', $userId, PDO::PARAM_INT);
            $result = $updateStmt->execute();

            if ($result) {
                $this->clearCache($userId); // Clear cache
                $roleName = self::$roleLookup[$newRole];
                return [
                    'success' => true,
                    'message' => "Đã cập nhật role của {$user['fullname']} thành {$roleName}",
                    'user' => $this->getById($userId)
                ];
            }

            return [
                'success' => false,
                'message' => 'Cập nhật role thất bại'
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => 'Lỗi: ' . $e->getMessage()
            ];
        }
    }
}