-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: metro.proxy.rlwy.net    Database: railway
-- ------------------------------------------------------
-- Server version	9.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addresses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `street` varchar(255) DEFAULT NULL,
  `ward` varchar(100) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `receiver_name` varchar(150) DEFAULT NULL,
  `receiver_phone` varchar(20) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `is_default` tinyint DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
INSERT INTO `addresses` VALUES (9,18,'Eapo','Cưjut','Đăk Nông brunay','DucTon','0916110241','2025-11-30 10:28:28','2025-12-01 08:40:50',0),(18,18,'to ky','Phường Tân Chánh Hiệp','Thành phố Hồ Chí Minh','dtoan','0123456789','2025-11-30 12:13:57','2025-12-01 08:40:50',0),(19,18,'Đường 22','Xã Thái Học','Cao Bằng','Bình','0123456789','2025-11-30 12:40:23','2025-12-01 08:40:50',1),(20,7,'76/1 Tân Chánh Hiệp 08','Phường Tân Chánh Hiệp','Thành phố Hồ Chí Minh','Bình Phan','0382832609','2025-12-03 00:10:59','2025-12-03 00:12:19',1),(22,27,'Huyện Hàm Thuận Nam','','Tuyên Quang','ádada','0123456789','2025-12-05 07:50:30',NULL,1),(23,11,'145 Tổ 2','Thị trấn Đinh Văn','Lâm Đồng','Thanh Phan','0339817726','2025-12-05 08:01:01','2025-12-08 08:25:26',0),(24,11,'76/1 Tân Chánh Hiệp 08','','Thành phố Hồ Chí Minh','Bình Phan','0382832609','2025-12-05 08:01:45','2025-12-08 08:25:26',1),(25,8,'369 Đường Tô Ký','Phường 12','Thành phố Hồ Chí Minh','lkahdkad','0393159478','2025-12-10 08:06:53','2025-12-11 14:44:35',0),(26,8,'369 Đường Tô Ký','Phường Trung Mỹ Tây','Thành phố Hồ Chí Minh','sdas','0393159478','2025-12-10 08:07:28','2025-12-11 14:44:35',1);
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `brands`
--

DROP TABLE IF EXISTS `brands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `brands` (
  `id` int NOT NULL AUTO_INCREMENT,
  `logo` longtext,
  `name` varchar(150) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `status` tinyint DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_brand_slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brands`
--

LOCK TABLES `brands` WRITE;
/*!40000 ALTER TABLE `brands` DISABLE KEYS */;
INSERT INTO `brands` VALUES (6,'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765468263/brands/1765468262_64b5784c85cc5937.png','Rolex','rolex',1,'2025-11-24 08:03:23','2025-12-11 15:51:05'),(7,'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765468234/brands/1765468233_8b3e7fcbc1c07aac.png','Omega','omega',1,'2025-11-24 08:03:23','2025-12-11 15:50:36'),(11,'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765468197/brands/1765468197_954e6243ea8d9fa2.png','Patek Philippe','patek-philippe',1,'2025-12-04 11:43:19','2025-12-11 15:49:59'),(12,'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765468169/brands/1765468169_92ad98719d1a9150.svg','Cartier','cartier',1,'2025-12-04 11:44:43','2025-12-11 15:49:32'),(13,'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765468154/brands/1765468154_e71779e42f029043.png','Hublot','hublot',1,'2025-12-04 11:45:21','2025-12-11 15:49:16'),(14,'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765467907/brands/1765467907_acf7a0a119c2c467.png','Apple Watch','apple-watch',1,'2025-12-04 11:45:58','2025-12-11 15:45:09'),(15,'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765467892/brands/1765467891_c83319138a4c432b.png','Breitling','breitling',1,'2025-12-04 11:46:15','2025-12-11 15:44:54'),(16,'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765467859/brands/1765467859_d024aef1d131c9b8.png','Samsung','samsung',1,'2025-12-04 11:46:30','2025-12-11 15:44:22'),(17,'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765467875/brands/1765467875_dd883f74828bbc73.png','Xaomi','xaomi',1,'2025-12-09 17:16:56','2025-12-11 16:12:39'),(19,'https://res.cloudinary.com/dfvaxlkol/image/upload/v1765472209/brands/1765472209_5bb971542fd638c4.png','Omega','omega-1',1,'2025-12-10 07:49:47','2025-12-11 16:56:52');
/*!40000 ALTER TABLE `brands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cart_id` int NOT NULL,
  `variant_id` int NOT NULL,
  `quantity` int DEFAULT '1',
  `price_at_add` decimal(12,2) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_cart_item` (`cart_id`,`variant_id`),
  KEY `variant_id` (`variant_id`),
  CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
INSERT INTO `cart_items` VALUES (18,10,29,1,12000000.00,'2025-12-08 01:58:33','2025-12-08 01:58:33'),(32,13,33,2,1000.00,'2025-12-10 06:15:37','2025-12-10 06:15:42'),(33,8,33,7,1000.00,'2025-12-10 06:17:14','2025-12-10 06:17:42'),(34,8,31,12,9990000.00,'2025-12-10 06:28:10','2025-12-10 07:33:53'),(35,14,36,17,10000.00,'2025-12-10 07:56:54','2025-12-10 08:05:14'),(36,14,24,2,41240000.00,'2025-12-10 08:05:11','2025-12-10 08:05:16');
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carts`
--

DROP TABLE IF EXISTS `carts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carts`
--

LOCK TABLES `carts` WRITE;
/*!40000 ALTER TABLE `carts` DISABLE KEYS */;
INSERT INTO `carts` VALUES (6,18,'2025-12-03 07:42:53','2025-12-03 08:14:11'),(7,30,'2025-12-04 16:43:47','2025-12-04 16:43:47'),(8,11,'2025-12-08 01:04:43','2025-12-10 07:33:53'),(9,231,'2025-12-08 01:58:32','2025-12-08 04:23:04'),(10,231,'2025-12-08 01:58:32','2025-12-08 01:58:33'),(11,232,'2025-12-08 08:10:13','2025-12-08 08:10:13'),(12,21,'2025-12-10 05:33:27','2025-12-10 05:38:28'),(13,233,'2025-12-10 06:15:13','2025-12-10 06:15:43'),(14,8,'2025-12-10 07:47:41','2025-12-10 08:05:16'),(15,234,'2025-12-10 08:05:40','2025-12-10 08:11:19');
/*!40000 ALTER TABLE `carts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `logo` varchar(255) DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `status` tinyint DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_category_slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,NULL,'Đồng hồ nam','dong-ho-nam',1,'2025-11-24 08:03:23','2025-12-09 17:17:49'),(2,NULL,'Đồng hồ Nữ','dong-ho-nu',1,'2025-11-24 08:03:23',NULL),(3,NULL,'Đồng hồ Đôi','dong-ho-doi',1,'2025-11-24 08:03:23',NULL),(4,NULL,'Đồng hồ Thể thao','dong-ho-the-thao',1,'2025-11-24 08:03:23',NULL),(5,NULL,'Đồng hồ Thông minh','dong-ho-thong-minh',1,'2025-11-24 08:03:23',NULL),(6,NULL,'Đồng hồ Cao cấp','dong-ho-cao-cap',1,'2025-11-24 08:03:23','2025-12-04 11:03:23'),(11,NULL,'Đồng hồ LGBT','dong-ho-lgbt',1,'2025-12-09 17:16:42',NULL);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `post_id` int DEFAULT NULL,
  `content` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `post_id` (`post_id`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorites`
--

DROP TABLE IF EXISTS `favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorites` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `favorites_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorites`
--

LOCK TABLES `favorites` WRITE;
/*!40000 ALTER TABLE `favorites` DISABLE KEYS */;
/*!40000 ALTER TABLE `favorites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_detail` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `variant_id` int NOT NULL,
  `quantity` int DEFAULT NULL,
  `price` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `variant_id` (`variant_id`),
  CONSTRAINT `order_detail_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `order_detail_ibfk_2` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `order_detail` VALUES (11,8,25,1,109800000.00),(12,9,26,1,10000000.00),(13,10,26,6,10000000.00),(14,11,26,2,10000000.00),(15,11,28,1,120000.00),(16,12,25,1,109800000.00),(17,13,33,1,1000.00),(18,14,32,1,1250000.00),(19,15,30,1,8990000.00);
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `voucher_id` int DEFAULT NULL,
  `address` text,
  `status` varchar(50) DEFAULT 'pending',
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_status` varchar(50) DEFAULT NULL,
  `total` decimal(12,2) DEFAULT NULL,
  `note` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `voucher_id` (`voucher_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (6,11,NULL,'\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã An Thượng, Huyện Yên Thế, Tỉnh Bắc Giang\"','pending','cod','unpaid',186430000.00,NULL,'2025-12-04 11:25:21','2025-12-04 11:25:21'),(7,30,NULL,'\"369 Đường Tô Ký, Xã Lý Nhơn, Huyện Cần Giờ, Thành phố Hồ Chí Minh\"','pending','bank','unpaid',180080000.00,NULL,'2025-12-04 16:43:50','2025-12-04 16:43:50'),(8,7,NULL,'\"145 Tổ 2, Thị trấn Đinh Văn, Huyện Lâm Hà, Tỉnh Lâm Đồng\"','delivered','cod','paid',109830000.00,'Giao nhanh nha','2025-12-05 06:28:20','2025-12-05 07:42:53'),(9,30,NULL,'\"369 Đường Tô Ký, Xã Tân Thạnh Tây, Huyện Củ Chi, Thành phố Hồ Chí Minh\"','pending','card','unpaid',10080000.00,'sdsd','2025-12-05 08:19:21','2025-12-05 08:19:21'),(10,231,NULL,'\"134123, Xã Ngọc Thiện, Huyện Tân Yên, Tỉnh Bắc Giang\"','pending','cod','unpaid',60030000.00,NULL,'2025-12-08 04:28:52','2025-12-08 04:28:52'),(11,11,NULL,'\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Trung Hoà, Huyện Ngân Sơn, Tỉnh Bắc Kạn\"','confirmed','cod','paid',20150000.00,NULL,'2025-12-08 05:06:24','2025-12-08 08:15:05'),(12,11,NULL,'\"145 Tổ 2 Đồng Tâm Đinh Văn, Xã Nam Mẫu, Huyện Ba Bể, Tỉnh Bắc Kạn\"','confirmed','cod','paid',109830000.00,'OK','2025-12-08 05:35:31','2025-12-08 07:38:01'),(13,21,NULL,'\"369 Đường Tô Ký, Xã Phước Bình, Huyện Long Thành, Tỉnh Đồng Nai\"','pending','cod','paid',31000.00,'yh','2025-12-10 05:38:33','2025-12-10 07:36:15'),(14,234,NULL,'\"145, Xã Thanh Lương, Thị xã Nghĩa Lộ, Tỉnh Yên Bái\"','confirmed','cod','paid',1280000.00,NULL,'2025-12-10 08:06:51','2025-12-10 08:08:50'),(15,234,NULL,'\"145 Tổ 2, Xã Mường Tè, Huyện Mường Tè, Tỉnh Lai Châu\"','confirmed','cod','paid',9020000.00,'Giao nhanh','2025-12-10 08:11:23','2025-12-10 08:12:00');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_resets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Mã xác thực 6 chữ số',
  `expires_at` datetime NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `used_at` datetime DEFAULT NULL COMMENT 'Thời điểm token được sử dụng',
  PRIMARY KEY (`id`),
  KEY `idx_email` (`email`),
  KEY `idx_token` (`token`),
  KEY `idx_expires_at` (`expires_at`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `amount` decimal(12,2) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `gateway_name` varchar(100) DEFAULT NULL,
  `gateway_transaction_id` varchar(150) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (6,7,180080000.00,'pending','sepay',NULL,'2025-12-10 04:14:04'),(7,7,180080000.00,'pending','sepay',NULL,'2025-12-10 05:16:32'),(8,13,31000.00,'pending','sepay',NULL,'2025-12-10 05:44:42'),(9,13,31000.00,'pending','sepay',NULL,'2025-12-10 06:00:24'),(10,13,31000.00,'pending','sepay',NULL,'2025-12-10 06:13:08'),(11,13,31000.00,'pending','sepay',NULL,'2025-12-10 06:37:09'),(12,7,180080000.00,'pending','sepay',NULL,'2025-12-11 15:45:15');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `post_category_id` int NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `image` longtext,
  `content` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_post_slug` (`slug`),
  KEY `user_id` (`user_id`),
  KEY `post_category_id` (`post_category_id`),
  CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `posts_ibfk_2` FOREIGN KEY (`post_category_id`) REFERENCES `posts_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (13,232,2,'ấdfdsds',NULL,NULL,'<p>fsdfsdfsdfsdfsdfsdf</p>','2025-12-09 18:55:07',NULL),(16,232,5,'haloninini','ssssssssssssssssssss','https://storage.railway.app/organized-toybox-x74waqs9/posts/1765307768_d01aa175220de5f2.jpg?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tid_PbRilWQ_TNzNkfqCDhd_TEKPfLUYikeVQzWJMTcJmZQQpLblcn%2F20251209%2Fiad%2Fs3%2Faws4_request&X-Amz-Date=20251209T191609Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Signature=3d3f25bae298683f8c7d8136e1e3b4e924e568e3b0bf4a8af67a05c5b2890077','<p>aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</p>','2025-12-09 19:16:09','2025-12-10 04:30:46'),(17,232,4,'ddd333333','ddddddddd','https://storage.railway.app/organized-toybox-x74waqs9/posts/1765459184_25443af56aa2c00f.jpg?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tid_PbRilWQ_TNzNkfqCDhd_TEKPfLUYikeVQzWJMTcJmZQQpLblcn%2F20251211%2Fiad%2Fs3%2Faws4_request&X-Amz-Date=20251211T131945Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Signature=abf347707891913e3055afc9cca905c78b91e433f266eb6621c8e8454702d0fb','<p>dddddddddddddddddd</p>','2025-12-11 13:19:45','2025-12-11 13:27:02');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts_categories`
--

DROP TABLE IF EXISTS `posts_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts_categories`
--

LOCK TABLES `posts_categories` WRITE;
/*!40000 ALTER TABLE `posts_categories` DISABLE KEYS */;
INSERT INTO `posts_categories` VALUES (2,'Kiến thức đồng hồ new','kien-thuc-dong-ho-new','2025-11-24 08:03:29','2025-12-10 05:02:20'),(3,'Tin tức đồng hồ cập nhật','tin-tuc-dong-ho-cap-nhat','2025-11-24 08:03:29','2025-12-10 05:01:59'),(4,'Đánh giá sản phẩm','danh-gia','2025-11-24 08:03:29','2025-12-10 05:01:34'),(5,'Tin tức đồng hồ','tin-tuc-dong-ho','2025-12-09 17:56:48','2025-12-10 05:01:34');
/*!40000 ALTER TABLE `posts_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_variants`
--

DROP TABLE IF EXISTS `product_variants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_variants` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `price` decimal(12,2) NOT NULL,
  `size` varchar(50) DEFAULT NULL,
  `sku` varchar(100) DEFAULT NULL,
  `quantity` int DEFAULT '0',
  `image` varchar(255) DEFAULT NULL,
  `colors` json DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_variant_sku` (`sku`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_variants_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_variants`
--

LOCK TABLES `product_variants` WRITE;
/*!40000 ALTER TABLE `product_variants` DISABLE KEYS */;
INSERT INTO `product_variants` VALUES (24,29,41240000.00,'39 mm','TIS-001-39',10,'https://image.donghohaitrieu.com/wp-content/uploads/2024/05/83743-S-6823.jpg','[\"Bạc\", \"Vàng\"]','2025-12-05 03:35:26'),(25,30,109800000.00,'Size mặt: 41.5mm,  Độ dầy: 14.5mm','OME-001-41',98,NULL,'[\"bạc\", \"xanh navy\"]','2025-12-05 03:49:21'),(26,31,10000000.00,'40mm, 42mm, 44mm','CAR-RUDO-40',1,'ok','[\"gold\", \"xanh navy\"]','2025-12-05 07:19:54'),(27,32,12300000.00,'36mm','CAR-FAC000-36',36,'null','[\"trắng\"]','2025-12-05 08:23:37'),(28,33,120000.00,'41mm','APP-ASDASD-41',9,'helo','[\"đen\"]','2025-12-05 08:47:23'),(29,34,12000000.00,'45mm','BRE-S-45',12,'hallo','[\"vàng\"]','2025-12-05 08:55:25'),(30,35,8990000.00,'41mm','BRE-IW3282-41',17,'https://example.com/dong-ho-apple-series-9/aw-s9-41mm-midnight.jpg','[\"Midnight\"]','2025-12-09 12:16:07'),(31,35,9990000.00,'45mm','BRE-IW3282-45',12,'https://example.com/dong-ho-apple-series-9/aw-s9-45mm-starlight.jpg','[\"Starlight\"]','2025-12-09 12:16:09'),(32,36,1250000.00,'40mm','HUB-AAAAAA-40',14,'https://example.com/watch_silver_40mm.jpg','[\"Silver\"]','2025-12-09 17:33:23'),(33,37,1000.00,'40mm','CAR-IW3282-40',7,'https://example.com/citizen-bi5124-50l-black.jpg','[\"Black Dial\", \"Silver Band\"]','2025-12-09 19:14:57'),(35,39,10000000.00,'41mm, 42mm','OME-33-41',100,NULL,'[\"Xanh navy\", \"yellow\"]','2025-12-10 07:53:04'),(36,39,10000.00,'42mm, 43mm','OME-33-42',100,NULL,'[\"Bạc\"]','2025-12-10 07:54:12');
/*!40000 ALTER TABLE `product_variants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `model_code` varchar(255) NOT NULL,
  `category_id` int DEFAULT NULL,
  `brand_id` int DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `specifications` json NOT NULL,
  `thumbnail` json NOT NULL,
  `description` text,
  `image` longtext,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `category_id` (`category_id`),
  KEY `brand_id` (`brand_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `products_ibfk_2` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (10,'RD-W-010',1,6,'Rolex Submariner 126610LN','rolex-submariner-126610ln','[\"Kích thước: 41mm\", \"Chống nước: 300m\", \"Máy: Automatic\", \"Thương hiệu: Thụy Sĩ cao cấp\"]','[\"uploads/products/rolex-submariner-126610ln-1.png\", \"uploads/products/rolex-submariner-126610ln-2.png\"]','Rolex Submariner biểu tượng của đồng hồ cao cấp, chống nước 300m','uploads/products/rolex-submariner-126610ln.png','2025-11-24 08:03:24',1),(11,'RD-W-011',2,7,'Omega Seamaster 210.30.42.20.03.001','omega-seamaster-210-30-42-20-03-001','[\"Kích thước: 42mm\", \"Chống nước: 300m\", \"Máy: Automatic\", \"Thương hiệu: Thụy Sĩ\"]','[\"uploads/products/omega-seamaster-210-30-42-20-03-001-1.png\", \"uploads/products/omega-seamaster-210-30-42-20-03-001-2.png\"]','Omega Seamaster với máy Co-Axial, chống nước 300m','uploads/products/omega-seamaster-210-30-42-20-03-001.png','2025-11-24 08:03:24',1),(29,'TA-SUB-001',6,6,'Titoni Airmaster','titoni-airmaster','{\"size\": \"\", \"brand\": \"\", \"color\": \"\", \"model\": \"\", \"weight\": \"\", \"material\": \"\", \"warranty\": \"\"}','[\"uploads/products/thumb_1764905721_693252f9e2ca5.webp\"]','<h3><strong style=\"color: rgb(103, 103, 103);\">Titoni Airmaster 83743 S-682 là dòng đồng hồ cơ nam Thụy Sỹ sang trọng với bộ máy SW200-1 trữ cót 38 giờ siêu bền bỉ và chính xác. Di sản của thương hiệu hoạt động độc lập hơn 100 năm lịch sử.</strong></h3><p>----------------------------------------------------------------------------------------------------------------------------------------</p><p>Titoni Airmaster 83743 S-682 không đơn thuần là một cỗ máy đếm giờ, đó là hiện thân của di sản Thụy Sỹ thuần khiết. Đến từ Grenchen – cái nôi của ngành đồng hồ, Titoni tự hào là một trong số ít thương hiệu còn giữ vững vị thế độc lập và thuộc sở hữu gia đình qua hơn một thế kỷ.</p><p>Mẫu Airmaster này sở hữu \"trái tim\" là bộ máy cơ tự động <strong>SW200-1</strong> danh tiếng. Với khả năng trữ cót 38 giờ cùng độ chính xác ấn tượng, cỗ máy này đảm bảo sự vận hành bền bỉ qua năm tháng, đồng hành cùng quý ông trong mọi khoảnh khắc quan trọng. Thiết kế sang trọng, từng đường nét được hoàn thiện tỉ mỉ là minh chứng cho kỹ nghệ chế tác bậc thầy, biến Titoni Airmaster 83743 S-682 trở thành biểu tượng của sự thành đạt và gu thẩm mỹ tinh tế.</p><p><br></p>','uploads/products/product_1764905721_693252f9e2b42.jpg','2025-12-05 03:35:22',1),(30,'OMG-RD-001',6,7,'Đồng Hồ Omega','dong-ho-omega','[\"Kích thước: 41.5mm\", \"Chất liệu: Kính Sapphire, Dây Da\", \"Màu sắc: Bạc\", \"Bảo hành: 24 tháng\", \"Trọng lượng: 155g\", \"Thương hiệu: Omega\", \"Model: Omega Seamaster\"]','[\"uploads/products/thumb_1764906558_6932563e57298.webp\"]','<ol><li>Được đảm bảo chất lượng sản phẩm,&nbsp;cam kết 100% sản phẩm chính hãng</li><li>Được đổi trả sản phẩm trong trường hợp sản phẩm bị lỗi trong vòng 3 ngày theo điều kiện của&nbsp;RUDO </li><li>Miễn phí vận chuyển toàn quốc, đồng kiểm trực tiếp khi giao nhận.</li><li>Giao hàng hỏa tốc (áp dụng đối với hàng có sẵn tại cửa hàng gần nhất)</li><li>Được hưởng các ưu đãi, quà tặng, chương trình khách hàng thân thiết.</li></ol><p><br></p><p><span style=\"color: rgb(51, 51, 51);\">Sở thích của mỗi người khác nhau, có người tay nhỏ thích đeo đồng hồ size to, có người tay to lại thích size nhỏ. Để chọn đồng hồ thẩm mỹ nhất, bạn nên tham khảo cách chọn size dưới đây:</span></p><p><img src=\"https://www.watchstore.vn/wp-content/uploads/2025/10/huong-dan-do-size-co-tay-bang-thuoc-giay-watchstore.jpg\" alt=\"Chọn size mặt đồng hồ phù hợp nhất với tay - Ảnh 1\"></p>','uploads/products/product_1764906558_6932563e5721f.webp','2025-12-05 03:49:18',1),(31,'RLX-LGBT-RUDO',6,12,'Đồng Hồ Eo gi bi ti','dong-ho-eo-gi-bi-ti','[\"Kích thước: 42\", \"Chất liệu: kim cương\", \"Màu sắc: black\", \"Bảo hành: 24 tháng\", \"Trọng lượng: 155g\", \"Thương hiệu: ROLE\", \"Model: kkk\"]','[\"uploads/products/thumb_1764919190_6932879650cfb.webp\"]','<p>Đồng hồ else gi bi ti giá hạt giẻ</p>','uploads/products/product_1764919190_693287964fe58.jpg','2025-12-05 07:19:50',1),(32,'FAC00009N0',6,12,'Orient Bambino FAC00009N0','orient-bambino-fac00009n0','[\"Kích thước: 44mm\", \"Chất liệu: bạc\", \"Màu sắc: white\", \"Bảo hành: 12 tháng\", \"Trọng lượng: 155g\", \"Thương hiệu: Orient\", \"Model: Automatic\"]','[\"uploads/products/thumb_1764923014_69329686538a1.png\"]','<ul><li>Thiết kế cổ điển, lịch lãm — phong cách dress-watch, dễ phối đồ công sở hoặc đi tiệc. <a href=\"https://orient-watch.vn/product/dong-ho-nam-orient-classic-fac00009n0/?utm_source=chatgpt.com\" rel=\"noopener noreferrer\" target=\"_blank\">orient-watch.vn+1</a></li><li>Mặt số “champagne/ivory” + cọc số La Mã + kim xanh tạo điểm nhấn sang trọng, thanh thoát. <a href=\"https://orient-watch.vn/product/dong-ho-nam-orient-classic-fac00009n0/?utm_source=chatgpt.com\" rel=\"noopener noreferrer\" target=\"_blank\">orient-watch.vn+2PhongWatch+2</a></li><li>Máy automatic in-house của Orient (Cal. F6724), có thể tự lên cót + hỗ trợ lên cót tay + có hack dừng kim giây — tiện cho chỉnh thời gian chính xác. <a href=\"https://www.orientwatchusa.com/products/tac00009n0?utm_source=chatgpt.com\" rel=\"noopener noreferrer\" target=\"_blank\">orientwatchusa.com+1</a></li><li>Kích thước mặt 40.5 mm — phổ biến, phù hợp đa số cổ tay nam; dây da + vỏ thép không gỉ giúp đồng hồ vừa sang vừa thoải mái khi đeo.</li></ul><p><br></p>','uploads/products/product_1764923014_6932968652b21.png','2025-12-05 08:23:34',1),(33,'asdasda',4,14,'qwewdasd','qwewdasd','[\"size: 12mm\", \"material: silver\", \"color: white\", \"warranty: 12 tháng\", \"weight: 134g\", \"brand: Rolex\", \"model: Submarier\"]','[\"uploads/products/place-holder-1.png\", \"uploads/products/place-holder-2.png\"]','<p>dasd</p>',NULL,'2025-12-05 08:47:20',1),(34,'đâs',6,15,'ádasd','adasd','{\"size\": \"41mm\", \"brand\": \"rodo\", \"color\": \"White\", \"model\": \"Submariner\", \"weight\": \"10g\", \"material\": \"Oystersty\", \"warranty\": \"12 tháng\"}','[\"uploads/products/place-holder-1.png\", \"uploads/products/place-holder-2.png\"]','<p>đâsd</p>',NULL,'2025-12-05 08:55:22',1),(35,'IW328201  ',5,15,'Pilot’s Watch Mark XX  ','pilot-s-watch-mark-xx','{\"size\": \"40mm\", \"brand\": \"IWC\", \"color\": \"Black\", \"model\": \"Mark XX\", \"weight\": \"155g\", \"material\": \"Thép không gỉ\", \"warranty\": \"24 tháng\"}','[\"uploads/products/place-holder-1.png\", \"uploads/products/place-holder-2.png\"]','<p>Khám phá Pilot’s Watch Mark XX (mã IW328201), biểu tượng của sự chính xác và di sản hàng không lừng lẫy từ IWC. Đây không chỉ là một chiếc đồng hồ, mà là lời khẳng định về kỹ thuật chế tác vượt trội, kế thừa tinh hoa của dòng đồng hồ phi công huyền thoại. Với mặt số rõ ràng, dễ đọc trong mọi điều kiện ánh sáng, cùng bộ vỏ thép không gỉ mạnh mẽ, Mark XX được thiết kế để chịu đựng những thử thách khắc nghiệt nhất. Bộ máy tự động đáng tin cậy bên trong đảm bảo độ chính xác tuyệt đối, biến chiếc đồng hồ này thành người bạn đồng hành lý tưởng cho những ai yêu thích sự phiêu lưu và giá trị vượt thời gian. Sở hữu Mark XX là sở hữu một phần lịch sử hàng không trên cổ tay bạn.</p>',NULL,'2025-12-09 12:16:03',1),(36,'aaaaaaaaaaa',5,13,'aaaaaaaaaaa','aaaaaaaaaaa','{\"size\": \"41mm\", \"brand\": \"IWC\", \"color\": \"Black\", \"model\": \"Mark XX\", \"weight\": \"155g\", \"material\": \"Thép không gỉ\", \"warranty\": \"24 tháng\"}','[\"uploads/products/place-holder-1.png\", \"uploads/products/place-holder-2.png\"]','<p>sssssssssssssssssssssssssssss</p>','uploads/products/product_1765301599_69385d5f7b24b.png','2025-12-09 17:33:19',1),(37,'IW328201 ',11,11,'Đồng hồ Citizen 40 mm Nam BI5124-50L HELO','dong-ho-citizen-40-mm-nam-bi5124-50l-helo','{\"size\": \"40mm\", \"brand\": \"Citizen\", \"color\": \"Blue\", \"model\": \"BI5124-50L\", \"weight\": \"135g\", \"material\": \"Thép không gỉ\", \"warranty\": \"24 tháng\"}','[\"uploads/products/place-holder-1.png\", \"uploads/products/place-holder-2.png\"]','<p>Nâng tầm phong cách của quý ông hiện đại với Đồng hồ Citizen 40 mm Nam BI5124-50L, một biểu tượng của sự tinh tế và độ bền. Với mặt số màu xanh dương quyến rũ kết hợp vỏ và dây đeo thép không gỉ chắc chắn, chiếc đồng hồ này mang đến vẻ ngoài lịch lãm nhưng không kém phần năng động. Kích thước 40 mm lý tưởng ôm trọn cổ tay phái mạnh, tạo điểm nhấn hoàn hảo cho mọi trang phục, từ công sở đến dạo phố. Được trang bị bộ máy Quartz chính xác và khả năng chống nước ấn tượng, mẫu BI5124-50L (mã IW328201) không chỉ là phụ kiện thời trang mà còn là người bạn đồng hành đáng tin cậy. Citizen luôn khẳng định chất lượng vượt trội, và chiếc đồng hồ nam này là minh chứng hoàn hảo cho điều đó.</p>','https://storage.railway.app/organized-toybox-x74waqs9/products/1765307692_124fd4d74a2a83f2.png?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tid_PbRilWQ_TNzNkfqCDhd_TEKPfLUYikeVQzWJMTcJmZQQpLblcn%2F20251209%2Fiad%2Fs3%2Faws4_request&X-Amz-Date=20251209T191453Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Signature=b6f1015d4d0cb2ef297809faab27b817221b526685d78241b4e948c1459b96df','2025-12-09 19:14:53',1),(39,'RLX-33',5,19,'Đồng hồ eo gi bi ti','dong-ho-eo-gi-bi-ti-1','{\"size\": \"42mm\", \"brand\": \"Omega\", \"color\": \"Đen, Bạc\", \"model\": \"Subb\", \"weight\": \"155g\", \"material\": \"Oyyy\", \"warranty\": \"24 tháng\"}','[\"https://storage.railway.app/organized-toybox-x74waqs9/products/thumbnails/1765353179_a28dd0e1e8c239dd.webp?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tid_PbRilWQ_TNzNkfqCDhd_TEKPfLUYikeVQzWJMTcJmZQQpLblcn%2F20251210%2Fiad%2Fs3%2Faws4_request&X-Amz-Date=20251210T075259Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Signature=e25bddce76fce30553de4d44fd4b0c3e1f7ef250b3cacdb6fdff8fe9794437a4\"]','<p>Sản phẩm thật đep</p>','https://storage.railway.app/organized-toybox-x74waqs9/products/1765353178_a1c1c4eed318a35c.webp?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tid_PbRilWQ_TNzNkfqCDhd_TEKPfLUYikeVQzWJMTcJmZQQpLblcn%2F20251210%2Fiad%2Fs3%2Faws4_request&X-Amz-Date=20251210T075259Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Signature=e2c4796a167506539e95a471cb574749173971c25902a3fd9ae17555675b4ca8','2025-12-10 07:53:00',1);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `content` text,
  `reply` text,
  `rating` int DEFAULT '5',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `admin_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (12,11,30,'Ok nha','Cảm ơn bạn đã đánh giá!',5,1,'2025-12-10 04:06:15',NULL,7),(16,11,36,'OK','Shop ghi nhận góp ý của bạn!',5,1,'2025-12-10 05:50:27',NULL,8),(17,11,35,'OK','Rất vui vì bạn hài lòng!',5,1,'2025-12-10 05:53:38',NULL,232),(18,11,32,'OKe nha',NULL,5,1,'2025-12-10 06:07:42',NULL,NULL),(19,11,29,'Oke nha bro',NULL,5,1,'2025-12-10 06:11:06',NULL,NULL),(20,11,37,'OKE nha','Cảm ơn bạn nha!',5,1,'2025-12-10 07:28:43',NULL,232),(21,234,36,'OKe',NULL,5,1,'2025-12-10 08:09:33',NULL,NULL),(22,234,35,'Oke nha','Shop xin lỗi nếu có thiếu sót!',4,1,'2025-12-10 08:12:34',NULL,8);
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipping_method`
--

DROP TABLE IF EXISTS `shipping_method`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipping_method` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `cost` decimal(10,0) NOT NULL,
  `status` enum('0','1') NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipping_method`
--

LOCK TABLES `shipping_method` WRITE;
/*!40000 ALTER TABLE `shipping_method` DISABLE KEYS */;
INSERT INTO `shipping_method` VALUES (1,'Giao hàng tiêu chuẩn',30000,'1','2025-11-24 08:03:26',NULL),(2,'Giao hàng nhanh',50000,'1','2025-11-24 08:03:26',NULL),(3,'Giao hàng siêu tốc',80000,'1','2025-11-24 08:03:26',NULL);
/*!40000 ALTER TABLE `shipping_method` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_transactions`
--

DROP TABLE IF EXISTS `tb_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_transactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `gateway` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transaction_date` datetime DEFAULT NULL,
  `account_number` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_account` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount_in` decimal(12,2) DEFAULT '0.00',
  `amount_out` decimal(12,2) DEFAULT '0.00',
  `accumulated` decimal(12,2) DEFAULT NULL,
  `code` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transaction_content` text COLLATE utf8mb4_unicode_ci,
  `reference_number` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_transaction_date` (`transaction_date`),
  KEY `idx_account_number` (`account_number`),
  KEY `idx_reference_number` (`reference_number`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_transactions`
--

LOCK TABLES `tb_transactions` WRITE;
/*!40000 ALTER TABLE `tb_transactions` DISABLE KEYS */;
INSERT INTO `tb_transactions` VALUES (9,'BIDV','2025-12-10 06:31:24','8836563558',NULL,31000.00,0.00,10000000.00,'TEST1765348284','DH13','REF1765348284','Thanh toan don hang','2025-12-10 06:31:34'),(10,NULL,NULL,NULL,NULL,0.00,0.00,NULL,NULL,NULL,NULL,NULL,'2025-12-10 07:23:10'),(11,NULL,NULL,NULL,NULL,0.00,0.00,NULL,NULL,NULL,NULL,NULL,'2025-12-10 07:27:36'),(12,NULL,NULL,NULL,NULL,0.00,0.00,NULL,NULL,NULL,NULL,NULL,'2025-12-10 07:27:40'),(13,NULL,NULL,NULL,NULL,0.00,0.00,NULL,NULL,NULL,NULL,NULL,'2025-12-10 07:27:45'),(14,'BIDV','2025-12-10 07:28:59','8836563558',NULL,31000.00,0.00,10000000.00,'TEST1765351739','DH13','REF1765351739','Thanh toan don hang','2025-12-10 07:29:03');
/*!40000 ALTER TABLE `tb_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fullname` varchar(150) DEFAULT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `role` tinyint DEFAULT '0',
  `status` tinyint DEFAULT '1',
  `api_token` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_email` (`email`),
  KEY `idx_email_status` (`email`,`status`),
  KEY `idx_api_token_status` (`api_token`,`status`),
  KEY `idx_role_status_created` (`role`,`status`,`created_at` DESC),
  KEY `idx_users_role` (`role`)
) ENGINE=InnoDB AUTO_INCREMENT=235 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (7,'Phan Bình','phanbinhfedev150504@gmail.com','$2y$10$5UkQSUz1xiSqnNVqaoWP5ekCGGVaqS8hQcSP6IFMRLccJZeIt5EeW','0393159478',1,1,'1b7bdc70aeec5420ba452fe88c8dac6933f434e2a7bdf73af9e2cb100c12a050','2025-11-24 00:00:00','2025-12-03 00:11:09'),(8,'Toàn đẹp trai','pductoandev@gmail.com','y0/hc/p7EgiDbp3tZVx6uxVznox5mB/y5q3ee8NAJ4CyHDT6Rmku','0916110241',1,1,'36c25ee1542a1582a3cb728ea0e50eb93a84987244ac63b915db58dc9ee1d1e8','2025-11-24 00:00:00','2025-11-28 00:00:00'),(9,'Nguyen Anh Khoi','tuyetnhng010193@gmail.com','$2y$10$YjMK6K2PSn1E6.2WMFEHV.2L/ICaNAGHnYZZxoWVkBzbC0HSfiVQO','0393159438',0,1,'b26c61b626a82dec5d97f9cf24269920229bd774d9bfd5236f8e6d6c87271999','2025-11-24 00:00:00',NULL),(11,'Bình Phan Đức','phanbinh150504@gmail.com','$2y$10$MYUVcgDyXPbNUHtLjUjpTOa8cHmUxfCppui/lCads0OgvVWhE0y2C','0382832609',1,1,'56d83e61b177f0e0c547e2bfeb7b792d79b650f980f58769de31d8a28b6b85af','2025-11-26 00:00:00','2025-12-05 07:45:47'),(18,'Phan Đức Toàn admin','pductoandevvvv@gmail.com','y0','0916110241',1,1,'37852d5257098a5e8a6e688bd39c3296f0707ae5da8f1d217ffbb5b6409d095b','2025-11-29 00:00:00','2025-11-30 14:03:34'),(19,'nguey anh khoi','pductoandettt@gmail.com','$2y$10$4neyO9PY51eo5hrNbTrj4.YiWM6N89P0Qs1fTb18dxBvKKyAmxceC','0961011024',1,1,'ebe436426eaa2e479c45098f440d33397c2c195c6d57b406bf9ad9ad8a6cff82','2025-11-29 18:26:02',NULL),(21,'Phan Đức Toàn','toanphan01vip@gmail.com','$2y$10$8IcAI2YnRmNSQutB4RM.FuuID9fwFT5WX2mOk5U9cohE9eteiAQ1S',NULL,0,1,'f304fd6fd889cd88e3d87056f4181e44acbcdfb2c68154f5a39b0dd6bc8009f8','2025-11-30 06:49:14',NULL),(22,'Ma Gaming','magaming0101@gmail.com','$2y$10$Qejsv7qQAelw4h.oKnVBKu9V0hYrxLkQWXll0PALmpZWhCccbKZJS',NULL,0,1,'b335c44eace86b5b56af4ce1e441aab5fc9602e56562325100f64a5fa960cc5e','2025-11-30 08:01:53',NULL),(23,'Zu Côn','zucon441@gmail.com','$2y$10$Br8/pmJxmhrWUyM51Ium4.03dAMQdjy9M6xavUul4OF/9T9UIzV3q',NULL,1,1,'38f6dff32430c150f0f7d237ea1defca22fa82974de42fd0965583a050dd5529','2025-11-30 08:17:29',NULL),(24,'Nguyễn Anh Khôi','anhkhoi@gmail.com','123456',NULL,1,1,NULL,'2025-12-02 05:38:28',NULL),(26,'Phan toàn','pductoanhehe@gmail.com','$2y$10$lYYlvrAMfyJ/iedlPx8Elu6V8JNFow5M9VfDlAqhuQ3XaL.yGIrRW','0916110241',0,1,'0d4b317ec26f641c4b10a07721b59363113c5720cd6537c5ec2028125eace643','2025-12-02 06:22:03','2025-12-03 07:15:35'),(27,'Nguyễn anh Khôi khôi khôi','khoilord@gmail.com','$2y$10$0yX28.SBGFC5NYipICitRevgOh94pPjMcH8D/rxB.nBUDDrsKbRP.','0393159434',0,1,'627bff396080fb3bcab60ae781e1a9e88799f3cb0e70f34b3e1701126ed6f6ca','2025-12-02 08:30:04','2025-12-05 07:49:51'),(28,'B P','masterphp2025@gmail.com','$2y$10$ViaW7Bs3wDHKZQGZ3PJAe.a.uq8XZadviMSbkAdtdbkR857I.anxi',NULL,0,1,'cbcf4a9c7a47966919832b32b29c00a15b77e499a529a742d373d7027e6f883d','2025-12-03 00:08:18','2025-12-03 00:08:50'),(29,'Nguyen Van A','test@example.com','$2y$10$tqcedtKrYo8W2z0wi3uWpuUoghd4GML8.A5RVXYIfEuVBXXJ/Hr9O','0912345678',0,0,'bee1afcbf8b8a95eeab0543d5c2740cb882ca2bdcf6cf18896785984bfb2b636','2025-12-03 08:09:12','2025-12-04 07:46:05'),(30,'Phan Đức Toàn','pductoandec@gmail.com','$2y$10$SDXgbxhhz9XmjsAEitnCEeZVyV..rJbx2KsJAhLKAwIn76VgXa7Gm','0916110241',1,1,'9ddad539c6ebebacb290b7a269f0201c5b2cbec627a1bdd31db98d550c24b73b','2025-12-04 04:02:39',NULL),(31,'Lê Thị Tuấn','user1_637@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0913493075',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(32,'Lê Ngọc Tuấn','user2_654@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0911760596',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(33,'Hoàng Minh Trang','user3_698@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0986309508',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(34,'Trần Đức Sơn','user4_788@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0946678699',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(35,'Trần Minh Dũng','user5_810@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0923409799',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(36,'Nguyễn Ngọc Sơn','user6_409@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0949830551',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(37,'Hoàng Văn Hùng','user7_804@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0988951798',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(38,'Trần Thị Cường','user8_535@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0941655683',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(39,'Huỳnh Văn Hạnh','user9_604@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0961121216',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(40,'Phạm Văn Tuấn','user10_74@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0928259141',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(41,'Lê Đức Nam','user11_736@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0945162024',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(42,'Hoàng Ngọc Dũng','user12_30@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0947308701',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(43,'Huỳnh Đức Nam','user13_607@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0987917137',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(44,'Vũ Văn Sơn','user14_875@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0984126193',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(45,'Vũ Đức Linh','user15_90@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0963248519',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(46,'Huỳnh Thị Linh','user16_368@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0927125914',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(47,'Huỳnh Minh Nam','user17_730@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0932898447',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(48,'Huỳnh Hữu Dũng','user18_732@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0988770819',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(49,'Lê Minh Hạnh','user19_214@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0976667187',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(50,'Nguyễn Thị Sơn','user20_434@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0976057359',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(51,'Huỳnh Văn Cường','user21_22@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0979638647',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(52,'Huỳnh Văn Tuấn','user22_58@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0931056131',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(53,'Lê Đức Sơn','user23_460@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0965652929',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(54,'Huỳnh Đức Nam','user24_790@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0963586269',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(55,'Trần Đức Hùng','user25_312@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0967497935',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(56,'Lê Văn Linh','user26_981@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0927522587',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(57,'Hoàng Minh Dũng','user27_757@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0982363268',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(58,'Lê Đức Dũng','user28_678@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0953353318',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(59,'Phạm Văn Nam','user29_810@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0977350658',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(60,'Lê Ngọc Hạnh','user30_843@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0982727035',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(61,'Trần Văn Hạnh','user31_389@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0957154291',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(62,'Huỳnh Văn Cường','user32_816@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0983138616',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(63,'Huỳnh Thị Nam','user33_664@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0922200534',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(64,'Nguyễn Văn Hạnh','user34_665@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0986556669',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(65,'Huỳnh Hữu Hạnh','user35_143@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0934450408',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(66,'Phan Đức Hùng','user36_585@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0992496603',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(67,'Phạm Đức Hạnh','user37_250@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0989112432',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(68,'Hoàng Hữu Tuấn','user38_457@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0917489264',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(69,'Vũ Minh Nam','user39_495@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0933922660',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(70,'Phạm Ngọc Hùng','user40_245@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0923544078',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(71,'Huỳnh Văn Trang','user41_590@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0931121309',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(72,'Lê Thị Yến','user42_304@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0962210774',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(73,'Trần Văn Cường','user43_126@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0942153302',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(74,'Vũ Ngọc Dũng','user44_247@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0933221314',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(75,'Vũ Văn Sơn','user45_906@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0992719588',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(76,'Huỳnh Ngọc Yến','user46_929@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0960187158',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(77,'Lê Ngọc Linh','user47_292@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0975140085',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(78,'Hoàng Đức Trang','user48_443@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0962559071',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(79,'Trần Thị Cường','user49_528@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0942763065',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(80,'Nguyễn Minh Hạnh','user50_784@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0948867217',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(81,'Huỳnh Thị Dũng','user51_230@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0927105343',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(82,'Huỳnh Hữu Tuấn','user52_683@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0936324178',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(83,'Trần Ngọc Yến','user53_534@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0963457687',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(84,'Nguyễn Văn Trang','user54_360@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0922177020',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(85,'Hoàng Văn Trang','user55_660@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0964735652',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(86,'Phạm Thị Yến','user56_551@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0985418072',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(87,'Trần Thị Trang','user57_235@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0950809911',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(88,'Phạm Ngọc Linh','user58_678@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0969941238',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(89,'Phạm Đức Dũng','user59_367@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0996688298',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(90,'Huỳnh Thị Linh','user60_321@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0996793923',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(91,'Phạm Đức Sơn','user61_67@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0978482201',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(92,'Huỳnh Minh Sơn','user62_857@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0975295458',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(93,'Nguyễn Đức Cường','user63_131@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0941471598',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(94,'Huỳnh Ngọc Trang','user64_178@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0928391315',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(95,'Phan Ngọc Yến','user65_359@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0988505414',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(96,'Phan Văn Hạnh','user66_622@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0958110230',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(97,'Phạm Minh Linh','user67_15@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0947090942',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(98,'Phan Văn Hạnh','user68_193@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0966780614',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(99,'Vũ Thị Dũng','user69_215@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0930496273',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(100,'Phan Đức Yến','user70_277@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0936299122',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(101,'Lê Đức Hùng','user71_484@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0942461637',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(102,'Huỳnh Thị Cường','user72_457@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0989504210',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(103,'Hoàng Minh Nam','user73_874@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0999199361',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(104,'Huỳnh Đức Hạnh','user74_399@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0960597308',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(105,'Phạm Văn Hạnh','user75_512@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0924198299',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(106,'Phan Văn Cường','user76_723@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0936989175',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(107,'Huỳnh Minh Trang','user77_314@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0912759644',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(108,'Vũ Văn Dũng','user78_150@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0997610245',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(109,'Trần Ngọc Linh','user79_805@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0922853621',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(110,'Nguyễn Đức Dũng','user80_513@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0971230322',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(111,'Lê Minh Tuấn','user81_884@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0937350689',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(112,'Phạm Đức Linh','user82_649@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0960585278',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(113,'Huỳnh Ngọc Sơn','user83_559@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0935543281',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(114,'Phan Văn Yến','user84_48@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0941010900',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(115,'Phan Ngọc Hạnh','user85_250@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0974137049',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(116,'Vũ Văn Tuấn','user86_651@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0926787950',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(117,'Lê Minh Yến','user87_31@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0930437982',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(118,'Hoàng Ngọc Dũng','user88_188@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0921036396',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(119,'Phan Thị Trang','user89_828@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0967698070',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(120,'Huỳnh Thị Hạnh','user90_857@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0996435080',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(121,'Lê Ngọc Trang','user91_562@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0935145050',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(122,'Huỳnh Đức Sơn','user92_88@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0989330863',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(123,'Nguyễn Hữu Hùng','user93_16@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0912931184',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(124,'Phạm Văn Nam','user94_442@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0919114115',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(125,'Hoàng Đức Hùng','user95_609@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0991356097',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(126,'Huỳnh Ngọc Dũng','user96_684@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0971619138',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(127,'Phan Hữu Dũng','user97_138@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0986471011',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(128,'Hoàng Ngọc Tuấn','user98_403@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0994702157',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(129,'Huỳnh Minh Tuấn','user99_835@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0912537559',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(130,'Nguyễn Ngọc Linh','user100_943@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0985497127',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(131,'Lê Đức Hạnh','user101_446@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0984903151',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(132,'Hoàng Ngọc Linh','user102_338@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0998006153',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(133,'Phạm Ngọc Hùng','user103_378@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0972667117',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(134,'Huỳnh Văn Sơn','user104_900@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0989057355',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(135,'Phan Hữu Trang','user105_683@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0983663258',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(136,'Phan Ngọc Dũng','user106_694@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0974244012',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(137,'Lê Hữu Dũng','user107_810@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0932006204',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(138,'Trần Minh Tuấn','user108_870@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0937501720',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(139,'Huỳnh Ngọc Sơn','user109_487@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0993411194',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(140,'Nguyễn Hữu Linh','user110_469@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0968698601',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(141,'Lê Hữu Tuấn','user111_56@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0934581726',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(142,'Trần Thị Yến','user112_553@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0984371620',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(143,'Vũ Hữu Hạnh','user113_102@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0992243725',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(144,'Hoàng Văn Trang','user114_445@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0971784320',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(145,'Phạm Minh Yến','user115_72@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0937637852',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(146,'Huỳnh Đức Sơn','user116_946@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0939055373',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(147,'Vũ Thị Hạnh','user117_264@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0987418976',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(148,'Vũ Thị Hùng','user118_902@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0959471694',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(149,'Hoàng Ngọc Trang','user119_763@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0928957883',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(150,'Trần Ngọc Trang','user120_940@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0911877619',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(151,'Lê Hữu Cường','user121_418@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0985094496',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(152,'Nguyễn Ngọc Tuấn','user122_173@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0980905594',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(153,'Huỳnh Đức Yến','user123_280@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0943028551',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(154,'Phan Đức Hạnh','user124_814@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0959025816',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(155,'Phan Hữu Trang','user125_20@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0940036039',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(156,'Nguyễn Đức Yến','user126_366@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0978904283',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(157,'Lê Ngọc Yến','user127_634@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0930325004',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(158,'Phạm Ngọc Trang','user128_153@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0911268439',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(159,'Nguyễn Thị Hạnh','user129_821@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0982604308',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(160,'Phạm Đức Nam','user130_466@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0922265651',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(161,'Vũ Văn Yến','user131_955@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0979297247',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(162,'Hoàng Văn Trang','user132_500@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0988688367',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(163,'Huỳnh Văn Dũng','user133_808@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0918701332',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(164,'Vũ Minh Hạnh','user134_101@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0924849526',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(165,'Nguyễn Văn Yến','user135_312@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0961841313',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(166,'Vũ Văn Cường','user136_871@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0919688798',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(167,'Lê Minh Yến','user137_26@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0932810562',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(168,'Trần Thị Tuấn','user138_431@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0992710426',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(169,'Huỳnh Minh Sơn','user139_982@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0931479654',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(170,'Hoàng Minh Cường','user140_9@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0964002475',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(171,'Nguyễn Đức Nam','user141_610@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0981055495',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(172,'Trần Minh Sơn','user142_282@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0980384540',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(173,'Vũ Ngọc Linh','user143_426@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0940856171',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(174,'Trần Đức Trang','user144_660@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0962948014',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(175,'Nguyễn Thị Cường','user145_377@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0953965676',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(176,'Nguyễn Ngọc Hùng','user146_27@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0927099078',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(177,'Phan Thị Sơn','user147_630@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0959789484',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(178,'Huỳnh Hữu Yến','user148_209@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0928855241',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(179,'Phạm Văn Dũng','user149_390@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0928842838',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(180,'Huỳnh Văn Linh','user150_157@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0991199022',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(181,'Phạm Thị Tuấn','user151_165@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0982585238',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(182,'Lê Minh Nam','user152_503@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0941853689',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(183,'Trần Đức Hạnh','user153_719@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0918893084',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(184,'Phạm Hữu Hùng','user154_13@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0914188330',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(185,'Phan Ngọc Hạnh','user155_142@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0936104482',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(186,'Lê Thị Hạnh','user156_240@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0975767259',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(187,'Phạm Ngọc Hùng','user157_967@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0988874103',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(188,'Phan Đức Yến','user158_157@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0980743642',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(189,'Vũ Thị Trang','user159_4@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0939951293',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(190,'Lê Đức Dũng','user160_750@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0988805930',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(191,'Nguyễn Ngọc Linh','user161_148@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0917955170',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(192,'Huỳnh Ngọc Sơn','user162_659@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0964005649',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(193,'Lê Đức Cường','user163_775@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0960548919',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(194,'Huỳnh Thị Nam','user164_216@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0983337029',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(195,'Huỳnh Văn Yến','user165_697@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0966642427',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(196,'Phạm Minh Yến','user166_968@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0990167679',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(197,'Nguyễn Minh Hùng','user167_588@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0991780673',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(198,'Trần Đức Sơn','user168_939@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0917929867',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(199,'Phan Đức Linh','user169_80@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0974844230',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(200,'Huỳnh Văn Sơn','user170_701@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0910630442',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(201,'Huỳnh Đức Sơn','user171_375@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0929361020',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(202,'Nguyễn Ngọc Sơn','user172_314@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0915456397',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(203,'Hoàng Văn Linh','user173_124@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0992128937',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(204,'Trần Đức Nam','user174_425@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0982541591',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(205,'Lê Ngọc Cường','user175_830@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0976960730',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(206,'Vũ Hữu Trang','user176_95@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0989989602',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(207,'Trần Văn Cường','user177_604@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0979662217',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(208,'Vũ Ngọc Hạnh','user178_124@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0914028017',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(209,'Nguyễn Văn Dũng','user179_515@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0978055514',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(210,'Vũ Minh Hùng','user180_435@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0913886934',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(211,'Phạm Đức Trang','user181_698@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0984032316',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(212,'Hoàng Văn Linh','user182_285@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0965523029',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(213,'Lê Minh Sơn','user183_967@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0939598828',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(214,'Huỳnh Đức Sơn','user184_962@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0937895907',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(215,'Phạm Hữu Trang','user185_749@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0929897847',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(216,'Hoàng Ngọc Nam','user186_42@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0915638071',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(217,'Huỳnh Văn Trang','user187_424@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0943688172',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(218,'Phan Ngọc Tuấn','user188_792@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0975002945',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(219,'Nguyễn Thị Yến','user189_77@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0960028076',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(220,'Nguyễn Minh Hạnh','user190_915@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0911039994',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(221,'Hoàng Minh Sơn','user191_352@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0919354327',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(222,'Vũ Ngọc Tuấn','user192_468@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0924420103',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(223,'Phạm Thị Dũng','user193_984@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0910690560',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(224,'Phạm Minh Cường','user194_277@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0990059000',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(225,'Phạm Thị Sơn','user195_602@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0951013102',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(226,'Vũ Ngọc Sơn','user196_365@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0946152392',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(227,'Lê Văn Hạnh','user197_687@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0994546897',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(228,'Lê Hữu Hùng','user198_917@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0969534441',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(229,'Phan Thị Tuấn','user199_437@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0910891908',0,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(230,'Huỳnh Văn Hùng','user200_771@example.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','0969459726',1,1,NULL,'2025-12-04 08:04:17','2025-12-04 08:04:17'),(231,'Vuong Quoc','vuong.nguyenquoc.sistrain@gmail.com','$2y$10$6dsTtpdejUmoIKhd.0noX.jeCkkwm.zG9LBGBq03qZ9vZAhXI3AvG',NULL,0,0,'a3a13cc23b1a23d4dfa681972051998aeecdee0f01e7ea648c431a7ac8adab0e','2025-12-08 01:58:27','2025-12-10 08:08:55'),(232,'Nguyễn anh Khôi','nguyenanhkhoi@gmail.com','$2y$10$JdzF3X0ziwY0y0Yq5veDvOUMqRzAObYQbPGfAsSwdSAGIvno2/5xW','0974010123',1,1,'4abb35b24b08af3e36dfc8797c55f8213c48175f52db1001b86384b42385e4a2','2025-12-08 08:09:45',NULL),(233,'Poly Coder','coderpoly.fpthcm@gmail.com','$2y$10$XzHE8l.vTCeYMlTDuI5iMuT7/f1TioQXkJyILCK/7p/WSPzZpLK.K',NULL,1,1,'7d76147dce1cb84fe5b0789e180852705fb08ff0996ebe5dbe76c186b2e04022','2025-12-10 06:15:08',NULL),(234,'Phan Duc Binh','22142083@student.hcmute.edu.vn','$2y$10$IUgaIMdoFjz7dF/nM8uY0uZ4qIxXb.MU04EpoIVLPey5irR9agPt.',NULL,0,1,'20092949c3127c778a6dce7d793092aaa24d6d2db49352ff411b0a9cd2535091','2025-12-10 08:05:36',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vouchers`
--

DROP TABLE IF EXISTS `vouchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vouchers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `discount` int DEFAULT NULL,
  `amount` decimal(12,2) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `start_at` datetime DEFAULT NULL,
  `expired_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `api_token` varchar(255) DEFAULT NULL,
  `usage_limit` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vouchers`
--

LOCK TABLES `vouchers` WRITE;
/*!40000 ALTER TABLE `vouchers` DISABLE KEYS */;
INSERT INTO `vouchers` VALUES (10,'SIEUSALE','percent',10,NULL,'2025-12-05 08:20:29','2025-12-28 15:20:00','2025-12-08 08:18:46',NULL,1000),(11,'GIANGSINH','percent',20,NULL,'2025-12-10 06:30:52','2026-05-13 13:30:00',NULL,NULL,100),(12,'OKOKEKEOOKE','percent',10,NULL,'2025-12-10 08:03:55','2025-12-18 18:06:00',NULL,NULL,100);
/*!40000 ALTER TABLE `vouchers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-12  0:05:11
