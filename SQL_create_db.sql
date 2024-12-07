-- Create the database from scratch
DROP DATABASE IF EXISTS LabDatabase;
CREATE DATABASE LabDatabase;
USE LabDatabase;

-- Create Operators table
CREATE TABLE Operators (
    OperatorID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    ContactInfo TEXT
);

-- Create Experiments table
CREATE TABLE Experiments (
    ExperimentID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
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
    FOREIGN KEY (ExperimentID) REFERENCES Experiments(ExperimentID),
    FOREIGN KEY (OperatorID) REFERENCES Operators(OperatorID)
);

-- Create AnalyticalMethods table
CREATE TABLE AnalyticalMethods (
    MethodID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Description TEXT
);

-- Create Analysts table
CREATE TABLE Analysts (
    AnalystID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    ContactInfo TEXT
);

-- Create AnalyticalTasks table
CREATE TABLE AnalyticalTasks (
    TaskID INT PRIMARY KEY AUTO_INCREMENT,
    SampleID INT,
    MethodID INT,
    AnalystID INT,
    ResultValue VARCHAR(100),
    Specification VARCHAR(100),
    PassFail BOOLEAN,
    FOREIGN KEY (SampleID) REFERENCES Samples(SampleID),
    FOREIGN KEY (MethodID) REFERENCES AnalyticalMethods(MethodID),
    FOREIGN KEY (AnalystID) REFERENCES Analysts(AnalystID)
);

-- Insert data into Operators
INSERT INTO Operators (Name, ContactInfo)
VALUES 
    ('Alice Johnson', 'alice.johnson@example.com'),
    ('Bob Smith', 'bob.smith@example.com');

-- Insert data into Experiments
INSERT INTO Experiments (Name, StartDate, EndDate, Description, OperatorID)
VALUES 
    ('HPLC Analysis Experiment', '2024-01-01', '2024-01-10', 'Analysis of sample purity using HPLC', 1),
    ('NMR Experiment', '2024-02-01', '2024-02-05', 'Assay determination using NMR', 2);

-- Insert data into Samples, including OperatorID
INSERT INTO Samples (ExperimentID, Name, Description, OperatorID)
VALUES 
    (1, 'Sample A', 'Organic compound for HPLC purity test', 1),
    (1, 'Sample B', 'Organic compound for NMR assay', 1),
    (2, 'Sample C', 'Chemical for NMR testing', 2);

-- Insert data into AnalyticalMethods
INSERT INTO AnalyticalMethods (Name, Description)
VALUES 
    ('HPLC Purity Test', 'High-performance liquid chromatography for purity analysis'),
    ('NMR Assay', 'Nuclear magnetic resonance for assay determination');

-- Insert data into Analysts
INSERT INTO Analysts (Name, ContactInfo)
VALUES 
    ('Dr. Carol Lee', 'carol.lee@example.com'),
    ('Dr. David Brown', 'david.brown@example.com');

-- Insert data into AnalyticalTasks
INSERT INTO AnalyticalTasks (SampleID, MethodID, AnalystID, ResultValue, Specification, PassFail)
VALUES 
    (1, 1, 1, '98.5%', '>= 98%', TRUE), 
    (2, 2, 2, '95.0%', '>= 95%', TRUE), 
    (3, 2, 1, '92.0%', '>= 95%', FALSE);

-- Verify the structure and data
SELECT * FROM Operators;
SELECT * FROM Experiments;
SELECT * FROM Samples;
SELECT * FROM AnalyticalMethods;
SELECT * FROM Analysts;
SELECT * FROM AnalyticalTasks;
