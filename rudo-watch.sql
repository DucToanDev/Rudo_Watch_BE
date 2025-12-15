-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: localhost:3306
-- Thời gian đã tạo: Th12 15, 2025 lúc 01:25 PM
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
(20, 7, '76/1 Tân Chánh Hiệp 08', 'Phường Tân Chánh Hiệp', 'Thành phố Hồ Chí Minh', 'Bình Phan', '0382832609', '2025-12-03 00:10:59', '2025-12-03 00:12:19', 1),
(22, 27, 'Huyện Hàm Thuận Nam', '', 'Tuyên Quang', 'ádada', '0123456789', '2025-12-05 07:50:30', NULL, 1),
(23, 11, '145 Tổ 2', 'Xã Đinh Văn Lâm Hà', 'Lâm Đồng', 'Thanh Phan', '0339817726', '2025-12-05 08:01:01', '2025-12-13 13:32:07', 0),
(24, 11, '76/1 Tân Chánh Hiệp 08', 'Phường Trung Mỹ Tây', 'Hồ Chí Minh', 'Bình Phan', '0382832609', '2025-12-05 08:01:45', '2025-12-13 13:33:06', 1),
(25, 8, '369 Đường Tô Ký', 'Phường 12', 'Thành phố Hồ Chí Minh', 'lkahdkad', '0393159478', '2025-12-10 08:06:53', '2025-12-11 14:44:35', 0),
(26, 8, '369 Đường Tô Ký', 'Phường Trung Mỹ Tây', 'Thành phố Hồ Chí Minh', 'sdas', '0393159478', '2025-12-10 08:07:28', '2025-12-11 14:44:35', 1),
(27, 232, 'Huyện Hàm Thuận Nam', 'Phường 17', 'Thành phố Hồ Chí Minh', 'Toàn dầu ăn', '0393159478', '2025-12-12 17:15:30', '2025-12-13 12:32:42', 0),
(28, 232, 'Huyện Hàm Thuận Nam', 'Phường Dĩ An', 'Hồ Chí Minh', 'khung củ', '0192345678', '2025-12-12 18:00:11', '2025-12-13 12:32:42', 1),
(29, 21, 'Thôn mèn mén', 'Xã Hòa An', 'Cao Bằng', 'Phan Đức Toàn', '0916110241', '2025-12-14 19:18:04', '2025-12-14 21:23:40', 0),
(30, 21, '369 Đường Tô Ký', 'Xã Thạnh An', 'Hồ Chí Minh', 'Toàn đẹp trai', '0916112041', '2025-12-14 19:18:43', '2025-12-14 21:23:40', 1);

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
(8, 11, '2025-12-08 01:04:43', '2025-12-15 11:30:38'),
(9, 231, '2025-12-08 01:58:32', '2025-12-08 04:23:04'),
(10, 231, '2025-12-08 01:58:32', '2025-12-08 01:58:33'),
(11, 232, '2025-12-08 08:10:13', '2025-12-15 12:16:32'),
(12, 21, '2025-12-10 05:33:27', '2025-12-15 07:55:09'),
(13, 233, '2025-12-10 06:15:13', '2025-12-13 08:35:10'),
(14, 8, '2025-12-10 07:47:41', '2025-12-15 13:20:49'),
(15, 234, '2025-12-10 08:05:40', '2025-12-10 08:11:19'),
(16, 236, '2025-12-13 12:42:47', '2025-12-13 12:42:47'),
(17, 238, '2025-12-14 11:41:08', '2025-12-14 12:05:47'),
(18, 239, '2025-12-14 21:51:59', '2025-12-15 01:55:08'),
(19, 9, '2025-12-15 02:16:55', '2025-12-15 02:16:55');

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
(97, 18, 103, 1, 134000000.00, '2025-12-15 01:55:08', '2025-12-15 01:55:08'),
(98, 19, 103, 1, 134000000.00, '2025-12-15 02:16:55', '2025-12-15 02:16:55'),
(119, 11, 90, 1, 10101000.00, '2025-12-15 12:16:32', '2025-12-15 12:16:32');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `status` tinyint(4) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Đồng hồ Nam', 'dong-ho-nam', 1, '2025-11-24 08:03:23', '2025-12-14 07:51:30'),
(2, 'Đồng hồ Nữ', 'dong-ho-nu', 1, '2025-11-24 08:03:23', NULL),
(4, 'Đồng hồ Thể thao', 'dong-ho-the-thao', 1, '2025-11-24 08:03:23', NULL),
(5, 'Đồng hồ Thông minh', 'dong-ho-thong-minh', 1, '2025-11-24 08:03:23', NULL),
(6, 'Đồng hồ Cao cấp', 'dong-ho-cao-cap', 1, '2025-11-24 08:03:23', '2025-12-14 19:52:59');

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

--
-- Đang đổ dữ liệu cho bảng `favorites`
--

INSERT INTO `favorites` (`id`, `user_id`, `product_id`) VALUES
(16, 21, 68);

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
(8, 7, NULL, '\"145 Tổ 2, Thị trấn Đinh Văn, Huyện Lâm Hà, Tỉnh Lâm Đồng\"', 'delivered', 'cod', 'paid', 109830000.00, 'Giao nhanh nha', '2025-12-05 06:28:20', '2025-12-05 07:42:53'),
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
(27, 232, NULL, '\"Huyện Hàm Thuận Nam, Xã Tân Đoàn, Huyện Văn Quan, Tỉnh Lạng Sơn\"', 'confirmed', 'cod', 'paid', 31000.00, NULL, '2025-12-13 19:58:54', '2025-12-14 16:06:36'),
(28, 21, NULL, '\"369 Đường Tô Ký, Phường 6, Quận 8, Thành phố Hồ Chí Minh\"', 'confirmed', 'cod', 'unpaid', 51000.00, NULL, '2025-12-13 21:23:20', '2025-12-14 11:20:13'),
(29, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Trấn Yên, Huyện Bắc Sơn, Tỉnh Lạng Sơn\"', 'pending', 'bank', 'unpaid', 12220000.00, 'ok', '2025-12-13 21:28:55', '2025-12-13 21:28:55'),
(30, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Công Bằng, Huyện Pác Nặm, Tỉnh Bắc Kạn\"', 'pending', 'cod', 'unpaid', 24410000.00, 'ok', '2025-12-13 21:36:51', '2025-12-13 21:36:51'),
(31, 21, NULL, '\"369 Đường Tô Ký, Phường Tân Phong, Quận 7, Thành phố Hồ Chí Minh\"', 'delivered', 'bank', 'paid', 45500.00, 'b', '2025-12-13 22:00:57', '2025-12-13 22:08:47'),
(32, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Đồng Cốc, Huyện Lục Ngạn, Tỉnh Bắc Giang\"', 'pending', 'cod', 'unpaid', 13220000.00, 'ok', '2025-12-14 11:15:52', '2025-12-14 11:15:52'),
(33, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Phường Kỳ Sơn, Thành phố Hòa Bình, Tỉnh Hoà Bình\"', 'pending', 'cod', 'unpaid', 12220000.00, 'ok', '2025-12-14 12:13:15', '2025-12-14 12:13:15'),
(34, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Hóa Trung, Huyện Đồng Hỷ, Tỉnh Thái Nguyên\"', 'pending', 'cod', 'unpaid', 12220000.00, 'ok', '2025-12-14 12:16:49', '2025-12-14 12:16:49'),
(35, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Thanh Lâm, Huyện Ba Chẽ, Tỉnh Quảng Ninh\"', 'pending', 'cod', 'unpaid', 12220000.00, 'ok', '2025-12-14 12:20:55', '2025-12-14 12:20:55'),
(36, 232, NULL, '\"Huyện Hàm Thuận Nam, Xã Bình Mỹ, Huyện Củ Chi, Thành phố Hồ Chí Minh\"', 'delivered', 'cod', 'paid', 160030000.00, NULL, '2025-12-14 16:07:55', '2025-12-15 00:04:29'),
(37, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Đạp Thanh, Huyện Ba Chẽ, Tỉnh Quảng Ninh\"', 'pending', 'cod', 'unpaid', 920000.00, 'okee', '2025-12-14 16:19:03', '2025-12-14 16:19:03'),
(38, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Hòa Cư, Huyện Cao Lộc, Tỉnh Lạng Sơn\"', 'pending', 'cod', 'unpaid', 5130000.00, 'okeeeeeee', '2025-12-14 16:28:35', '2025-12-14 16:28:35'),
(39, 232, NULL, '\"Huyện Hàm Thuận Nam, Xã Thông Thụ, (Không dùng), Nghệ An\"', 'pending', 'cod', 'unpaid', 10330000.00, 'adasdasdasd', '2025-12-14 20:02:56', '2025-12-14 20:02:56'),
(40, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Đinh Văn Lâm Hà, (Không dùng), Lâm Đồng\"', 'delivered', 'cod', 'paid', 5130000.00, NULL, '2025-12-14 22:00:10', '2025-12-15 03:59:08'),
(41, 232, NULL, '\"Huyện Hàm Thuận Nam, Phường Tân Đông Hiệp, (Không dùng), Hồ Chí Minh\"', 'delivered', 'cod', 'paid', 15430000.00, 'dasdasdasdasd', '2025-12-14 22:28:43', '2025-12-15 00:03:58'),
(42, 232, NULL, '\"khu phần mềm quan trung, Phường Dĩ An, (Không dùng), Hồ Chí Minh\"', 'delivered', 'cod', 'paid', 10131000.00, NULL, '2025-12-14 23:54:33', '2025-12-14 23:55:16'),
(43, 232, NULL, '\"số nhà, Phường Đông Hòa, (Không dùng), Hồ Chí Minh\"', 'shipping', 'cod', 'paid', 412767000.00, 'asdas', '2025-12-15 00:01:41', '2025-12-15 02:39:36'),
(44, 21, NULL, '\"369 Đường Tô Ký, Phường Tân Đông Hiệp, (Không dùng), Hồ Chí Minh\"', 'delivered', 'bank', 'paid', 920000.00, 'SÁ', '2025-12-15 02:21:57', '2025-12-15 02:26:11'),
(45, 232, NULL, '\"số nhà, Xã Đồng Xuân, (Không dùng), Đắk Lắk\"', 'cancelled', 'cod', 'unpaid', 412767000.00, NULL, '2025-12-15 03:27:49', '2025-12-15 04:01:36'),
(46, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Lạc Đạo, (Không dùng), Hưng Yên\"', 'delivered', 'cod', 'paid', 10131000.00, 'ok', '2025-12-15 04:04:45', '2025-12-15 04:05:06'),
(47, 21, NULL, '\"369 Đường Tô Ký, Phường Tam Chúc, (Không dùng), Ninh Bình\"', 'cancelled', 'cod', 'unpaid', 1650978000.00, 'd', '2025-12-15 04:21:05', '2025-12-15 07:19:12'),
(48, 21, NULL, '\"369 Đường Tô Ký, Xã Quỳ Châu, (Không dùng), Nghệ An\"', 'delivered', 'cod', 'paid', 250050000.00, NULL, '2025-12-15 07:55:10', '2025-12-15 07:55:50'),
(49, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Đinh Văn Lâm Hà, (Không dùng), Lâm Đồng\"', 'cancelled', 'cod', 'unpaid', 6334000.00, 'ok', '2025-12-15 10:30:16', '2025-12-15 10:35:07'),
(50, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Sín Thầu, (Không dùng), Điện Biên\"', 'pending', 'cod', 'unpaid', 10330000.00, 'ok', '2025-12-15 10:36:33', '2025-12-15 10:36:33'),
(51, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Nậm Hàng, (Không dùng), Lai Châu\"', 'pending', 'cod', 'unpaid', 10330000.00, 'ok', '2025-12-15 10:37:27', '2025-12-15 10:37:27'),
(52, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Nậm Kè, (Không dùng), Điện Biên\"', 'pending', 'cod', 'unpaid', 15030000.00, 'ok', '2025-12-15 10:41:29', '2025-12-15 10:41:29'),
(53, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Sin Suối Hồ, (Không dùng), Lai Châu\"', 'pending', 'cod', 'unpaid', 15030000.00, 'ok', '2025-12-15 11:09:07', '2025-12-15 11:09:07'),
(54, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Mường Nhé, (Không dùng), Điện Biên\"', 'pending', 'cod', 'unpaid', 90371000.00, NULL, '2025-12-15 11:16:01', '2025-12-15 11:16:01'),
(55, 11, NULL, '\"145 Tổ 2 Đồng Tâm Đinh Văn, Phường Mộc Châu, (Không dùng), Sơn La\"', 'pending', 'cod', 'unpaid', 431679000.00, 'ok', '2025-12-15 11:30:39', '2025-12-15 11:30:39'),
(56, 8, NULL, '\"dfd, Phường Hải Bình, (Không dùng), Thanh Hóa\"', 'pending', 'cod', 'unpaid', 25050000.00, 'd', '2025-12-15 12:21:34', '2025-12-15 12:21:34'),
(57, 8, NULL, '\"s, Xã Tân Hưng, (Không dùng), Hưng Yên\"', 'pending', 'bank', 'unpaid', 250050000.00, NULL, '2025-12-15 12:22:23', '2025-12-15 12:22:23'),
(58, 8, NULL, '\"d, Phường Minh Xuân, (Không dùng), Tuyên Quang\"', 'pending', 'bank', 'unpaid', 250050000.00, NULL, '2025-12-15 12:26:41', '2025-12-15 12:26:41'),
(59, 8, NULL, '\"d, Xã Mễ Sở, (Không dùng), Hưng Yên\"', 'pending', 'bank', 'unpaid', 250050000.00, NULL, '2025-12-15 12:29:05', '2025-12-15 12:29:05'),
(60, 11, NULL, '\"145 Tổ 2, Xã Đinh Văn Lâm Hà, (Không dùng), Lâm Đồng\"', 'pending', 'cod', 'unpaid', 15030000.00, NULL, '2025-12-15 12:40:46', '2025-12-15 12:40:46'),
(61, 8, NULL, '\"369 Đường Tô Ký, Phường Trung Mỹ Tây, (Không dùng), Hồ Chí Minh\"', 'pending', 'bank', 'unpaid', 250050000.00, 'c', '2025-12-15 12:48:19', '2025-12-15 12:48:19'),
(62, 8, NULL, '\"369 Đường Tô Ký, Phường Vĩnh Tân, (Không dùng), Hồ Chí Minh\"', 'pending', 'cod', 'unpaid', 25030000.00, NULL, '2025-12-15 12:54:40', '2025-12-15 12:54:40'),
(63, 8, NULL, '{\"fullname\":\"sdas\",\"receiver_name\":\"sdas\",\"phone\":\"0393159478\",\"receiver_phone\":\"0393159478\",\"phone_number\":\"0393159478\",\"email\":\"pductoandev@gmail.com\",\"address_line\":\"369 Đường Tô Ký\",\"street\":\"369 Đường Tô Ký\",\"detail\":\"369 Đường Tô Ký\",\"province\":\"Hồ Chí Minh\",\"province_code\":\"79\",\"ward\":\"Phường Trung Mỹ Tây\",\"ward_code\":\"26785\",\"district\":\"(Không dùng)\",\"full_address\":\"369 Đường Tô Ký, Phường Trung Mỹ Tây, (Không dùng), Hồ Chí Minh\"}', 'pending', 'cod', 'unpaid', 412767000.00, 'dd', '2025-12-15 13:06:38', '2025-12-15 13:06:38'),
(64, 8, NULL, '{\"fullname\":\"sdas\",\"receiver_name\":\"sdas\",\"phone\":\"0393159478\",\"receiver_phone\":\"0393159478\",\"phone_number\":\"0393159478\",\"email\":\"\",\"address_line\":\"369 Đường Tô Ký\",\"street\":\"369 Đường Tô Ký\",\"detail\":\"369 Đường Tô Ký\",\"province\":\"Hồ Chí Minh\",\"province_code\":\"79\",\"ward\":\"Phường Trung Mỹ Tây\",\"ward_code\":\"26785\",\"district\":\"(Không dùng)\",\"full_address\":\"369 Đường Tô Ký, Phường Trung Mỹ Tây, (Không dùng), Hồ Chí Minh\"}', 'pending', 'cod', 'unpaid', 412787000.00, NULL, '2025-12-15 13:07:27', '2025-12-15 13:07:27'),
(65, 8, NULL, '{\"fullname\":\"sdas\",\"receiver_name\":\"sdas\",\"phone\":\"0393159478\",\"receiver_phone\":\"0393159478\",\"phone_number\":\"0393159478\",\"email\":\"p\",\"address_line\":\"369 Đường Tô Ký\",\"street\":\"369 Đường Tô Ký\",\"detail\":\"369 Đường Tô Ký\",\"province\":\"Hồ Chí Minh\",\"province_code\":\"79\",\"ward\":\"Phường Trung Mỹ Tây\",\"ward_code\":\"26785\",\"district\":\"(Không dùng)\",\"full_address\":\"369 Đường Tô Ký, Phường Trung Mỹ Tây, (Không dùng), Hồ Chí Minh\"}', 'pending', 'cod', 'unpaid', 25050000.00, NULL, '2025-12-15 13:09:00', '2025-12-15 13:09:00'),
(66, 8, 17, '{\"fullname\":\"sdas\",\"receiver_name\":\"sdas\",\"phone\":\"0393159478\",\"receiver_phone\":\"0393159478\",\"phone_number\":\"0393159478\",\"email\":\"pductoandev@gmail.com\",\"address_line\":\"369 Đường Tô Ký\",\"street\":\"369 Đường Tô Ký\",\"detail\":\"369 Đường Tô Ký\",\"province\":\"Hồ Chí Minh\",\"province_code\":\"79\",\"ward\":\"Phường Trung Mỹ Tây\",\"ward_code\":\"26785\",\"district\":\"(Không dùng)\",\"full_address\":\"369 Đường Tô Ký, Phường Trung Mỹ Tây, (Không dùng), Hồ Chí Minh\"}', 'pending', 'cod', 'unpaid', 10131000.00, NULL, '2025-12-15 13:20:42', '2025-12-15 13:20:42'),
(67, 8, 13, '{\"fullname\":\"sdas\",\"receiver_name\":\"sdas\",\"phone\":\"0393159478\",\"receiver_phone\":\"0393159478\",\"phone_number\":\"0393159478\",\"email\":\"pductoandev@gmail.com\",\"address_line\":\"369 Đường Tô Ký\",\"street\":\"369 Đường Tô Ký\",\"detail\":\"369 Đường Tô Ký\",\"province\":\"Hồ Chí Minh\",\"province_code\":\"79\",\"ward\":\"Phường Trung Mỹ Tây\",\"ward_code\":\"26785\",\"district\":\"(Không dùng)\",\"full_address\":\"369 Đường Tô Ký, Phường Trung Mỹ Tây, (Không dùng), Hồ Chí Minh\"}', 'pending', 'cod', 'unpaid', 412787000.00, NULL, '2025-12-15 13:21:50', '2025-12-15 13:21:50');

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
(34, 29, 42, 1, 12190000.00),
(35, 30, 42, 2, 12190000.00),
(37, 32, 43, 1, 13190000.00),
(38, 33, 42, 1, 12190000.00),
(39, 34, 42, 1, 12190000.00),
(40, 35, 42, 1, 12190000.00),
(41, 36, 79, 1, 160000000.00),
(42, 37, 84, 1, 890000.00),
(43, 38, 88, 1, 5100000.00),
(44, 39, 92, 1, 10300000.00),
(45, 40, 88, 1, 5100000.00),
(46, 41, 92, 1, 10300000.00),
(47, 41, 88, 1, 5100000.00),
(48, 42, 90, 1, 10101000.00),
(49, 43, 97, 1, 412737000.00),
(50, 44, 84, 1, 890000.00),
(51, 45, 97, 1, 412737000.00),
(52, 46, 90, 1, 10101000.00),
(53, 47, 97, 4, 412737000.00),
(54, 48, 104, 1, 250000000.00),
(55, 49, 89, 1, 6304000.00),
(56, 50, 92, 1, 10300000.00),
(57, 51, 92, 1, 10300000.00),
(58, 52, 96, 1, 15000000.00),
(59, 53, 96, 1, 15000000.00),
(60, 54, 87, 1, 90341000.00),
(61, 55, 97, 1, 412737000.00),
(62, 55, 89, 3, 6304000.00),
(63, 56, 102, 1, 25000000.00),
(64, 57, 104, 1, 250000000.00),
(65, 58, 104, 1, 250000000.00),
(66, 59, 104, 1, 250000000.00),
(67, 60, 96, 1, 15000000.00),
(68, 61, 104, 1, 250000000.00),
(69, 62, 102, 1, 25000000.00),
(70, 63, 97, 1, 412737000.00),
(71, 64, 97, 1, 412737000.00),
(72, 65, 102, 1, 25000000.00),
(73, 66, 90, 1, 10101000.00),
(74, 67, 97, 1, 412737000.00);

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
(81, 'pductoandev@gmail.com', '7a34f52c52e41dd9f48cf70d47c9b37acbc6380eb7df9f54c38e3ebe7ba6226e', '434501', '2025-12-12 12:22:59', '2025-12-12 12:12:59', NULL);

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
(8, 13, 31000.00, 'pending', 'sepay', NULL, '2025-12-10 05:44:42'),
(9, 13, 31000.00, 'pending', 'sepay', NULL, '2025-12-10 06:00:24'),
(10, 13, 31000.00, 'pending', 'sepay', NULL, '2025-12-10 06:13:08'),
(11, 13, 31000.00, 'pending', 'sepay', NULL, '2025-12-10 06:37:09'),
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
(40, 23, 31000.00, 'pending', 'sepay', NULL, '2025-12-13 12:06:56'),
(41, 29, 12220000.00, 'pending', 'sepay', NULL, '2025-12-13 14:28:57'),
(42, 29, 12220000.00, 'pending', 'sepay', NULL, '2025-12-13 14:31:32'),
(43, 31, 45500.00, 'pending', 'sepay', NULL, '2025-12-13 15:00:57'),
(44, 31, 45500.00, 'pending', 'sepay', NULL, '2025-12-13 15:01:54'),
(45, 44, 920000.00, 'pending', 'sepay', NULL, '2025-12-14 19:21:57'),
(46, 57, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:22:23'),
(47, 57, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:23:00'),
(48, 57, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:23:03'),
(49, 57, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:23:57'),
(50, 57, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:24:19'),
(51, 57, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:24:36'),
(52, 57, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:24:58'),
(53, 57, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:25:00'),
(54, 57, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:25:50'),
(55, 57, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:25:54'),
(56, 57, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:26:02'),
(57, 58, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:26:41'),
(58, 58, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:28:15'),
(59, 58, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:28:28'),
(60, 58, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:28:45'),
(61, 59, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:29:06'),
(62, 59, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:30:17'),
(63, 59, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:30:42'),
(64, 59, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:31:00'),
(65, 59, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:31:03'),
(66, 59, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:31:22'),
(67, 59, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:31:23'),
(68, 59, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:31:57'),
(69, 59, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:32:14'),
(70, 59, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:32:14'),
(71, 59, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:32:32'),
(72, 59, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:32:39'),
(73, 59, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:32:55'),
(74, 59, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:32:56'),
(75, 59, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:34:23'),
(76, 59, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:34:31'),
(77, 59, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:34:39'),
(78, 61, 250050000.00, 'pending', 'sepay', NULL, '2025-12-15 05:48:19');

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
(17, 232, 2, 'Đồng hồ lặn là gì? Tiêu chuẩn đánh giá & 7 đặc điểm nhận diện', 'ddddddddd', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765771110/posts/1765771099_adc6af9e63a3cd72.png', '<p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"><em>Đồng hồ lặn là gì? Sự phân biệt giữa đồng hồ lặn và những </em></strong><strong style=\"color: rgb(40, 138, 214); background-color: transparent;\"><em><a href=\"https://donghohaitrieu.com/\" rel=\"noopener noreferrer\" target=\"_blank\">đồng hồ đeo tay</a></em></strong><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"><em> thông thường dựa trên những đặc điểm nào? Bài viết sau sẽ cho chúng ta biết sự khác biệt giữa chúng không chỉ dừng lại ở mức chống nước.</em></strong></p><p><br></p><h2><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Đồng hồ lặn là gì?</strong></h2><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Đồng hồ lặn (Diver watch) là loại đồng hồ chuyên dụng, được thiết kế đặc biệt để phục cho thợ lặn và những người cần theo dõi thời gian trong các hoạt động dưới nước. Được xếp vào nhóm thiết bị thể thao cần có đặc tính bền bỉ, chống nước, chịu lực tốt.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Chúng được chế tạo để chịu được áp lực nước ở độ sâu lớn và có các tính năng hỗ trợ an toàn cho thợ lặn trong suốt hành trình dưới nước.</span></p><p><br></p><h2><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">7 đặc điểm nhận diện đồng hồ lặn</strong></h2><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Đặc điểm nhận diện đồng hồ lặn thường liên quan đến thiết kế vỏ chắc chắn, khả năng chống nước, và các tính năng như vòng bezel xoay và núm vặn chống nước.</span></p><p><br></p><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">1. Đảm bảo khả năng dễ đọc</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Đối với thợ lặn chuyên nghiệp, đồng hồ lặn là công cụ quan trọng để theo dõi thời gian và các chỉ số khác, giúp đảm bảo an toàn trong suốt quá trình thám hiểm dưới nước. Những phiên bản cần đảm bảo khả năng dễ đọc trong bất kỳ điều kiện nào. </span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Chính vì vậy, mặt số đồng hồ lặn thường được phủ một lớp </span><a href=\"https://donghohaitrieu.com/thuat-ngu-dong-ho/da-quang-la-gi.html\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"background-color: transparent; color: rgb(40, 138, 214);\">dạ quang</a><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">, giúp người dùng dễ dàng xem giờ ngay cả trong điều kiện thiếu ánh sáng dưới nước.</span></p><p><br></p><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">2. Núm vặn chặt và gioăng núm bảo vệ</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Núm điều chỉnh và nắp lưng của đồng hồ có dạng vít vặn, vừa vặn hỗ trợ ngăn nước vào bên trong bộ máy. Vòng đệm (Gioăng) niêm phong nắp lưng, múm điều chỉnh, mặt kính để chống nước (thường làm bằng cao su, nhựa). </span></p><p><br></p><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">3. Vòng bezel xoay</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Bezel xoay sẽ có 2 loại như sau:</span></p><ol><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Bezel xoay một chiều (Unidirectional Rotating Bezel): Chỉ có thể xoay theo một hướng (thường là ngược chiều kim đồng hồ). Loại này phổ biến trên đồng hồ lặn để tránh việc vô tình xoay bezel làm sai lệch thời gian lặn, đảm bảo an toàn cho thợ lặn.</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Bezel xoay hai chiều (Bidirectional Rotating Bezel): Có thể xoay theo cả hai hướng, giúp người dùng điều chỉnh nhanh chóng và chính xác thời gian cần đo mà không giới hạn hướng xoay. Loại bezel này thường thấy trên đồng hồ phi công hoặc đồng hồ đa năng.</span></li></ol><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Hầu hết đồng hồ lặn sử dụng vòng bezel xoay một chiều, giúp thợ lặn theo dõi thời gian chính xác và đảm bảo an toàn. Đây cũng là điểm yếu vì đồng hồ sẽ hoạt động chậm lại nếu vòng bezel vô tình bị lệch khỏi vị trí. Một số thương hiệu đã giải quyết vấn đề này bằng cách sử dụng các vòng bezel xoay bên trong (hạn chế việc vô tình xoay mặt số).</span></p><p><br></p><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">4. Van thoát khí Heli</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Van khí Heli là bộ phận cần thiết cho những chiếc đồng hồ chuyên nghiệp, giúp thoát khí Helo tích tụ trong thiết bị ra ngoài trong quá trình lặn sâu. Đảm bảo bộ máy bên trong không bị phá hủy trong môi trường lặn cũng như sự an toàn tính mạng.</span></p><p><br></p><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">5. Kính chịu lực</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Để đảm bảo một chiếc đồng hồ lặn đủ tiêu chuẩn, mặt kính phải được làm từ vật liệu cứng cáp, dày, có thể cong hình vòm để gia tăng khả năng chịu áp lực nước. Tối thiểu phải sử dụng </span><a href=\"https://donghohaitrieu.com/thuat-ngu-dong-ho/vat-lieu-kinh-cung-la-gi.html\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"background-color: transparent; color: rgb(40, 138, 214);\">kính cứng</a><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">, </span><a href=\"https://donghohaitrieu.com/thuat-ngu-dong-ho/mat-kinh-hardlex-crystal-la-gi.html\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"background-color: transparent; color: rgb(40, 138, 214);\">Hardlex</a><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"> (độc quyền của </span><a href=\"https://donghohaitrieu.com/brand/seiko\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"background-color: transparent; color: rgb(40, 138, 214);\">Seiko</a><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">) và Sapphire. </span></p><p><br></p><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">6. Khả năng chống từ trường</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Đã từng có nghiên cứu tin rằng “Nước là chất nghịch từ nên không bị ảnh hưởng bởi từ tính”. Tuy nhiên thực tế, nước không phải rào cản mạnh để chống từ trường. Từ trường có thể đi qua nước nhưng cường độ của lực có sự suy giảm phụ thuộc vào loại vật liệu và khoảng cách mà từ trường phải đi qua nước.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Theo tiêu chuẩn ISO 6425, đồng hồ lặn cần có khả năng chống từ trường (</span><a href=\"https://donghohaitrieu.com/thuat-ngu-dong-ho/anti-magnetic-la-gi.html\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"background-color: transparent; color: rgb(40, 138, 214);\">anti magnet</a><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">) ở mức tối thiểu là 4.800 A/m (amperes trên mét). Điều này đảm bảo đồng hồ vẫn hoạt động chính xác khi tiếp xúc với các nguồn từ trường yếu( trong môi trường làm việc, sinh hoạt).</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Tuy nhiên, với sự phát triển của công nghệ và nhu cầu sử dụng trong các điều kiện khắc nghiệt hơn, nhiều mẫu đồng hồ lặn hiện đại có khả năng chống từ trường cao hơn rất nhiều. Chẳng hạn như 15.000 gauss (tương đương 1.200.000 A/m), nhờ sử dụng các vật liệu chống từ đặc biệt (</span><a href=\"https://donghohaitrieu.com/thuat-ngu-dong-ho/chat-lieu-titanium-tren-dong-ho.html\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"background-color: transparent; color: rgb(40, 138, 214);\">titanium</a><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">).</span></p><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">7. Chất liệu bền</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Vỏ, dây đeo, mặt kính đều làm từ chất liệu bền bỉ, không bị hư tổn trước áp lực nước. Các chất liệu phổ biến dùng để chế tạo đồng hồ lặn bao gồm thép không gỉ 316L, titanium, gốm, sợi carbon và cao su, đảm bảo độ bền và khả năng chống chịu áp lực nước.</span></p><h2><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">ISO 6425: Tiêu chuẩn chống nước của đồng hồ lặn liệu có cần thiết?</strong></h2><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Đây là tiêu chuẩn quốc tế dành cho các mẫu đồng hồ lặn chuyên dụng, đảm bảo khả năng chịu nước ở độ sâu ít nhất 100 mét (10ATM) mà vẫn duy trì độ chính xác như trong điều kiện bình thường. Đồng hồ đạt chuẩn ISO 6425 được phân loại theo khả năng chịu nước:</span></p><ol><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><a href=\"https://donghohaitrieu.com/thuat-ngu-dong-ho/chong-nuoc-10atm-la-gi.html\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(40, 138, 214); background-color: transparent;\">10ATM</a><span style=\"color: rgb(103, 103, 103); background-color: rgb(255, 255, 255);\"> (100M/10BAR): chịu nước đến 100m.</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><a href=\"https://donghohaitrieu.com/thuat-ngu-dong-ho/chong-nuoc-20atm-la-gi.html\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(40, 138, 214); background-color: transparent;\">20ATM</a><span style=\"color: rgb(103, 103, 103); background-color: rgb(255, 255, 255);\"> (200M/20BAR): chịu nước đến 200m, đáp ứng tiêu chuẩn của các đồng hồ lặn hiện đại.</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><a href=\"https://donghohaitrieu.com/thuat-ngu-dong-ho/chong-nuoc-30atm-la-gi.html\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(40, 138, 214); background-color: transparent;\">30ATM</a><span style=\"color: rgb(103, 103, 103); background-color: rgb(255, 255, 255);\"> (300M/30BAR): chịu nước tối đa 300m, phù hợp cho thợ lặn chuyên nghiệp, nhưng không thích hợp cho lặn bão hòa.</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">60ATM (600M/60BAR): dùng cho thợ lặn kỹ thuật, có thể thực hiện lặn bão hòa, một hoạt động đòi hỏi thiết bị bảo hộ để đảm bảo an toàn ở độ sâu lớn.</span></li></ol><h2><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Giải đáp các thông tin đến đồng hồ lặn</strong></h2><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">1. Nguồn gốc và lịch sử</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Đồng hồ lặn bắt đầu phát triển từ năm 1916 khi đồng hồ bỏ túi được gắn bên trong mũ bảo hiểm thợ lặn. Tuy nhiên lúc đó thợ lặn chỉ sử dụng chúng như thiết bị bỏ túi không quá quan trọng.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Phải đến 2 năm sau bài viết trên tờ New York Times về đồng hồ chiến hào. Vào ngày 11 tháng 6 năm 1918, công ty Jacques Depollier &amp; Son tại New York đã được cấp bằng sáng chế cho một mẫu đồng hồ “chống nước và chống bụi”. Trong một quảng cáo cùng năm, Depollier nhấn mạnh nhu cầu cấp thiết về đồng hồ chống nước cho binh lính, thủy thủ, phi công và những người hoạt động ngoài trời. Đồng hồ “DD” của Depollier hứa hẹn ngăn chặn nước, bụi và khí, và được quảng cáo với hình ảnh đặt trong bể cá, dù không đề cập đến thợ lặn.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Nền công nghiệp đồng hồ lặn bắt đầu phát triển, kêu gọi hàng loạt thương hiệu nổi tiếng dấn thân vào sân chơi. Ví như: Rolex đã tung ra chiếc đồng hồ Submarine chống nước và chống bụi đầu tiên của mình vào năm 1922. Hay Omega Marine huyền thoại vào năm 1932.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Đến năm 1935, con đường phát triển của ngành công nghiệp đồng hồ và các hoạt động dưới nước cuối cùng đã đan xen vào nhau.</span></p><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">2. Tại sao đồng hồ lặn ít có tính năng phức tạp? Nếu có thì là chức năng nào?</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Đồng hồ lặn thường có ít tính năng phức tạp vì mục tiêu chính của nó là đảm bảo độ tin cậy và tính chính xác trong môi trường khắc nghiệt. Việc bổ sung thêm nhiều chức năng đôi khi gây “tác dụng ngược”, tăng nguy cơ hư hỏng hay giảm độ bền.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Thiết bị lặn sâu phải hiển thị thông tin chính xác và dễ quan sát, đặc biệt là trong những điều kiện ánh sáng yếu. Một số tính năng thêm vào có thể làm tăng số lượng bộ phận di chuyển và lỗ hở, từ đó có thể làm giảm khả năng chống nước.</span></p><h2><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Tham chiếu BST đồng hồ lặn nổi tiếng nhất</strong></h2><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Đồng hồ lặn là tiêu chuẩn đánh giá khả năng hoàn thiện và kỹ thuật chế tác của một thương hiệu. Có rất nhiều bộ sưu tập đồng hồ lặn danh tiếng đã được ra đời, đa phần đến từ Thụy Sỹ.</span></p><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">1. Rolex Submariner</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Bên cạnh xây dựng hình ảnh quý ông lịch lãm, thành đạt thông qua Rolex Datejust. Rolex còn là biểu tượng cho đồng hồ lặn biển với phiên bản Rolex Submariner. Ra mắt lần đầu tiên vào năm 1953, Submariner được phát triển như một chiếc đồng hồ lặn chuyên nghiệp với khả năng chống nước lên đến độ sâu 300 mét (1.000 feet). Bên cạnh đó, nó cũng được đánh giá cao về mặt thẩm mỹ và đã trở thành một món phụ kiện thời trang sang trọng.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Đặc trưng của dòng Rolex Submariner đó là thiết kế vỏ Oyster bền bỉ với kích thước 40mm. Sở hữu </span><a href=\"https://donghohaitrieu.com/thuat-ngu-dong-ho/vong-bezel-la-gi.html\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"background-color: transparent; color: rgb(40, 138, 214);\">vòng bezel</a><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"> xoay một chiều làm bằng gốm được khắc các con số, mặt đồng hồ đơn giản, dễ đọc với cọc số phủ dạ quang. Dây đeo </span><a href=\"https://donghohaitrieu.com/thuat-ngu-dong-ho/day-oyster-rolex.html\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"background-color: transparent; color: rgb(40, 138, 214);\">Oyster</a><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"> có hệ thống khóa an toàn Oysterlock và cơ chế mở rộng Glidelock, giúp người dùng điều chỉnh độ dài dây dễ dàng hơn.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Nhờ hệ thống chống nước Triplock với ba lớp bảo vệ và nắp lưng vặn chặt, Submariner có thể chống nước ở độ sâu lên tới 30ATM, lý tưởng cho thợ lặn chuyên nghiệp.</span></p><p><br></p><p><br></p><p><br></p>', '2025-12-11 13:19:45', '2025-12-15 04:08:29'),
(19, 232, 2, 'HeavyDrive: Công nghệ chống sốc làm thay đổi cuộc chơi của ETA', 'heavydrive-cong-nghe-chong-soc-lam-thay-oi-cuoc-choi-cua-eta', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765772785/posts/1765772781_5850cd9de184ebfa.png', '<p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"><em>Tháng 3/2018, tại Grenchen (Thụy Sỹ), ETA phát đi thông báo rằng họ đã nghiên cứu thành công và giới thiệu ra thị trường HeavyDrive – Công nghệ độc quyền giúp quản lý sốc thông minh dành cho kim đồng hồ ở máy ETA Quartz.</em></strong></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Với một chiếc đồng hồ Quartz cơ bản, phần kim giây dễ bị mất cân bằng khi có lực tác động. Điều này làm hạn chế việc lựa chọn vật liệu và kiểu dáng kim đồng hồ.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Nhờ có HeavyDrive, IC sẽ ra lệnh cho động cơ gửi một lực chống lại (xung phản lực) do cú sốc gây ra để khóa phần kim giây tại chỗ trong quá trình xảy ra va chạm. Xung phản lực giúp ngăn kim giây nhảy lên và hạn chế tối đa những va chạm tác động lên hằng ngày.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Theo thông báo từ ETA, HeavyDrive chịu được độ mất cân bằng cao hơn đáng kể so với bất kỳ máy Quartz nào:</span></p><ol><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Khả năng chịu được độ mất cân bằng của kim giây tăng 200%</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Khả năng chịu được độ mất cân bằng của kim phút tăng 20%</span></li></ol><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">HeavyDrive thách thức các nhà phát triển sáng tạo thêm nhiều loại vật liệu và kiểu dáng kim đồng hồ mà trước đó họ chưa từng thử. Công nghệ cũng gián tiếp gia tăng độ chính xác và tuổi thọ lên đồng hồ Quartz.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Với HeavyDrive, ETA mang đến một bộ máy đồng hồ không chỉ chịu được tác động sốc mà còn chống nước và chống từ trường, điều này đặc biệt quan trọng đối với những chiếc đồng hồ sử dụng trong môi trường khắc nghiệt như thể thao, leo núi hay thám hiểm.</span></p><h2><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Có gì ở công nghệ HeavyDrive?</strong></h2><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Mạch tích hợp (IC) ở công nghệ HeavyDrive phản ứng chỉ trong vài micro giây khi gặp những cú sốc, từ đó ra lệnh nhanh chóng.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Công nghệ HeavyDrive hiện đã có sẵn trên các dòng máy Trendline ETA (thế hệ máy F0X như ETA F03.105, ETA F04.105, ETA F05.841, ETA F06.105ETA F07.105,…).</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">HeavyDrive thường song hành với công nghệ Precidrive™ mà ETA đã ra mắt vào năm 2013 để gia tăng thêm độ bền và chính xác cho bộ máy.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"><img src=\"https://image.donghohaitrieu.com/wp-content/uploads/2024/06/cong-nghe-heavydrive-la-gi-2.jpg\" alt=\"Các mã máy có hỗ trợ HeavyDrive\" height=\"642\" width=\"900\"></span></p><p class=\"ql-align-center\"><em style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Danh sách các mã máy có hỗ trợ công nghệ HeavyDrive</em></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Thông tin thêm:</strong></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Ngoài HeavyDrive, ETA còn phát triển nhiều công nghệ tiên tiến khác giúp đồng hồ Quartz trở nên chính xác và bền bỉ hơn. Một trong số đó là PreciDrive, công nghệ giúp cải thiện độ chính xác của đồng hồ Quartz, đồng thời kéo dài tuổi thọ pin. Powermatic 80 là một công nghệ khác từ ETA, giúp đồng hồ tự động có thể hoạt động trong 80 giờ mà không cần lên dây cót.</span></p><h2><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Giải đáp những thắc mắc về công nghệ ETA và HeavyDrive</strong></h2><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Dù HeavyDrive là một phát minh độc quyền nhưng dường như có rất ít thông tin giới thiệu về. Cùng tôi giải đáp những thắc mắc thường gặp!</span></p><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">1. Làm sao để biết đồng hồ của mình có công nghệ này?</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Việc giới thiệu HeavyDrive như một cách để ETA củng cố vai trò là nhà sản xuất bộ máy lớn nhất Thụy Sỹ. Nhưng đây không phải là điểm bán hàng để ETA quảng bá rộng rãi.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Vậy nên bạn thường không tìm thấy HeavyDrive trong bảng mô tả kỹ thuật nếu không chủ động tìm kiếm.</span></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Có 3 cách để biết đồng hồ của mình có HeavyDrive:</strong></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">1. </strong><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Đọc bài Review sản phẩm trên website Đồng Hồ Hải Triều, đội ngũ chuyên gia của chúng tôi đã tìm kiếm thông tin chuẩn xác từ hãng để cung cấp đến quý khách hàng.</span></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">2.</strong><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"> Truy cập trực tiếp vào Website của ETA (https://www.eta.ch) hoặc Website thương hiệu thành viên của tập đoàn Swatch Group.</span></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">3.</strong><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"> Truy cập vào chuyên trang bộ máy đồng hồ https://calibercorner.com, tại đây có đầy đủ thông tin dành cho bạn cần.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Như tôi đã nói, đây không phải là điểm bán hàng nên bạn tìm kiếm chiếc đồng hồ có trang bị công nghệ HeavyDrive tại các cửa hàng bán lẻ là không có kết quả.</span></p><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">2. Những thương hiệu đồng hồ có công nghệ quản lý chống sốc</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">ETA là công ty sản xuất bộ máy trực thuộc </span><a href=\"https://donghohaitrieu.com/tu-dien-dong-ho/kien-thuc/lich-su-tap-doan-swatch.html\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"background-color: transparent; color: rgb(40, 138, 214);\">Swatch Group</a><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"> – Tập đoàn đồng hồ lớn nhất thế giới mà các nhãn như Tissot, Longines, Certina, Rado, Mido, Omega, Jaquet Droz, Omega, Breguet, Blancpain, Glashütte Original,… cũng đang là thương hiệu thành viên của Swatch.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Ngoại trừ thương hiệu cao cấp Omega, Omega, Breguet, Blancpain,… có xưởng lắp ráp bộ máy riêng. Còn lại đều đang sử dụng máy ETA cho đồng hồ.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Do đó, bạn dễ dàng tìm thấy công nghệ chống sốc kim trên những chiếc đồng hồ đeo tay cao cấp của Tissot, Longines, Certina, Rado, Mido,…</span></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Lời kết</strong></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Tóm lại, với công nghệ HeavyDrive, ETA đã mang lại một bước tiến lớn trong việc bảo vệ đồng hồ Quartz khỏi va đập, đồng thời cải thiện độ chính xác và tuổi thọ của máy. Điều này không chỉ giúp các mẫu đồng hồ của ETA trở nên bền bỉ hơn mà còn mở ra những khả năng thiết kế mới cho các thương hiệu đồng hồ cao cấp.</span></p><p><br></p>', '2025-12-15 04:26:25', NULL),
(20, 232, 5, 'Cerachrom: Vành bezel “bất khả chiến bại” làm nên giá trị đồng hồ lặn Rolex', 'cerachrom-vanh-bezel-bat-kha-chien-bai-lam-nen-gia-tri-ong-ho-lan-rolex', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765772901/posts/1765772897_740137775bf4e145.png', '<h2><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Vành bezel Cerachrom và sự thật đằng sau hào quang ấy là gì?</strong></h2><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Được Rolex giới thiệu lần đầu tiên vào năm 2005, viền bezel Cerachrom nhanh chóng trở thành biểu tượng của độ bền, vẻ đẹp và sự trường tồn.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Ngày nay nó cũng xuất hiện trên Yacht-Master, Yacht-Master II, cũng như các dòng lặn như: Submariner, Submariner Date, Sea-Dweller và Rolex Deepsea. Tùy thuộc vào đồng hồ, khung </span><a href=\"https://donghohaitrieu.com/thuat-ngu-dong-ho/vong-bezel-la-gi.html\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"background-color: transparent; color: rgb(40, 138, 214);\">bezel</a><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"> bằng gốm có màu đen, xanh lam hoặc xanh lục.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"><img src=\"https://image.donghohaitrieu.com/wp-content/uploads/2024/12/cerachrom-la-gi-1.jpg\" alt=\"Cerachrom Bezel: Chất liệu &quot;bất khả chiến bại&quot; làm nên giá trị đồng hồ lặn Rolex\" height=\"720\" width=\"900\"></span></p><p class=\"ql-align-center\"><em style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Cận cảnh viền bezel Cerachrom 2 màu</em></p><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">1. Quy trình chế tạo độc quyền ở nhiệt độ 1.600° C</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Được tạo ra để chống lại thời gian, Cerachrom Bezel không chỉ nâng tầm độ bền của đồng hồ mà còn mang lại vẻ đẹp vĩnh cửu. Làm thế nào điều này được thực hiện?</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Cerachrom là một loại gốm công nghệ cao, được chế tạo thông qua quá trình nung bột zirconium dioxide hoặc nhôm oxit rất mịn.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Nguyên liệu thô tại thời điểm này có điện trở suất rất thấp, được định hình bằng phương pháp đúc áp suất cao để tạo một khoảng trống. Bước này tạo hình dạng cho sản phẩm và tạo khuôn các chữ số, vạch chia và chữ khắc, cho dù chúng được thụt vào hay nổi lên. </span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Sau khi phôi được lấy ra khỏi khuôn, nó sẽ trải qua quá trình xử lý nhiệt để loại bỏ các chất liên kết. Sau đó được nung ở nhiệt độ lên tới 1.600° C trong hơn 24 giờ trong một quá trình được gọi là thiêu kết. Trong quá trình nung và thiêu kết, các mảnh co lại khoảng 25 đến 30% và thu được màu sắc cuối cùng. </span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Bước gia công cuối cùng mang lại cho mỗi mảnh hình dạng và kích thước chính xác để lắp ráp. Vì vật liệu bây giờ đã có được nó độ cứng đặc trưng, ​​hoạt động này đòi hỏi phải sử dụng các công cụ kim cương.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Để có mức độ dễ đọc tối ưu, các chữ số, vạch chia và chữ khắc được đúc bằng gốm và được phủ một lớp kim loại mỏng như vàng, vàng hồng hoặc bạch kim, tùy thuộc vào từng chiếc đồng hồ.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Mặc dù hầu hết các quy trình đều tự động hoá, nhưng Rolex vẫn mất 40 giờ cho mỗi viền Cerachrom được sản xuất ra.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"><img src=\"https://image.donghohaitrieu.com/wp-content/uploads/2024/12/cerachrom-la-gi-2.jpg\" alt=\"Cerachrom Bezel: Chất liệu &quot;bất khả chiến bại&quot; làm nên giá trị đồng hồ lặn Rolex\" height=\"899\" width=\"901\"></span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Nói ngắn gọn, quy trình tạo ra Cerachrom Bezel gồm 8 bước (Ảnh trên mô phỏng từng giai đoạn theo chiều kim đồng hồ từ vị trí giờ số 1):</span></p><ol><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Thêm chất kết dính </span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Ép phun</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Loại bỏ chất kết dính</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Tẩm thêm hoá chất (đối với bezel 2 màu)</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Thiêu kết</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Gia công các chi tiết, phủ PVD bạch kim, vàng vàng hoặc vàng hồng lên bezel</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Đánh bóng, giúp đạt độ sáng hoàn hảo</span></li></ol><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">2. Là loại vật liệu bền mãi với thời gian</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Cerachrom gần như không chịu ảnh hưởng bởi các tác nhân gây lão hoá như tia UV, nhiệt độ hay độ ẩm. Điều này có nghĩa là viền bezel làm từ Cerachrom sẽ không bị phai màu, ít trầy xước, chống ăn mòn, không xuống cấp và giữ nguyên được vẻ đẹp rực rỡ dù bạn sử dụng đồng hồ trong hàng chục năm.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Đây là một bước tiến mạnh mẽ so với các vật liệu truyền thống khác. Cerachrom mang lại cho Rolex một viền bezel gần như bất tử. Điều này càng làm tăng giá trị và sức hấp dẫn của các mẫu đồng hồ sử dụng Cerachrom.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"><img src=\"https://i.ytimg.com/vi/zQ4JR8iBoJo/hqdefault.jpg\" alt=\"YouTube video\" height=\"360\" width=\"480\"></span></p><p class=\"ql-align-center\"><em style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Độ bền, sáng bóng của Cerachrom trong mọi điều kiện thời tiết</em></p><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">3. Giới hạn trong ứng dụng trên đồng hồ</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Mặc dù Cerachrom là một chất liệu vượt trội nhưng việc ứng dụng nó lại rất hạn chế, chủ yếu chỉ tập trung vào viền bezel. Lý do nằm ở đặc tính của vật liệu cứng nhưng cũng khá giòn, khiến nó không phù hợp với những bộ phận đòi hỏi sự linh hoạt như dây đeo hay vỏ.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Ngoài ra, việc sản xuất Cerachrom cũng đòi hỏi chi phí cao và kỹ thuật phức tạp, dẫn đến việc nó chỉ xuất hiện trên các dòng cao cấp như Rolex Submariner, GMT-Master II, Daytona… Điều này càng làm tăng giá trị và sức hút của những mẫu đồng hồ sử dụng Cerachrom biến chúng thành biểu tượng cho sự sang trọng và đẳng cấp.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"><img src=\"https://i.ytimg.com/vi/KZjjQZ8SB4Y/hqdefault.jpg\" alt=\"YouTube video\" height=\"360\" width=\"480\"></span></p><h2><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Cerachrom – Thép không gỉ – Nhôm Aluminum: Ai mới là kẻ thống trị?</strong></h2><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Cerachrom đứng ở đâu trong bảng xếp hạng vật liệu chống xước tốt nhất? Cùng tham khảo qua bảng so sánh chi tiết dưới đây.</span></p><table><tbody><tr><td data-row=\"1\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Tiêu chí</strong></td><td data-row=\"1\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Cerachrom</strong></td><td data-row=\"1\"><strong style=\"color: rgb(103, 103, 103); background-color: transparent;\"><a href=\"https://donghohaitrieu.com/thuat-ngu-dong-ho/thep-khong-gi-la-gi.html\" rel=\"noopener noreferrer\" target=\"_blank\">Thép không gỉ</a></strong></td><td data-row=\"1\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Nhôm Aluminum</strong></td></tr><tr><td data-row=\"2\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Độ bền</strong></td><td data-row=\"2\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Độ cứng đạt Mohs 8 (gần bằng Sapphire), chống trầy tốt.</span></td><td data-row=\"2\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Độ cứng Mohs 4-5, dễ trầy hơn.</span></td><td data-row=\"2\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Độ cứng Mohs 2-3, dễ móp và trầy xước nhất.</span></td></tr><tr><td data-row=\"3\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Khả năng chống ăn mòn</strong></td><td data-row=\"3\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Gần như miễn nhiễm với hóa chất, muối biển, axit.</span></td><td data-row=\"3\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Chống ăn mòn tốt, nhưng tiếp xúc với môi trường muối lâu có thể bị ảnh hưởng nhẹ.</span></td><td data-row=\"3\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Dễ bị ăn mòn và oxy hoá.</span></td></tr><tr><td data-row=\"4\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Trọng lượng</strong></td><td data-row=\"4\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Nhẹ hơn thép không gỉ khoảng 30%, nặng hơn nhôm 2 lần.</span></td><td data-row=\"4\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Mật độ 7.9 g/cm³, nặng hơn Cerachrom và nhôm.</span></td><td data-row=\"4\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Rất nhẹ, mật độ 2.7 g/cm³, nhẹ hơn 66% so với thép không gỉ.</span></td></tr><tr><td data-row=\"5\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Khả năng chịu nhiệt</strong></td><td data-row=\"5\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Chịu nhiệt lên tới 1.500°C trong sản xuất, không bị biến dạng.</span></td><td data-row=\"5\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Chịu nhiệt tốt đến khoảng 800°C trước khi mất cấu trúc.</span></td><td data-row=\"5\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Kém chịu nhiệt, bắt đầu biến dạng ở 200-300°C.</span></td></tr><tr><td data-row=\"6\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Giá thành</strong></td><td data-row=\"6\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Đắt đỏ do quá trình sản xuất phức tạp.</span></td><td data-row=\"6\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Hợp lý, phổ biến trên nhiều dòng đồng hồ.</span></td><td data-row=\"6\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Rẻ nhất trong 3 chất liệu.</span></td></tr><tr><td data-row=\"7\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Ứng dụng</strong></td><td data-row=\"7\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Viền bezel đồng hồ cao cấp.</span></td><td data-row=\"7\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Thân, vỏ, dây của các hãng bình dân đến cao cấp.</span></td><td data-row=\"7\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Đồng hồ giá rẻ.</span></td></tr><tr><td data-row=\"8\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Độ phổ biến</strong></td><td data-row=\"8\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Hiếm, chỉ có ở các dòng cao cấp như Rolex.</span></td><td data-row=\"8\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Rất phổ biến trong ngành công nghiệp đồng hồ.</span></td><td data-row=\"8\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Phổ biến trong các dòng đồng hồ giá rẻ.</span></td></tr><tr><td data-row=\"9\"><strong style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Khả năng bảo dưỡng</strong></td><td data-row=\"9\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Không cần bảo dưỡng, không phai màu.</span></td><td data-row=\"9\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Cần làm sạch, đánh bóng sau thời gian dài sử dụng.</span></td><td data-row=\"9\"><span style=\"background-color: rgb(255, 255, 255); color: rgb(102, 102, 102);\">Dễ hỏng, cần bảo dưỡng thường xuyên.</span></td></tr></tbody></table><p><br></p>', '2025-12-15 04:28:21', NULL);
INSERT INTO `posts` (`id`, `user_id`, `post_category_id`, `name`, `slug`, `image`, `content`, `created_at`, `updated_at`) VALUES
(21, 232, 3, 'Anti Magnetic là gì? Nhiệm vụ bảo vệ đồng hồ khỏi từ tính', 'anti-magnetic-la-gi-nhiem-vu-bao-ve-ong-ho-khoi-tu-tinh', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765772967/posts/1765772962_3242d2664e548f43.png', '<h2><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Anti magnetic trên đồng hồ có nghĩa là gì?</strong></h2><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Thuật ngữ “anti magnetic” có nghĩa là kháng từ, tương tự “anti magnetic watch” tức chỉ dòng đồng hồ có khả năng kháng từ tốt. Theo quy chuẩn hiện nay, đồng hồ nên đạt được mức chống từ tính tối thiểu ISO 764, tương đương có thể chống lại từ trường trong khoảng 4800A/m.</span></p><p><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Thông tin thêm:</strong><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"> Tiêu chuẩn ISO 764 hoặc tương đương là DIN 8309 (tiêu chuẩn của Đức) quy định một chiếc đồng hồ thông thường phải có khả năng chịu được từ trường tiếp xúc trực tiếp ít nhất là 4800 A/m ≈ 60 Gauss ≈ 6 mT. Độ chính xác của đồng hồ lúc này phải là ± 30 giây/ngày. Quy định này xuất bản vào năm 1984, sửa đổi về mặt kỹ thuật vào 2002. Thông số này được đút kết từ quá trình nghiên cứu mô phỏng đồng hồ trong môi trường từ trường một chiều có cường độ không vượt quá 4800A/m.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Hiện nay ISO 764 mới nhất phát hành giai đoạn 2020 bổ sung thêm đồng hồ chống từ tính nâng cao (chịu được lực và từ trường mạnh liên tục và đồng nhất có cường độ cao bằng hoặc hơn 16.000 A/m ở cự ly gần).</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Tất cả đồng hồ có khả năng chống từ cao hơn 4800 A/m đều được gọi là đồng hồ chống từ nhưng tiêu chí để gọi là chuyên nghiệp phải hơn 80000 A/m tức 1000 Gauss (căn cứ theo Rolex Milgauss). Các hãng nổi tiếng chuyên về khả năng chống từ của đồng hồ: Rolex, IWC, Seiko, Omega.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Câu chuyện về sản xuất đồng hồ công nghệ anti magnetic ra đời vào khoảng cuối thế kỷ 19. Theo các chuyên gia, từ trường ảnh hưởng rất xấu đến sự di chuyển các kim quay. Mục tiêu được đặt ra đó là phải tìm và sử dụng các vật liệu có khả năng bảo đảm chuyển động ổn định của đồng hồ. Nhiều phương pháp nghiên cứu đã ra đời, góp phần xây dựng nền công nghiệp đồng hồ ngày càng vững mạnh.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"><img src=\"https://image.donghohaitrieu.com/wp-content/uploads/2024/08/1-anti-magnetic-nhiem-vu-bao-ve-dong-ho-khoi-tu-tinh-min.jpg\" alt=\"Bộ máy Omega Co-Axial 8508 có công nghệ anti magnetic- ảnh 1\" height=\"900\" width=\"900\"></span></p><p class=\"ql-align-center\"><em style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Bộ máy Omega Co-Axial 8508 chống từ tính trên 15.000 Gauss</em></p><h2><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Tại sao tính năng kháng từ lại quan trọng?</strong></h2><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Kháng từ tính giúp đồng hồ hoạt động bền bỉ và chính xác, ngay cả trong nhiều điều kiện môi trường khác nhau. Đặc biệt cần thiết với những chiếc đồng hồ cơ học.</span></p><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">1. Từ tính là gì?</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Từ tính là một hiện tượng tự nhiên, thể hiện sức hút và đẩy giữa nam châm và các vật dẫn điện, có thể ảnh hưởng lên các linh kiện kim loại và bộ máy đồng hồ. Từ tính được đo bằng đơn vị Gauss hoặc Tesla.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Việc lựa chọn đồng hồ có khả năng kháng từ tính (anti magnetic) giúp các linh kiện bộ máy hoạt động chính xác, ổn định, tránh hiện tượng tĩnh điện trên kim loại.</span></p><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">2. Vì sao từ trường ảnh hưởng đến độ chính xác của đồng hồ?</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Nguyên nhân dẫn đến đồng hồ có thể bị nhiễm từ bắt nguồn bởi các nam châm điện từ xuất hiện phổ biến trong hầu hết thiết bị công nghệ như: tivi, tủ lạnh, máy lạnh, máy giặt, lò vi sóng, … Trong không gian có từ trường mạnh, đồng hồ sẽ bị chi phối tiêu cực, khiến cho các phần trong máy hoạt động không hợp lý. Lò xo cân bằng và các bánh răng là cốt lõi của việc đồng hồ hoạt động chính xác. Nếu quá trình chuyển động tiếp xúc với từ trường và lò xo làm bằng các vật liệu kim loại, bộ chuyển động sẽ bị hư hại. </span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Khi nhiễm từ, lò xo cân bằng bị dính chặt lại, rút ngắn sự linh hoạt, gây ra hiện tượng kim chuyển động chậm hoặc nhanh một cách bất thường. Không chỉ vậy, việc nhiễm từ ảnh hưởng đến khả năng bù nhiệt độ của dây cân bằng, làm cho đồng hồ nhảy tốc độ khác nhau ở các nhiệt độ khác nhau.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Từ khi công nghệ đồng hồ anti magnetic ra đời, các bộ máy đồng hồ được bảo vệ chặt chẽ khỏi sự tác động của từ tính. Tuổi thọ của máy cũng tăng cao, hoạt động ổn định và còn hạn chế tác động nhiệt lên bộ chuyển động. </span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"><img src=\"https://image.donghohaitrieu.com/wp-content/uploads/2024/08/3-anti-magnetic-nhiem-vu-bao-ve-dong-ho-khoi-tu-tinh-min.jpg\" alt=\"Đồng hồ Grand Seiko SBGX341 - ảnh 2\" height=\"900\" width=\"900\"></span></p><p class=\"ql-align-center\"><em style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Đồng hồ Grand Seiko</em><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"> </span><em style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">có khả năng vượt trội trong chống từ tính</em></p><h2><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Các phương pháp chống từ trường trên đồng hồ</strong></h2><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Nhận thấy từ tính ảnh hưởng tiêu cực đến quá trình hoạt động của máy đồng hồ. Các nhà sản xuất đã không ngừng phân tích và đưa ra nhiều biện pháp, linh kiện hỗ trợ giải quyết thuật ngữ anti magnetic.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Nguyên lý chống từ là: sử dụng các loại vật liệu, cơ chế miễn nhiễm với từ trường, không làm bộ máy bị nhiễm từ.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Khả năng chống từ của đồng hồ thuở ban sơ của đồng hồ vẫn còn cho hiệu quả đáng kể đến ngày nay đó là dùng các vật liệu không nhạy cảm với từ trường (không nhiễm từ) để làm bộ máy hoặc các bộ phận quan trọng dễ bị nhiễm từ khi làm bằng hợp kim thường như dây tóc, dây cót, ngựa, bánh lắc,…</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Các vật liệu nổi tiếng đó là: hợp kim Invar (sắt-niken-carbon-crom), Elinvar (tương tự Invar nhưng kém hơn một chút), Glucydur (beryllium-đồng), Nivarox (sắt-niken-crom-titan-berili), Parachrom (hợp kim niobium-zirconium với lớp phủ oxide làm dây tóc của Rolex) Spiromax (Silicon với lớp phủ Silicon Dioxide làm dây tóc+bánh xe thoát của Patek Philippe), Spron510 (hợp kim Co-Ni làm dây cót và dây tóc của Seiko), Silicon.</span></p><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">1. Dùng tấm chắn từ trường</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Phương pháp dùng để chống từ tính đầu tiên được áp dụng đó là bảo vệ bộ chuyển động bằng một lớp chắn làm bằng vật liệu có khả năng thấm từ cao. Cách làm này có công dụng thu hút các đường sức từ tập trung vào tấm chắn, duy trì hoạt động ổn định của đồng hồ.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Tuy nhiên, phương pháp này cũng gặp khá nhiều hạn chế vì phải thường xuyên kiểm tra lá chắn. Ngày này, các nhà nghiên cứu đã tìm ra nhiều cách thay thế và bảo vệ linh kiện tốt hơn. </span></p><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">2. Sử dụng dây tóc chống từ trường</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Dây tóc hay lò xo cân bằng là phần quan trọng của bộ hoạt động. Ngày nay, các nhà máy bắt đầu thay thế dây tóc vật liệu kim loại bằng Nivarox (cải thiện nhưng vẫn có khả năng thấm từ tính). Gần đây nhất còn có các sản phẩm từ silicon, nivachron với đặc tính khử từ trường và chống biến động nhiệt độ ưu tú hơn. Điển hình như các sản phẩm đồng hồ đến từ </span><a href=\"https://donghohaitrieu.com/tu-dien-dong-ho/kien-thuc/lich-su-tap-doan-swatch.html\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"background-color: transparent; color: rgb(40, 138, 214);\">Swatch Group</a><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"> như: Tissot, Omega, Rado, Carbon Composite…</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Vận dụng dây tóc chống từ trường rất cần thiết vì sẽ giúp cho đồng hồ luôn hoạt động chính xác, bảo vệ động cơ và ngăn tác động của nhiệt độ đến bộ máy.</span></p><h3><strong style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">3. Sử dụng bánh xe thoát Silicon</strong></h3><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Bánh xe thoát là một phần của bộ chuyển động cơ học, nó cung cấp năng lượng cho hệ thống dao động và hoạt động của bánh răng. Ảnh hưởng trực tiếp đến độ chuẩn xác của đồng hồ.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Khi sử dụng vật liệu phi từ tính như </span><a href=\"https://donghohaitrieu.com/thuat-ngu-dong-ho/vat-lieu-silicon-la-gi.html\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"background-color: transparent; color: rgb(40, 138, 214);\">silicon</a><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"> làm linh kiện, độ sai số và tuổi thọ của đồng hồ được cải thiện đáng kể. Một phần do silicon sẽ không bị ảnh hưởng bởi từ trường bên ngoài. Khả năng chống ăn mòn cao, nhẹ và cũng ổn định hơn các loại vật tư khác. Nhờ lớp phủ bằng silicon mà sự ma sát giữa các bề mặt giảm thiểu, bảo vệ bộ máy khỏi tác động môi trường.</span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\"><img src=\"https://image.donghohaitrieu.com/wp-content/uploads/2024/08/2-anti-magnetic-nhiem-vu-bao-ve-dong-ho-khoi-tu-tinh-min.jpg\" alt=\"Sử dụng bánh xe thoát Silicon - ảnh 3\" height=\"900\" width=\"900\"></span></p><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(103, 103, 103);\">Một số thương hiệu đồng hồ nổi tiếng ứng dụng bánh xe silicon vào trong bộ máy vận hành như: Rolex, Patek Philippe, Hublot, IWC, Harry Winston.</span></p><p><br></p>', '2025-12-15 04:29:27', NULL);

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
  `sold` int(10) UNSIGNED DEFAULT 0,
  `is_featured` enum('0','1') NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT current_timestamp(),
  `status` tinyint(4) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `products`
--

INSERT INTO `products` (`id`, `model_code`, `category_id`, `brand_id`, `name`, `slug`, `specifications`, `thumbnail`, `description`, `image`, `sold`, `is_featured`, `created_at`, `status`) VALUES
(45, 'RDW-APW-001', 5, 14, 'Apple Watch Series 11 Viền Nhôm GPS 46mm', 'apple-watch-series-11-vien-nhom-gps-46mm', '{\"size\":\"46mm\",\"material\":\"D\\u00e2y cao su\",\"warranty\":\"24 th\\u00e1ng\",\"weight\":\"37.8g\",\"brand\":\"Apple Watch\",\"model\":\"H\\u00e3ng kh\\u00f4ng c\\u00f4ng b\\u1ed1\"}', '[\"https:\\/\\/res.cloudinary.com\\/dfvaxlkol\\/image\\/upload\\/v1765634355\\/products\\/thumbnails\\/1765634354_d5d861967601733b.png\"]', '<p><strong style=\"color: rgb(51, 51, 51);\">Mới đây, Apple đã chính thức giới thiệu mẫu đồng hồ thông minh mới nhất của mình, Apple Watch Series 11 Viền Nhôm GPS 46mm. Sản phẩm này nhanh chóng trở thành tâm điểm trong phân khúc smartwatch cao cấp nhờ loạt nâng cấp vượt trội từ thời lượng pin được cải thiện lên đến 24 giờ, màn hình Ion-X siêu bền và các tính năng sức khỏe AI tiên tiến. Đây không chỉ là một chiếc đồng hồ, mà còn là trợ lý sức khỏe và giao tiếp toàn diện trên cổ tay.</strong></p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765634354/products/1765634352_33099a228974ed39.png', 0, '0', '2025-12-13 20:59:15', 1),
(51, 'RDW-APW-002', 5, 14, 'Apple Watch SE 2 GPS 40mm Sport Band-3', 'apple-watch-se-2-gps-40mm-sport-band-3', '{\"size\":\"40mm\",\"material\":\"H\\u1ee3p kim nh\\u00f4m b\\u1ec1n b\\u1ec9\",\"warranty\":\"24 th\\u00e1ng\",\"weight\":\"27.8g\",\"brand\":\"Apple Watch\",\"model\":\"Kh\\u00f4ng \\u0111\\u01b0\\u1ee3c cung c\\u1ea5p\"}', '[\"https:\\/\\/res.cloudinary.com\\/dfvaxlkol\\/image\\/upload\\/v1765698298\\/products\\/thumbnails\\/1765698296_a2b9ce0f9c1fb574.png\"]', '<p>Là chiếc đồng hồ thông minh tầm trung, nổi bật với thiết kế nhôm nhẹ, màn hình Retina sáng, chip S8 SiP mạnh mẽ, các tính năng sức khỏe &amp; an toàn quan trọng như theo dõi nhịp tim, phát hiện ngã/va chạm, và dây Sport Band silicone mềm mại, chống nước 50m, lý tưởng cho người dùng phổ thông, năng động, hoặc cổ tay nhỏ, mang lại trải nghiệm thông minh tiện lợi với mức giá hợp lý.&nbsp;</p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765698296/products/1765698294_e3e4fb311784427a.png', 0, '0', '2025-12-14 14:44:58', 1),
(57, 'RDW-SSW-002', 4, 16, 'Samsung Galaxy Watch8 Classic Bluetooth 46mm', 'samsung-galaxy-watch8-classic-bluetooth-46mm', '{\"size\":\"46mm\",\"material\":\"V\\u1ecf th\\u00e9p kh\\u00f4ng g\\u1ec9 (Stainless Steel)\",\"warranty\":\"12 th\\u00e1ng\",\"weight\":\"63.5g\",\"brand\":\"Samsung\",\"model\":\"Galaxy Watch8 Classic (Bluetooth)\"}', '[\"https:\\/\\/res.cloudinary.com\\/dfvaxlkol\\/image\\/upload\\/v1765700406\\/products\\/thumbnails\\/1765700405_bbbe9cea09f944b7.png\"]', '<p>Samsung Galaxy Watch8 Classic đánh dấu sự trở lại của thiết kế vòng bezel xoay vật lý trứ danh, mang lại trải nghiệm điều hướng mượt mà và vẻ ngoài lịch lãm. Đồng hồ sở hữu màn hình Super AMOLED siêu sáng (lên tới 3000 nits) được bảo vệ bởi kính Sapphire bền bỉ. Với vi xử lý Exynos W1000 (3nm) mạnh mẽ và cảm biến BioActive thế hệ mới, sản phẩm cung cấp các tính năng theo dõi sức khỏe tiên tiến như chấm điểm năng lượng (Energy Score) và theo dõi chỉ số AGEs, là trợ lý sức khỏe toàn diện trên cổ tay người dùng.</p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765700405/products/1765700402_4b496f44fe2f93df.png', 0, '0', '2025-12-14 15:20:06', 1),
(58, 'RDW-RLW-001', 6, 6, 'Day Date 40', 'day-date-40', '{\"size\":\"40mm\",\"material\":\"V\\u00e0ng 18K\",\"warranty\":\"60 th\\u00e1ng\",\"weight\":\"210g\",\"brand\":\"Rolex\",\"model\":\"Day-Date 40\"}', '[\"https:\\/\\/res.cloudinary.com\\/dfvaxlkol\\/image\\/upload\\/v1765700453\\/products\\/thumbnails\\/1765700450_2dd391adc10f7f63.png\"]', '<p>Khám phá sự tinh hoa của thời gian cùng đồng hồ Day Date 40, mẫu RDW-RLW-001 – biểu tượng của phong cách đẳng cấp và sự thanh lịch vượt thời gian. Với kích thước 40mm lý tưởng, Day Date 40 không chỉ vừa vặn hoàn hảo trên cổ tay mà còn tôn lên vẻ ngoài sang trọng, lịch lãm cho mọi quý ông. Mặt số hiển thị ngày và thứ rõ ràng, tiện lợi, kết hợp hài hòa với thiết kế cổ điển nhưng vẫn đầy hiện đại, tạo nên một tổng thể cuốn hút. Đây không chỉ là một cỗ máy đếm giờ, mà còn là tuyên ngôn về gu thẩm mỹ tinh tế, một phụ kiện không thể thiếu để khẳng định cá tính và đẳng cấp riêng của bạn. Day Date 40 RDW-RLW-001 chính là lựa chọn hoàn hảo, mang đến sự tự tin và phong thái đỉnh cao trong mọi khoảnh khắc.</p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765700450/products/1765700447_8da4e8d070814d38.png', 0, '0', '2025-12-14 15:20:53', 1),
(59, 'RDW-SSW-03', 5, 16, 'Samsung Galaxy Watch8 Bluetooth 44mm', 'samsung-galaxy-watch8-bluetooth-44mm', '{\"size\":\"44mm\",\"material\":\"Nh\\u00f4m Armor Aluminum, K\\u00ednh Sapphire\",\"warranty\":\"12 th\\u00e1ng\",\"weight\":\"33.8g\",\"brand\":\"Samsung\",\"model\":\"Galaxy Watch8 (Bluetooth)\"}', '[\"https:\\/\\/res.cloudinary.com\\/dfvaxlkol\\/image\\/upload\\/v1765700689\\/products\\/thumbnails\\/1765700688_72bfd8618e40633d.png\"]', '<p>Sở hữu thiết kế hiện đại, tối giản với khung viền Armor Aluminum cao cấp, vừa nhẹ vừa bền bỉ. Được trang bị vi xử lý 3nm hiệu năng cao và tích hợp Galaxy AI, đồng hồ mang đến khả năng theo dõi sức khỏe chuyên sâu, từ chấm điểm năng lượng (Energy Score) đến phân tích giấc ngủ chi tiết.Màn hình Super AMOLED rực rỡ được bảo vệ bởi kính Sapphire giúp chống trầy xước tối ưu trong quá trình sử dụng hàng ngày.</p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765700688/products/1765700686_87f1ca39963c6a5b.png', 0, '0', '2025-12-14 15:24:49', 1),
(61, 'RDW-RLW-002', 5, 6, 'Rolex Oyster Perpetual', 'rolex-oyster-perpetual', '{\"size\":\"41mm\",\"material\":\"Th\\u00e9p kh\\u00f4ng g\\u1ec9\",\"warranty\":\"60 th\\u00e1ng\",\"weight\":\"155g\",\"brand\":\"Rolex\",\"model\":\"Oyster Perpetual\"}', '[\"https:\\/\\/res.cloudinary.com\\/dfvaxlkol\\/image\\/upload\\/v1765700999\\/products\\/thumbnails\\/1765700998_e122a6887c6ba0a5.png\"]', '<p>Nắm giữ tinh hoa của sự sang trọng và độ chính xác vượt thời gian với chiếc Rolex Oyster Perpetual. Là biểu tượng kinh điển của sự bền bỉ và phong cách thanh lịch, mẫu đồng hồ này là minh chứng cho triết lý chế tác đồng hồ không ngừng nghỉ của Rolex. Vỏ Oyster trứ danh đảm bảo khả năng chống thấm nước tối ưu, trong khi bộ máy Perpetual tự động chính xác tuyệt đối mang đến trải nghiệm thời gian hoàn hảo. Với thiết kế tinh giản nhưng đầy cuốn hút, Rolex Oyster Perpetual là sự lựa chọn hoàn hảo để nâng tầm phong cách của bạn trong mọi khoảnh khắc. Mã sản phẩm: RDW-RLW-002.</p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765700998/products/1765700993_942641f6bb7434a3.png', 0, '0', '2025-12-14 15:29:59', 1),
(62, 'RDW-SSW-004', 5, 16, 'Samsung Galaxy Watch FE BT 40mm', 'samsung-galaxy-watch-fe-bt-40mm', '{\"size\":\"40mm\",\"material\":\"Khung vi\\u1ec1n Nh\\u00f4m, K\\u00ednh Sapphire\",\"warranty\":\"12 th\\u00e1ng\",\"weight\":\"26.6g\",\"brand\":\"Samsung\",\"model\":\"Galaxy Watch FE (Bluetooth)\"}', '[\"https:\\/\\/res.cloudinary.com\\/dfvaxlkol\\/image\\/upload\\/v1765701090\\/products\\/thumbnails\\/1765701088_4718efed3c35c4e6.png\"]', '<p>Samsung Galaxy Watch FE (Fan Edition) mang đến thiết kế năng động và thời thượng với mức giá dễ tiếp cận. Điểm nhấn của phiên bản này là mặt kính Sapphire cao cấp giúp chống trầy xước vượt trội, bảo vệ màn hình bền bỉ theo thời gian.Đồng hồ được trang bị cảm biến BioActive 3 trong 1 mạnh mẽ, hỗ trợ đo nhịp tim, phân tích thành phần cơ thể (BIA) và theo dõi giấc ngủ chuyên sâu, là người bạn đồng hành lý tưởng cho lối sống lành mạnh hàng ngày.</p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765701088/products/1765701085_eceabce0294dddf7.png', 0, '0', '2025-12-14 15:31:29', 1),
(63, 'RDW-RLW-003', 6, 6, 'Rolex Land-Dweller', 'rolex-land-dweller', '{\"size\":\"41mm\",\"brand\":\"Rolex\",\"model\":\"Land-Dweller\",\"material\":\"Th\\u00e9p kh\\u00f4ng g\\u1ec9 Oystersteel\",\"weight\":\"165g\",\"warranty\":\"60 th\\u00e1ng\"}', '[\"https://res.cloudinary.com/dfvaxlkol/image/upload/v1765701427/products/thumbnails/1765701425_4f8d45dc737800fe.png\"]', '<p>Rolex Land-Dweller (RDW-RLW-003) không chỉ là một chiếc đồng hồ, mà còn là biểu tượng của tinh thần kiên cường và sự bền bỉ bất chấp mọi thử thách trên mặt đất. Được chế tác để đồng hành cùng bạn qua những chuyến phiêu lưu khắc nghiệt nhất hay những bộn bề của đô thị, Land-Dweller là sự kết hợp hoàn hảo giữa độ chính xác vượt trội và khả năng chống chịu đáng nể. Mỗi chi tiết đều thể hiện vẻ đẹp sang trọng vượt thời gian, khẳng định phong cách mạnh mẽ và đẳng cấp riêng biệt của chủ nhân. Với Land-Dweller, bạn không chỉ sở hữu một cỗ máy thời gian đỉnh cao, mà còn là một di sản gắn liền với những câu chuyện chinh phục.</p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765701425/products/1765701421_ea6390030bb43ce2.png', 0, '1', '2025-12-14 15:37:07', 1),
(64, 'RDW-SSW-005', 4, 16, 'Samsung Galaxy Fit3', 'samsung-galaxy-fit3', '{\"size\":\"42mm\",\"material\":\"Khung vi\\u1ec1n Nh\\u00f4m, D\\u00e2y Silicone\",\"warranty\":\"12 th\\u00e1ng\",\"weight\":\"36.8g\",\"brand\":\"Samsung\",\"model\":\"Galaxy Fit3\"}', '[\"https:\\/\\/res.cloudinary.com\\/dfvaxlkol\\/image\\/upload\\/v1765701464\\/products\\/thumbnails\\/1765701461_dc71dba057c7d9db.png\"]', '<p>Samsung Galaxy Fit3 gây ấn tượng với màn hình lớn 1.6 inch AMOLED rực rỡ, mang lại không gian hiển thị rộng hơn 45% so với thế hệ trước. Đây là lần đầu tiên dòng Fit được trang bị khung viền hợp kim nhôm sang trọng, vừa bền bỉ vừa nhẹ nhàng. Với thời lượng pin bền bỉ lên đến 13 ngày, tích hợp hơn 100 chế độ tập luyện và các tính năng an toàn như phát hiện té ngã, Galaxy Fit3 là trợ thủ đắc lực cho việc theo dõi sức khỏe hàng ngày.</p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765701461/products/1765701457_d71990adbe5584c3.png', 0, '0', '2025-12-14 15:37:44', 1),
(65, 'RDW-RLW-004', 6, 6, ' Rolex GMT-Master II ', 'rolex-gmt-master-ii', '{\"size\":\"40mm\",\"brand\":\"Rolex\",\"model\":\"Oyster\",\"material\":\"v\\u00e0ng v\\u00e0ng 18 ct\",\"weight\":\"155g\",\"warranty\":\"12 th\\u00e1ng\"}', '[\"https://res.cloudinary.com/dfvaxlkol/image/upload/v1765702052/products/thumbnails/1765702046_d18b92564acde457.png\"]', '<p>Khám phá sự tinh hoa của nghệ thuật chế tác đồng hồ với Rolex GMT-Master II (mã RDW-RLW-004), biểu tượng của những chuyến phiêu lưu và sự sang trọng vượt thời gian. Sinh ra từ nhu cầu của các phi công, chiếc đồng hồ huyền thoại này đã định nghĩa lại khái niệm về thời gian kép, cho phép bạn theo dõi đồng thời hai múi giờ một cách dễ dàng.\r\n\r\nVới vành bezel xoay 24 giờ đặc trưng và kim GMT riêng biệt, Rolex GMT-Master II không chỉ là một công cụ hỗ trợ du lịch mà còn là tuyên ngôn về phong cách và đẳng cấp. Thiết kế mạnh mẽ, bền bỉ kết hợp cùng bộ máy tự động chính xác tuyệt đối, RDW-RLW-004 là người bạn đồng hành lý tưởng cho những ai khao khát chinh phục thế giới, luôn giữ kết nối dù ở bất kỳ đâu. Sở hữu ngay một kiệt tác đồng hồ Thụy Sĩ, minh chứng cho sự tinh tế và khả năng vận hành đỉnh cao.</p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765702046/products/1765702039_1b5621881c768ab6.png', 0, '1', '2025-12-14 15:47:32', 1),
(66, 'RDW-RLW-005', 6, 6, 'Submariner Date 1166', 'submariner-date-1166', '{\"size\":\"40 mm\",\"model\":\"Subma\",\"material\":\"v\\u00e0ng v\\u00e0ng 18 ct\",\"weight\":\"200g\",\"warranty\":\"24 th\\u00e1ng\"}', '[\"https://res.cloudinary.com/dfvaxlkol/image/upload/v1765702472/products/thumbnails/1765702464_7691c16c65c9f1c9.png\"]', '<p><span style=\"background-color: rgb(239, 236, 234); color: rgb(25, 25, 25);\">Bằng cách vận hành xưởng đúc độc quyền của riêng mình, Rolex có khả năng vô song để đúc hợp kim vàng 18 ct chất lượng cao nhất. Tùy theo tỷ lệ bạc, đồng, bạch kim hoặc palladium được thêm vào, người ta thu được các loại vàng 18 ct khác nhau: vàng, hồng hoặc trắng. Chúng chỉ được chế tạo bằng những kim loại nguyên chất nhất và được kiểm tra tỉ mỉ trong phòng thí nghiệm nội bộ với thiết bị hiện đại, trước khi vàng được tạo hình và tạo hình với sự chú ý tỉ mỉ đến chất lượng. Cam kết của Rolex về sự xuất sắc bắt đầu từ nguồn.</span></p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765702464/products/1765702459_6f220825e02f43b5.png', 1, '0', '2025-12-14 15:54:32', 1),
(67, 'RDW-BRW-001', 6, 15, 'Navitimer B01 Chronograph 41', 'navitimer-b01-chronograph-41', '{\"size\":\"33mm\",\"material\":\"da\",\"warranty\":\"12 th\\u00e1ng\",\"weight\":\"200g\",\"brand\":\"Breitling\",\"model\":\"limit\"}', '[\"https:\\/\\/res.cloudinary.com\\/dfvaxlkol\\/image\\/upload\\/v1765702945\\/products\\/thumbnails\\/1765702944_ad7607e729a6eb02.png\"]', '<p><span style=\"color: rgb(29, 29, 29);\">Lần đầu tiên, màu xanh dương đậm hiệu ứng lì xuất hiện để tôn lên chất liệu gốm chịu lực cao đặc trưng của đồng hồ J12. Với màu sắc độc quyền này, Studio Sáng tạo Đồng hồ của CHANEL mang đến một vẻ quyến rũ mới mẻ cho thời gian.</span></p><p><span style=\"color: rgb(29, 29, 29);\">Khám phá 9 phiên bản đính hoặc không đính sapphire màu xanh dương, bao gồm 5 thiết kế Haute Horlogerie. Phiên bản giới hạn.</span></p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765702944/products/1765702942_1d9dae2675d4d4b8.png', 1, '0', '2025-12-14 16:02:25', 1),
(68, 'RDW-BRW-002', 1, 15, 'Navitimer B01 Chronograph', 'navitimer-b01-chronograph', '{\"size\":\"42mm\",\"material\":\"th\\u00e9p\",\"warranty\":\"24 th\\u00e1ng\",\"weight\":\"150g\",\"brand\":\"beritling\",\"model\":\"Automatic\"}', '[\"https:\\/\\/res.cloudinary.com\\/dfvaxlkol\\/image\\/upload\\/v1765704604\\/products\\/thumbnails\\/1765704600_b90f710e5da33294.png\"]', '<p><span style=\"color: rgb(51, 51, 51);\">Đồng hồ Breitling Navitimer B01 Chronograph AB0139241C1A1 là mẫu đồng hồ đến từ thương hiệu Breitling, có kích cỡ mặt số 41 mm dành cho các quý ông lịch lãm. Chiếc đồng hồ sử dụng bộ máy tự động có xuất xứ Thụy Sĩ, đồng hồ có thể vận hành trong thời gian dài, có độ bền và giá trị sưu tầm cao. Chất liệu vỏ được chế tác từ thép có độ bền cao và vẻ ngoài sang trọng. Đồng hồ được trang bị dây kim loại bền bỉ, lịch lãm. Chất liệu kính làm từ Sapphire đem lại khả năng chống xước, chống lóa tuyệt vời</span></p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765704600/products/1765704598_a76e6761b1ea57b7.png', 0, '0', '2025-12-14 16:30:04', 1),
(82, 'RDW-NAUTILUS-2146', 6, 11, 'Nautilus ', 'nautilus-6', '{\"size\":\"41mm\",\"brand\":\"Patek Philippe\",\"model\":\"RDW-NAUTILUS-2146\",\"material\":\"Th\\u00e9p kh\\u00f4ng g\\u1ec9\",\"weight\":\"155g\",\"warranty\":\"24 th\\u00e1ng\"}', '[\"https://res.cloudinary.com/dfvaxlkol/image/upload/v1765723741/products/thumbnails/1765723739_c6efcb2dc740a1f3.webp\",\"https://res.cloudinary.com/dfvaxlkol/image/upload/v1765723741/products/thumbnails/1765723739_2693c31a6c51ceb1.webp\",\"https://res.cloudinary.com/dfvaxlkol/image/upload/v1765723744/products/thumbnails/1765723739_29b95a03059fc758.webp\"]', '<p>Bước vào kỷ nguyên mới cùng Nautilus RDW-NAUTILUS-2146, một kiệt tác của công nghệ và thiết kế đỉnh cao. Lấy cảm hứng từ sự bền bỉ của đại dương sâu thẳm và vẻ đẹp hoàn hảo của vỏ ốc anh vũ, Nautilus không chỉ là một sản phẩm, mà là một lời khẳng định về phong cách và sự tiên phong. Thiết bị này mang đến trải nghiệm vượt trội, kết hợp hài hòa giữa hiệu suất mạnh mẽ và sự tinh xảo trong từng đường nét, thách thức mọi giới hạn. Với Nautilus RDW-NAUTILUS-2146, bạn không chỉ sở hữu công nghệ hiện đại, mà còn là biểu tượng của sự khám phá không ngừng và đẳng cấp vượt thời gian. Hãy để Nautilus định nghĩa lại chuẩn mực trải nghiệm của bạn ngay hôm nay.</p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765723654/products/1765723651_e33a31e54e19593d.webp', 0, '0', '2025-12-14 21:02:36', 1),
(83, 'RDW-ROLEX-DEEPSEA-8677', 6, 6, 'Rolex Deepsea', 'rolex-deepsea', '{\"size\":\"44mm\",\"brand\":\"Rolex\",\"model\":\"RDW-ROLEX-DEEPSEA-8677\",\"material\":\"Th\\u00e9p kh\\u00f4ng g\\u1ec9\",\"weight\":\"220g\",\"warranty\":\"60 th\\u00e1ng\"}', '[\"https://res.cloudinary.com/dfvaxlkol/image/upload/v1765726312/products/thumbnails/1765726293_2a7632ffc7f50db4.png\",\"https://res.cloudinary.com/dfvaxlkol/image/upload/v1765726453/products/thumbnails/1765726443_769cb123c1e99d24.png\"]', '<p>Khám phá chiều sâu đại dương với chiếc đồng hồ Rolex Deepsea (RDW-ROLEX-DEEPSEA-8677) huyền thoại. Đây không chỉ là một phụ kiện thời gian, mà là một công cụ lặn chuyên nghiệp được chế tác để thách thức những giới hạn khắc nghiệt nhất. Với vỏ Oystersteel siêu bền và hệ thống Ringlock độc đáo, chiếc Rolex Deepsea này sở hữu khả năng chống nước vượt trội đến mức kinh ngạc, sẵn sàng đồng hành cùng bạn trong những cuộc phiêu lưu dưới đáy biển sâu. Sự kết hợp hoàn hảo giữa kỹ thuật chế tác đỉnh cao của Rolex và vẻ ngoài mạnh mẽ, sang trọng đã biến Deepsea thành biểu tượng của sự bền bỉ, chính xác và phong cách đẳng cấp, dành cho những ai khao khát khám phá và chinh phục.</p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765726293/products/1765726290_51a14e24ad6b382e.png', 0, '0', '2025-12-14 22:31:52', 1),
(87, 'RDW-NG-H-BIG-BANG-5950', 6, 13, 'Đồng hồ Big Bang', 'dong-ho-big-bang', '{\"size\":\"41mm\",\"brand\":\"Hublot\",\"model\":\"Big Bang Chronograph\",\"material\":\"Th\\u00e9p kh\\u00f4ng g\\u1ec9, D\\u00e2y da c\\u00e1 s\\u1ea5u v\\u00e0 Cao su\",\"weight\":\"155g\",\"warranty\":\"24 th\\u00e1ng\"}', '[\"https://res.cloudinary.com/dfvaxlkol/image/upload/v1765728222/products/thumbnails/1765728214_bfc4bcd8d067512a.jpg\",\"https://res.cloudinary.com/dfvaxlkol/image/upload/v1765728252/products/thumbnails/1765728217_1421dfbe8e7658d1.png\"]', '<p>Đồng hồ Big Bang không chỉ đơn thuần là một cỗ máy thời gian, mà còn là một tuyên ngôn phong cách mạnh mẽ và đầy cá tính. Với tên gọi đầy ấn tượng, mẫu đồng hồ này thực sự \"bùng nổ\" với thiết kế độc đáo, thu hút mọi ánh nhìn ngay từ khoảnh khắc đầu tiên. Từng đường nét tinh xảo, sự kết hợp táo bạo của các chi tiết tạo nên một tổng thể hài hòa, khẳng định đẳng cấp và gu thẩm mỹ vượt trội của người đeo.\r\n\r\nĐây không chỉ là một phụ kiện để xem giờ, mà còn là biểu tượng của sự tự tin, phá cách, dành riêng cho những ai luôn tìm kiếm sự khác biệt và muốn tạo dấu ấn riêng. Sở hữu Đồng hồ Big Bang, bạn đang đeo trên tay một tác phẩm nghệ thuật hiện đại, nâng tầm phong cách sống. Hãy trải nghiệm sự cuốn hút từ mẫu RDW-NG-H-BIG-BANG-5950 ngay hôm nay để khẳng định phong thái độc đáo của bạn.</p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765728370/products/1765728367_acff6852ad0061ac.png', 0, '1', '2025-12-14 23:06:10', 1),
(88, 'RDW-DATEJUST-3186', 6, 6, 'Datejust', 'datejust', '{\"size\":\"41mm\",\"brand\":\"Rolex\",\"model\":\"RDW-DATEJUST-3186\",\"material\":\"Th\\u00e9p kh\\u00f4ng g\\u1ec9\",\"weight\":\"160g\",\"warranty\":\"60 th\\u00e1ng\"}', '[\"https://res.cloudinary.com/dfvaxlkol/image/upload/v1765741682/products/thumbnails/1765741677_5dce6d6b989d09e2.png\",\"https://res.cloudinary.com/dfvaxlkol/image/upload/v1765741680/products/thumbnails/1765741677_3ad1526c9b2c9136.png\",\"https://res.cloudinary.com/dfvaxlkol/image/upload/v1765741680/products/thumbnails/1765741676_92775f0d6ed9b8f5.png\"]', '<p>Khám phá sự giao thoa hoàn hảo giữa nét cổ điển vượt thời gian và vẻ đẹp hiện đại với chiếc đồng hồ <strong>Datejust </strong>huyền thoại. Mang mã <strong><em>RDW-DATEJUST-3186</em></strong>, đây không chỉ là một cỗ máy thời gian mà còn là biểu tượng của phong cách và đẳng cấp. Với thiết kế tinh xảo, từng đường nét của Datejust đều được chăm chút tỉ mỉ, từ mặt số thanh lịch đến bộ vỏ bền bỉ, tạo nên một vẻ đẹp sang trọng khó cưỡng. Chiếc đồng hồ này dễ dàng phối hợp với mọi trang phục, từ công sở đến những buổi tiệc đêm sang trọng, khẳng định gu thẩm mỹ tinh tế của người sở hữu. Datejust RDW-DATEJUST-3186 chính là lựa chọn hoàn hảo để bạn thể hiện cá tính và tạo dấu ấn riêng biệt trong mọi khoảnh khắc.</p>', 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765741686/products/1765741684_91b9f611c74e461d.png', 1, '1', '2025-12-15 02:48:07', 1);

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
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `product_variants`
--

INSERT INTO `product_variants` (`id`, `product_id`, `price`, `sku`, `quantity`, `image`, `colors`, `created_at`, `updated_at`) VALUES
(42, 45, 12190000.00, 'APP-001-01', 14, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765634294/products/variants/1765634292_ad9e1e95f8f28796.png', '[\"Đen\"]', '2025-12-13 13:59:15', '0000-00-00 00:00:00'),
(43, 45, 13190000.00, 'APP-001-02', 12, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765634322/products/variants/1765634320_e1b976d2b2a14017.png', '[\"Trắng\"]', '2025-12-13 13:59:16', '0000-00-00 00:00:00'),
(52, 51, 5790000.00, 'APP-002-01', 12, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765698060/products/variants/1765698057_e123f93a17d2a3f8.png', '[\"Đen\"]', '2025-12-14 07:44:58', '0000-00-00 00:00:00'),
(53, 51, 5990000.00, 'APP-002-02', 9, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765698146/products/variants/1765698144_a4e4a943ac7f2ae7.png', '[\"Xanh\"]', '2025-12-14 07:44:58', '0000-00-00 00:00:00'),
(54, 51, 5790000.00, 'APP-002-03', 10, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765698250/products/variants/1765698248_4db41e48353a8c11.png', '[\"Trắng\"]', '2025-12-14 07:44:58', '0000-00-00 00:00:00'),
(55, 51, 6190000.00, 'APP-002-04', 6, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765698284/products/variants/1765698282_5c21c08f1318aecb.png', '[\"Vàng\"]', '2025-12-14 07:44:59', '0000-00-00 00:00:00'),
(67, 57, 10690000.00, 'SAM-002-01', 8, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765700314/products/variants/1765700311_4eb8e2bd5b23c54e.png', '[\"Đen\"]', '2025-12-14 08:20:06', '0000-00-00 00:00:00'),
(68, 57, 11690000.00, 'SAM-002-02', 6, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765700373/products/variants/1765700370_c038d28e9d8dec7a.png', '[\"Trắng\"]', '2025-12-14 08:20:06', '0000-00-00 00:00:00'),
(69, 58, 250000000.00, 'ROL-001-01', 8, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765700435/products/variants/1765700432_589beca0416e347e.png', '[\"vàng\"]', '2025-12-14 08:20:53', '0000-00-00 00:00:00'),
(70, 58, 280000000.00, 'ROL-001-02', 5, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765700416/products/variants/1765700411_012ea7da3dd2e100.png', '[\"Xanh\"]', '2025-12-14 08:20:53', '0000-00-00 00:00:00'),
(71, 58, 320000000.00, 'ROL-001-03', 3, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765700408/products/variants/1765700406_933434d16fc0e580.png', '[\"bạc\"]', '2025-12-14 08:20:54', '0000-00-00 00:00:00'),
(72, 59, 6890000.00, 'SAM-03-01', 12, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765700642/products/variants/1765700640_8b8fa470a02f1173.png', '[\"Đen\"]', '2025-12-14 08:24:49', '0000-00-00 00:00:00'),
(73, 59, 6990000.00, 'SAM-03-02', 20, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765700653/products/variants/1765700650_a2a135f423055005.png', '[\"Trắng\"]', '2025-12-14 08:24:49', '0000-00-00 00:00:00'),
(77, 61, 150000000.00, 'ROL-002-01', 8, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765700946/products/variants/1765700943_d84dd88220ca9459.png', '[\"Xanh\"]', '2025-12-14 08:29:59', '0000-00-00 00:00:00'),
(78, 61, 145000000.00, 'ROL-002-02', 12, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765700977/products/variants/1765700974_db54ca9ae566890a.png', '[\"đen\"]', '2025-12-14 08:29:59', '0000-00-00 00:00:00'),
(79, 61, 160000000.00, 'ROL-002-03', 4, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765700982/products/variants/1765700977_129e54e2ab7dfb99.png', '[\"Tím\"]', '2025-12-14 08:30:00', '0000-00-00 00:00:00'),
(80, 62, 219000.00, 'SAM-004-01', 12, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765701033/products/variants/1765701031_5f93b0358e0d2ee9.png', '[\"Đen\"]', '2025-12-14 08:31:30', '0000-00-00 00:00:00'),
(81, 62, 209000.00, 'SAM-004-02', 15, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765701061/products/variants/1765701059_d68fa257ba35cb91.png', '[\"Hồng\"]', '2025-12-14 08:31:30', '0000-00-00 00:00:00'),
(82, 63, 23000000.00, 'ROL-003-01', 2, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765701283/products/variants/1765701280_668b73aeb404d1fc.png', '[\"Hồng\"]', '2025-12-14 08:37:07', '2025-12-15 02:57:07'),
(83, 63, 53000000.00, 'ROL-003-02', 3, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765701403/products/variants/1765701401_91ffce9b530edd4f.png', '[\"bạc\"]', '2025-12-14 08:37:08', '2025-12-14 12:26:43'),
(84, 64, 890000.00, 'SAM-005-01', 14, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765701441/products/variants/1765701439_9bda89f0230bebca.png', '[\"Đen\"]', '2025-12-14 08:37:44', '0000-00-00 00:00:00'),
(85, 64, 990000.02, 'SAM-005-02', 14, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765701444/products/variants/1765701442_96d93e5b5119aea7.png', '[\"Trắng\"]', '2025-12-14 08:37:44', '0000-00-00 00:00:00'),
(86, 65, 10341000.00, 'ROL-004-01', 2, NULL, '[\"Đen\"]', '2025-12-14 08:47:33', '2025-12-15 02:57:31'),
(87, 65, 90341000.00, 'ROL-004-02', 3, NULL, '[\"bạc\"]', '2025-12-14 08:47:33', '2025-12-14 12:25:37'),
(88, 66, 5100000.00, 'ROL-005-01', 0, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765702383/products/variants/1765702379_9d6bc95d6f02b54f.png', '[\"xanh\"]', '2025-12-14 08:54:32', '0000-00-00 00:00:00'),
(89, 66, 6304000.00, 'ROL-005-02', 1, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765702389/products/variants/1765702385_9bdc4c8fc045836b.png', '[\"Đen\"]', '2025-12-14 08:54:32', '2025-12-15 03:27:20'),
(90, 67, 10101000.00, 'BRE-001-01', 1, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765702896/products/variants/1765702894_ef13a6554d69192d.png', '[\"Nâu\"]', '2025-12-14 09:02:25', '0000-00-00 00:00:00'),
(91, 67, 11002000.00, 'BRE-001-02', 5, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765702906/products/variants/1765702903_a5b9fa988c49afd8.png', '[\"Đen\"]', '2025-12-14 09:02:25', '0000-00-00 00:00:00'),
(92, 68, 10300000.00, 'BRE-002-01', 0, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765704467/products/variants/1765704465_1f0402d0bbf8ecb3.png', '[\"xanh lục\"]', '2025-12-14 09:30:05', '0000-00-00 00:00:00'),
(93, 68, 1230000.00, 'BRE-002-02', 5, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765704475/products/variants/1765704469_8eaf4a182b43b076.png', '[\"Đen\"]', '2025-12-14 09:30:05', '0000-00-00 00:00:00'),
(96, 82, 15000000.00, 'PAT-2146-01', 2, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765723676/products/variants/1765723672_05cb015139635aae.webp', '[\"Xanh Dương\"]', '2025-12-14 14:02:36', '2025-12-14 14:49:05'),
(97, 83, 412737000.00, 'ROL-8677-01', 7, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765726188/products/variants/1765726186_a588824c7d38b928.png', '[\"Bạc\"]', '2025-12-14 15:31:52', '2025-12-14 15:34:27'),
(98, 83, 1639322000.00, 'ROL-8677-02', 10, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765726228/products/variants/1765726226_89f25cc90691cc74.png', '[\"Vàng\"]', '2025-12-14 15:31:53', '2025-12-14 15:34:27'),
(99, 83, 404017000.00, 'ROL-8677-03', 10, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765726464/products/variants/1765726462_3500708f90883151.png', '[\"Thép không gỉ\"]', '2025-12-14 15:31:53', '2025-12-14 15:34:27'),
(102, 87, 25000000.00, 'HUB-5950-01', 12, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765728172/products/variants/1765728168_db5fb339ddd8c8ae.png', '[\"Bạch Kim\"]', '2025-12-14 16:06:11', '2025-12-14 17:01:15'),
(103, 87, 134000000.00, 'HUB-5950-02', 8, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765728201/products/variants/1765728197_c7190c885c5445d9.png', '[\"Vàng\"]', '2025-12-14 16:06:11', '2025-12-14 17:01:15'),
(104, 88, 250000000.00, 'ROL-3186-01', 0, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765741812/products/variants/1765741809_59a150cc0284576f.png', '[\"Vàng Hồng\"]', '2025-12-14 19:48:07', '2025-12-15 00:29:23'),
(105, 88, 26000000.00, 'ROL-3186-02', 7, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765741825/products/variants/1765741822_367985e6393cf278.png', '[\"Bạc\"]', '2025-12-14 19:48:07', '2025-12-15 00:29:23'),
(106, 88, 27000000.00, 'ROL-3186-03', 3, 'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765741668/products/variants/1765741666_a12ac75b888cb49c.png', '[\"Đen\"]', '2025-12-14 19:48:07', '2025-12-15 00:29:23');

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
(28, 232, 61, 'sản phảm tốt ăn ngon', 'mẹ mày béo', 5, 0, '2025-12-14 21:50:41', '2025-12-15 03:32:05', 21),
(29, 232, 66, 'sản phẩm ăn rất ngon', NULL, 5, 1, '2025-12-14 22:29:44', NULL, NULL),
(30, 232, 68, 'ngon lắm', NULL, 5, 1, '2025-12-14 22:30:13', NULL, NULL),
(31, 232, 83, 'hale', NULL, 5, 1, '2025-12-15 00:26:53', NULL, NULL),
(33, 21, 64, 'cx', 'cam on bạn', 5, 1, '2025-12-15 04:17:59', '2025-12-15 07:37:29', 21),
(34, 21, 88, 'scam à, hàng giả à', NULL, 5, 1, '2025-12-15 07:56:49', NULL, NULL);

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
(24, 'BIDV', '2025-12-13 19:07:16', '8836563558', '96247RUDOWATCH', 31000.00, 0.00, 0.00, NULL, '110758026907 0916110241 DH23', '8ee8f515-250f-4397-9978-e94d5e223f00', 'BankAPINotify 110758026907 0916110241 DH23', '2025-12-13 19:07:18'),
(25, 'BIDV', '2025-12-13 22:02:27', '8836563558', '96247RUDOWATCH', 45500.00, 0.00, 0.00, NULL, '110777358935 0916110241 DH31', '0890c914-08b6-425e-a5e3-2df836211a78', 'BankAPINotify 110777358935 0916110241 DH31', '2025-12-13 22:02:45'),
(26, 'BIDV', '2025-12-13 22:02:27', '8836563558', '96247RUDOWATCH', 45500.00, 0.00, 0.00, NULL, '110777358935 0916110241 DH31', '0890c914-08b6-425e-a5e3-2df836211a78', 'BankAPINotify 110777358935 0916110241 DH31', '2025-12-13 22:03:48'),
(27, 'BIDV', '2025-12-13 22:02:27', '8836563558', '96247RUDOWATCH', 45500.00, 0.00, 0.00, NULL, '110777358935 0916110241 DH31', '0890c914-08b6-425e-a5e3-2df836211a78', 'BankAPINotify 110777358935 0916110241 DH31', '2025-12-13 22:04:52'),
(28, 'BIDV', '2025-12-13 22:02:27', '8836563558', '96247RUDOWATCH', 45500.00, 0.00, 0.00, NULL, '110777358935 0916110241 DH31', '0890c914-08b6-425e-a5e3-2df836211a78', 'BankAPINotify 110777358935 0916110241 DH31', '2025-12-13 22:06:55'),
(29, 'BIDV', '2025-12-13 22:02:27', '8836563558', '96247RUDOWATCH', 45500.00, 0.00, 0.00, NULL, '110777358935 0916110241 DH31', '0890c914-08b6-425e-a5e3-2df836211a78', 'BankAPINotify 110777358935 0916110241 DH31', '2025-12-13 22:09:58'),
(30, 'BIDV', '2025-12-13 22:02:27', '8836563558', '96247RUDOWATCH', 45500.00, 0.00, 0.00, NULL, '110777358935 0916110241 DH31', '0890c914-08b6-425e-a5e3-2df836211a78', 'BankAPINotify 110777358935 0916110241 DH31', '2025-12-13 22:15:01'),
(31, 'BIDV', '2025-12-15 02:22:24', '8836563558', '96247RUDOWATCH', 920000.00, 0.00, 0.00, NULL, '110907257984 0916110241 DH44', '41ef9d93-05d2-497d-b487-0fc6c5a9160b', 'BankAPINotify 110907257984 0916110241 DH44', '2025-12-15 02:22:26'),
(32, 'BIDV', '2025-12-15 02:22:24', '8836563558', '96247RUDOWATCH', 920000.00, 0.00, 0.00, NULL, '110907257984 0916110241 DH44', '41ef9d93-05d2-497d-b487-0fc6c5a9160b', 'BankAPINotify 110907257984 0916110241 DH44', '2025-12-15 02:23:32');

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
(9, 'Nguyen Anh Khoi', 'tuyetnhng010193@gmail.com', '$2y$10$E11rnLRal3wvh45RsPrw8OIqPkGcwwbpJ4BR6KvCCSWWLUQ11QaTy', '0393159438', 0, 1, '38a76208f0849f0b8825f0cd0a3aef04fac897d0174edd7bf03aefc0b36c493c', '2025-11-24 00:00:00', NULL),
(11, 'Phan Đức Bình', 'phanbinh150504@gmail.com', '$2y$10$u4CgMEojn6FhohVK2PiiQubmnmdb.3h.RppA8bs3TbnIuTNJ6vTDu', '0382832609', 1, 1, 'b7d24d03f73cb43bbe6327ee383d3ba959da9801a62aebb81df1400d1823b48f', '2025-11-26 00:00:00', '2025-12-13 10:48:54'),
(19, 'nguey anh khoi', 'pductoandettt@gmail.com', '$2y$10$4neyO9PY51eo5hrNbTrj4.YiWM6N89P0Qs1fTb18dxBvKKyAmxceC', '0961011024', 1, 1, 'ebe436426eaa2e479c45098f440d33397c2c195c6d57b406bf9ad9ad8a6cff82', '2025-11-29 18:26:02', NULL),
(21, 'Toàn đẹp trai', 'toanphan01vip@gmail.com', '$2y$10$zWCoyysDbDTEzBIjyZaPZ.Q33wu6OnZ1zoZ532ywnA5x39N7HOm8m', '0916110241', 1, 1, 'b3ee0f27805e172becee4bbe4b39db82d188485e0a2b95c2540143b83562051f', '2025-11-30 06:49:14', '2025-12-15 00:21:40'),
(22, 'Ma Gaming', 'magaming0101@gmail.com', '$2y$10$Qejsv7qQAelw4h.oKnVBKu9V0hYrxLkQWXll0PALmpZWhCccbKZJS', NULL, 0, 1, 'b335c44eace86b5b56af4ce1e441aab5fc9602e56562325100f64a5fa960cc5e', '2025-11-30 08:01:53', NULL),
(23, 'Zu Côn', 'zucon441@gmail.com', '$2y$10$Br8/pmJxmhrWUyM51Ium4.03dAMQdjy9M6xavUul4OF/9T9UIzV3q', NULL, 1, 1, '38f6dff32430c150f0f7d237ea1defca22fa82974de42fd0965583a050dd5529', '2025-11-30 08:17:29', NULL),
(24, 'Nguyễn Anh Khôi', 'anhkhoi@gmail.com', '123456', NULL, 1, 1, NULL, '2025-12-02 05:38:28', NULL),
(26, 'Phan toàn', 'pductoanhehe@gmail.com', '$2y$10$lYYlvrAMfyJ/iedlPx8Elu6V8JNFow5M9VfDlAqhuQ3XaL.yGIrRW', '0916110241', 0, 1, '0d4b317ec26f641c4b10a07721b59363113c5720cd6537c5ec2028125eace643', '2025-12-02 06:22:03', '2025-12-03 07:15:35'),
(27, 'Nguyễn anh Khôi khôi khôi', 'khoilord@gmail.com', '$2y$10$0yX28.SBGFC5NYipICitRevgOh94pPjMcH8D/rxB.nBUDDrsKbRP.', '0393159434', 0, 1, '627bff396080fb3bcab60ae781e1a9e88799f3cb0e70f34b3e1701126ed6f6ca', '2025-12-02 08:30:04', '2025-12-05 07:49:51'),
(231, 'Vuong Quoc', 'vuong.nguyenquoc.sistrain@gmail.com', '$2y$10$6dsTtpdejUmoIKhd.0noX.jeCkkwm.zG9LBGBq03qZ9vZAhXI3AvG', NULL, 0, 1, 'a3a13cc23b1a23d4dfa681972051998aeecdee0f01e7ea648c431a7ac8adab0e', '2025-12-08 01:58:27', '2025-12-14 04:31:42'),
(232, 'Nguyễn anh Khôi', 'nguyenanhkhoi@gmail.com', '$2y$10$JdzF3X0ziwY0y0Yq5veDvOUMqRzAObYQbPGfAsSwdSAGIvno2/5xW', '0974010123', 1, 1, '4abb35b24b08af3e36dfc8797c55f8213c48175f52db1001b86384b42385e4a2', '2025-12-08 08:09:45', NULL),
(233, 'Poly Coder', 'coderpoly.fpthcm@gmail.com', '$2y$10$XzHE8l.vTCeYMlTDuI5iMuT7/f1TioQXkJyILCK/7p/WSPzZpLK.K', NULL, 1, 1, '7d76147dce1cb84fe5b0789e180852705fb08ff0996ebe5dbe76c186b2e04022', '2025-12-10 06:15:08', NULL),
(234, 'Phan Duc Binh', '22142083@student.hcmute.edu.vn', '$2y$10$IUgaIMdoFjz7dF/nM8uY0uZ4qIxXb.MU04EpoIVLPey5irR9agPt.', NULL, 0, 1, '20092949c3127c778a6dce7d793092aaa24d6d2db49352ff411b0a9cd2535091', '2025-12-10 08:05:36', NULL),
(236, 'Toàn đẹp trai', 'phanductoandev@gmail.com', '$2y$10$t6DYoknEsU1XRksbtJib8eZY2/8ieAJn8sdRXCAi5ycGdE6NzsnHi', '0916110241', 0, 1, '31b5cd14ad6e71d8cdce6ff2e1668de3e9ddfdb521c775958011addee22f0481', '2025-12-13 02:38:32', '2025-12-13 02:54:56'),
(237, 'Vương Quốc', 'vuongnguyenquoc@gmai.com', '$2y$10$hg8G2r6OZFYZ6usmrsuQkeY51aa/QPL4Gq6ZdpcjDeL1k.QpAu.7.', '0382832609', 0, 1, '7ec8b75449902e2a73c028a413fbc041de95af70145b1bf94ecc9d9ba03abdcf', '2025-12-14 04:27:43', NULL),
(238, 'Bình Phan', 'bpnext150504@gmail.com', '$2y$10$CqVz2/4R8MQayGLlENV9U.Gw.ryusoFEGa3H/E4zMKSFoyyo6EBme', NULL, 0, 1, '661c0cd077a1bbbe1967f23fcc2b815ed78c3843d5536c3c165e474257e384f7', '2025-12-14 04:41:07', NULL),
(239, 'Nguyễn anh Khôi', 'nguyenanhkhoi2@gmail.com', '$2y$10$jJNJtR6qjgAvDl1IRDhvRuQiUhghMN2xsfBBBzNk6pkfkqrKuW8l.', '0393159478', 0, 1, 'bf4f345897ebb09147ea2806cba78ef0468e1508e434428d32fa6326e5b2728c', '2025-12-14 14:51:41', NULL),
(240, 'Giảng viên admin', 'admin@gmail.com', '$2y$10$l30fUOmsBpBse9NIueVlCeTqCUU7Fi.aZ4am8Gw36C.1XoJtzIQpm', '0916110241', 0, 1, '436ba79cc8d626da01d86dcb2d482ce70cb3167b3bd1ea1d161253f59a505aff', '2025-12-15 01:03:15', NULL),
(241, 'Giảng viên client', 'client@gmail.com', '$2y$10$8ZImFxSU0XY52q1IxDPjjemNBocAEy2T8nshsz.Xcxh4ZcIW7rXAy', '0916110241', 0, 1, '520696b82c5dee7ab730133074b064c7bb264307111dbc1456a2cc22e1440279', '2025-12-15 01:03:56', NULL);

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
(10, 'SIEUSALE', 'percent', 10, NULL, '2025-12-05 08:20:29', '2025-12-15 00:12:00', '2025-12-28 15:20:00', '2025-12-14 17:12:59', NULL, 1000),
(11, 'GIANGSINH', 'percent', 20, NULL, '2025-12-10 06:30:52', NULL, '2026-05-13 13:30:00', NULL, NULL, 100),
(13, 'SALE2024', 'percent', 20, NULL, '2025-12-13 13:10:55', '2025-12-08 23:38:00', '2025-12-31 10:12:00', '2025-12-14 16:40:51', NULL, 100),
(14, 'OKOKEKEOOKE', 'percent', 20, NULL, '2025-12-14 20:00:36', '2025-12-16 03:00:00', '2025-12-19 03:00:00', '2025-12-14 20:01:16', NULL, 199),
(17, 'OKOKEKEOOKEJF', 'money', NULL, 20000.00, '2025-12-14 20:47:16', '2025-12-15 03:47:00', '2026-01-11 03:47:00', NULL, NULL, 100),
(18, 'OKOKEKEOOKEF', 'money', NULL, 10000.00, '2025-12-14 20:48:00', '2025-12-17 03:47:00', '2026-01-11 03:47:00', '2025-12-14 20:53:47', NULL, 50);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT cho bảng `brands`
--
ALTER TABLE `brands`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT cho bảng `carts`
--
ALTER TABLE `carts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT cho bảng `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=123;

--
-- AUTO_INCREMENT cho bảng `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT cho bảng `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT cho bảng `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT cho bảng `order_detail`
--
ALTER TABLE `order_detail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

--
-- AUTO_INCREMENT cho bảng `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=117;

--
-- AUTO_INCREMENT cho bảng `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;

--
-- AUTO_INCREMENT cho bảng `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT cho bảng `posts_categories`
--
ALTER TABLE `posts_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- AUTO_INCREMENT cho bảng `product_variants`
--
ALTER TABLE `product_variants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;

--
-- AUTO_INCREMENT cho bảng `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT cho bảng `shipping_method`
--
ALTER TABLE `shipping_method`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `tb_transactions`
--
ALTER TABLE `tb_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=242;

--
-- AUTO_INCREMENT cho bảng `vouchers`
--
ALTER TABLE `vouchers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

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
