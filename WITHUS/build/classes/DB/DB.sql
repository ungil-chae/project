DROP DATABASE IF EXISTS book_recommendation_db;

CREATE DATABASE book_recommendation_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

USE book_recommendation_db;

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
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nickname` varchar(50) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `gender` enum('M','F','O') DEFAULT NULL,
  `mbti` varchar(10) DEFAULT NULL,
  `reg_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `last_login_date` datetime DEFAULT NULL,
  `status` enum('active','inactive','withdrawn') DEFAULT 'active',
  `hobbies` text,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `nickname` (`nickname`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'sst7050','$2a$10$IDwHRwbvpCJiS9erIOdra.5nAmIrM3w1AASBQO9DFv3nci6sW7DXG','gustjr','sst@naver.com','M','INTP','2025-07-03 15:06:00','2025-07-11 08:06:22','active','science,coding,fashion,technology,education',NULL,'현석'),(2,'s12345','$2a$10$rSEx5k9Yr8iPhG7fVOfbye2i9urzEfZEtJqVQIsGsHwWS8tgXKAFC','현석','sss@naver.com','M','INFP','2025-07-04 14:30:01','2025-07-04 14:30:32','withdrawn','reading,technology','2025-07-04 05:33:09','심현석'),(3,'sst2525','$2a$10$TZArtraBdlw.09n8R8qFWeIWQ.5hp2o0FHcKc9Bv/CEP2t42VIYNW','현수','sst23@naver.com','F','ENFJ','2025-07-07 17:46:01',NULL,'active','reading,travel,technology',NULL,'심현수'),(4,'sst1999','$2a$10$qdJf0ghROstgtAA9HLct8ej2z42LRbQfkB9QupH/SCGSYepQxIiai','현석심','asdasd@naver.com','M','ESTJ','2025-07-08 10:45:07',NULL,'active','reading,gaming,fashion',NULL,'현석심'),(5,'sst1995','$2a$10$lkF5zX5Y3LcyuP/.XnnwAuR9V5ShsPwl9lFfv2LDzI/7Wku6bRE6q','현석아','dfddf@naver.com','M','ENTP','2025-07-08 10:56:35',NULL,'active','movie,gaming,coding',NULL,'현석심이'),(6,'shs1999','$2a$10$xvUr4bxGUze2XpDLulsx3OlxcLOe8KOlDYcqGVjKFkhc1uZ7fl/V.','현석이','sstt@naver.com','M','ESFJ','2025-07-08 11:04:06','2025-07-09 16:28:22','withdrawn','reading,travel,science','2025-07-09 07:28:35','현석아'),(7,'sst2050','$2a$10$lyyStqCCGlosgewljJGgS.r.ws9swV8YmorkKQmXQavXnud8BI0zW','현수스','sst70500@naver.com','M','ENTJ','2025-07-08 11:06:29',NULL,'active','movie,gaming,coding',NULL,'현수심'),(8,'yasuo','$2a$10$f0EUW9TerwI.ugyH3jeqAeb21vHlbUxnaH8ZmnF6HsO70MI8Y2CB.',' yasuo','yasuo@naver.com','M','ENTJ','2025-07-08 11:08:42',NULL,'active','gaming,coding,fashion',NULL,'야스오'),(9,'yone','$2a$10$ly9Jg.K0OL6Hy9YUXX4m3OCHYrW0c0Imh4NicMpxEOQcEw6o1CBO2','요네','yone@naver.com','M','ENTJ','2025-07-08 11:12:47','2025-07-08 14:19:00','withdrawn','gaming','2025-07-08 05:19:13','요네스'),(10,'timo','$2a$10$Q0PX8bQmftY45PFjyTNk7.0P50zB1UmxTT4ZC0OuDZ6W7.JUtqV5S','티모','timo@naver.com','M','ENFJ','2025-07-08 11:26:29','2025-07-08 12:41:34','active','reading',NULL,'티모'),(11,'sss','$2a$10$0n/52FGfPkotU1Aot56/C.FakooU7Q4j5OcXbcsnXG4a19xfqUhmy','sss','ssssss@naver.com','F','ISFJ','2025-07-08 16:04:10',NULL,'active','cooking,fashion',NULL,'sss'),(12,'daye','$2a$10$i5X4lctPBuWRdYUXnLaO.e/JdzE/1lUaOUodM44AgbuhbaiQlDLjG','daye','daye@gmail.com','F','ENFJ','2025-07-11 09:45:57','2025-07-11 16:21:02','active','reading,movie,music,science,photography,writing',NULL,'daye'),(13,'zxcvb1234','$2a$10$tP3DUPl/ZKPFmsahvZhUN.sUPGGPpFrVumEtEOAQ7fiT6XS4OAJm.','냥','qwer@naver.com','F','ISFP','2025-07-11 13:56:41','2025-07-11 13:57:03','active','reading,gaming,fashion',NULL,'냐냥'),(14,'asas','$2a$10$1/Wl/zKh4RzIaMpDH6gWk.v.La9mhqczT7GcITPhYn5cNtxdi3LKy','asasas','qwer1213@naver.com','F','INFJ','2025-07-11 14:41:21',NULL,'active','reading,gaming',NULL,'asasas'),(15,'asd1234','$2a$10$Kfm76k4HHlN.0IDgeWgrgu4VLR0wATUxWVp2pdVK8Zy7.LNTr78py','웅일','cwil23@gsad.com','O','ISFJ','2025-07-11 15:02:41','2025-07-11 15:02:55','active','science',NULL,'채웅일'),(16,'asdf1234','$2a$10$xfCf6fvGM0JXz13VwSTlHuxz78WgOjRexYNKW/XydE7CSL5/zzwOu','냠냠짱','qwer123456@naver.com','F','INTJ','2025-07-11 15:21:36','2025-07-11 15:23:17','withdrawn','fashion,photography','2025-07-11 06:23:32','냐냠'),(17,'qwert1234','$2a$10$bhUBf4g2WoZcs3.wPh3T3.1p.VypF6icyhrKnkPtdaPx.DQf8c436','냐냥짱','qwer1234@naver.com','F','ISFP','2025-07-11 16:17:17','2025-07-11 16:17:39','withdrawn','movie,cooking,fashion','2025-07-11 07:20:20','냐냥');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books` (통합된 테이블)
-- [변경] 기존 books + reviewbook 통합
-- - category 컬럼 유지 (기존 books)
-- - created_at, updated_at 컬럼 추가 (기존 reviewbook)
-- - link 컬럼으로 통일 (naver_link → link)
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `book_id` int NOT NULL AUTO_INCREMENT,
  `isbn` varchar(20) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `author` varchar(255) DEFAULT NULL,
  `publisher` varchar(255) DEFAULT NULL,
  `pub_date` date DEFAULT NULL,
  `description` text,
  `cover_image_url` varchar(500) DEFAULT NULL,
  `link` varchar(500) DEFAULT NULL COMMENT '외부 링크 (네이버, 교보문고 등)',
  `category` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`book_id`),
  UNIQUE KEY `isbn` (`isbn`)
) ENGINE=InnoDB AUTO_INCREMENT=300 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
-- [변경] 기존 reviewbook 데이터를 books로 이전
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES
(1,'9791169213868','자바 최적화 (클라우드 시대의 자바 성능 튜닝을 위한 실용적인 기법)','벤저민 J. 에번스','','',NULL,'https://shopping-phinf.pstatic.net/main_5481319/54813194388.20250520082541.jpg','https://search.shopping.naver.com/book/catalog/54813194388','IT/프로그래밍','2025-07-11 07:23:08','2025-07-11 07:23:08'),
(2,'9791194368311','쓰는 인간 (종이에 기록한 사유와 창조의 역사)','롤런드 앨런','','',NULL,'https://shopping-phinf.pstatic.net/main_5526949/55269496515.20250617094239.jpg','https://search.shopping.naver.com/book/catalog/55269496515','에세이','2025-07-11 07:43:50','2025-07-11 07:43:50'),
(3,'9791198987631','세계 경제 지각 변동 (트럼프가 흔드는 세계 경제, 어디로 가는가)','박종훈','','',NULL,'https://shopping-phinf.pstatic.net/main_5540159/55401590712.20250621110430.jpg','https://search.shopping.naver.com/book/catalog/55401590712','경제/경영','2025-07-11 08:00:05','2025-07-11 08:00:05'),
(4,'9788937487927','색채가 없는 다자키 쓰쿠루와 그가 순례를 떠난 해','무라카미 하루키','','',NULL,'https://shopping-phinf.pstatic.net/main_3249151/32491516801.20230620100117.jpg','https://search.shopping.naver.com/book/catalog/32491516801','소설','2025-07-11 09:48:45','2025-07-11 09:48:45'),
(5,'9788950995553','행복의 기원 (인간의 행복은 어디서 오는가)','서은국','','',NULL,'https://shopping-phinf.pstatic.net/main_3245589/32455898125.20250207071245.jpg','https://search.shopping.naver.com/book/catalog/32455898125','인문','2025-07-11 09:50:27','2025-07-11 09:50:27'),
(6,'9791189327156','물고기는 존재하지 않는다 (상실, 사랑 그리고 숨어 있는 삶의 질서에 관한 이야기)','룰루 밀러','','',NULL,'https://shopping-phinf.pstatic.net/main_3243943/32439434396.20230913071305.jpg','https://search.shopping.naver.com/book/catalog/32439434396','과학','2025-07-11 09:53:33','2025-07-11 09:53:33'),
(7,'9788931011623','사랑의 기술','에리히 프롬','','',NULL,'https://shopping-phinf.pstatic.net/main_3245742/32457424202.20250104071307.jpg','https://search.shopping.naver.com/book/catalog/32457424202','인문','2025-07-11 09:54:20','2025-07-11 09:54:20'),
(8,'9788925538297','스토너(초판본)','존 윌리엄스','','',NULL,'https://shopping-phinf.pstatic.net/main_3247557/32475579115.20230926084912.jpg','https://search.shopping.naver.com/book/catalog/32475579115','소설','2025-07-11 09:56:32','2025-07-11 09:56:32'),
(9,'9788935669738','나의 눈부신 친구','엘레나 페란테','','',NULL,'https://shopping-phinf.pstatic.net/main_3243631/32436316846.20250705082931.jpg','https://search.shopping.naver.com/book/catalog/32436316846','소설','2025-07-11 09:57:15','2025-07-11 09:57:15'),
(10,'9788932923963','안나 카레니나 1','톨스토이','','',NULL,'https://shopping-phinf.pstatic.net/main_4678930/46789302622.20240402092652.jpg','https://search.shopping.naver.com/book/catalog/46789302622','소설','2025-07-11 09:58:13','2025-07-11 09:58:13'),
(11,'9791189932671','명랑한 은둔자','캐롤라인 냅','','',NULL,'https://shopping-phinf.pstatic.net/main_3246549/32465493734.20230913071201.jpg','https://search.shopping.naver.com/book/catalog/32465493734','에세이','2025-07-11 09:58:42','2025-07-11 09:58:42'),
(12,'9791167742063','경험의 멸종 (기술이 경험을 대체하는 시대, 인간은 계속 인간일 수 있을까)','크리스틴 로젠','','',NULL,'https://shopping-phinf.pstatic.net/main_5479376/54793763348.20250520082547.jpg','https://search.shopping.naver.com/book/catalog/54793763348','인문','2025-07-11 09:59:22','2025-07-11 09:59:22'),
(13,'9788954646079','바깥은 여름 (김애란 소설)','김애란','','',NULL,'https://shopping-phinf.pstatic.net/main_3247674/32476741846.20231004072443.jpg','https://search.shopping.naver.com/book/catalog/32476741846','소설','2025-07-11 09:59:54','2025-07-11 09:59:54'),
(14,'9788954617246','칼의 노래 (김훈 장편소설)','김훈','','',NULL,'https://shopping-phinf.pstatic.net/main_3248501/32485010628.20250624111418.jpg','https://search.shopping.naver.com/book/catalog/32485010628','소설','2025-07-11 10:03:00','2025-07-11 10:03:00'),
(15,'9788972917038','소유냐 존재냐','에리히 프롬','','',NULL,'https://shopping-phinf.pstatic.net/main_3248246/32482460626.20240519071016.jpg','https://search.shopping.naver.com/book/catalog/32482460626','인문','2025-07-11 10:04:11','2025-07-11 10:04:11'),
(16,'9788954682152','작별하지 않는다 (한강 소설ㅣ2024년 노벨문학상 수상작가 l 2023년 메디치 외국문학상 수상)','한강','','',NULL,'https://shopping-phinf.pstatic.net/main_3243636/32436366634.20231124160335.jpg','https://search.shopping.naver.com/book/catalog/32436366634','소설','2025-07-11 10:26:53','2025-07-11 10:26:53'),
(17,'9788937428234','비눗방울 퐁 (이유리 소설집)','이유리','','',NULL,'https://shopping-phinf.pstatic.net/main_5127888/51278882623.20241108092237.jpg','https://search.shopping.naver.com/book/catalog/51278882623','소설','2025-07-11 10:28:06','2025-07-11 10:28:06'),
(18,'9788925575179','둘도 없는 사이','시몬 드 보부아르','','',NULL,'https://shopping-phinf.pstatic.net/main_4724339/47243391618.20240521102001.jpg','https://search.shopping.naver.com/book/catalog/47243391618','소설','2025-07-11 10:28:53','2025-07-11 10:28:53'),
(19,'9791168127500','오로라 (들키면 어떻게 되나요?)','최진영','','',NULL,'https://shopping-phinf.pstatic.net/main_4591764/45917647618.20240221090916.jpg','https://search.shopping.naver.com/book/catalog/45917647618','소설','2025-07-11 10:29:33','2025-07-11 10:29:33'),
(20,'9791198570529','하늘과 바람과 별과 시 (한 권으로 읽는 윤동주)','윤동주','','',NULL,'https://shopping-phinf.pstatic.net/main_5567153/55671538171.20250709092536.jpg','https://search.shopping.naver.com/book/catalog/55671538171','시','2025-07-11 13:57:51','2025-07-11 13:57:51'),
(21,'9788964211830','자바 (Seventh Edition)','Horstmann, Cay S.','','',NULL,'https://shopping-phinf.pstatic.net/main_3246702/32467024674.20250123071209.jpg','https://search.shopping.naver.com/book/catalog/32467024674','IT/프로그래밍','2025-07-11 15:03:23','2025-07-11 15:03:23'),
(22,'9788956407159','자바시장','박계상','','',NULL,'https://shopping-phinf.pstatic.net/main_3343574/33435744838.20221019152940.jpg','https://search.shopping.naver.com/book/catalog/33435744838','여행','2025-07-11 16:18:20','2025-07-11 16:18:20');
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hashtags`
--

DROP TABLE IF EXISTS `hashtags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hashtags` (
  `tag_id` int NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(50) NOT NULL,
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `tag_name` (`tag_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hashtags`
--

LOCK TABLES `hashtags` WRITE;
/*!40000 ALTER TABLE `hashtags` DISABLE KEYS */;
/*!40000 ALTER TABLE `hashtags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookhashtags`
--

DROP TABLE IF EXISTS `bookhashtags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookhashtags` (
  `book_hashtag_id` int NOT NULL AUTO_INCREMENT,
  `book_id` int NOT NULL,
  `tag_id` int NOT NULL,
  PRIMARY KEY (`book_hashtag_id`),
  UNIQUE KEY `book_id` (`book_id`,`tag_id`),
  KEY `tag_id` (`tag_id`),
  CONSTRAINT `bookhashtags_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON DELETE CASCADE,
  CONSTRAINT `bookhashtags_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `hashtags` (`tag_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookhashtags`
--

LOCK TABLES `bookhashtags` WRITE;
/*!40000 ALTER TABLE `bookhashtags` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookhashtags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `celebrecommendations`
--

DROP TABLE IF EXISTS `celebrecommendations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `celebrecommendations` (
  `celeb_rec_id` int NOT NULL AUTO_INCREMENT,
  `celeb_name` varchar(100) NOT NULL,
  `celeb_description` text,
  `celeb_image_url` varchar(500) DEFAULT NULL,
  `recommend_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`celeb_rec_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `celebrecommendations`
--

LOCK TABLES `celebrecommendations` WRITE;
/*!40000 ALTER TABLE `celebrecommendations` DISABLE KEYS */;
/*!40000 ALTER TABLE `celebrecommendations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `celebrecommendedbooks`
--

DROP TABLE IF EXISTS `celebrecommendedbooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `celebrecommendedbooks` (
  `celeb_rec_book_id` int NOT NULL AUTO_INCREMENT,
  `celeb_rec_id` int NOT NULL,
  `book_id` int NOT NULL,
  `order_in_rec` int DEFAULT NULL,
  PRIMARY KEY (`celeb_rec_book_id`),
  UNIQUE KEY `celeb_rec_id` (`celeb_rec_id`,`book_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `celebrecommendedbooks_ibfk_1` FOREIGN KEY (`celeb_rec_id`) REFERENCES `celebrecommendations` (`celeb_rec_id`) ON DELETE CASCADE,
  CONSTRAINT `celebrecommendedbooks_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `celebrecommendedbooks`
--

LOCK TABLES `celebrecommendedbooks` WRITE;
/*!40000 ALTER TABLE `celebrecommendedbooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `celebrecommendedbooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
-- [변경] book_id가 books 테이블을 참조하도록 변경 (기존 reviewbook → books)
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `book_id` int NOT NULL,
  `review_text` text NOT NULL,
  `rating` tinyint NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  KEY `user_id` (`user_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_blocks`
--

DROP TABLE IF EXISTS `content_blocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `content_blocks` (
  `block_id` int NOT NULL AUTO_INCREMENT,
  `review_id` int NOT NULL,
  `block_type` enum('text','image') NOT NULL,
  `block_order` int NOT NULL,
  `text_content` text,
  `image_url` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`block_id`),
  KEY `review_id` (`review_id`),
  CONSTRAINT `content_blocks_ibfk_1` FOREIGN KEY (`review_id`) REFERENCES `reviews` (`review_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_blocks`
--

LOCK TABLES `content_blocks` WRITE;
/*!40000 ALTER TABLE `content_blocks` DISABLE KEYS */;
/*!40000 ALTER TABLE `content_blocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlists`
--

DROP TABLE IF EXISTS `playlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlists` (
  `playlist_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`playlist_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `playlists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlists`
--

LOCK TABLES `playlists` WRITE;
/*!40000 ALTER TABLE `playlists` DISABLE KEYS */;
/*!40000 ALTER TABLE `playlists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlistbooks`
--

DROP TABLE IF EXISTS `playlistbooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlistbooks` (
  `playlist_book_id` int NOT NULL AUTO_INCREMENT,
  `playlist_id` int NOT NULL,
  `book_id` int NOT NULL,
  `added_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`playlist_book_id`),
  UNIQUE KEY `playlist_id` (`playlist_id`,`book_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `playlistbooks_ibfk_1` FOREIGN KEY (`playlist_id`) REFERENCES `playlists` (`playlist_id`) ON DELETE CASCADE,
  CONSTRAINT `playlistbooks_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlistbooks`
--

LOCK TABLES `playlistbooks` WRITE;
/*!40000 ALTER TABLE `playlistbooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `playlistbooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userinterests`
--

DROP TABLE IF EXISTS `userinterests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userinterests` (
  `user_interest_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `interest_tag` varchar(50) NOT NULL,
  PRIMARY KEY (`user_interest_id`),
  UNIQUE KEY `user_id` (`user_id`,`interest_tag`),
  CONSTRAINT `userinterests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userinterests`
--

LOCK TABLES `userinterests` WRITE;
/*!40000 ALTER TABLE `userinterests` DISABLE KEYS */;
/*!40000 ALTER TABLE `userinterests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlists`
--

DROP TABLE IF EXISTS `wishlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlists` (
  `user_id` int NOT NULL,
  `book_id` int NOT NULL,
  `added_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`book_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `wishlists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `wishlists_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `wishlists` WRITE;

UNLOCK TABLES;
