-- Barthel Index Database Schema for SQL Server
-- This script creates the necessary tables for managing Barthel Index evaluations

-- Drop existing tables if they exist
IF OBJECT_ID('dbo.BarthelEvaluations', 'U') IS NOT NULL
    DROP TABLE dbo.BarthelEvaluations;

IF OBJECT_ID('dbo.Patients', 'U') IS NOT NULL
    DROP TABLE dbo.Patients;

-- Create Patients table
CREATE TABLE dbo.Patients (
    PatientID VARCHAR(50) PRIMARY KEY,
    PatientName NVARCHAR(100) NOT NULL,
    DateOfBirth DATE NULL,
    Gender CHAR(1) NULL,  -- M/F
    CreatedDate DATETIME DEFAULT GETDATE(),
    UpdatedDate DATETIME DEFAULT GETDATE()
);

-- Create BarthelEvaluations table
CREATE TABLE dbo.BarthelEvaluations (
    EvaluationID INT IDENTITY(1,1) PRIMARY KEY,
    PatientID VARCHAR(50) NOT NULL,
    EvaluationType VARCHAR(20) NOT NULL,  -- 'Admission' or 'Discharge'
    EvaluationDate DATE NOT NULL,

    -- Barthel Index Items (0-10 or 0-15 points)
    Item1_Feeding INT NULL CHECK (Item1_Feeding IN (0, 5, 10)),
    Item2_Transfer INT NULL CHECK (Item2_Transfer IN (0, 5, 10, 15)),
    Item3_Grooming INT NULL CHECK (Item3_Grooming IN (0, 5)),
    Item4_ToiletUse INT NULL CHECK (Item4_ToiletUse IN (0, 5, 10)),
    Item5_Bathing INT NULL CHECK (Item5_Bathing IN (0, 5)),
    Item6_Mobility INT NULL CHECK (Item6_Mobility IN (0, 5, 10, 15)),
    Item7_Stairs INT NULL CHECK (Item7_Stairs IN (0, 5, 10)),
    Item8_Dressing INT NULL CHECK (Item8_Dressing IN (0, 5, 10)),
    Item9_BowelControl INT NULL CHECK (Item9_BowelControl IN (0, 5, 10)),
    Item10_BladderControl INT NULL CHECK (Item10_BladderControl IN (0, 5, 10)),

    -- Total Score (0-100)
    TotalScore INT NULL CHECK (TotalScore >= 0 AND TotalScore <= 100),

    -- Metadata
    Notes NVARCHAR(500) NULL,
    EvaluatorName NVARCHAR(100) NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    UpdatedDate DATETIME DEFAULT GETDATE(),

    -- Foreign Key
    CONSTRAINT FK_Evaluations_Patients FOREIGN KEY (PatientID)
        REFERENCES dbo.Patients(PatientID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    -- Unique constraint: One evaluation per type per patient per date
    CONSTRAINT UQ_Patient_Type_Date UNIQUE (PatientID, EvaluationType, EvaluationDate)
);

-- Create indexes for better performance
CREATE INDEX IX_Evaluations_PatientID ON dbo.BarthelEvaluations(PatientID);
CREATE INDEX IX_Evaluations_Date ON dbo.BarthelEvaluations(EvaluationDate);
CREATE INDEX IX_Evaluations_Type ON dbo.BarthelEvaluations(EvaluationType);

-- Insert sample data (optional)
-- INSERT INTO dbo.Patients (PatientID, PatientName, DateOfBirth, Gender)
-- VALUES
--     ('P001', 'Taro Yamada', '1950-01-15', 'M'),
--     ('P002', 'Hanako Suzuki', '1945-03-20', 'F');

-- INSERT INTO dbo.BarthelEvaluations
--     (PatientID, EvaluationType, EvaluationDate,
--      Item1_Feeding, Item2_Transfer, Item3_Grooming, Item4_ToiletUse, Item5_Bathing,
--      Item6_Mobility, Item7_Stairs, Item8_Dressing, Item9_BowelControl, Item10_BladderControl,
--      TotalScore, EvaluatorName)
-- VALUES
--     ('P001', 'Admission', '2025-10-01', 5, 5, 0, 5, 0, 5, 0, 5, 5, 5, 35, 'Dr. Smith'),
--     ('P001', 'Discharge', '2025-10-28', 10, 15, 5, 10, 5, 15, 10, 10, 10, 10, 100, 'Dr. Smith');

GO

-- Create a view for easy querying with improvement calculation
CREATE VIEW dbo.vw_PatientEvaluationSummary AS
SELECT
    p.PatientID,
    p.PatientName,
    adm.EvaluationDate AS AdmissionDate,
    adm.TotalScore AS AdmissionScore,
    dis.EvaluationDate AS DischargeDate,
    dis.TotalScore AS DischargeScore,
    (dis.TotalScore - adm.TotalScore) AS ScoreImprovement,
    CASE
        WHEN dis.TotalScore IS NULL THEN 'In Progress'
        WHEN dis.TotalScore >= 100 THEN 'Independent'
        WHEN dis.TotalScore >= 60 THEN 'Mild Dependency'
        WHEN dis.TotalScore >= 40 THEN 'Moderate Dependency'
        WHEN dis.TotalScore >= 20 THEN 'Severe Dependency'
        ELSE 'Total Dependency'
    END AS DischargeStatus
FROM
    dbo.Patients p
LEFT JOIN
    dbo.BarthelEvaluations adm ON p.PatientID = adm.PatientID AND adm.EvaluationType = 'Admission'
LEFT JOIN
    dbo.BarthelEvaluations dis ON p.PatientID = dis.PatientID AND dis.EvaluationType = 'Discharge';

GO

-- Grant permissions (adjust as needed)
-- GRANT SELECT, INSERT, UPDATE ON dbo.Patients TO YourDatabaseUser;
-- GRANT SELECT, INSERT, UPDATE ON dbo.BarthelEvaluations TO YourDatabaseUser;
-- GRANT SELECT ON dbo.vw_PatientEvaluationSummary TO YourDatabaseUser;

PRINT 'Database schema created successfully!';
