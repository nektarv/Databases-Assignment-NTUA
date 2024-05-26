-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: final database
-- ------------------------------------------------------
-- Server version	8.4.0

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
-- Table structure for table `chef_cu`
--

DROP TABLE IF EXISTS `chef_cu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chef_cu` (
  `CH_ID` int NOT NULL,
  `CU_ID` int NOT NULL,
  PRIMARY KEY (`CH_ID`,`CU_ID`),
  KEY `CU_idx` (`CU_ID`),
  CONSTRAINT `CH1` FOREIGN KEY (`CH_ID`) REFERENCES `chefs` (`CH_ID`) ON DELETE CASCADE,
  CONSTRAINT `CU1` FOREIGN KEY (`CU_ID`) REFERENCES `ethnic_cuisine` (`CU_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chefs`
--

DROP TABLE IF EXISTS `chefs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chefs` (
  `CH_ID` int NOT NULL AUTO_INCREMENT,
  `First_Name` varchar(15) NOT NULL,
  `Last_Name` varchar(20) NOT NULL,
  `Phone` int NOT NULL,
  `Birthday` date DEFAULT NULL,
  `Age` int DEFAULT NULL,
  `Experience` int DEFAULT NULL,
  `Class` int DEFAULT NULL,
  `File_Name` varchar(45) NOT NULL,
  PRIMARY KEY (`CH_ID`),
  KEY `chef_photo_idx` (`File_Name`),
  KEY `idx_fullname` (`First_Name`,`Last_Name`),
  CONSTRAINT `chef_photo` FOREIGN KEY (`File_Name`) REFERENCES `photo` (`file_name`),
  CONSTRAINT `chefs_chk_1` CHECK ((`Age` > 17)),
  CONSTRAINT `chefs_chk_2` CHECK ((`Class` < 6)),
  CONSTRAINT `chefs_chk_3` CHECK ((`Class` < 6))
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `chefs_recipes`
--

DROP TABLE IF EXISTS `chefs_recipes`;
/*!50001 DROP VIEW IF EXISTS `chefs_recipes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `chefs_recipes` AS SELECT 
 1 AS `CH_ID`,
 1 AS `REC_ID`,
 1 AS `Name`,
 1 AS `Pastry`,
 1 AS `Difficulty`,
 1 AS `Desctiprion`,
 1 AS `Tip1`,
 1 AS `Tip2`,
 1 AS `Tip3`,
 1 AS `Total Time`,
 1 AS `Prep Time`,
 1 AS `Exec_Time`,
 1 AS `Portions`,
 1 AS `Characterization`,
 1 AS `PRIM_ING_ID`,
 1 AS `CU_ID`,
 1 AS `THEME_ID`,
 1 AS `file_name`,
 1 AS `Kcal per serving`,
 1 AS `Protein per serving`,
 1 AS `Carbs per serving`,
 1 AS `Fat per serving`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ep_cu`
--

DROP TABLE IF EXISTS `ep_cu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ep_cu` (
  `EP_ID` int NOT NULL,
  `CU_ID` int NOT NULL,
  PRIMARY KEY (`EP_ID`,`CU_ID`),
  KEY `CU_idx` (`CU_ID`),
  CONSTRAINT `CU2` FOREIGN KEY (`CU_ID`) REFERENCES `ethnic_cuisine` (`CU_ID`) ON DELETE CASCADE,
  CONSTRAINT `EP2` FOREIGN KEY (`EP_ID`) REFERENCES `episodes` (`EP_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `episodes`
--

DROP TABLE IF EXISTS `episodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `episodes` (
  `EP_ID` int NOT NULL AUTO_INCREMENT,
  `Season` int NOT NULL,
  `EP_Number` int NOT NULL,
  `Winner` int DEFAULT NULL,
  `File_Name` varchar(45) NOT NULL,
  PRIMARY KEY (`EP_ID`),
  KEY `file_name_idx` (`File_Name`),
  KEY `idx_winner` (`Winner`),
  CONSTRAINT `ep_photo` FOREIGN KEY (`File_Name`) REFERENCES `photo` (`file_name`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `episodes_played`
--

DROP TABLE IF EXISTS `episodes_played`;
/*!50001 DROP VIEW IF EXISTS `episodes_played`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `episodes_played` AS SELECT 
 1 AS `CH_ID`,
 1 AS `EP_ID`,
 1 AS `recipe`,
 1 AS `Grade`,
 1 AS `Winner`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ethnic_cuisine`
--

DROP TABLE IF EXISTS `ethnic_cuisine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ethnic_cuisine` (
  `CU_ID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(30) NOT NULL,
  `file_name` varchar(45) NOT NULL,
  PRIMARY KEY (`CU_ID`),
  UNIQUE KEY `Name_UNIQUE` (`Name`),
  KEY `cu_photo_idx` (`file_name`),
  KEY `idx_cu_name` (`Name`),
  CONSTRAINT `cu_photo` FOREIGN KEY (`file_name`) REFERENCES `photo` (`file_name`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `food_groups`
--

DROP TABLE IF EXISTS `food_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_groups` (
  `FG_ID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(30) NOT NULL,
  `Desription` varchar(100) DEFAULT NULL,
  `file_name` varchar(45) NOT NULL,
  `Characterization` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`FG_ID`),
  KEY `fg_photo_idx` (`file_name`),
  KEY `idx_fd_name` (`Name`),
  CONSTRAINT `fg_photo` FOREIGN KEY (`file_name`) REFERENCES `photo` (`file_name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gear`
--

DROP TABLE IF EXISTS `gear`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gear` (
  `GR_ID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `Instructions` varchar(500) DEFAULT NULL,
  `file_name` varchar(45) NOT NULL,
  PRIMARY KEY (`GR_ID`),
  KEY `gear_photo_idx` (`file_name`),
  KEY `idx_gear` (`Name`),
  CONSTRAINT `gear_photo` FOREIGN KEY (`file_name`) REFERENCES `photo` (`file_name`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ingredients`
--

DROP TABLE IF EXISTS `ingredients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingredients` (
  `ING_ID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Desription` varchar(100) DEFAULT NULL,
  `Kcal per 100` int NOT NULL DEFAULT '0',
  `FG_ID` int NOT NULL,
  `File_name` varchar(45) NOT NULL,
  PRIMARY KEY (`ING_ID`),
  KEY `ing_photo_idx` (`File_name`),
  KEY `ing_fg` (`FG_ID`),
  KEY `idx_ingr_name` (`Name`),
  CONSTRAINT `ing_fg` FOREIGN KEY (`FG_ID`) REFERENCES `food_groups` (`FG_ID`),
  CONSTRAINT `ing_photo` FOREIGN KEY (`File_name`) REFERENCES `photo` (`file_name`)
) ENGINE=InnoDB AUTO_INCREMENT=999 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `judges`
--

DROP TABLE IF EXISTS `judges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `judges` (
  `CH_ID` int NOT NULL,
  `EP_ID` int NOT NULL,
  `count` int DEFAULT NULL,
  PRIMARY KEY (`CH_ID`,`EP_ID`),
  KEY `EP_idx` (`EP_ID`),
  CONSTRAINT `CH5` FOREIGN KEY (`CH_ID`) REFERENCES `chefs` (`CH_ID`) ON DELETE CASCADE,
  CONSTRAINT `EP5` FOREIGN KEY (`EP_ID`) REFERENCES `episodes` (`EP_ID`) ON DELETE CASCADE,
  CONSTRAINT `judge_count` CHECK ((`count` < 4))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `label`
--

DROP TABLE IF EXISTS `label`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `label` (
  `LA_ID` int NOT NULL AUTO_INCREMENT,
  `Label_Name` varchar(20) DEFAULT NULL,
  `Label_Info` varchar(45) DEFAULT NULL,
  `file_name` varchar(45) NOT NULL,
  PRIMARY KEY (`LA_ID`),
  KEY `file_name_idx` (`file_name`),
  KEY `idx_label` (`Label_Name`),
  CONSTRAINT `filename` FOREIGN KEY (`file_name`) REFERENCES `photo` (`file_name`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nutrition_info`
--

DROP TABLE IF EXISTS `nutrition_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nutrition_info` (
  `REC_ID` int NOT NULL,
  `Fat per serving` int DEFAULT '0',
  `Protein per serving` int DEFAULT '0',
  `Carbs per serving` int DEFAULT '0',
  `Kcal per serving` int DEFAULT '0',
  PRIMARY KEY (`REC_ID`),
  CONSTRAINT `recipe_nutrition` FOREIGN KEY (`REC_ID`) REFERENCES `recipes` (`REC_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `personal_info`
--

DROP TABLE IF EXISTS `personal_info`;
/*!50001 DROP VIEW IF EXISTS `personal_info`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `personal_info` AS SELECT 
 1 AS `CH_ID`,
 1 AS `First_Name`,
 1 AS `Last_Name`,
 1 AS `Phone`,
 1 AS `Birthday`,
 1 AS `Age`,
 1 AS `Experience`,
 1 AS `Class`,
 1 AS `File_Name`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `photo`
--

DROP TABLE IF EXISTS `photo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `photo` (
  `file_name` varchar(45) NOT NULL,
  `Description` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`file_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `plays`
--

DROP TABLE IF EXISTS `plays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plays` (
  `CH_ID` int NOT NULL,
  `EP_ID` int NOT NULL,
  `Grade` int NOT NULL,
  `Cuisine` int DEFAULT NULL,
  `recipe` int DEFAULT NULL,
  `score1` int DEFAULT NULL,
  `score2` int DEFAULT NULL,
  `score3` int DEFAULT NULL,
  PRIMARY KEY (`CH_ID`,`EP_ID`),
  KEY `EP_idx` (`EP_ID`),
  KEY `idx_ep_rec` (`recipe`),
  CONSTRAINT `CH3` FOREIGN KEY (`CH_ID`) REFERENCES `chefs` (`CH_ID`) ON DELETE CASCADE,
  CONSTRAINT `EP3` FOREIGN KEY (`EP_ID`) REFERENCES `episodes` (`EP_ID`) ON DELETE CASCADE,
  CONSTRAINT `rec23` FOREIGN KEY (`recipe`) REFERENCES `recipes` (`REC_ID`) ON DELETE CASCADE,
  CONSTRAINT `plays_chk_1` CHECK ((`Grade` < 16)),
  CONSTRAINT `total_score` CHECK ((`Grade` = ((`score1` + `score2`) + `score3`)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rec_chef`
--

DROP TABLE IF EXISTS `rec_chef`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rec_chef` (
  `CH_ID` int NOT NULL,
  `REC_ID` int NOT NULL,
  PRIMARY KEY (`CH_ID`,`REC_ID`),
  KEY `REC_idx` (`REC_ID`),
  CONSTRAINT `Chef` FOREIGN KEY (`CH_ID`) REFERENCES `chefs` (`CH_ID`) ON DELETE CASCADE,
  CONSTRAINT `REC` FOREIGN KEY (`REC_ID`) REFERENCES `recipes` (`REC_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rec_gear`
--

DROP TABLE IF EXISTS `rec_gear`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rec_gear` (
  `REC_ID` int NOT NULL,
  `GR_ID` int NOT NULL,
  PRIMARY KEY (`REC_ID`,`GR_ID`),
  KEY `GR_idx` (`GR_ID`),
  CONSTRAINT `GR4` FOREIGN KEY (`GR_ID`) REFERENCES `gear` (`GR_ID`) ON DELETE CASCADE,
  CONSTRAINT `REC4` FOREIGN KEY (`REC_ID`) REFERENCES `recipes` (`REC_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rec_ingr`
--

DROP TABLE IF EXISTS `rec_ingr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rec_ingr` (
  `REC_ID` int NOT NULL,
  `ING_ID` int NOT NULL,
  `Precise_Quantity` int DEFAULT '0',
  `Inprecise_Quantity` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`REC_ID`,`ING_ID`),
  KEY `ING_idx` (`ING_ID`),
  CONSTRAINT `ING2` FOREIGN KEY (`ING_ID`) REFERENCES `ingredients` (`ING_ID`) ON DELETE CASCADE,
  CONSTRAINT `REC2` FOREIGN KEY (`REC_ID`) REFERENCES `recipes` (`REC_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rec_label`
--

DROP TABLE IF EXISTS `rec_label`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rec_label` (
  `LA_ID` int NOT NULL,
  `REC_ID` int NOT NULL,
  PRIMARY KEY (`LA_ID`,`REC_ID`),
  KEY `REC_idx` (`REC_ID`),
  CONSTRAINT `LABEL1` FOREIGN KEY (`LA_ID`) REFERENCES `label` (`LA_ID`) ON DELETE CASCADE,
  CONSTRAINT `REC1` FOREIGN KEY (`REC_ID`) REFERENCES `recipes` (`REC_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rec_type`
--

DROP TABLE IF EXISTS `rec_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rec_type` (
  `REC_ID` int NOT NULL,
  `TY_ID` int NOT NULL,
  PRIMARY KEY (`REC_ID`,`TY_ID`),
  KEY `TY_idx` (`TY_ID`),
  CONSTRAINT `REC5` FOREIGN KEY (`REC_ID`) REFERENCES `recipes` (`REC_ID`) ON DELETE CASCADE,
  CONSTRAINT `TY4` FOREIGN KEY (`TY_ID`) REFERENCES `type` (`TY_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recipes`
--

DROP TABLE IF EXISTS `recipes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recipes` (
  `REC_ID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Pastry` tinyint DEFAULT '0',
  `Difficulty` int DEFAULT NULL,
  `Desctiprion` varchar(100) DEFAULT NULL,
  `Tip1` varchar(150) DEFAULT NULL,
  `Tip2` varchar(150) DEFAULT NULL,
  `Tip3` varchar(150) DEFAULT NULL,
  `Total Time` int DEFAULT NULL,
  `Prep Time` int DEFAULT NULL,
  `Exec_Time` int DEFAULT NULL,
  `Portions` int DEFAULT NULL,
  `Characterization` varchar(20) DEFAULT NULL,
  `PRIM_ING_ID` int NOT NULL,
  `CU_ID` int NOT NULL,
  `THEME_ID` int NOT NULL,
  `file_name` varchar(45) NOT NULL,
  PRIMARY KEY (`REC_ID`),
  KEY `test_idx` (`CU_ID`),
  KEY `Primary_ingr_idx` (`PRIM_ING_ID`),
  KEY `Rec_Theme_idx` (`THEME_ID`),
  KEY `photo_idx` (`file_name`),
  KEY `idx_recipe_name` (`Name`),
  CONSTRAINT `cuisine_recipe` FOREIGN KEY (`CU_ID`) REFERENCES `ethnic_cuisine` (`CU_ID`),
  CONSTRAINT `photo` FOREIGN KEY (`file_name`) REFERENCES `photo` (`file_name`),
  CONSTRAINT `Primary_ingr` FOREIGN KEY (`PRIM_ING_ID`) REFERENCES `ingredients` (`ING_ID`),
  CONSTRAINT `Rec_Theme` FOREIGN KEY (`THEME_ID`) REFERENCES `theme` (`THEME_ID`),
  CONSTRAINT `recipes_chk_1` CHECK ((`Total Time` = (`Prep Time` + `Exec_Time`))),
  CONSTRAINT `recipes_chk_2` CHECK ((`Difficulty` < 6))
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `steps`
--

DROP TABLE IF EXISTS `steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `steps` (
  `REC_ID` int NOT NULL,
  `Count` int NOT NULL,
  `Step` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`REC_ID`,`Count`),
  CONSTRAINT `Step_Rec` FOREIGN KEY (`REC_ID`) REFERENCES `recipes` (`REC_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `theme`
--

DROP TABLE IF EXISTS `theme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `theme` (
  `THEME_ID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(30) NOT NULL,
  `Description` varchar(500) DEFAULT NULL,
  `File_Name` varchar(45) NOT NULL,
  PRIMARY KEY (`THEME_ID`),
  UNIQUE KEY `Name_UNIQUE` (`Name`),
  KEY `file_name_idx` (`File_Name`),
  KEY `idx_theme` (`Name`),
  CONSTRAINT `file_name` FOREIGN KEY (`File_Name`) REFERENCES `photo` (`file_name`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `type`
--

DROP TABLE IF EXISTS `type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `type` (
  `TY_ID` int NOT NULL,
  `Meal_type` varchar(20) DEFAULT NULL,
  `file_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`TY_ID`),
  KEY `type_photo_idx` (`file_name`),
  KEY `idx_type` (`Meal_type`),
  CONSTRAINT `type_photo` FOREIGN KEY (`file_name`) REFERENCES `photo` (`file_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_chefs_mapping`
--

DROP TABLE IF EXISTS `user_chefs_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_chefs_mapping` (
  `mysql_user` varchar(100) NOT NULL,
  `ch_id` int NOT NULL,
  PRIMARY KEY (`mysql_user`),
  KEY `ch_id` (`ch_id`),
  CONSTRAINT `user_chefs_mapping_ibfk_1` FOREIGN KEY (`ch_id`) REFERENCES `chefs` (`CH_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

 -- make a frankenstein that handles everything on episode insertion
/*TODO:
ADD A RECIPE SELECTOR BASED ON CHEFS PROBABLY 
PROBABLY(?) ADD A COLUMN ON PLAYS OF WHAT EVERY CHEF COOKS
AND SOME CHECKS INSIDE DATABASE WHICH WE HAVE ALREADY INCLUDED ON FAKER BUT SHOULD EXIST AS INTEGRITY CONSTRAINTS*/

DELIMITER $$

DROP TRIGGER IF EXISTS `Episode_grades`$$
	
DELIMITER $$
CREATE DEFINER = CURRENT_USER TRIGGER `Episode_grades` 
AFTER INSERT ON `Episodes` 
FOR EACH ROW
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE j INT DEFAULT 0;
    DECLARE rgrade INT;
    DECLARE rscore1 INT;
    DECLARE rscore2 INT;
    DECLARE rscore3 INT;
    DECLARE rCU_ID INT;
    DECLARE rCH_ID INT;
    DECLARE rREC_ID INT;
    DECLARE prev_ep1 INT;
    DECLARE prev_ep2 INT;
    DECLARE prev_ep3 INT;
    DECLARE judge1 INT;
    DECLARE judge2 INT;
    DECLARE judge3 INT;

    -- Get IDs of the last three episodes
    SELECT EP_ID INTO prev_ep1 FROM Episodes ORDER BY EP_ID DESC LIMIT 2, 1;
    SELECT EP_ID INTO prev_ep2 FROM Episodes ORDER BY EP_ID DESC LIMIT 1, 1;
    SELECT EP_ID INTO prev_ep3 FROM Episodes ORDER BY EP_ID DESC LIMIT 0, 1;

    -- Setup cuisines-----
    loop_players: LOOP
		SET rscore1=FLOOR(RAND() * 6);
        SET rscore2=FLOOR(RAND() * 6);
        SET rscore3=FLOOR(RAND() * 6);
        SET rgrade = rscore1+rscore2+rscore3;
        SET j=0;
        
        -- Ensure rCU_ID is valid and hasn't been used in all of the previous three episodes
        SELECT CU_ID INTO rCU_ID 
        FROM ethnic_cuisine
        WHERE CU_ID NOT IN (
            SELECT DISTINCT CU_ID
            FROM ep_cu
            WHERE EP_ID IN (prev_ep1, prev_ep2, prev_ep3)
            GROUP BY CU_ID
            HAVING COUNT(DISTINCT EP_ID) = 3
        )
        ORDER BY RAND() 
        LIMIT 1;

        -- Ensure rCH_ID is valid and from the selected cuisine
        SELECT C.CH_ID INTO rCH_ID 
        FROM Chefs C JOIN chef_cu A ON C.CH_ID=A.CH_ID
        WHERE C.CH_ID NOT IN (
            SELECT DISTINCT CH_ID
            FROM PLAYS
            WHERE EP_ID IN (prev_ep1, prev_ep2, prev_ep3)
            GROUP BY CH_ID
            HAVING COUNT(DISTINCT EP_ID) = 3
        ) 
        AND A.CU_ID = rCU_ID -- Ensure chef is from the selected cuisine
        ORDER BY RAND() 
        LIMIT 1;
        
		SELECT R.REC_ID INTO rREC_ID
        FROM rec_chef R
        WHERE R.REC_ID NOT IN (
            SELECT DISTINCT recipe
            FROM PLAYS
            WHERE EP_ID IN (prev_ep1, prev_ep2, prev_ep3)
            GROUP BY recipe
            HAVING COUNT(DISTINCT EP_ID) = 3
        ) 
        AND R.CH_ID = rCH_ID -- Ensure chef cooks recipy
        AND EXISTS (SELECT REC_ID 
        FROM recipes t 
        WHERE t.REC_ID=R.REC_ID 
        AND t.CU_ID = rCU_ID)
        ORDER BY RAND() 
        LIMIT 1;

        -- Check for unique combination of CH_ID and EP_ID
        IF NOT EXISTS (
            SELECT 1 
            FROM PLAYS 
            WHERE CH_ID = rCH_ID AND EP_ID = NEW.EP_ID
        ) THEN
            SET j=j+1;
        END IF;

        -- Insert into ep_cu table to record the association
        IF NOT EXISTS (
            SELECT 1 
            FROM ep_cu 
            WHERE CU_ID = rCU_ID AND EP_ID = NEW.EP_ID
        ) THEN
            SET j=j+1;
        END IF;

        IF j=2 THEN
            INSERT INTO PLAYS (CH_ID, EP_ID, Grade, Cuisine,recipe,score1,score2,score3) VALUES (rCH_ID, NEW.EP_ID, rgrade, rCU_ID,rREC_ID,rscore1,rscore2,rscore3);
            INSERT INTO ep_cu (CU_ID, EP_ID) VALUES (rCU_ID, NEW.EP_ID);
            SET i=i+1;
        END IF;

        -- Exit the loop after 10 unique insertsrec_chef
        IF i >= 10 THEN
            LEAVE loop_players;
        END IF;
    END LOOP;

    -- Select three judges who haven't judged in the last three consecutive episodes and are not players
    SELECT CH_ID INTO judge1 
    FROM Chefs 
    WHERE CH_ID NOT IN (
        SELECT DISTINCT CH_ID
        FROM judges
        WHERE EP_ID IN (prev_ep1, prev_ep2, prev_ep3)
        GROUP BY CH_ID
        HAVING COUNT(DISTINCT EP_ID) = 3
    ) AND CH_ID NOT IN (
        SELECT CH_ID
        FROM PLAYS
        WHERE EP_ID = NEW.EP_ID
    )
    ORDER BY RAND() 
    LIMIT 1;

    SELECT CH_ID INTO judge2 
    FROM Chefs 
    WHERE CH_ID NOT IN (
        SELECT DISTINCT CH_ID
        FROM judges
        WHERE EP_ID IN (prev_ep1, prev_ep2, prev_ep3)
        GROUP BY CH_ID
        HAVING COUNT(DISTINCT EP_ID) = 3
    ) AND CH_ID NOT IN (
        SELECT CH_ID
        FROM PLAYS
        WHERE EP_ID = NEW.EP_ID
    ) AND CH_ID <> judge1
    ORDER BY RAND() 
    LIMIT 1;

    SELECT CH_ID INTO judge3 
    FROM Chefs 
    WHERE CH_ID NOT IN (
        SELECT DISTINCT CH_ID
        FROM judges
        WHERE EP_ID IN (prev_ep1, prev_ep2, prev_ep3)
        GROUP BY CH_ID
        HAVING COUNT(DISTINCT EP_ID) = 3
    ) AND CH_ID NOT IN (
        SELECT CH_ID
        FROM PLAYS
        WHERE EP_ID = NEW.EP_ID
    ) AND CH_ID NOT IN (judge1, judge2)
    ORDER BY RAND() 
    LIMIT 1;

    -- Insert the judges into the JUDGES table
    INSERT INTO judges (CH_ID, EP_ID, count) VALUES (judge1, NEW.EP_ID,1);
    INSERT INTO judges (CH_ID, EP_ID, count) VALUES (judge2, NEW.EP_ID,2);
    INSERT INTO judges (CH_ID, EP_ID, count) VALUES (judge3, NEW.EP_ID,3);

END$$

DELIMITER ;
-- --------------------------------------------------------------------------

DELIMITER $$

DROP TRIGGER IF EXISTS Create_nutrition_info_for_recipe$$
DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `Create_nutrition_info_for_recipe`
BEFORE INSERT ON `nutrition_info` 
FOR EACH ROW
BEGIN
    DECLARE total_kcals INT DEFAULT 0;
    DECLARE quantity INT;
    
     SELECT Portions INTO quantity
     FROM recipes r
     WHERE r.REC_ID=NEW.REC_ID;

    SELECT (SUM(i.`Kcal per 100` * ri.Precise_Quantity / 100))/quantity
    INTO total_kcals
    FROM ingredients i 
    JOIN rec_ingr ri ON ri.ING_ID = i.ING_ID
    WHERE ri.REC_ID = NEW.REC_ID;

    SET NEW.`Kcal per serving` = total_kcals;
END$$

DELIMITER ;

-- ---------------------------------------------------------------------
DELIMITER //


DROP PROCEDURE IF EXISTS `get_winner`//

CREATE PROCEDURE get_winner(Episode INT)
BEGIN
		DECLARE mywinner INT;
        SELECT c.CH_ID INTO mywinner
        FROM chefs c JOIN plays p ON c.CH_ID = p.CH_ID
        WHERE p.EP_ID = Episode
        ORDER BY grade DESC, c.class
        LIMIT 1;
	UPDATE episodes E
    SET E.winner = mywinner
    WHERE E.EP_ID=Episode;
END //
DELIMITER ;

-- ---------------------------------------------------------------------

DELIMITER //

DROP PROCEDURE IF EXISTS `set_all_winners` //

CREATE PROCEDURE `set_all_winners`()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE max1 INT;

    -- Get the maximum episode ID
    SELECT MAX(EP_ID) INTO max1
    FROM episodes;

    -- Loop through all episode IDs from 1 to max1
    WHILE i <= max1 DO
        -- Call the get_winner procedure for the current episode ID
        CALL get_winner(i);

        -- Increment the loop counter
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;
-- ------------------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS add_chef//

CREATE PROCEDURE add_chef(in user_id INT)
BEGIN
DECLARE username VARCHAR(255);
    DECLARE pass VARCHAR(255);

    -- Construct username and password
    SET username = CONCAT('chef', user_id);
    SET pass = CONCAT('password', user_id);
    
	SET @sql_query = CONCAT('DROP USER IF EXISTS \'', username,'\'@\'localhost\';');

    -- Prepare and execute the SQL statement
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
	SET @sql_query = CONCAT('CREATE USER \'', username,'\'@\'localhost\' IDENTIFIED BY \'', pass, '\';');

    -- Prepare and execute the SQL statement
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
	SET @sql_query = CONCAT('GRANT Chef TO \'',username,'\'@\'localhost\';');

    -- Prepare and execute the SQL statement
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    DELETE FROM user_chefs_mapping WHERE mysql_user=username;
    INSERT INTO user_chefs_mapping (mysql_user, ch_id) VALUES (username,user_id);
END//

-- -------------------------------------------------------------

DROP PROCEDURE IF EXISTS `set_all_chefs` //

CREATE PROCEDURE `set_all_chefs`()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE max1 INT;
    DECLARE min1 INT;

    -- Get the maximum episode ID
    SELECT MAX(CH_ID) INTO max1
    FROM Chefs;
	SELECT MIN(CH_ID) INTO min1
    FROM Chefs;
    
	SET i=min1;
    -- Loop through all episode IDs from 1 to max1
    WHILE i <= max1 DO
			IF EXISTS (SELECT CH_ID from Chefs WHERE CH_ID=i) THEN CALL add_chef(i);
        -- Call the get_winner procedure for the current episode ID
			END IF;
        -- Increment the loop counter
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;



--
-- Final view structure for view `chefs_recipes`
--

/*!50001 DROP VIEW IF EXISTS `chefs_recipes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `chefs_recipes` AS select `rc`.`CH_ID` AS `CH_ID`,`r`.`REC_ID` AS `REC_ID`,`r`.`Name` AS `Name`,`r`.`Pastry` AS `Pastry`,`r`.`Difficulty` AS `Difficulty`,`r`.`Desctiprion` AS `Desctiprion`,`r`.`Tip1` AS `Tip1`,`r`.`Tip2` AS `Tip2`,`r`.`Tip3` AS `Tip3`,`r`.`Total Time` AS `Total Time`,`r`.`Prep Time` AS `Prep Time`,`r`.`Exec_Time` AS `Exec_Time`,`r`.`Portions` AS `Portions`,`r`.`Characterization` AS `Characterization`,`r`.`PRIM_ING_ID` AS `PRIM_ING_ID`,`r`.`CU_ID` AS `CU_ID`,`r`.`THEME_ID` AS `THEME_ID`,`r`.`file_name` AS `file_name`,`n`.`Kcal per serving` AS `Kcal per serving`,`n`.`Protein per serving` AS `Protein per serving`,`n`.`Carbs per serving` AS `Carbs per serving`,`n`.`Fat per serving` AS `Fat per serving` from ((`rec_chef` `rc` join `recipes` `r` on((`rc`.`REC_ID` = `r`.`REC_ID`))) join `nutrition_info` `n` on((`r`.`REC_ID` = `n`.`REC_ID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `episodes_played`
--

/*!50001 DROP VIEW IF EXISTS `episodes_played`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `episodes_played` AS select `p`.`CH_ID` AS `CH_ID`,`p`.`EP_ID` AS `EP_ID`,`p`.`recipe` AS `recipe`,`p`.`Grade` AS `Grade`,`e`.`Winner` AS `Winner` from (`plays` `p` join `episodes` `e` on((`p`.`EP_ID` = `e`.`EP_ID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `personal_info`
--

/*!50001 DROP VIEW IF EXISTS `personal_info`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `personal_info` AS select `chefs`.`CH_ID` AS `CH_ID`,`chefs`.`First_Name` AS `First_Name`,`chefs`.`Last_Name` AS `Last_Name`,`chefs`.`Phone` AS `Phone`,`chefs`.`Birthday` AS `Birthday`,`chefs`.`Age` AS `Age`,`chefs`.`Experience` AS `Experience`,`chefs`.`Class` AS `Class`,`chefs`.`File_Name` AS `File_Name` from `chefs` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-25 21:09:35
