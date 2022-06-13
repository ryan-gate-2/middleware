-- MySQL dump 10.13  Distrib 8.0.28, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: slotlayerdb
-- ------------------------------------------------------
-- Server version	8.0.28-0ubuntu0.20.04.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `access_profiles`
--

DROP TABLE IF EXISTS `access_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_profiles` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `profile_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `api_dk` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `api_evo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `max_entries_sessions` tinyint NOT NULL DEFAULT '2',
  `branded` tinyint NOT NULL DEFAULT '1',
  `active` int NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_unique` (`profile_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_profiles`
--

LOCK TABLES `access_profiles` WRITE;
/*!40000 ALTER TABLE `access_profiles` DISABLE KEYS */;
INSERT INTO `access_profiles` VALUES ('1','base_profile',NULL,'0',2,1,1,'2022-04-12 23:12:38','2022-04-12 23:12:38',NULL),('2','grey_only',NULL,'0',2,1,1,'2022-04-12 23:12:38','2022-04-12 23:12:38',NULL);
/*!40000 ALTER TABLE `access_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `access_providers`
--

DROP TABLE IF EXISTS `access_providers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_providers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `provider` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `access_profile` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `access_providers_access_profile_foreign` (`access_profile`),
  CONSTRAINT `access_providers_access_profile_foreign` FOREIGN KEY (`access_profile`) REFERENCES `access_profiles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_providers`
--

LOCK TABLES `access_providers` WRITE;
/*!40000 ALTER TABLE `access_providers` DISABLE KEYS */;
INSERT INTO `access_providers` VALUES (2,'pragmatic','20.2','1',NULL,NULL),(3,'netent','2','1',NULL,NULL);
/*!40000 ALTER TABLE `access_providers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `currencyprices`
--

DROP TABLE IF EXISTS `currencyprices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `currencyprices` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `currency` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `currency` (`currency`),
  UNIQUE KEY `currency_2` (`currency`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currencyprices`
--

LOCK TABLES `currencyprices` WRITE;
/*!40000 ALTER TABLE `currencyprices` DISABLE KEYS */;
INSERT INTO `currencyprices` VALUES (1,'EUR','0.92272','2022-04-13 01:44:22','2022-04-13 01:44:22'),(2,'GBP','0.768495','2022-04-13 01:44:22','2022-04-13 01:44:22'),(3,'TRY','14.588104','2022-04-13 01:44:22','2022-04-13 01:44:22'),(4,'CAD','1.261705','2022-04-13 01:44:22','2022-04-13 01:44:22'),(5,'PLN','4.279503','2022-04-13 01:44:22','2022-04-13 01:44:22'),(6,'TND','2.998499','2022-04-13 01:44:22','2022-04-13 01:44:22'),(7,'BRL','4.674796','2022-04-13 01:44:22','2022-04-13 01:44:22'),(8,'AUD','1.339863','2022-04-13 01:44:22','2022-04-13 01:44:22'),(9,'CHF','0.93223','2022-04-13 01:44:22','2022-04-13 01:44:22'),(10,'KRW','1225.470246','2022-04-13 01:44:22','2022-04-13 01:44:22'),(11,'INR','76.124498','2022-04-13 01:44:22','2022-04-13 01:44:22');
/*!40000 ALTER TABLE `currencyprices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `demo_sessions`
--

DROP TABLE IF EXISTS `demo_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `demo_sessions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `casino_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `session_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `player_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `player_meta` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `player_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `game` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `request_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `visited` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `active` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `currency` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `demo_sessions`
--

LOCK TABLES `demo_sessions` WRITE;
/*!40000 ALTER TABLE `demo_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `demo_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gameoptions`
--

DROP TABLE IF EXISTS `gameoptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gameoptions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `apikey` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ownedBy` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `operatorurl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `operator_secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `real_sessions_stat` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `poker_prefix` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `slots_prefix` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `callbackurl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `native_currency` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `allowed_ips` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `extendedApi` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `poker_enabled` int NOT NULL DEFAULT '0',
  `active` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gameoptions`
--

LOCK TABLES `gameoptions` WRITE;
/*!40000 ALTER TABLE `gameoptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `gameoptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gametransactions`
--

DROP TABLE IF EXISTS `gametransactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gametransactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `casinoid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ownedBy` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `player` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bet` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `win` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `usd_exchange` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '1',
  `gameid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `txid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `roundid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `final` int NOT NULL DEFAULT '0',
  `callback_state` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '1',
  `rawdata` json NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gametransactions`
--

LOCK TABLES `gametransactions` WRITE;
/*!40000 ALTER TABLE `gametransactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `gametransactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'2018_04_30_000000_create_roles_table',1),(2,'2018_04_30_000010_create_users_table',1),(3,'2018_04_30_000011_create_password_resets_table',1),(4,'2018_04_30_000020_create_user_roles_table',1),(5,'2019_08_19_000000_create_failed_jobs_table',1),(6,'2018_04_30_000010_create_providers_table',2),(7,'2018_04_30_000022_create_providers_table',3),(8,'2018_04_30_000023_create_providers_table',4),(9,'2018_04_30_000023_create_currency_table',5);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `providers`
--

DROP TABLE IF EXISTS `providers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `providers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `provider_id` char(255) COLLATE utf8_unicode_ci NOT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ggr_cost` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `index_rating` varchar(255) COLLATE utf8_unicode_ci DEFAULT '60',
  `softswiss_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `providers`
--

LOCK TABLES `providers` WRITE;
/*!40000 ALTER TABLE `providers` DISABLE KEYS */;
INSERT INTO `providers` VALUES (1,'netent','slots','11','60',NULL),(2,'pragmatic','slots','10','60',NULL);
/*!40000 ALTER TABLE `providers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regular_sessions`
--

DROP TABLE IF EXISTS `regular_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regular_sessions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `casino_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `session_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `player_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `player_meta` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `player_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `game` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `request_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `visited` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `active` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `currency` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `extra_currency` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `updated_at` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regular_sessions`
--

LOCK TABLES `regular_sessions` WRITE;
/*!40000 ALTER TABLE `regular_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `regular_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `roles_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES ('1805ec99-74cc-4a41-b078-7b65e98ed2ed','regular','Regular Users','2022-04-12 23:12:38','2022-04-12 23:12:38',NULL),('3a58f5fc-6b05-4630-93a2-8143dfcb77f3','cumque','Non provident id praesentium beatae sequi nihil.','2022-04-12 23:12:38','2022-04-12 23:12:38',NULL),('6787f393-4e8c-467e-bb86-4fc1b1df530d','admin','Administrator Users','2022-04-12 23:12:38','2022-04-12 23:12:38',NULL),('696c8d61-8d0c-4188-8db3-0c825719a8ce','delectus','Dicta quisquam fugit labore vel mollitia neque.','2022-04-12 23:12:39','2022-04-12 23:12:39',NULL),('6ad0308b-47ba-427b-8ebf-de8e33622ac8','a','Exercitationem et explicabo et sed.','2022-04-12 23:12:38','2022-04-12 23:12:38',NULL),('7fe8cff3-307b-4046-9735-8c4836d45c5b','voluptatibus','Dolor dolores adipisci officiis in dolor cumque quidem.','2022-04-12 23:12:38','2022-04-12 23:12:38',NULL),('86334dd3-e5e0-47b6-a1a7-4328596f27fe','voluptas','Sint sequi mollitia qui non quia aut.','2022-04-12 23:12:38','2022-04-12 23:12:38',NULL),('8fdcb2af-a714-4dd5-a9d2-d408455a9a54','sapiente','Mollitia tempore cum iure quia reiciendis odit.','2022-04-12 23:12:38','2022-04-12 23:12:38',NULL),('9c14008a-5329-406a-99d3-077305ac2a59','mollitia','Eligendi consequuntur nisi perspiciatis animi voluptatem.','2022-04-12 23:12:38','2022-04-12 23:12:38',NULL),('a967bd26-9b7a-4796-9962-bc30a9f3bc7c','recusandae','Sapiente odio beatae autem qui.','2022-04-12 23:12:39','2022-04-12 23:12:39',NULL),('c91efe1e-2fef-4558-b0ba-b06b31252112','at','Et sit adipisci ut et iure voluptatem.','2022-04-12 23:12:38','2022-04-12 23:12:38',NULL),('f9e470d7-4949-4a8b-a5d2-052f84421c35','qui','Recusandae ut rem repudiandae.','2022-04-12 23:12:38','2022-04-12 23:12:38',NULL);
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `user_roles_role_id_foreign` (`role_id`),
  CONSTRAINT `user_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE,
  CONSTRAINT `user_roles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES ('508c6e46-85da-42b3-94ac-dc3886275913','3a58f5fc-6b05-4630-93a2-8143dfcb77f3',NULL,NULL,NULL),('508c6e46-85da-42b3-94ac-dc3886275913','6ad0308b-47ba-427b-8ebf-de8e33622ac8',NULL,NULL,NULL),('ca57d728-6d35-4fb6-b5d3-3204aaf58ec8','9c14008a-5329-406a-99d3-077305ac2a59',NULL,NULL,NULL);
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `primary_role` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_primary_role_foreign` (`primary_role`),
  CONSTRAINT `users_primary_role_foreign` FOREIGN KEY (`primary_role`) REFERENCES `roles` (`role_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('45180761-ee13-4c26-9b48-236eaf3a2f46','Prof. Laurine Gottlieb III','wweber@example.org','2022-04-12 23:12:39','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','6ad0308b-47ba-427b-8ebf-de8e33622ac8','2XjsXNiNHO','2022-04-12 23:12:39','2022-04-12 23:12:39'),('4b3f66e3-1689-4db2-8a35-81b19fe17979','Bob','bob@bob.com','2022-04-12 23:12:39','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','1805ec99-74cc-4a41-b078-7b65e98ed2ed','FMBcrhxESv','2022-04-12 23:12:39','2022-04-12 23:12:39'),('508c6e46-85da-42b3-94ac-dc3886275913','Rita Gerhold','ngrady@example.org','2022-04-12 23:12:39','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','8fdcb2af-a714-4dd5-a9d2-d408455a9a54','tz9NPHQl6m','2022-04-12 23:12:39','2022-04-12 23:12:39'),('94ce5aa3-428e-4333-9326-fb958383df71','Jody Borer','rocio.kulas@example.org','2022-04-12 23:12:39','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','6787f393-4e8c-467e-bb86-4fc1b1df530d','VIs6t3NEj7','2022-04-12 23:12:39','2022-04-12 23:12:39'),('b9097ddf-3431-439a-8b41-637c07156935','Dr. Rhoda Johns','stefanie80@example.org','2022-04-12 23:12:39','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','1805ec99-74cc-4a41-b078-7b65e98ed2ed','ZSxZMHufva','2022-04-12 23:12:39','2022-04-12 23:12:39'),('ca57d728-6d35-4fb6-b5d3-3204aaf58ec8','Ms. Gloria Gleason III','oondricka@example.com','2022-04-12 23:12:39','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','3a58f5fc-6b05-4630-93a2-8143dfcb77f3','8e8NcnqhMX','2022-04-12 23:12:39','2022-04-12 23:12:39'),('cae2fc48-3ad4-46ad-a379-740a5d0c8e28','Admin','admin@admin.com','2022-04-12 23:12:39','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','6787f393-4e8c-467e-bb86-4fc1b1df530d','Kfij4grgah','2022-04-12 23:12:39','2022-04-12 23:12:39');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-04-14  0:47:20
