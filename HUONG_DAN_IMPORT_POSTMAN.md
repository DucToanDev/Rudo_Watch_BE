# Hướng Dẫn Import Postman Collection cho Posts API

## File Collection

File: `Rudo_Watch_Posts_API.postman_collection.json`

## Cách Import vào Postman

### Bước 1: Mở Postman
1. Mở ứng dụng Postman trên máy tính
2. Click vào **Import** (góc trên bên trái)

### Bước 2: Import Collection
1. Click **Upload Files**
2. Chọn file `Rudo_Watch_Posts_API.postman_collection.json`
3. Click **Import**

### Bước 3: Cấu Hình Variables

Sau khi import, cần cấu hình variables:

1. Click vào collection **"Rudo Watch - Posts API"**
2. Vào tab **Variables**
3. Cập nhật các biến:

| Variable | Value | Mô tả |
|----------|-------|-------|
| `base_url` | `http://localhost/backend` | URL base của API (thay đổi theo môi trường) |
| `token` | `your-auth-token-here` | Token xác thực (lấy từ login API) |

**Lưu ý:** 
- Nếu test trên production, đổi `base_url` thành URL production
- `token` cần lấy từ API login và cập nhật thủ công

## Cấu Trúc Collection

Collection được chia thành 2 nhóm:

### 1. Post Categories (Danh Mục Bài Viết)

#### Public Endpoints (Không cần auth):
- **Get All Categories** - `GET /api/v1/post-categories`
- **Get Category by ID** - `GET /api/v1/post-categories/{id}`
- **Get Active Categories** - `GET /api/v1/post-categories/active`

#### Protected Endpoints (Cần auth):
- **Create Category** - `POST /api/v1/post-categories`
- **Update Category** - `PUT /api/v1/post-categories/{id}`
- **Delete Category** - `DELETE /api/v1/post-categories/{id}`

### 2. Posts (Bài Viết)

#### Public Endpoints (Không cần auth):
- **Get All Posts** - `GET /api/v1/posts` (có query params)
- **Get Post by ID** - `GET /api/v1/posts/{id}`
- **Get Post by Slug** - `GET /api/v1/posts/slug/{slug}`
- **Get Published Posts** - `GET /api/v1/posts/published`
- **Get Posts by Category** - `GET /api/v1/posts/category/{category_id}`

#### Protected Endpoints (Cần auth):
- **Create Post (JSON)** - `POST /api/v1/posts` (không có ảnh)
- **Create Post with Image** - `POST /api/v1/posts` (có upload ảnh)
- **Update Post (JSON)** - `PUT /api/v1/posts/{id}` (không có ảnh)
- **Update Post with Image** - `PUT /api/v1/posts/{id}` (có upload ảnh)
- **Delete Post** - `DELETE /api/v1/posts/{id}`

## Cách Sử Dụng

### 1. Lấy Token (Nếu chưa có)

1. Tạo request mới hoặc dùng collection Login (nếu có)
2. POST `/api/v1/login`
3. Copy `token` từ response
4. Vào collection variables và cập nhật `token`

### 2. Test Public Endpoints

Có thể test ngay không cần token:
- Get All Categories
- Get All Posts
- Get Post by ID
- etc.

### 3. Test Protected Endpoints

Cần có token:
1. Đảm bảo variable `token` đã được set
2. Các request sẽ tự động dùng `Bearer {{token}}` trong header

### 4. Upload Ảnh

Để upload ảnh khi tạo/cập nhật bài viết:
1. Chọn request **"Create Post with Image"** hoặc **"Update Post with Image"**
2. Vào tab **Body**
3. Tìm field `image`
4. Click **Select Files** và chọn ảnh
5. Điền các field khác (name, content, post_category_id)
6. Click **Send**

## Ví Dụ Request

### Tạo Danh Mục

**Request:** POST `/api/v1/post-categories`

**Headers:**
```
Authorization: Bearer {{token}}
Content-Type: application/json
```

**Body:**
```json
{
    "name": "Tin tức đồng hồ",
    "slug": "tin-tuc-dong-ho"
}
```

### Tạo Bài Viết với Ảnh

**Request:** POST `/api/v1/posts`

**Headers:**
```
Authorization: Bearer {{token}}
```

**Body (form-data):**
- `name`: Hướng dẫn chọn đồng hồ
- `content`: <p>Nội dung...</p>
- `post_category_id`: 1
- `image`: [Select File]

### Lấy Bài Viết theo Danh Mục

**Request:** GET `/api/v1/posts/category/1?limit=10`

**Response:**
```json
[
  {
    "id": 1,
    "name": "Bài viết mẫu",
    "slug": "bai-viet-mau",
    "content": "Nội dung...",
    "image": "https://storage.railway.app/.../image.jpg",
    "category_name": "Tin tức đồng hồ",
    "author_name": "Nguyễn Văn A",
    "created_at": "2024-01-01 00:00:00"
  }
]
```

## Lưu Ý

1. **Token hết hạn:** Nếu gặp lỗi 401, cần login lại và cập nhật token
2. **Base URL:** Đổi `base_url` theo môi trường (local, staging, production)
3. **Upload ảnh:** Chỉ dùng request có "with Image", không dùng JSON request
4. **Quyền:** Chỉ author hoặc admin mới được sửa/xóa bài viết
5. **Slug:** Tự động tạo từ `name` nếu không cung cấp

## Troubleshooting

### Lỗi 401 Unauthorized
- Kiểm tra token có đúng không
- Token có thể đã hết hạn, cần login lại

### Lỗi 404 Not Found
- Kiểm tra ID có đúng không
- Kiểm tra base_url có đúng không

### Lỗi 403 Forbidden
- Bạn không có quyền (chỉ author hoặc admin mới được sửa/xóa)

### Upload ảnh thất bại
- Kiểm tra file size (max 5MB)
- Kiểm tra file type (JPEG, PNG, GIF, WebP)
- Kiểm tra Railway S3 đã cấu hình chưa

