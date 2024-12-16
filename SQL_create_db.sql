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

-- Create Analysts table
CREATE TABLE Analysts (
    AnalystID INT PRIMARY KEY AUTO_INCREMENT,
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





ALTER TABLE Experiments AUTO_INCREMENT = 1000;
ALTER TABLE Samples AUTO_INCREMENT = 2000;
ALTER TABLE AnalyticalMethods AUTO_INCREMENT = 3000;
ALTER TABLE QuantitativeResults AUTO_INCREMENT = 4000;
ALTER TABLE QualitativeResults AUTO_INCREMENT = 5000;
ALTER TABLE Operators AUTO_INCREMENT = 6000;
ALTER TABLE Analysts AUTO_INCREMENT = 7000;


-- Insert sample data for Operators
INSERT INTO Operators (Name, ContactInfo, Status)
VALUES 
    ('Alice Johnson', 'alice.johnson@example.com', 'Active'),
    ('Bob Smith', 'bob.smith@example.com', 'Active'),
    ('Cathy Brown', 'cathy.brown@example.com', 'Inactive'),
    ('David Wilson', 'david.wilson@example.com', 'Active'),
    ('Evelyn Davis', 'evelyn.davis@example.com', 'Inactive');

-- Insert sample data for Experiments
INSERT INTO Experiments (Name, Status, StartDate, EndDate, Description, OperatorID)
VALUES 
    ('Trinitrotoluene', 'Ongoing', '2024-12-07', NULL, 'Synthesis of Trinitrotoluene', 6000),
    ('Acetaminophen', 'Planned', '2024-12-10', NULL, 'Development of pain reliever', 6001),
    ('Ibuprofen', 'Finished', '2024-12-01', '2024-12-07', 'Process optimization for ibuprofen', 6002),
    ('Paracetamol', 'Cancelled', '2024-12-05', '2024-12-06', 'Trial batch for paracetamol production', 6003),
    ('Aspirin', 'Ongoing', '2024-12-08', NULL, 'Synthesis of acetylsalicylic acid', 6004);

-- Insert sample data for Samples
INSERT INTO Samples (ExperimentID, Name, Description, OperatorID, Status)
VALUES 
    (1000, 'Starting material', 'Organic compound for HPLC purity test', 6000, 'Valid'),
    (1000, 'Intermediate compound', 'Intermediate for GC-MS analysis', 6001, 'Rejected'),
    (1001, 'Final product', 'Product for assay determination', 6002, 'Valid'),
    (1002, 'Control sample', 'Standard for validation study', 6003, 'Valid'),
    (1003, 'Unknown sample', 'Sample for identity testing', 6004, 'Rejected');

-- Insert sample data for AnalyticalMethods
INSERT INTO AnalyticalMethods (Name, Description, Status)
VALUES 
    ('HPLC Purity', 'HPLC for purity analysis', 'Active'),
	('1H-NMR Identity', '1H NMR to check the identity of a sample', 'Active'),
    ('1H-NMR Quantitative', '1H NMR for assay determination', 'Active'),
    ('GC-MS Analysis', 'Gas Chromatography-Mass Spectrometry', 'Inactive'),
    ('UV-Vis Spectroscopy', 'UV-Vis for concentration analysis', 'Active');

-- Insert sample data for Analysts
INSERT INTO Analysts (Name, ContactInfo, Status)
VALUES 
    ('Dr. Carol Lee', 'carol.lee@example.com', 'Active'),
    ('Dr. Mark Taylor', 'mark.taylor@example.com', 'Active'),
    ('Dr. Nancy Hall', 'nancy.hall@example.com', 'Inactive'),
    ('Dr. Peter Adams', 'peter.adams@example.com', 'Active'),
    ('Dr. Linda Green', 'linda.green@example.com', 'Inactive');

INSERT INTO QuantitativeResults (SampleID, MethodID, AnalystID, ResultValue, Specification, PassFail, Status, PdfFilePath)
VALUES 
    (2000, 3000, 7000, 98.5, 98.0, TRUE, 'Valid', 'static/uploads/hplc_report.pdf'),
    (2001, 3000, 7001, 95.2, 95.0, TRUE, 'Valid', 'static/uploads/hplc_report.pdf'),
    (2002, 3000, 7002, 89.7, 90.0, FALSE, 'Valid', 'static/uploads/hplc_report.pdf'),
    (2003, 3000, 7003, 99.0, 98.5, TRUE, 'Valid', 'static/uploads/hplc_report.pdf'),
    (2004, 3000, 7004, 91.3, 92.0, FALSE, 'Valid', 'static/uploads/hplc_report.pdf');


INSERT INTO QualitativeResults (SampleID, MethodID, AnalystID, PassFail, Status, PdfFilePath)
VALUES 
    (2000, 3001, 7000, TRUE, 'Valid', 'static/uploads/nmr_report.pdf'),
    (2001, 3001, 7001, FALSE, 'Valid', 'static/uploads/nmr_report.pdf'),
    (2002, 3001, 7002, TRUE, 'Valid', 'static/uploads/nmr_report.pdf'),
    (2003, 3001, 7003, TRUE, 'Valid', 'static/uploads/nmr_report.pdf'),
    (2004, 3001, 7004, FALSE, 'Valid', 'static/uploads/nmr_report.pdf');





-- Verify the structure and data
SELECT * FROM Operators;
SELECT * FROM Experiments;
SELECT * FROM Samples;
SELECT * FROM AnalyticalMethods;
SELECT * FROM Analysts;
SELECT * FROM QuantitativeResults;
SELECT * FROM QualitativeResults;
