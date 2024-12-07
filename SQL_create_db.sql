-- Create the database from scratch
DROP DATABASE IF EXISTS LabDatabase;
CREATE DATABASE LabDatabase;
USE LabDatabase;

-- Create Operators table
CREATE TABLE Operators (
    OperatorID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    ContactInfo TEXT,
	Status ENUM('Active', 'Inactive') DEFAULT 'Active'
);

-- Create Experiments table
CREATE TABLE Experiments (
    ExperimentID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Status ENUM('Planned', 'Ongoing', 'Finished', 'Cancelled') DEFAULT 'Planned',
    StartDate DATE,
    EndDate DATE,
    Description TEXT,
    OperatorID INT,
    FOREIGN KEY (OperatorID) REFERENCES Operators(OperatorID)
);

-- Create Samples table, now with OperatorID
CREATE TABLE Samples (
    SampleID INT PRIMARY KEY AUTO_INCREMENT,
    ExperimentID INT,
    Name VARCHAR(100),
    Description TEXT,
    OperatorID INT,
    CreationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	Status ENUM('Valid', 'Rejected') DEFAULT 'Valid',
    FOREIGN KEY (ExperimentID) REFERENCES Experiments(ExperimentID),
    FOREIGN KEY (OperatorID) REFERENCES Operators(OperatorID)
);

-- Create AnalyticalMethods table
CREATE TABLE AnalyticalMethods (
    MethodID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Description TEXT,
	Status ENUM('Active', 'Inactive') DEFAULT 'Active'
);

-- Create Analysts table
CREATE TABLE Analysts (
    AnalystID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    ContactInfo TEXT,
	Status ENUM('Active', 'Inactive') DEFAULT 'Active'
);

-- Create QuantitativeResults table
CREATE TABLE QuantitativeResults (
    TaskID INT PRIMARY KEY AUTO_INCREMENT,
    SampleID INT,
    MethodID INT,
    AnalystID INT,
    ResultValue FLOAT,
    Specification FLOAT,
    PassFail BOOLEAN,
	Status ENUM('Valid', 'Rejected') DEFAULT 'Valid',
    PdfFilePath VARCHAR(255) NULL,
    FOREIGN KEY (SampleID) REFERENCES Samples(SampleID),
    FOREIGN KEY (MethodID) REFERENCES AnalyticalMethods(MethodID),
    FOREIGN KEY (AnalystID) REFERENCES Analysts(AnalystID)
);

CREATE TABLE QualitativeResults (
    TaskID INT PRIMARY KEY AUTO_INCREMENT,
    SampleID INT,
    MethodID INT,
    AnalystID INT,
    PassFail BOOLEAN,
	Status ENUM('Valid', 'Rejected') DEFAULT 'Valid',
	PdfFilePath VARCHAR(255) NULL,
    FOREIGN KEY (SampleID) REFERENCES Samples(SampleID),
    FOREIGN KEY (MethodID) REFERENCES AnalyticalMethods(MethodID),
    FOREIGN KEY (AnalystID) REFERENCES Analysts(AnalystID)
);


-- Insert sample data
INSERT INTO Operators (Name, ContactInfo, Status)
VALUES 
    ('Alice Johnson', 'alice.johnson@example.com', 'Active');
    
INSERT INTO Experiments (Name, Status, StartDate, EndDate, Description, OperatorID)
VALUES 
    ('Trinitrotoluene', 'Ongoing', '2024-12-07', NULL, 'Synthesis of Trinitrotoluene', 1);

INSERT INTO Samples (ExperimentID, Name, Description, OperatorID, Status)
VALUES 
    (1, 'Starting material', 'Organic compound for HPLC purity test', 1, 'Valid'),
    (1, 'Starting material 2', 'Chemical for NMR assay', 1, 'Valid');

INSERT INTO AnalyticalMethods (Name, Description, Status)
VALUES 
    ('HPLC Purity', 'HPLC for purity analysis', 'Active'),
	('1H-NMR Identity', '1H NMR to check the identity of a sample', 'Active'),
    ('1H-NMR Quantitative', '1H NMR for assay determination', 'Active');

INSERT INTO Analysts (Name, ContactInfo, Status)
VALUES 
    ('Dr. Carol Lee', 'carol.lee@example.com', 'Active');

INSERT INTO QuantitativeResults (SampleID, MethodID, AnalystID, ResultValue, Specification, PassFail, Status, PdfFilePath)
VALUES 
    (1, 1, 1, 98.5, 98.0, TRUE, 'Valid', NULL);  -- Quantitative result for HPLC, no PDF yet

INSERT INTO QualitativeResults (SampleID, MethodID, AnalystID, PassFail, Status, PdfFilePath)
VALUES 
    (1, 2, 1, TRUE, 'Valid', NULL);  -- Qualitative result for NMR, no PDF yet





-- Verify the structure and data
SELECT * FROM Operators;
SELECT * FROM Experiments;
SELECT * FROM Samples;
SELECT * FROM AnalyticalMethods;
SELECT * FROM Analysts;
SELECT * FROM QuantitativeResults;
SELECT * FROM QualitativeResults;
