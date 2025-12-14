-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: localhost:3306
-- Thời gian đã tạo: Th12 13, 2025 lúc 09:06 PM
-- Phiên bản máy phục vụ: 10.5.29-MariaDB-log
-- Phiên bản PHP: 8.3.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `y9qva8l40gzk_rudowatch`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `addresses`
--

CREATE TABLE `addresses` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `street` varchar(255) DEFAULT NULL,
  `ward` varchar(100) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `receiver_name` varchar(150) DEFAULT NULL,
  `receiver_phone` varchar(20) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL,
  `is_default` tinyint(4) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `addresses`
--

INSERT INTO `addresses` (`id`, `user_id`, `street`, `ward`, `province`, `receiver_name`, `receiver_phone`, `created_at`, `updated_at`, `is_default`) VALUES
(9, 18, 'Eapo', 'Cưjut', 'Đăk Nông brunay', 'DucTon', '0916110241', '2025-11-30 10:28:28', '2025-12-01 08:40:50', 0),
(18, 18, 'to ky', 'Phường Tân Chánh Hiệp', 'Thành phố Hồ Chí Minh', 'dtoan', '0123456789', '2025-11-30 12:13:57', '2025-12-01 08:40:50', 0),
(19, 18, 'Đường 22', 'Xã Thái Học', 'Cao Bằng', 'Bình', '0123456789', '2025-11-30 12:40:23', '2025-12-01 08:40:50', 1),
(20, 7, '76/1 Tân Chánh Hiệp 08', 'Phường Tân Chánh Hiệp', 'Thành phố Hồ Chí Minh', 'Bình Phan', '0382832609', '2025-12-03 00:10:59', '2025-12-03 00:12:19', 1),
(22, 27, 'Huyện Hàm Thuận Nam', '', 'Tuyên Quang', 'ádada', '0123456789', '2025-12-05 07:50:30', NULL, 1),
(23, 11, '145 Tổ 2', 'Xã Đinh Văn Lâm Hà', 'Lâm Đồng', 'Thanh Phan', '0339817726', '2025-12-05 08:01:01', '2025-12-13 13:32:07', 0),
(24, 11, '76/1 Tân Chánh Hiệp 08', 'Phường Trung Mỹ Tây', 'Hồ Chí Minh', 'Bình Phan', '0382832609', '2025-12-05 08:01:45', '2025-12-13 13:33:06', 1),
(25, 8, '369 Đường Tô Ký', 'Phường 12', 'Thành phố Hồ Chí Minh', 'lkahdkad', '0393159478', '2025-12-10 08:06:53', '2025-12-11 14:44:35', 0),
(26, 8, '369 Đường Tô Ký', 'Phường Trung Mỹ Tây', 'Thành phố Hồ Chí Minh', 'sdas', '0393159478', '2025-12-10 08:07:28', '2025-12-11 14:44:35', 1),
(27, 232, 'Huyện Hàm Thuận Nam', 'Phường 17', 'Thành phố Hồ Chí Minh', 'Toàn dầu ăn', '0393159478', '2025-12-12 17:15:30', '2025-12-13 12:32:42', 0),
(28, 232, 'Huyện Hàm Thuận Nam', 'Phường Dĩ An', 'Hồ Chí Minh', 'khung củ', '0192345678', '2025-12-12 18:00:11', '2025-12-13 12:32:42', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `brands`
--

CREATE TABLE `brands` (
  `id` int(11) NOT NULL,
  `logo` longtext DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `brands`
--

INSERT INTO `brands` (`id`, `logo`, `name`, `slug`, `status`, `created_at`, `updated_at`) VALUES
(6, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765468263/brands/1765468262_64b5784c85cc5937.png', 'Rolex', 'rolex', 1, '2025-11-24 08:03:23', '2025-12-11 15:51:05'),
(7, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765468234/brands/1765468233_8b3e7fcbc1c07aac.png', 'Omega', 'omega', 1, '2025-11-24 08:03:23', '2025-12-11 15:50:36'),
(11, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765468197/brands/1765468197_954e6243ea8d9fa2.png', 'Patek Philippe', 'patek-philippe', 1, '2025-12-04 11:43:19', '2025-12-11 15:49:59'),
(12, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765468169/brands/1765468169_92ad98719d1a9150.svg', 'Cartier', 'cartier', 1, '2025-12-04 11:44:43', '2025-12-11 15:49:32'),
(13, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765468154/brands/1765468154_e71779e42f029043.png', 'Hublot', 'hublot', 1, '2025-12-04 11:45:21', '2025-12-11 15:49:16'),
(14, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765467907/brands/1765467907_acf7a0a119c2c467.png', 'Apple Watch', 'apple-watch', 1, '2025-12-04 11:45:58', '2025-12-11 15:45:09'),
(15, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765467892/brands/1765467891_c83319138a4c432b.png', 'Breitling', 'breitling', 1, '2025-12-04 11:46:15', '2025-12-11 15:44:54'),
(16, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765467859/brands/1765467859_d024aef1d131c9b8.png', 'Samsung', 'samsung', 1, '2025-12-04 11:46:30', '2025-12-11 15:44:22'),
(17, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765467875/brands/1765467875_dd883f74828bbc73.png', 'Xaomi', 'xaomi', 1, '2025-12-09 17:16:56', '2025-12-11 16:12:39');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `carts`
--

CREATE TABLE `carts` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `carts`
--

INSERT INTO `carts` (`id`, `user_id`, `created_at`, `updated_at`) VALUES
(6, 18, '2025-12-03 07:42:53', '2025-12-03 08:14:11'),
(7, 30, '2025-12-04 16:43:47', '2025-12-04 16:43:47'),
(8, 11, '2025-12-08 01:04:43', '2025-12-13 20:12:24'),
(9, 231, '2025-12-08 01:58:32', '2025-12-08 04:23:04'),
(10, 231, '2025-12-08 01:58:32', '2025-12-08 01:58:33'),
(11, 232, '2025-12-08 08:10:13', '2025-12-13 19:58:54'),
(12, 21, '2025-12-10 05:33:27', '2025-12-13 20:57:29'),
(13, 233, '2025-12-10 06:15:13', '2025-12-13 08:35:10'),
(14, 8, '2025-12-10 07:47:41', '2025-12-10 08:05:16'),
(15, 234, '2025-12-10 08:05:40', '2025-12-10 08:11:19'),
(16, 236, '2025-12-13 12:42:47', '2025-12-13 12:42:47');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cart_items`
--

CREATE TABLE `cart_items` (
  `id` int(11) NOT NULL,
  `cart_id` int(11) NOT NULL,
  `variant_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT 1,
  `price_at_add` decimal(12,2) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `cart_items`
--

INSERT INTO `cart_items` (`id`, `cart_id`, `variant_id`, `quantity`, `price_at_add`, `created_at`, `updated_at`) VALUES
(18, 10, 29, 1, 12000000.00, '2025-12-08 01:58:33', '2025-12-08 01:58:33'),
(33, 8, 33, 19, 1000.00, '2025-12-10 06:17:14', '2025-12-13 20:12:24'),
(34, 8, 31, 12, 9990000.00, '2025-12-10 06:28:10', '2025-12-10 07:33:53'),
(36, 14, 24, 2, 41240000.00, '2025-12-10 08:05:11', '2025-12-10 08:05:16'),
(45, 13, 29, 11, 12000000.00, '2025-12-13 08:34:58', '2025-12-13 08:35:10'),
(46, 13, 25, 2, 109800000.00, '2025-12-13 08:34:58', '2025-12-13 08:35:10'),
(62, 8, 30, 3, 8990000.00, '2025-12-13 19:55:32', '2025-12-13 20:12:24'),
(64, 12, 33, 11, 1000.00, '2025-12-13 20:10:08', '2025-12-13 20:57:29'),
(65, 12, 39, 1, 200000.00, '2025-12-13 20:10:08', '2025-12-13 20:10:08');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `status` tinyint(4) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `categories`
--

INSERT INTO `categories` (`id`, `logo`, `name`, `slug`, `status`, `created_at`, `updated_at`) VALUES
(1, NULL, 'Đồng hồ nam', 'dong-ho-nam', 1, '2025-11-24 08:03:23', '2025-12-09 17:17:49'),
(2, NULL, 'Đồng hồ Nữ', 'dong-ho-nu', 1, '2025-11-24 08:03:23', NULL),
(4, NULL, 'Đồng hồ Thể thao', 'dong-ho-the-thao', 1, '2025-11-24 08:03:23', NULL),
(5, NULL, 'Đồng hồ Thông minh', 'dong-ho-thong-minh', 1, '2025-11-24 08:03:23', NULL),
(6, NULL, 'Đồng hồ Cao cấp', 'dong-ho-cao-cap', 1, '2025-11-24 08:03:23', '2025-12-04 11:03:23'),
(11, NULL, 'Đồng hồ LGBT', 'dong-ho-lgbt', 1, '2025-12-09 17:16:42', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `post_id` int(11) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `favorites`
--

CREATE TABLE `favorites` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `voucher_id` int(11) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `status` varchar(50) DEFAULT 'pending',
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_status` varchar(50) DEFAULT NULL,
  `total` decimal(12,2) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `voucher_id`, `address`, `status`, `payment_method`, `payment_status`, `total`, `note`, `created_at`, `updated_at`) VALUES
(6, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã An Thượng, Huyện Yên Thế, Tỉnh Bắc Giang\"', 'pending', 'cod', 'unpaid', 186430000.00, NULL, '2025-12-04 11:25:21', '2025-12-04 11:25:21'),
(7, 30, NULL, '\"369 Đường Tô Ký, Xã Lý Nhơn, Huyện Cần Giờ, Thành phố Hồ Chí Minh\"', 'pending', 'bank', 'unpaid', 180080000.00, NULL, '2025-12-04 16:43:50', '2025-12-04 16:43:50'),
(8, 7, NULL, '\"145 Tổ 2, Thị trấn Đinh Văn, Huyện Lâm Hà, Tỉnh Lâm Đồng\"', 'delivered', 'cod', 'paid', 109830000.00, 'Giao nhanh nha', '2025-12-05 06:28:20', '2025-12-05 07:42:53'),
(9, 30, NULL, '\"369 Đường Tô Ký, Xã Tân Thạnh Tây, Huyện Củ Chi, Thành phố Hồ Chí Minh\"', 'pending', 'card', 'unpaid', 10080000.00, 'sdsd', '2025-12-05 08:19:21', '2025-12-05 08:19:21'),
(10, 231, NULL, '\"134123, Xã Ngọc Thiện, Huyện Tân Yên, Tỉnh Bắc Giang\"', 'pending', 'cod', 'unpaid', 60030000.00, NULL, '2025-12-08 04:28:52', '2025-12-08 04:28:52'),
(11, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Trung Hoà, Huyện Ngân Sơn, Tỉnh Bắc Kạn\"', 'confirmed', 'cod', 'paid', 20150000.00, NULL, '2025-12-08 05:06:24', '2025-12-08 08:15:05'),
(12, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Nam Mẫu, Huyện Ba Bể, Tỉnh Bắc Kạn\"', 'confirmed', 'cod', 'paid', 109830000.00, 'OK', '2025-12-08 05:35:31', '2025-12-08 07:38:01'),
(13, 21, NULL, '\"369 Đường Tô Ký, Xã Phước Bình, Huyện Long Thành, Tỉnh Đồng Nai\"', 'pending', 'codun', 'paid', 31000.00, 'yh', '2025-12-10 05:38:33', '2025-12-13 12:27:36'),
(14, 234, NULL, '\"145, Xã Thanh Lương, Thị xã Nghĩa Lộ, Tỉnh Yên Bái\"', 'confirmed', 'cod', 'paid', 1280000.00, NULL, '2025-12-10 08:06:51', '2025-12-10 08:08:50'),
(15, 234, NULL, '\"145 Tổ 2, Xã Mường Tè, Huyện Mường Tè, Tỉnh Lai Châu\"', 'confirmed', 'cod', 'paid', 9020000.00, 'Giao nhanh', '2025-12-10 08:11:23', '2025-12-10 08:12:00'),
(16, 233, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Quảng Lợi, Huyện Quảng Điền, Thành phố Huế\"', 'pending', 'cod', 'unpaid', 11270000.00, NULL, '2025-12-12 16:49:39', '2025-12-12 16:49:39'),
(17, 21, NULL, '\"369 Đường Tô Ký, Xã Hòa Phú, Huyện Củ Chi, Thành phố Hồ Chí Minh\"', 'pending', 'bank', 'unpaid', 51000.00, NULL, '2025-12-13 18:33:01', '2025-12-13 18:33:01'),
(18, 21, NULL, '\"369 Đường Tô Ký, Phường 4, Quận 10, Thành phố Hồ Chí Minh\"', 'pending', 'bank', 'unpaid', 31000.00, NULL, '2025-12-13 18:37:41', '2025-12-13 18:37:41'),
(19, 21, NULL, '\"369 Đường Tô Ký, Phường 7, Quận 8, Thành phố Hồ Chí Minh\"', 'pending', 'bank', 'unpaid', 51000.00, 'sá', '2025-12-13 18:38:53', '2025-12-13 18:38:53'),
(20, 21, NULL, '\"369 Đường Tô Ký, Phường Tân Phú, Quận 7, Thành phố Hồ Chí Minh\"', 'pending', 'bank', 'unpaid', 51000.00, 'fdvfdxgbf', '2025-12-13 18:40:53', '2025-12-13 18:40:53'),
(21, 21, NULL, '\"369 Đường Tô Ký, Xã Tân Phú Trung, Huyện Củ Chi, Thành phố Hồ Chí Minh\"', 'confirmed', 'cod', 'paid', 31000.00, NULL, '2025-12-13 18:57:22', '2025-12-13 19:13:42'),
(22, 21, NULL, '\"369 Đường Tô Ký, Xã Hiệp Phước, Huyện Nhà Bè, Thành phố Hồ Chí Minh\"', 'confirmed', 'bank', 'paid', 31000.00, NULL, '2025-12-13 18:59:13', '2025-12-13 19:12:25'),
(23, 21, NULL, '\"369 Đường Tô Ký, Phường Tân Phong, Quận 7, Thành phố Hồ Chí Minh\"', 'confirmed', 'bank', 'paid', 31000.00, NULL, '2025-12-13 19:06:56', '2025-12-13 19:08:42'),
(24, 21, NULL, '\"369 Đường Tô Ký, Xã Bình Mỹ, Huyện Củ Chi, Thành phố Hồ Chí Minh\"', 'pending', 'bank', 'unpaid', 51000.00, 'sd', '2025-12-13 19:32:15', '2025-12-13 19:32:15'),
(25, 21, NULL, '\"369 Đường Tô Ký, Xã Bình Mỹ, Huyện Củ Chi, Thành phố Hồ Chí Minh\"', 'pending', 'bank', 'unpaid', 51000.00, 'sd', '2025-12-13 19:32:24', '2025-12-13 19:32:24'),
(26, 232, NULL, '\"Huyện Hàm Thuận Nam, Phường Tân Tạo, Quận Bình Tân, Thành phố Hồ Chí Minh\"', 'pending', 'cod', 'unpaid', 31000.00, NULL, '2025-12-13 19:45:33', '2025-12-13 19:45:33'),
(27, 232, NULL, '\"Huyện Hàm Thuận Nam, Xã Tân Đoàn, Huyện Văn Quan, Tỉnh Lạng Sơn\"', 'pending', 'cod', 'unpaid', 31000.00, NULL, '2025-12-13 19:58:54', '2025-12-13 19:58:54');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_detail`
--

CREATE TABLE `order_detail` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `variant_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` decimal(12,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `order_detail`
--

INSERT INTO `order_detail` (`id`, `order_id`, `variant_id`, `quantity`, `price`) VALUES
(11, 8, 25, 1, 109800000.00),
(12, 9, 26, 1, 10000000.00),
(13, 10, 26, 6, 10000000.00),
(14, 11, 26, 2, 10000000.00),
(15, 11, 28, 1, 120000.00),
(16, 12, 25, 1, 109800000.00),
(17, 13, 33, 1, 1000.00),
(19, 15, 30, 1, 8990000.00),
(20, 16, 31, 1, 9990000.00),
(22, 17, 33, 1, 1000.00),
(23, 18, 33, 1, 1000.00),
(24, 19, 33, 1, 1000.00),
(25, 20, 33, 1, 1000.00),
(26, 21, 33, 1, 1000.00),
(27, 22, 33, 1, 1000.00),
(28, 23, 33, 1, 1000.00),
(29, 24, 33, 1, 1000.00),
(30, 25, 33, 1, 1000.00),
(31, 26, 33, 1, 1000.00),
(32, 27, 33, 1, 1000.00);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `password_resets`
--

CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `code` varchar(6) DEFAULT NULL COMMENT 'Mã xác thực 6 chữ số',
  `expires_at` datetime NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `used_at` datetime DEFAULT NULL COMMENT 'Thời điểm token được sử dụng'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `password_resets`
--

INSERT INTO `password_resets` (`id`, `email`, `token`, `code`, `expires_at`, `created_at`, `used_at`) VALUES
(81, 'pductoandev@gmail.com', '7a34f52c52e41dd9f48cf70d47c9b37acbc6380eb7df9f54c38e3ebe7ba6226e', '434501', '2025-12-12 12:22:59', '2025-12-12 12:12:59', NULL),
(97, 'phanbinh150504@gmail.com', '95bbadb16bc45ab011533d8e6a9d1c6238e4945905861c21db70eae247c68a30', '052215', '2025-12-13 03:41:57', '2025-12-13 03:31:57', NULL),
(99, 'toanphan01vip@gmail.com', '29dbe877de97c27454a895c4c97ff1587ebfdc7902f90fb542eb010a33238f05', '652439', '2025-12-13 03:44:10', '2025-12-13 03:34:10', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `amount` decimal(12,2) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `gateway_name` varchar(100) DEFAULT NULL,
  `gateway_transaction_id` varchar(150) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `payments`
--

INSERT INTO `payments` (`id`, `order_id`, `amount`, `status`, `gateway_name`, `gateway_transaction_id`, `created_at`) VALUES
(6, 7, 180080000.00, 'pending', 'sepay', NULL, '2025-12-10 04:14:04'),
(7, 7, 180080000.00, 'pending', 'sepay', NULL, '2025-12-10 05:16:32'),
(8, 13, 31000.00, 'pending', 'sepay', NULL, '2025-12-10 05:44:42'),
(9, 13, 31000.00, 'pending', 'sepay', NULL, '2025-12-10 06:00:24'),
(10, 13, 31000.00, 'pending', 'sepay', NULL, '2025-12-10 06:13:08'),
(11, 13, 31000.00, 'pending', 'sepay', NULL, '2025-12-10 06:37:09'),
(12, 7, 180080000.00, 'pending', 'sepay', NULL, '2025-12-11 15:45:15'),
(13, 13, 31000.00, 'pending', 'sepay', NULL, '2025-12-13 04:14:44'),
(14, 13, 31000.00, 'pending', 'sepay', NULL, '2025-12-13 05:05:54'),
(15, 13, 31000.00, 'pending', 'sepay', NULL, '2025-12-13 05:24:23'),
(16, 13, 31000.00, 'pending', 'sepay', NULL, '2025-12-13 05:26:48'),
(17, 19, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:38:54'),
(18, 19, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:40:03'),
(19, 19, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:40:10'),
(20, 19, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:40:17'),
(21, 19, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:40:26'),
(22, 20, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:40:54'),
(23, 20, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:41:51'),
(24, 20, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:42:02'),
(25, 20, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:42:09'),
(26, 20, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:42:26'),
(27, 20, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:42:31'),
(28, 20, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:42:37'),
(29, 20, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:42:39'),
(30, 20, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:44:33'),
(31, 20, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:44:57'),
(32, 20, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:45:33'),
(33, 20, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:45:41'),
(34, 20, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:45:46'),
(35, 20, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:51:09'),
(36, 20, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:53:41'),
(37, 20, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:53:47'),
(38, 20, 51000.00, 'pending', 'sepay', NULL, '2025-12-13 11:53:54'),
(39, 22, 31000.00, 'pending', 'sepay', NULL, '2025-12-13 11:59:13'),
(40, 23, 31000.00, 'pending', 'sepay', NULL, '2025-12-13 12:06:56');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `posts`
--

CREATE TABLE `posts` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `post_category_id` int(11) NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `image` longtext DEFAULT NULL,
  `content` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `posts`
--

INSERT INTO `posts` (`id`, `user_id`, `post_category_id`, `name`, `slug`, `image`, `content`, `created_at`, `updated_at`) VALUES
(13, 232, 2, 'ấdfdsds', NULL, NULL, '<p>fsdfsdfsdfsdfsdfsdf</p>', '2025-12-09 18:55:07', NULL),
(16, 232, 5, 'haloninini', 'ssssssssssssssssssss', 'https://storage.railway.app/organized-toybox-x74waqs9/posts/1765307768_d01aa175220de5f2.jpg?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tid_PbRilWQ_TNzNkfqCDhd_TEKPfLUYikeVQzWJMTcJmZQQpLblcn%2F20251209%2Fiad%2Fs3%2Faws4_request&X-Amz-Date=20251209T191609Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Signature=3d3f25bae298683f8c7d8136e1e3b4e924e568e3b0bf4a8af67a05c5b2890077', '<p>aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</p>', '2025-12-09 19:16:09', '2025-12-10 04:30:46'),
(17, 232, 4, 'RỮA XE MÃI ĐỈNH', 'ddddddddd', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765605399/posts/1765605394_c3c301c8ac6a57d1.png', '<p>Tôi rất thích làm nghề rữa xe</p>', '2025-12-11 13:19:45', '2025-12-13 05:56:40');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `posts_categories`
--

CREATE TABLE `posts_categories` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `posts_categories`
--

INSERT INTO `posts_categories` (`id`, `name`, `slug`, `created_at`, `updated_at`) VALUES
(2, 'Kiến thức đồng hồ new', 'kien-thuc-dong-ho-new', '2025-11-24 08:03:29', '2025-12-10 05:02:20'),
(3, 'Tin tức đồng hồ cập nhật', 'tin-tuc-dong-ho-cap-nhat', '2025-11-24 08:03:29', '2025-12-10 05:01:59'),
(4, 'Đánh giá sản phẩm', 'danh-gia', '2025-11-24 08:03:29', '2025-12-10 05:01:34'),
(5, 'Tin tức đồng hồ', 'tin-tuc-dong-ho', '2025-12-09 17:56:48', '2025-12-10 05:01:34');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `model_code` varchar(255) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `specifications` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`specifications`)),
  `thumbnail` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`thumbnail`)),
  `description` text DEFAULT NULL,
  `image` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `status` tinyint(4) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `products`
--

INSERT INTO `products` (`id`, `model_code`, `category_id`, `brand_id`, `name`, `slug`, `specifications`, `thumbnail`, `description`, `image`, `created_at`, `status`) VALUES
(10, 'RD-W-010', 1, 6, 'Rolex Submariner 126610LN', 'rolex-submariner-126610ln', '[\"Kích thước: 41mm\", \"Chống nước: 300m\", \"Máy: Automatic\", \"Thương hiệu: Thụy Sĩ cao cấp\"]', '[\"uploads/products/rolex-submariner-126610ln-1.png\", \"uploads/products/rolex-submariner-126610ln-2.png\"]', 'Rolex Submariner biểu tượng của đồng hồ cao cấp, chống nước 300m', 'uploads/products/rolex-submariner-126610ln.png', '2025-11-24 08:03:24', 1),
(11, 'RD-W-011', 2, 7, 'Omega Seamaster 210.30.42.20.03.001', 'omega-seamaster-210-30-42-20-03-001', '[\"Kích thước: 42mm\", \"Chống nước: 300m\", \"Máy: Automatic\", \"Thương hiệu: Thụy Sĩ\"]', '[\"uploads/products/omega-seamaster-210-30-42-20-03-001-1.png\", \"uploads/products/omega-seamaster-210-30-42-20-03-001-2.png\"]', 'Omega Seamaster với máy Co-Axial, chống nước 300m', 'uploads/products/omega-seamaster-210-30-42-20-03-001.png', '2025-11-24 08:03:24', 1),
(29, 'TA-SUB-001', 6, 6, 'Titoni Airmaster', 'titoni-airmaster', '{\"size\": \"\", \"brand\": \"\", \"color\": \"\", \"model\": \"\", \"weight\": \"\", \"material\": \"\", \"warranty\": \"\"}', '[\"uploads/products/thumb_1764905721_693252f9e2ca5.webp\"]', '<h3><strong style=\"color: rgb(103, 103, 103);\">Titoni Airmaster 83743 S-682 là dòng đồng hồ cơ nam Thụy Sỹ sang trọng với bộ máy SW200-1 trữ cót 38 giờ siêu bền bỉ và chính xác. Di sản của thương hiệu hoạt động độc lập hơn 100 năm lịch sử.</strong></h3><p>----------------------------------------------------------------------------------------------------------------------------------------</p><p>Titoni Airmaster 83743 S-682 không đơn thuần là một cỗ máy đếm giờ, đó là hiện thân của di sản Thụy Sỹ thuần khiết. Đến từ Grenchen – cái nôi của ngành đồng hồ, Titoni tự hào là một trong số ít thương hiệu còn giữ vững vị thế độc lập và thuộc sở hữu gia đình qua hơn một thế kỷ.</p><p>Mẫu Airmaster này sở hữu \"trái tim\" là bộ máy cơ tự động <strong>SW200-1</strong> danh tiếng. Với khả năng trữ cót 38 giờ cùng độ chính xác ấn tượng, cỗ máy này đảm bảo sự vận hành bền bỉ qua năm tháng, đồng hành cùng quý ông trong mọi khoảnh khắc quan trọng. Thiết kế sang trọng, từng đường nét được hoàn thiện tỉ mỉ là minh chứng cho kỹ nghệ chế tác bậc thầy, biến Titoni Airmaster 83743 S-682 trở thành biểu tượng của sự thành đạt và gu thẩm mỹ tinh tế.</p><p><br></p>', 'uploads/products/product_1764905721_693252f9e2b42.jpg', '2025-12-05 03:35:22', 1),
(30, 'OMG-RD-001', 6, 7, 'Đồng Hồ Omega', 'dong-ho-omega', '[\"Kích thước: 41.5mm\", \"Chất liệu: Kính Sapphire, Dây Da\", \"Màu sắc: Bạc\", \"Bảo hành: 24 tháng\", \"Trọng lượng: 155g\", \"Thương hiệu: Omega\", \"Model: Omega Seamaster\"]', '[\"uploads/products/thumb_1764906558_6932563e57298.webp\"]', '<ol><li>Được đảm bảo chất lượng sản phẩm,&nbsp;cam kết 100% sản phẩm chính hãng</li><li>Được đổi trả sản phẩm trong trường hợp sản phẩm bị lỗi trong vòng 3 ngày theo điều kiện của&nbsp;RUDO </li><li>Miễn phí vận chuyển toàn quốc, đồng kiểm trực tiếp khi giao nhận.</li><li>Giao hàng hỏa tốc (áp dụng đối với hàng có sẵn tại cửa hàng gần nhất)</li><li>Được hưởng các ưu đãi, quà tặng, chương trình khách hàng thân thiết.</li></ol><p><br></p><p><span style=\"color: rgb(51, 51, 51);\">Sở thích của mỗi người khác nhau, có người tay nhỏ thích đeo đồng hồ size to, có người tay to lại thích size nhỏ. Để chọn đồng hồ thẩm mỹ nhất, bạn nên tham khảo cách chọn size dưới đây:</span></p><p><img src=\"https://www.watchstore.vn/wp-content/uploads/2025/10/huong-dan-do-size-co-tay-bang-thuoc-giay-watchstore.jpg\" alt=\"Chọn size mặt đồng hồ phù hợp nhất với tay - Ảnh 1\"></p>', 'uploads/products/product_1764906558_6932563e5721f.webp', '2025-12-05 03:49:18', 1),
(31, 'RLX-LGBT-RUDO', 6, 12, 'Đồng Hồ Eo gi bi ti', 'dong-ho-eo-gi-bi-ti', '[\"Kích thước: 42\", \"Chất liệu: kim cương\", \"Màu sắc: black\", \"Bảo hành: 24 tháng\", \"Trọng lượng: 155g\", \"Thương hiệu: ROLE\", \"Model: kkk\"]', '[\"uploads/products/thumb_1764919190_6932879650cfb.webp\"]', '<p>Đồng hồ else gi bi ti giá hạt giẻ</p>', 'uploads/products/product_1764919190_693287964fe58.jpg', '2025-12-05 07:19:50', 1),
(32, 'FAC00009N0', 6, 12, 'Orient Bambino FAC00009N0', 'orient-bambino-fac00009n0', '[\"Kích thước: 44mm\", \"Chất liệu: bạc\", \"Màu sắc: white\", \"Bảo hành: 12 tháng\", \"Trọng lượng: 155g\", \"Thương hiệu: Orient\", \"Model: Automatic\"]', '[\"uploads/products/thumb_1764923014_69329686538a1.png\"]', '<ul><li>Thiết kế cổ điển, lịch lãm — phong cách dress-watch, dễ phối đồ công sở hoặc đi tiệc. <a href=\"https://orient-watch.vn/product/dong-ho-nam-orient-classic-fac00009n0/?utm_source=chatgpt.com\" rel=\"noopener noreferrer\" target=\"_blank\">orient-watch.vn+1</a></li><li>Mặt số “champagne/ivory” + cọc số La Mã + kim xanh tạo điểm nhấn sang trọng, thanh thoát. <a href=\"https://orient-watch.vn/product/dong-ho-nam-orient-classic-fac00009n0/?utm_source=chatgpt.com\" rel=\"noopener noreferrer\" target=\"_blank\">orient-watch.vn+2PhongWatch+2</a></li><li>Máy automatic in-house của Orient (Cal. F6724), có thể tự lên cót + hỗ trợ lên cót tay + có hack dừng kim giây — tiện cho chỉnh thời gian chính xác. <a href=\"https://www.orientwatchusa.com/products/tac00009n0?utm_source=chatgpt.com\" rel=\"noopener noreferrer\" target=\"_blank\">orientwatchusa.com+1</a></li><li>Kích thước mặt 40.5 mm — phổ biến, phù hợp đa số cổ tay nam; dây da + vỏ thép không gỉ giúp đồng hồ vừa sang vừa thoải mái khi đeo.</li></ul><p><br></p>', 'uploads/products/product_1764923014_6932968652b21.png', '2025-12-05 08:23:34', 1),
(33, 'asdasda', 4, 14, 'qwewdasd', 'qwewdasd', '[\"size: 12mm\", \"material: silver\", \"color: white\", \"warranty: 12 tháng\", \"weight: 134g\", \"brand: Rolex\", \"model: Submarier\"]', '[\"uploads/products/place-holder-1.png\", \"uploads/products/place-holder-2.png\"]', '<p>dasd</p>', NULL, '2025-12-05 08:47:20', 1),
(34, 'đâs', 6, 15, 'ádasd', 'adasd', '{\"size\": \"41mm\", \"brand\": \"rodo\", \"color\": \"White\", \"model\": \"Submariner\", \"weight\": \"10g\", \"material\": \"Oystersty\", \"warranty\": \"12 tháng\"}', '[\"uploads/products/place-holder-1.png\", \"uploads/products/place-holder-2.png\"]', '<p>đâsd</p>', NULL, '2025-12-05 08:55:22', 1),
(35, 'IW328201  ', 5, 15, 'Pilot’s Watch Mark XX  ', 'pilot-s-watch-mark-xx', '{\"size\": \"40mm\", \"brand\": \"IWC\", \"color\": \"Black\", \"model\": \"Mark XX\", \"weight\": \"155g\", \"material\": \"Thép không gỉ\", \"warranty\": \"24 tháng\"}', '[\"uploads/products/place-holder-1.png\", \"uploads/products/place-holder-2.png\"]', '<p>Khám phá Pilot’s Watch Mark XX (mã IW328201), biểu tượng của sự chính xác và di sản hàng không lừng lẫy từ IWC. Đây không chỉ là một chiếc đồng hồ, mà là lời khẳng định về kỹ thuật chế tác vượt trội, kế thừa tinh hoa của dòng đồng hồ phi công huyền thoại. Với mặt số rõ ràng, dễ đọc trong mọi điều kiện ánh sáng, cùng bộ vỏ thép không gỉ mạnh mẽ, Mark XX được thiết kế để chịu đựng những thử thách khắc nghiệt nhất. Bộ máy tự động đáng tin cậy bên trong đảm bảo độ chính xác tuyệt đối, biến chiếc đồng hồ này thành người bạn đồng hành lý tưởng cho những ai yêu thích sự phiêu lưu và giá trị vượt thời gian. Sở hữu Mark XX là sở hữu một phần lịch sử hàng không trên cổ tay bạn.</p>', NULL, '2025-12-09 12:16:03', 1),
(37, 'IW328201 ', 11, 11, 'Đồng hồ Citizen 40 mm Nam BI5124-50L HELO', 'dong-ho-citizen-40-mm-nam-bi5124-50l-helo', '{\"size\": \"40mm\", \"brand\": \"Citizen\", \"color\": \"Blue\", \"model\": \"BI5124-50L\", \"weight\": \"135g\", \"material\": \"Thép không gỉ\", \"warranty\": \"24 tháng\"}', '[\"uploads/products/place-holder-1.png\", \"uploads/products/place-holder-2.png\"]', '<p>Nâng tầm phong cách của quý ông hiện đại với Đồng hồ Citizen 40 mm Nam BI5124-50L, một biểu tượng của sự tinh tế và độ bền. Với mặt số màu xanh dương quyến rũ kết hợp vỏ và dây đeo thép không gỉ chắc chắn, chiếc đồng hồ này mang đến vẻ ngoài lịch lãm nhưng không kém phần năng động. Kích thước 40 mm lý tưởng ôm trọn cổ tay phái mạnh, tạo điểm nhấn hoàn hảo cho mọi trang phục, từ công sở đến dạo phố. Được trang bị bộ máy Quartz chính xác và khả năng chống nước ấn tượng, mẫu BI5124-50L (mã IW328201) không chỉ là phụ kiện thời trang mà còn là người bạn đồng hành đáng tin cậy. Citizen luôn khẳng định chất lượng vượt trội, và chiếc đồng hồ nam này là minh chứng hoàn hảo cho điều đó.</p>', 'https://storage.railway.app/organized-toybox-x74waqs9/products/1765307692_124fd4d74a2a83f2.png?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tid_PbRilWQ_TNzNkfqCDhd_TEKPfLUYikeVQzWJMTcJmZQQpLblcn%2F20251209%2Fiad%2Fs3%2Faws4_request&X-Amz-Date=20251209T191453Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Signature=b6f1015d4d0cb2ef297809faab27b817221b526685d78241b4e948c1459b96df', '2025-12-09 19:14:53', 1),
(40, 'IW328201 ', 6, 11, 'promolao', 'promolao', '{}', '[\"uploads\\/products\\/place-holder-1.png\",\"uploads\\/products\\/place-holder-2.png\"]', '<p>áda</p>', NULL, '2025-12-13 19:08:32', 1),
(41, 'FAC00009N0', 4, 14, '.htaccess', 'htaccess', '{}', '[\"uploads\\/products\\/place-holder-1.png\",\"uploads\\/products\\/place-holder-2.png\"]', '<p>ádada</p>', NULL, '2025-12-13 19:10:10', 1),
(42, 'FAC00009N0', 4, 14, '.htaccess', 'htaccess-1', '{}', '[\"uploads\\/products\\/place-holder-1.png\",\"uploads\\/products\\/place-holder-2.png\"]', '<p>ádada</p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765627964/products/1765627961_321534d7614101f4.png', '2025-12-13 19:12:44', 1),
(43, 'chim-to-co-toi', 11, 17, 'Đồng hồ cơ sơ', 'dong-ho-co-so', '{\"brand\":\"ROLE\",\"model\":\"d\",\"material\":\"d\",\"size\":\"42\",\"weight\":\"122g\",\"warranty\":\"24 th\\u00e1ng\"}', '[\"https:\\/\\/res.cloudinary.com\\/dfvaxlkol\\/image\\/upload\\/v1765631142\\/products\\/thumbnails\\/1765631142_642d1f93112cc1e0.png\"]', '<p>dsdsd</p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765631141/products/1765631139_c78d5a431700a1e8.png', '2025-12-13 20:05:43', 1),
(44, 'M228238-0005', 6, 6, 'Đồng Hồ Rolex 40mm Nam ', 'dong-ho-rolex-40mm-nam', '{\"size\":\"40mm\",\"material\":\"V\\u00e0ng v\\u00e0ng 18K\",\"warranty\":\"60 th\\u00e1ng\",\"weight\":\"230g\",\"brand\":\"Rolex\",\"model\":\"Day-Date 40\"}', '[\"uploads\\/products\\/place-holder-1.png\",\"uploads\\/products\\/place-holder-2.png\"]', '<p>Tôn vinh đẳng cấp phái mạnh với Đồng Hồ Rolex 40mm Nam mã M228238-0005 – một tuyệt tác Day-Date 40 trứ danh. Chế tác hoàn hảo từ vàng vàng 18k nguyên khối, chiếc đồng hồ này toát lên vẻ quyền quý và sang trọng vượt thời gian. Nổi bật với mặt số champagne tinh tế, được điểm xuyết bằng các cọc số kim cương lấp lánh tại vị trí 6 và 9 giờ, tạo nên sự khác biệt độc đáo. Vành khía (fluted bezel) đặc trưng cùng dây đeo President huyền thoại không chỉ làm tăng thêm vẻ đẹp mà còn khẳng định vị thế của chủ nhân. Bên trong là bộ máy Calibre 3255 tự động, đạt chuẩn Chronometer Thụy Sĩ, đảm bảo độ chính xác và tin cậy tuyệt đối. Đồng Hồ Rolex M228238-0005 không chỉ là vật phẩm xem giờ, mà là biểu tượng của thành công và phong cách sống đẳng cấp.</p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765634116/products/1765634112_b1f7cb9786d90bcf.png', '2025-12-13 20:55:16', 1),
(45, 'RDW-APW-001', 5, 14, 'Apple Watch Series 11 Viền Nhôm GPS 46mm', 'apple-watch-series-11-vien-nhom-gps-46mm', '{\"size\":\"46mm\",\"material\":\"D\\u00e2y cao su\",\"warranty\":\"24 th\\u00e1ng\",\"weight\":\"37.8g\",\"brand\":\"Apple Watch\",\"model\":\"H\\u00e3ng kh\\u00f4ng c\\u00f4ng b\\u1ed1\"}', '[\"https:\\/\\/res.cloudinary.com\\/dfvaxlkol\\/image\\/upload\\/v1765634355\\/products\\/thumbnails\\/1765634354_d5d861967601733b.png\"]', '<p><strong style=\"color: rgb(51, 51, 51);\">Mới đây, Apple đã chính thức giới thiệu mẫu đồng hồ thông minh mới nhất của mình, Apple Watch Series 11 Viền Nhôm GPS 46mm. Sản phẩm này nhanh chóng trở thành tâm điểm trong phân khúc smartwatch cao cấp nhờ loạt nâng cấp vượt trội từ thời lượng pin được cải thiện lên đến 24 giờ, màn hình Ion-X siêu bền và các tính năng sức khỏe AI tiên tiến. Đây không chỉ là một chiếc đồng hồ, mà còn là trợ lý sức khỏe và giao tiếp toàn diện trên cổ tay.</strong></p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765634354/products/1765634352_33099a228974ed39.png', '2025-12-13 20:59:15', 1),
(46, 'M126710BLNR-0003', 6, 6, 'Đồng Hồ Rolex 40mm Nam ', 'dong-ho-rolex-40mm-nam-1', '{\"size\":\"40mm\",\"material\":\"Th\\u00e9p kh\\u00f4ng g\\u1ec9\",\"warranty\":\"60 th\\u00e1ng\",\"weight\":\"155g\",\"brand\":\"Rolex\",\"model\":\"GMT-Master II\"}', '[\"uploads\\/products\\/place-holder-1.png\",\"uploads\\/products\\/place-holder-2.png\"]', '<p>Nâng tầm phong cách của bạn với Đồng Hồ Rolex 40mm Nam, một biểu tượng của sự sang trọng và chính xác. Đây là mẫu GMT-Master II huyền thoại, mã M126710BLNR-0003, nổi bật với vành bezel Cerachrom xanh dương và đen đặc trưng – biệt danh \"Batman\" nổi tiếng. Với kích thước 40mm lý tưởng, chiếc đồng hồ này hoàn hảo cho cổ tay nam giới, mang đến vẻ ngoài mạnh mẽ nhưng không kém phần tinh tế. Được chế tác từ thép Oystersteel cao cấp, nó không chỉ bền bỉ mà còn là một tuyên ngôn đẳng cấp vượt thời gian, thể hiện gu thẩm mỹ tinh tế và thành công của người sở hữu.</p>', NULL, '2025-12-13 21:04:37', 1),
(47, ' M126203-0020-1', 6, 6, 'Đồng Hồ Rolex 36mm Nam', 'dong-ho-rolex-36mm-nam', '{\"size\":\"36mm\",\"material\":\"Th\\u00e9p Oystersteel v\\u00e0 V\\u00e0ng v\\u00e0ng 18K\",\"warranty\":\"60 th\\u00e1ng\",\"weight\":\"140g\",\"brand\":\"Rolex\",\"model\":\"Datejust 36\"}', '[\"uploads\\/products\\/place-holder-1.png\",\"uploads\\/products\\/place-holder-2.png\"]', '<p>Nâng tầm phong cách và khẳng định đẳng cấp với Đồng Hồ Rolex 36mm Nam M126203-0020-1. Đây là biểu tượng của sự sang trọng vượt thời gian, kết hợp hoàn hảo giữa kỹ nghệ chế tác đỉnh cao và thiết kế kinh điển đặc trưng của Rolex. Với kích thước 36mm lý tưởng, chiếc đồng hồ Rolex nam này mang đến vẻ đẹp tinh tế, vừa vặn trên cổ tay, phù hợp cho mọi quý ông yêu thích sự lịch lãm và khác biệt. Từng chi tiết được hoàn thiện tỉ mỉ, từ sự kết hợp thép Oystersteel bền bỉ và vàng sang trọng đến cỗ máy tự động chính xác tuyệt đối. Sở hữu M126203-0020-1 không chỉ là sở hữu một chiếc đồng hồ cao cấp, mà còn là một di sản, một tuyên ngôn về giá trị và thành công.</p>', NULL, '2025-12-13 21:06:23', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_variants`
--

CREATE TABLE `product_variants` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `price` decimal(12,2) NOT NULL,
  `sku` varchar(100) DEFAULT NULL,
  `quantity` int(11) DEFAULT 0,
  `image` varchar(255) DEFAULT NULL,
  `colors` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`colors`)),
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `product_variants`
--

INSERT INTO `product_variants` (`id`, `product_id`, `price`, `sku`, `quantity`, `image`, `colors`, `created_at`) VALUES
(24, 29, 41240000.00, 'TIS-001-39', 10, 'https://image.donghohaitrieu.com/wp-content/uploads/2024/05/83743-S-6823.jpg', '[\"Bạc\", \"Vàng\"]', '2025-12-05 03:35:26'),
(25, 30, 109800000.00, 'OME-001-41', 98, NULL, '[\"bạc\", \"xanh navy\"]', '2025-12-05 03:49:21'),
(26, 31, 10000000.00, 'CAR-RUDO-40', 1, 'ok', '[\"gold\", \"xanh navy\"]', '2025-12-05 07:19:54'),
(27, 32, 12300000.00, 'CAR-FAC000-36', 36, 'null', '[\"trắng\"]', '2025-12-05 08:23:37'),
(28, 33, 120000.00, 'APP-ASDASD-41', 9, 'helo', '[\"đen\"]', '2025-12-05 08:47:23'),
(29, 34, 12000000.00, 'BRE-S-45', 12, 'hallo', '[\"vàng\"]', '2025-12-05 08:55:25'),
(30, 35, 8990000.00, 'BRE-IW3282-41', 17, 'https://example.com/dong-ho-apple-series-9/aw-s9-41mm-midnight.jpg', '[\"Midnight\"]', '2025-12-09 12:16:07'),
(31, 35, 9990000.00, 'BRE-IW3282-45', 11, 'https://example.com/dong-ho-apple-series-9/aw-s9-45mm-starlight.jpg', '[\"Starlight\"]', '2025-12-09 12:16:09'),
(33, 37, 1000.00, 'CAR-IW3282-40', 9996, 'https://example.com/citizen-bi5124-50l-black.jpg', '[\"Black Dial\", \"Silver Band\"]', '2025-12-09 19:14:57'),
(37, 40, 1200000.00, 'PAT-IW3282-41', 12222, 'hình ảnh', '[\"đen\"]', '2025-12-13 12:08:33'),
(38, 41, 100000000.00, 'APP-FAC000-41', 123, NULL, '[\"den\"]', '2025-12-13 12:10:10'),
(39, 43, 200000.00, 'PAT-toi-01', 2, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765631099/products/variants/1765631098_cfec2ec458e301c3.png', '[\"Trắng\",\"Đen\"]', '2025-12-13 13:05:43'),
(40, 43, 400000.00, 'PAT-toi-02', 5, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765631130/products/variants/1765631127_707550d9ca89bc7c.jpg', '[\"Vàng\"]', '2025-12-13 13:05:43'),
(41, 44, 4500000.00, 'ROL-0005-01', 5, 'https://example.com/rolex-228238-0005-nau-socola.jpg', '[\"vàng\"]', '2025-12-13 13:55:16'),
(42, 45, 12190000.00, 'APP-001-01', 20, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765634294/products/variants/1765634292_ad9e1e95f8f28796.png', '[\"Đen\"]', '2025-12-13 13:59:15'),
(43, 45, 13190000.00, 'APP-001-02', 13, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765634322/products/variants/1765634320_e1b976d2b2a14017.png', '[\"Trắng\"]', '2025-12-13 13:59:16'),
(44, 46, 124440000.00, 'ROL-0003-01', 12, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765634647/products/variants/1765634643_9d455744f98f7f85.png', '[\"tím\"]', '2025-12-13 14:04:37'),
(45, 46, 120000000.00, 'ROL-0003-02', 12, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765634646/products/variants/1765634643_25cc856bfb342555.png', '[\"xanh\"]', '2025-12-13 14:04:37'),
(46, 47, 15500.00, 'ROL-1-01', 8, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765634750/products/variants/1765634747_54739428987ceb2b.png', '[\"thép vàng\",\"mặt số bạc\"]', '2025-12-13 14:06:24'),
(47, 47, 16200.00, 'ROL-1-02', 4, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765634757/products/variants/1765634755_ecd596d366fd24f7.png', '[\"thép vàng\",\"mặt số xanh\"]', '2025-12-13 14:06:24');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `reviews`
--

CREATE TABLE `reviews` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `reply` text DEFAULT NULL,
  `rating` int(11) DEFAULT 5,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL,
  `admin_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `reviews`
--

INSERT INTO `reviews` (`id`, `user_id`, `product_id`, `content`, `reply`, `rating`, `status`, `created_at`, `updated_at`, `admin_id`) VALUES
(12, 11, 30, 'Ok nha', 'Cảm ơn bạn đã đánh giá!', 5, 1, '2025-12-10 04:06:15', NULL, 7),
(17, 11, 35, 'OK', 'Rất vui vì bạn hài lòng!', 5, 1, '2025-12-10 05:53:38', NULL, 232),
(19, 11, 29, 'Oke nha bro', NULL, 5, 1, '2025-12-10 06:11:06', NULL, NULL),
(20, 11, 37, 'OKE nha', 'Cảm ơn bạn nha!', 5, 0, '2025-12-10 07:28:43', '2025-12-13 15:56:15', 232),
(22, 234, 35, 'Oke nha', 'Đêm qua em tuyệt lắm', 4, 1, '2025-12-10 08:12:34', '2025-12-13 18:52:58', 232),
(23, 232, 44, 'Hơi rẻ không cùng đẳng cấp với mình', NULL, 5, 1, '2025-12-13 20:59:18', NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `shipping_method`
--

CREATE TABLE `shipping_method` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `cost` decimal(10,0) NOT NULL,
  `status` enum('0','1') NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `shipping_method`
--

INSERT INTO `shipping_method` (`id`, `name`, `cost`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Giao hàng tiêu chuẩn', 30000, '1', '2025-11-24 08:03:26', NULL),
(2, 'Giao hàng nhanh', 50000, '1', '2025-11-24 08:03:26', NULL),
(3, 'Giao hàng siêu tốc', 80000, '1', '2025-11-24 08:03:26', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tb_transactions`
--

CREATE TABLE `tb_transactions` (
  `id` int(11) NOT NULL,
  `gateway` varchar(100) DEFAULT NULL,
  `transaction_date` datetime DEFAULT NULL,
  `account_number` varchar(50) DEFAULT NULL,
  `sub_account` varchar(50) DEFAULT NULL,
  `amount_in` decimal(12,2) DEFAULT 0.00,
  `amount_out` decimal(12,2) DEFAULT 0.00,
  `accumulated` decimal(12,2) DEFAULT NULL,
  `code` varchar(100) DEFAULT NULL,
  `transaction_content` text DEFAULT NULL,
  `reference_number` varchar(150) DEFAULT NULL,
  `body` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `tb_transactions`
--

INSERT INTO `tb_transactions` (`id`, `gateway`, `transaction_date`, `account_number`, `sub_account`, `amount_in`, `amount_out`, `accumulated`, `code`, `transaction_content`, `reference_number`, `body`, `created_at`) VALUES
(9, 'BIDV', '2025-12-10 06:31:24', '8836563558', NULL, 31000.00, 0.00, 10000000.00, 'TEST1765348284', 'DH13', 'REF1765348284', 'Thanh toan don hang', '2025-12-10 06:31:34'),
(10, NULL, NULL, NULL, NULL, 0.00, 0.00, NULL, NULL, NULL, NULL, NULL, '2025-12-10 07:23:10'),
(11, NULL, NULL, NULL, NULL, 0.00, 0.00, NULL, NULL, NULL, NULL, NULL, '2025-12-10 07:27:36'),
(12, NULL, NULL, NULL, NULL, 0.00, 0.00, NULL, NULL, NULL, NULL, NULL, '2025-12-10 07:27:40'),
(13, NULL, NULL, NULL, NULL, 0.00, 0.00, NULL, NULL, NULL, NULL, NULL, '2025-12-10 07:27:45'),
(14, 'BIDV', '2025-12-10 07:28:59', '8836563558', NULL, 31000.00, 0.00, 10000000.00, 'TEST1765351739', 'DH13', 'REF1765351739', 'Thanh toan don hang', '2025-12-10 07:29:03'),
(15, NULL, '2025-12-13 05:11:52', NULL, NULL, 0.00, 0.00, NULL, NULL, NULL, NULL, NULL, '2025-12-13 12:11:49'),
(16, NULL, '2025-12-13 05:12:17', NULL, NULL, 0.00, 0.00, NULL, NULL, NULL, NULL, NULL, '2025-12-13 12:12:14'),
(17, 'BIDV', '2025-12-13 05:12:17', '1234567890', NULL, 1000000.00, 0.00, 5000000.00, NULL, 'DH123', 'TEST_1765602737', NULL, '2025-12-13 12:12:15'),
(18, NULL, '2025-12-13 05:12:39', NULL, NULL, 0.00, 0.00, NULL, NULL, NULL, NULL, NULL, '2025-12-13 12:12:37'),
(19, 'BIDV', '2025-12-13 05:12:39', '1234567890', NULL, 1000000.00, 0.00, 5000000.00, NULL, 'DH123', 'TEST_1765602759', NULL, '2025-12-13 12:12:37'),
(20, NULL, '2025-12-13 05:14:38', NULL, NULL, 0.00, 0.00, NULL, NULL, NULL, NULL, NULL, '2025-12-13 12:14:36'),
(21, 'BIDV', '2025-12-13 05:14:38', '1234567890', NULL, 1000000.00, 0.00, 5000000.00, NULL, 'DH123', 'TEST_1765602878', NULL, '2025-12-13 12:14:36'),
(22, 'BIDV', '2025-12-13 12:27:31', '8836563558', '96247RUDOWATCH', 31000.00, 0.00, 0.00, NULL, '110715862365 0916110241 DH13', '2fb062de-d258-44bc-948f-a4d3727b1092', 'BankAPINotify 110715862365 0916110241 DH13', '2025-12-13 12:27:34'),
(23, 'BIDV', '2025-12-13 18:59:37', '8836563558', '96247RUDOWATCH', 31000.00, 0.00, 0.00, NULL, '110757086347 0916110241 DH22', '2bd2c432-8c37-4072-81c8-3adc0663cc1a', 'BankAPINotify 110757086347 0916110241 DH22', '2025-12-13 18:59:39'),
(24, 'BIDV', '2025-12-13 19:07:16', '8836563558', '96247RUDOWATCH', 31000.00, 0.00, 0.00, NULL, '110758026907 0916110241 DH23', '8ee8f515-250f-4397-9978-e94d5e223f00', 'BankAPINotify 110758026907 0916110241 DH23', '2025-12-13 19:07:18');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `fullname` varchar(150) DEFAULT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `role` tinyint(4) DEFAULT 0,
  `status` tinyint(4) DEFAULT 1,
  `api_token` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `fullname`, `email`, `password`, `phone`, `role`, `status`, `api_token`, `created_at`, `updated_at`) VALUES
(7, 'Phan Bình', 'phanbinhfedev150504@gmail.com', '$2y$10$5UkQSUz1xiSqnNVqaoWP5ekCGGVaqS8hQcSP6IFMRLccJZeIt5EeW', '0393159478', 1, 1, '1b7bdc70aeec5420ba452fe88c8dac6933f434e2a7bdf73af9e2cb100c12a050', '2025-11-24 00:00:00', '2025-12-03 00:11:09'),
(8, 'Toàn đẹp trai', 'pductoandev@gmail.com', 'y0/hc/p7EgiDbp3tZVx6uxVznox5mB/y5q3ee8NAJ4CyHDT6Rmku', '0916110241', 1, 1, '36c25ee1542a1582a3cb728ea0e50eb93a84987244ac63b915db58dc9ee1d1e8', '2025-11-24 00:00:00', '2025-11-28 00:00:00'),
(9, 'Nguyen Anh Khoi', 'tuyetnhng010193@gmail.com', '$2y$10$YjMK6K2PSn1E6.2WMFEHV.2L/ICaNAGHnYZZxoWVkBzbC0HSfiVQO', '0393159438', 0, 1, 'b26c61b626a82dec5d97f9cf24269920229bd774d9bfd5236f8e6d6c87271999', '2025-11-24 00:00:00', NULL),
(11, 'Phan Đức Bình', 'phanbinh150504@gmail.com', '$2y$10$MYUVcgDyXPbNUHtLjUjpTOa8cHmUxfCppui/lCads0OgvVWhE0y2C', '0382832609', 1, 1, '56d83e61b177f0e0c547e2bfeb7b792d79b650f980f58769de31d8a28b6b85af', '2025-11-26 00:00:00', '2025-12-13 10:48:54'),
(18, 'Phan Đức Toàn admin', 'pductoandevvvv@gmail.com', 'y0', '0916110241', 1, 1, '37852d5257098a5e8a6e688bd39c3296f0707ae5da8f1d217ffbb5b6409d095b', '2025-11-29 00:00:00', '2025-11-30 14:03:34'),
(19, 'nguey anh khoi', 'pductoandettt@gmail.com', '$2y$10$4neyO9PY51eo5hrNbTrj4.YiWM6N89P0Qs1fTb18dxBvKKyAmxceC', '0961011024', 1, 1, 'ebe436426eaa2e479c45098f440d33397c2c195c6d57b406bf9ad9ad8a6cff82', '2025-11-29 18:26:02', NULL),
(21, 'Chim to cột điệnn', 'toanphan01vip@gmail.com', '$2y$10$8IcAI2YnRmNSQutB4RM.FuuID9fwFT5WX2mOk5U9cohE9eteiAQ1S', '0916110241', 1, 1, 'f304fd6fd889cd88e3d87056f4181e44acbcdfb2c68154f5a39b0dd6bc8009f8', '2025-11-30 06:49:14', '2025-12-13 02:08:43'),
(22, 'Ma Gaming', 'magaming0101@gmail.com', '$2y$10$Qejsv7qQAelw4h.oKnVBKu9V0hYrxLkQWXll0PALmpZWhCccbKZJS', NULL, 0, 1, 'b335c44eace86b5b56af4ce1e441aab5fc9602e56562325100f64a5fa960cc5e', '2025-11-30 08:01:53', NULL),
(23, 'Zu Côn', 'zucon441@gmail.com', '$2y$10$Br8/pmJxmhrWUyM51Ium4.03dAMQdjy9M6xavUul4OF/9T9UIzV3q', NULL, 1, 1, '38f6dff32430c150f0f7d237ea1defca22fa82974de42fd0965583a050dd5529', '2025-11-30 08:17:29', NULL),
(24, 'Nguyễn Anh Khôi', 'anhkhoi@gmail.com', '123456', NULL, 1, 1, NULL, '2025-12-02 05:38:28', NULL),
(26, 'Phan toàn', 'pductoanhehe@gmail.com', '$2y$10$lYYlvrAMfyJ/iedlPx8Elu6V8JNFow5M9VfDlAqhuQ3XaL.yGIrRW', '0916110241', 0, 1, '0d4b317ec26f641c4b10a07721b59363113c5720cd6537c5ec2028125eace643', '2025-12-02 06:22:03', '2025-12-03 07:15:35'),
(27, 'Nguyễn anh Khôi khôi khôi', 'khoilord@gmail.com', '$2y$10$0yX28.SBGFC5NYipICitRevgOh94pPjMcH8D/rxB.nBUDDrsKbRP.', '0393159434', 0, 1, '627bff396080fb3bcab60ae781e1a9e88799f3cb0e70f34b3e1701126ed6f6ca', '2025-12-02 08:30:04', '2025-12-05 07:49:51'),
(28, 'B P', 'masterphp2025@gmail.com', '$2y$10$ViaW7Bs3wDHKZQGZ3PJAe.a.uq8XZadviMSbkAdtdbkR857I.anxi', NULL, 0, 1, 'cbcf4a9c7a47966919832b32b29c00a15b77e499a529a742d373d7027e6f883d', '2025-12-03 00:08:18', '2025-12-03 00:08:50'),
(29, 'Nguyen Van A', 'test@example.com', '$2y$10$tqcedtKrYo8W2z0wi3uWpuUoghd4GML8.A5RVXYIfEuVBXXJ/Hr9O', '0912345678', 0, 0, 'bee1afcbf8b8a95eeab0543d5c2740cb882ca2bdcf6cf18896785984bfb2b636', '2025-12-03 08:09:12', '2025-12-04 07:46:05'),
(30, 'Phan Đức Toàn', 'pductoandec@gmail.com', '$2y$10$SDXgbxhhz9XmjsAEitnCEeZVyV..rJbx2KsJAhLKAwIn76VgXa7Gm', '0916110241', 1, 1, '9ddad539c6ebebacb290b7a269f0201c5b2cbec627a1bdd31db98d550c24b73b', '2025-12-04 04:02:39', NULL),
(31, 'Lê Thị Tuấn', 'user1_637@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0913493075', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(32, 'Lê Ngọc Tuấn', 'user2_654@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0911760596', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(33, 'Hoàng Minh Trang', 'user3_698@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0986309508', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(34, 'Trần Đức Sơn', 'user4_788@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0946678699', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(35, 'Trần Minh Dũng', 'user5_810@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0923409799', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(36, 'Nguyễn Ngọc Sơn', 'user6_409@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0949830551', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(37, 'Hoàng Văn Hùng', 'user7_804@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0988951798', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(38, 'Trần Thị Cường', 'user8_535@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0941655683', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(39, 'Huỳnh Văn Hạnh', 'user9_604@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0961121216', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(40, 'Phạm Văn Tuấn', 'user10_74@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0928259141', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(41, 'Lê Đức Nam', 'user11_736@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0945162024', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(42, 'Hoàng Ngọc Dũng', 'user12_30@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0947308701', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(43, 'Huỳnh Đức Nam', 'user13_607@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0987917137', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(44, 'Vũ Văn Sơn', 'user14_875@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0984126193', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(45, 'Vũ Đức Linh', 'user15_90@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0963248519', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(46, 'Huỳnh Thị Linh', 'user16_368@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0927125914', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(47, 'Huỳnh Minh Nam', 'user17_730@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0932898447', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(48, 'Huỳnh Hữu Dũng', 'user18_732@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0988770819', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(49, 'Lê Minh Hạnh', 'user19_214@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0976667187', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(50, 'Nguyễn Thị Sơn', 'user20_434@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0976057359', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(51, 'Huỳnh Văn Cường', 'user21_22@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0979638647', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(52, 'Huỳnh Văn Tuấn', 'user22_58@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0931056131', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(53, 'Lê Đức Sơn', 'user23_460@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0965652929', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(54, 'Huỳnh Đức Nam', 'user24_790@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0963586269', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(55, 'Trần Đức Hùng', 'user25_312@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0967497935', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(56, 'Lê Văn Linh', 'user26_981@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0927522587', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(57, 'Hoàng Minh Dũng', 'user27_757@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0982363268', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(58, 'Lê Đức Dũng', 'user28_678@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0953353318', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(59, 'Phạm Văn Nam', 'user29_810@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0977350658', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(60, 'Lê Ngọc Hạnh', 'user30_843@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0982727035', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(61, 'Trần Văn Hạnh', 'user31_389@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0957154291', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(62, 'Huỳnh Văn Cường', 'user32_816@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0983138616', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(63, 'Huỳnh Thị Nam', 'user33_664@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0922200534', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(64, 'Nguyễn Văn Hạnh', 'user34_665@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0986556669', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(65, 'Huỳnh Hữu Hạnh', 'user35_143@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0934450408', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(66, 'Phan Đức Hùng', 'user36_585@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0992496603', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(67, 'Phạm Đức Hạnh', 'user37_250@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0989112432', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(68, 'Hoàng Hữu Tuấn', 'user38_457@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0917489264', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(69, 'Vũ Minh Nam', 'user39_495@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0933922660', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(70, 'Phạm Ngọc Hùng', 'user40_245@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0923544078', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(71, 'Huỳnh Văn Trang', 'user41_590@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0931121309', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(72, 'Lê Thị Yến', 'user42_304@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0962210774', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(73, 'Trần Văn Cường', 'user43_126@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0942153302', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(74, 'Vũ Ngọc Dũng', 'user44_247@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0933221314', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(75, 'Vũ Văn Sơn', 'user45_906@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0992719588', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(76, 'Huỳnh Ngọc Yến', 'user46_929@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0960187158', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(77, 'Lê Ngọc Linh', 'user47_292@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0975140085', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(78, 'Hoàng Đức Trang', 'user48_443@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0962559071', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(79, 'Trần Thị Cường', 'user49_528@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0942763065', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(80, 'Nguyễn Minh Hạnh', 'user50_784@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0948867217', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(81, 'Huỳnh Thị Dũng', 'user51_230@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0927105343', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(82, 'Huỳnh Hữu Tuấn', 'user52_683@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0936324178', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(83, 'Trần Ngọc Yến', 'user53_534@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0963457687', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(84, 'Nguyễn Văn Trang', 'user54_360@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0922177020', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(85, 'Hoàng Văn Trang', 'user55_660@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0964735652', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(86, 'Phạm Thị Yến', 'user56_551@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0985418072', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(87, 'Trần Thị Trang', 'user57_235@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0950809911', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(88, 'Phạm Ngọc Linh', 'user58_678@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0969941238', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(89, 'Phạm Đức Dũng', 'user59_367@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0996688298', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(90, 'Huỳnh Thị Linh', 'user60_321@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0996793923', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(91, 'Phạm Đức Sơn', 'user61_67@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0978482201', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(92, 'Huỳnh Minh Sơn', 'user62_857@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0975295458', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(93, 'Nguyễn Đức Cường', 'user63_131@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0941471598', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(94, 'Huỳnh Ngọc Trang', 'user64_178@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0928391315', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(95, 'Phan Ngọc Yến', 'user65_359@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0988505414', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(96, 'Phan Văn Hạnh', 'user66_622@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0958110230', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(97, 'Phạm Minh Linh', 'user67_15@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0947090942', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(98, 'Phan Văn Hạnh', 'user68_193@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0966780614', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(99, 'Vũ Thị Dũng', 'user69_215@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0930496273', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(100, 'Phan Đức Yến', 'user70_277@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0936299122', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(101, 'Lê Đức Hùng', 'user71_484@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0942461637', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(102, 'Huỳnh Thị Cường', 'user72_457@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0989504210', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(103, 'Hoàng Minh Nam', 'user73_874@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0999199361', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(104, 'Huỳnh Đức Hạnh', 'user74_399@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0960597308', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(105, 'Phạm Văn Hạnh', 'user75_512@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0924198299', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(106, 'Phan Văn Cường', 'user76_723@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0936989175', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(107, 'Huỳnh Minh Trang', 'user77_314@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0912759644', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(108, 'Vũ Văn Dũng', 'user78_150@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0997610245', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(109, 'Trần Ngọc Linh', 'user79_805@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0922853621', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(110, 'Nguyễn Đức Dũng', 'user80_513@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0971230322', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(111, 'Lê Minh Tuấn', 'user81_884@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0937350689', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(112, 'Phạm Đức Linh', 'user82_649@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0960585278', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(113, 'Huỳnh Ngọc Sơn', 'user83_559@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0935543281', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(114, 'Phan Văn Yến', 'user84_48@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0941010900', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(115, 'Phan Ngọc Hạnh', 'user85_250@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0974137049', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(116, 'Vũ Văn Tuấn', 'user86_651@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0926787950', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(117, 'Lê Minh Yến', 'user87_31@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0930437982', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(118, 'Hoàng Ngọc Dũng', 'user88_188@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0921036396', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(119, 'Phan Thị Trang', 'user89_828@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0967698070', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(120, 'Huỳnh Thị Hạnh', 'user90_857@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0996435080', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(121, 'Lê Ngọc Trang', 'user91_562@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0935145050', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(122, 'Huỳnh Đức Sơn', 'user92_88@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0989330863', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(123, 'Nguyễn Hữu Hùng', 'user93_16@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0912931184', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(124, 'Phạm Văn Nam', 'user94_442@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0919114115', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(125, 'Hoàng Đức Hùng', 'user95_609@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0991356097', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(126, 'Huỳnh Ngọc Dũng', 'user96_684@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0971619138', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(127, 'Phan Hữu Dũng', 'user97_138@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0986471011', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(128, 'Hoàng Ngọc Tuấn', 'user98_403@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0994702157', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(129, 'Huỳnh Minh Tuấn', 'user99_835@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0912537559', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(130, 'Nguyễn Ngọc Linh', 'user100_943@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0985497127', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(131, 'Lê Đức Hạnh', 'user101_446@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0984903151', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(132, 'Hoàng Ngọc Linh', 'user102_338@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0998006153', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(133, 'Phạm Ngọc Hùng', 'user103_378@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0972667117', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(134, 'Huỳnh Văn Sơn', 'user104_900@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0989057355', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(135, 'Phan Hữu Trang', 'user105_683@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0983663258', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(136, 'Phan Ngọc Dũng', 'user106_694@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0974244012', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(137, 'Lê Hữu Dũng', 'user107_810@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0932006204', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(138, 'Trần Minh Tuấn', 'user108_870@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0937501720', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(139, 'Huỳnh Ngọc Sơn', 'user109_487@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0993411194', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(140, 'Nguyễn Hữu Linh', 'user110_469@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0968698601', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(141, 'Lê Hữu Tuấn', 'user111_56@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0934581726', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(142, 'Trần Thị Yến', 'user112_553@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0984371620', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(143, 'Vũ Hữu Hạnh', 'user113_102@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0992243725', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(144, 'Hoàng Văn Trang', 'user114_445@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0971784320', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(145, 'Phạm Minh Yến', 'user115_72@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0937637852', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(146, 'Huỳnh Đức Sơn', 'user116_946@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0939055373', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(147, 'Vũ Thị Hạnh', 'user117_264@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0987418976', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(148, 'Vũ Thị Hùng', 'user118_902@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0959471694', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(149, 'Hoàng Ngọc Trang', 'user119_763@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0928957883', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(150, 'Trần Ngọc Trang', 'user120_940@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0911877619', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(151, 'Lê Hữu Cường', 'user121_418@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0985094496', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(152, 'Nguyễn Ngọc Tuấn', 'user122_173@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0980905594', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(153, 'Huỳnh Đức Yến', 'user123_280@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0943028551', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(154, 'Phan Đức Hạnh', 'user124_814@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0959025816', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(155, 'Phan Hữu Trang', 'user125_20@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0940036039', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(156, 'Nguyễn Đức Yến', 'user126_366@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0978904283', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(157, 'Lê Ngọc Yến', 'user127_634@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0930325004', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(158, 'Phạm Ngọc Trang', 'user128_153@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0911268439', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(159, 'Nguyễn Thị Hạnh', 'user129_821@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0982604308', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(160, 'Phạm Đức Nam', 'user130_466@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0922265651', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(161, 'Vũ Văn Yến', 'user131_955@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0979297247', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(162, 'Hoàng Văn Trang', 'user132_500@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0988688367', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(163, 'Huỳnh Văn Dũng', 'user133_808@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0918701332', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(164, 'Vũ Minh Hạnh', 'user134_101@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0924849526', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(165, 'Nguyễn Văn Yến', 'user135_312@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0961841313', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(166, 'Vũ Văn Cường', 'user136_871@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0919688798', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(167, 'Lê Minh Yến', 'user137_26@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0932810562', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(168, 'Trần Thị Tuấn', 'user138_431@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0992710426', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(169, 'Huỳnh Minh Sơn', 'user139_982@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0931479654', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(170, 'Hoàng Minh Cường', 'user140_9@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0964002475', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(171, 'Nguyễn Đức Nam', 'user141_610@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0981055495', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(172, 'Trần Minh Sơn', 'user142_282@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0980384540', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(173, 'Vũ Ngọc Linh', 'user143_426@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0940856171', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(174, 'Trần Đức Trang', 'user144_660@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0962948014', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(175, 'Nguyễn Thị Cường', 'user145_377@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0953965676', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(176, 'Nguyễn Ngọc Hùng', 'user146_27@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0927099078', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(177, 'Phan Thị Sơn', 'user147_630@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0959789484', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(178, 'Huỳnh Hữu Yến', 'user148_209@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0928855241', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(179, 'Phạm Văn Dũng', 'user149_390@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0928842838', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(180, 'Huỳnh Văn Linh', 'user150_157@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0991199022', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(181, 'Phạm Thị Tuấn', 'user151_165@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0982585238', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(182, 'Lê Minh Nam', 'user152_503@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0941853689', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(183, 'Trần Đức Hạnh', 'user153_719@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0918893084', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(184, 'Phạm Hữu Hùng', 'user154_13@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0914188330', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(185, 'Phan Ngọc Hạnh', 'user155_142@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0936104482', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(186, 'Lê Thị Hạnh', 'user156_240@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0975767259', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(187, 'Phạm Ngọc Hùng', 'user157_967@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0988874103', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(188, 'Phan Đức Yến', 'user158_157@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0980743642', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(189, 'Vũ Thị Trang', 'user159_4@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0939951293', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(190, 'Lê Đức Dũng', 'user160_750@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0988805930', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(191, 'Nguyễn Ngọc Linh', 'user161_148@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0917955170', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(192, 'Huỳnh Ngọc Sơn', 'user162_659@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0964005649', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(193, 'Lê Đức Cường', 'user163_775@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0960548919', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(194, 'Huỳnh Thị Nam', 'user164_216@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0983337029', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(195, 'Huỳnh Văn Yến', 'user165_697@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0966642427', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(196, 'Phạm Minh Yến', 'user166_968@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0990167679', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(197, 'Nguyễn Minh Hùng', 'user167_588@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0991780673', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(198, 'Trần Đức Sơn', 'user168_939@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0917929867', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(199, 'Phan Đức Linh', 'user169_80@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0974844230', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(200, 'Huỳnh Văn Sơn', 'user170_701@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0910630442', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(201, 'Huỳnh Đức Sơn', 'user171_375@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0929361020', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(202, 'Nguyễn Ngọc Sơn', 'user172_314@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0915456397', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(203, 'Hoàng Văn Linh', 'user173_124@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0992128937', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(204, 'Trần Đức Nam', 'user174_425@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0982541591', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(205, 'Lê Ngọc Cường', 'user175_830@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0976960730', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(206, 'Vũ Hữu Trang', 'user176_95@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0989989602', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(207, 'Trần Văn Cường', 'user177_604@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0979662217', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(208, 'Vũ Ngọc Hạnh', 'user178_124@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0914028017', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(209, 'Nguyễn Văn Dũng', 'user179_515@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0978055514', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(210, 'Vũ Minh Hùng', 'user180_435@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0913886934', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(211, 'Phạm Đức Trang', 'user181_698@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0984032316', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(212, 'Hoàng Văn Linh', 'user182_285@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0965523029', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(213, 'Lê Minh Sơn', 'user183_967@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0939598828', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(214, 'Huỳnh Đức Sơn', 'user184_962@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0937895907', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(215, 'Phạm Hữu Trang', 'user185_749@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0929897847', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(216, 'Hoàng Ngọc Nam', 'user186_42@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0915638071', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(217, 'Huỳnh Văn Trang', 'user187_424@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0943688172', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(218, 'Phan Ngọc Tuấn', 'user188_792@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0975002945', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(219, 'Nguyễn Thị Yến', 'user189_77@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0960028076', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(220, 'Nguyễn Minh Hạnh', 'user190_915@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0911039994', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(221, 'Hoàng Minh Sơn', 'user191_352@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0919354327', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(222, 'Vũ Ngọc Tuấn', 'user192_468@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0924420103', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(223, 'Phạm Thị Dũng', 'user193_984@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0910690560', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(224, 'Phạm Minh Cường', 'user194_277@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0990059000', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(225, 'Phạm Thị Sơn', 'user195_602@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0951013102', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(226, 'Vũ Ngọc Sơn', 'user196_365@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0946152392', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(227, 'Lê Văn Hạnh', 'user197_687@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0994546897', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(228, 'Lê Hữu Hùng', 'user198_917@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0969534441', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(229, 'Phan Thị Tuấn', 'user199_437@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0910891908', 0, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(230, 'Huỳnh Văn Hùng', 'user200_771@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '0969459726', 1, 1, NULL, '2025-12-04 08:04:17', '2025-12-04 08:04:17'),
(231, 'Vuong Quoc', 'vuong.nguyenquoc.sistrain@gmail.com', '$2y$10$6dsTtpdejUmoIKhd.0noX.jeCkkwm.zG9LBGBq03qZ9vZAhXI3AvG', NULL, 0, 0, 'a3a13cc23b1a23d4dfa681972051998aeecdee0f01e7ea648c431a7ac8adab0e', '2025-12-08 01:58:27', '2025-12-10 08:08:55'),
(232, 'Nguyễn anh Khôi', 'nguyenanhkhoi@gmail.com', '$2y$10$JdzF3X0ziwY0y0Yq5veDvOUMqRzAObYQbPGfAsSwdSAGIvno2/5xW', '0974010123', 1, 1, '4abb35b24b08af3e36dfc8797c55f8213c48175f52db1001b86384b42385e4a2', '2025-12-08 08:09:45', NULL),
(233, 'Poly Coder', 'coderpoly.fpthcm@gmail.com', '$2y$10$XzHE8l.vTCeYMlTDuI5iMuT7/f1TioQXkJyILCK/7p/WSPzZpLK.K', NULL, 1, 1, '7d76147dce1cb84fe5b0789e180852705fb08ff0996ebe5dbe76c186b2e04022', '2025-12-10 06:15:08', NULL),
(234, 'Phan Duc Binh', '22142083@student.hcmute.edu.vn', '$2y$10$IUgaIMdoFjz7dF/nM8uY0uZ4qIxXb.MU04EpoIVLPey5irR9agPt.', NULL, 0, 1, '20092949c3127c778a6dce7d793092aaa24d6d2db49352ff411b0a9cd2535091', '2025-12-10 08:05:36', NULL),
(235, 'Nguyễn Văn A', 'user@example.com', '$2y$10$INCOnjYUZqepH/sW.R69/uvexl3DHTgKme0VhDeHNgQO84ipI8vrW', '0123456789', 0, 1, '917674df8059ec08a393858702a3840a166c0eb27b3ce631ea8d0eb8e15fb9bf', '2025-12-12 18:47:01', NULL),
(236, 'Toàn đẹp trai', 'phanductoandev@gmail.com', '$2y$10$t6DYoknEsU1XRksbtJib8eZY2/8ieAJn8sdRXCAi5ycGdE6NzsnHi', '0916110241', 0, 1, '31b5cd14ad6e71d8cdce6ff2e1668de3e9ddfdb521c775958011addee22f0481', '2025-12-13 02:38:32', '2025-12-13 02:54:56');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `vouchers`
--

CREATE TABLE `vouchers` (
  `id` int(11) NOT NULL,
  `code` varchar(50) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `discount` int(11) DEFAULT NULL,
  `amount` decimal(12,2) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `start_at` datetime DEFAULT NULL,
  `expired_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `api_token` varchar(255) DEFAULT NULL,
  `usage_limit` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `vouchers`
--

INSERT INTO `vouchers` (`id`, `code`, `type`, `discount`, `amount`, `created_at`, `start_at`, `expired_at`, `updated_at`, `api_token`, `usage_limit`) VALUES
(10, 'SIEUSALE', 'percent', 10, NULL, '2025-12-05 08:20:29', NULL, '2025-12-28 15:20:00', '2025-12-08 08:18:46', NULL, 1000),
(11, 'GIANGSINH', 'percent', 20, NULL, '2025-12-10 06:30:52', NULL, '2026-05-13 13:30:00', NULL, NULL, 100),
(12, 'OKOKEKEOOKE', 'percent', 10, NULL, '2025-12-10 08:03:55', NULL, '2025-12-18 18:06:00', NULL, NULL, 100),
(13, 'SALE20', 'percent', 20, NULL, '2025-12-13 13:10:55', NULL, '2025-12-31 10:12:00', NULL, NULL, 100);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_brand_slug` (`slug`);

--
-- Chỉ mục cho bảng `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_cart_item` (`cart_id`,`variant_id`),
  ADD KEY `variant_id` (`variant_id`);

--
-- Chỉ mục cho bảng `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_category_slug` (`slug`);

--
-- Chỉ mục cho bảng `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `post_id` (`post_id`);

--
-- Chỉ mục cho bảng `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Chỉ mục cho bảng `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `voucher_id` (`voucher_id`);

--
-- Chỉ mục cho bảng `order_detail`
--
ALTER TABLE `order_detail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `variant_id` (`variant_id`);

--
-- Chỉ mục cho bảng `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_token` (`token`),
  ADD KEY `idx_expires_at` (`expires_at`);

--
-- Chỉ mục cho bảng `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Chỉ mục cho bảng `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_post_slug` (`slug`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `post_category_id` (`post_category_id`);

--
-- Chỉ mục cho bảng `posts_categories`
--
ALTER TABLE `posts_categories`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `brand_id` (`brand_id`);

--
-- Chỉ mục cho bảng `product_variants`
--
ALTER TABLE `product_variants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_variant_sku` (`sku`),
  ADD KEY `product_id` (`product_id`);

--
-- Chỉ mục cho bảng `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Chỉ mục cho bảng `shipping_method`
--
ALTER TABLE `shipping_method`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tb_transactions`
--
ALTER TABLE `tb_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_transaction_date` (`transaction_date`),
  ADD KEY `idx_account_number` (`account_number`),
  ADD KEY `idx_reference_number` (`reference_number`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_email_status` (`email`,`status`),
  ADD KEY `idx_api_token_status` (`api_token`,`status`),
  ADD KEY `idx_role_status_created` (`role`,`status`,`created_at`),
  ADD KEY `idx_users_role` (`role`);

--
-- Chỉ mục cho bảng `vouchers`
--
ALTER TABLE `vouchers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT cho bảng `brands`
--
ALTER TABLE `brands`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT cho bảng `carts`
--
ALTER TABLE `carts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT cho bảng `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT cho bảng `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT cho bảng `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT cho bảng `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT cho bảng `order_detail`
--
ALTER TABLE `order_detail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT cho bảng `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100;

--
-- AUTO_INCREMENT cho bảng `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT cho bảng `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT cho bảng `posts_categories`
--
ALTER TABLE `posts_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT cho bảng `product_variants`
--
ALTER TABLE `product_variants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT cho bảng `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT cho bảng `shipping_method`
--
ALTER TABLE `shipping_method`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `tb_transactions`
--
ALTER TABLE `tb_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=237;

--
-- AUTO_INCREMENT cho bảng `vouchers`
--
ALTER TABLE `vouchers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `carts`
--
ALTER TABLE `carts`
  ADD CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `favorites_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `order_detail`
--
ALTER TABLE `order_detail`
  ADD CONSTRAINT `order_detail_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `order_detail_ibfk_2` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `posts_ibfk_2` FOREIGN KEY (`post_category_id`) REFERENCES `posts_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `product_variants`
--
ALTER TABLE `product_variants`
  ADD CONSTRAINT `product_variants_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
