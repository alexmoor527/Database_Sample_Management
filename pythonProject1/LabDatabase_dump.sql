-- MySQL dump 10.13  Distrib 8.0.39, for Win64 (x86_64)
--
-- Host: localhost    Database: LabDatabase
-- ------------------------------------------------------
-- Server version	8.0.39

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
-- Table structure for table `analysts`
--

DROP TABLE IF EXISTS `analysts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `analysts` (
  `AnalystID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `ContactInfo` text,
  `Status` enum('Active','Inactive') DEFAULT 'Active',
  PRIMARY KEY (`AnalystID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `analysts`
--

LOCK TABLES `analysts` WRITE;
/*!40000 ALTER TABLE `analysts` DISABLE KEYS */;
INSERT INTO `analysts` VALUES (1,'Dr. Carol Lee','carol.lee@example.com','Active'),(2,'asdf','123','Active');
/*!40000 ALTER TABLE `analysts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `analyticalmethods`
--

DROP TABLE IF EXISTS `analyticalmethods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `analyticalmethods` (
  `MethodID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `Description` text,
  `Status` enum('Active','Inactive') DEFAULT 'Active',
  PRIMARY KEY (`MethodID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `analyticalmethods`
--

LOCK TABLES `analyticalmethods` WRITE;
/*!40000 ALTER TABLE `analyticalmethods` DISABLE KEYS */;
INSERT INTO `analyticalmethods` VALUES (1,'HPLC Purity','HPLC for purity analysis','Active'),(2,'1H-NMR Identity','1H NMR to check the identity of a sample','Active'),(3,'1H-NMR Quantitative','1H NMR for assay determination','Active');
/*!40000 ALTER TABLE `analyticalmethods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `experiments`
--

DROP TABLE IF EXISTS `experiments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `experiments` (
  `ExperimentID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `Status` enum('Planned','Ongoing','Finished','Cancelled') DEFAULT 'Planned',
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `Description` text,
  `OperatorID` int DEFAULT NULL,
  PRIMARY KEY (`ExperimentID`),
  KEY `OperatorID` (`OperatorID`),
  CONSTRAINT `experiments_ibfk_1` FOREIGN KEY (`OperatorID`) REFERENCES `operators` (`OperatorID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `experiments`
--

LOCK TABLES `experiments` WRITE;
/*!40000 ALTER TABLE `experiments` DISABLE KEYS */;
INSERT INTO `experiments` VALUES (1,'Trinitrotoluene','Planned','2024-12-07',NULL,'Synthesis of Trinitrotoluene',1),(2,'Cubane','Ongoing','2024-12-16',NULL,'Synthesis of Cubane',1);
/*!40000 ALTER TABLE `experiments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operators`
--

DROP TABLE IF EXISTS `operators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operators` (
  `OperatorID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `ContactInfo` text,
  `Status` enum('Active','Inactive') DEFAULT 'Active',
  PRIMARY KEY (`OperatorID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operators`
--

LOCK TABLES `operators` WRITE;
/*!40000 ALTER TABLE `operators` DISABLE KEYS */;
INSERT INTO `operators` VALUES (1,'Alice Johnson','alice.johnson@example.com','Active'),(2,'Alex','asdf','Active');
/*!40000 ALTER TABLE `operators` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qualitativeresults`
--

DROP TABLE IF EXISTS `qualitativeresults`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qualitativeresults` (
  `TaskID` int NOT NULL AUTO_INCREMENT,
  `SampleID` int DEFAULT NULL,
  `MethodID` int DEFAULT NULL,
  `AnalystID` int DEFAULT NULL,
  `PassFail` tinyint(1) DEFAULT NULL,
  `Status` enum('Valid','Rejected') DEFAULT 'Valid',
  `PdfFilePath` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`TaskID`),
  KEY `SampleID` (`SampleID`),
  KEY `MethodID` (`MethodID`),
  KEY `AnalystID` (`AnalystID`),
  CONSTRAINT `qualitativeresults_ibfk_1` FOREIGN KEY (`SampleID`) REFERENCES `samples` (`SampleID`),
  CONSTRAINT `qualitativeresults_ibfk_2` FOREIGN KEY (`MethodID`) REFERENCES `analyticalmethods` (`MethodID`),
  CONSTRAINT `qualitativeresults_ibfk_3` FOREIGN KEY (`AnalystID`) REFERENCES `analysts` (`AnalystID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qualitativeresults`
--

LOCK TABLES `qualitativeresults` WRITE;
/*!40000 ALTER TABLE `qualitativeresults` DISABLE KEYS */;
INSERT INTO `qualitativeresults` VALUES (1,1,2,1,0,'Valid',NULL),(2,3,2,1,1,'Valid','static/uploads/nmr_report.pdf');
/*!40000 ALTER TABLE `qualitativeresults` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quantitativeresults`
--

DROP TABLE IF EXISTS `quantitativeresults`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quantitativeresults` (
  `TaskID` int NOT NULL AUTO_INCREMENT,
  `SampleID` int DEFAULT NULL,
  `MethodID` int DEFAULT NULL,
  `AnalystID` int DEFAULT NULL,
  `ResultValue` float DEFAULT NULL,
  `Specification` float DEFAULT NULL,
  `PassFail` tinyint(1) DEFAULT NULL,
  `Status` enum('Valid','Rejected') DEFAULT 'Valid',
  `PdfFilePath` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`TaskID`),
  KEY `SampleID` (`SampleID`),
  KEY `MethodID` (`MethodID`),
  KEY `AnalystID` (`AnalystID`),
  CONSTRAINT `quantitativeresults_ibfk_1` FOREIGN KEY (`SampleID`) REFERENCES `samples` (`SampleID`),
  CONSTRAINT `quantitativeresults_ibfk_2` FOREIGN KEY (`MethodID`) REFERENCES `analyticalmethods` (`MethodID`),
  CONSTRAINT `quantitativeresults_ibfk_3` FOREIGN KEY (`AnalystID`) REFERENCES `analysts` (`AnalystID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quantitativeresults`
--

LOCK TABLES `quantitativeresults` WRITE;
/*!40000 ALTER TABLE `quantitativeresults` DISABLE KEYS */;
INSERT INTO `quantitativeresults` VALUES (1,1,1,1,98.5,98,0,'Valid',NULL),(2,3,1,1,98.2,98,1,'Valid','static/uploads\\hplc_report.pdf');
/*!40000 ALTER TABLE `quantitativeresults` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `samples`
--

DROP TABLE IF EXISTS `samples`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `samples` (
  `SampleID` int NOT NULL AUTO_INCREMENT,
  `ExperimentID` int DEFAULT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `Description` text,
  `OperatorID` int DEFAULT NULL,
  `CreationDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `Status` enum('Valid','Rejected') DEFAULT 'Valid',
  PRIMARY KEY (`SampleID`),
  KEY `ExperimentID` (`ExperimentID`),
  KEY `OperatorID` (`OperatorID`),
  CONSTRAINT `samples_ibfk_1` FOREIGN KEY (`ExperimentID`) REFERENCES `experiments` (`ExperimentID`),
  CONSTRAINT `samples_ibfk_2` FOREIGN KEY (`OperatorID`) REFERENCES `operators` (`OperatorID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `samples`
--

LOCK TABLES `samples` WRITE;
/*!40000 ALTER TABLE `samples` DISABLE KEYS */;
INSERT INTO `samples` VALUES (1,1,'Starting material','Organic compound for HPLC purity test',1,'2024-12-16 12:54:04','Valid'),(2,1,'Starting material 2','Reagent for NMR assay',1,'2024-12-16 12:54:04','Valid'),(3,2,'IPC','IPC during reaction',1,'2024-12-16 13:07:23','Valid'),(5,1,'asdf','asdf',1,'2024-12-16 13:21:13','Valid');
/*!40000 ALTER TABLE `samples` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-16 14:29:30
