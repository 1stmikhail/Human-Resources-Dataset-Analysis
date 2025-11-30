CREATE DATABASE EMPLOYEES;
GO
USE EMPLOYEES;
GO

CREATE TABLE employee_master (
    EmployeeNumber INT PRIMARY KEY,
    Age INT,
    Gender VARCHAR(10),
    MaritalStatus VARCHAR(20),
    HireDate DATE,
    TerminationDate DATE,
    Tenure FLOAT
);

CREATE TABLE job_info (
    EmployeeNumber INT PRIMARY KEY,
    JobRole VARCHAR(50),
    JobLevel INT,
    Education INT,
    EducationField VARCHAR(50)
);

CREATE TABLE salary (
    EmployeeNumber INT PRIMARY KEY,
    MonthlyIncome DECIMAL(10,2),
    PercentSalaryHike INT,
    StockOptionLevel INT
);

CREATE TABLE department (
    EmployeeNumber INT PRIMARY KEY,
    Department VARCHAR(50),
    BusinessTravel VARCHAR(50),
    DistanceFromHome INT
);

CREATE TABLE attrition (
    EmployeeNumber INT PRIMARY KEY,
    Attrition VARCHAR(10),
    PerformanceRating INT,
    JobSatisfaction INT,
    EnvironmentSatisfaction INT
); 

BULK INSERT employee_master
FROM 'C:\HRData\employee_master.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

BULK INSERT job_info
FROM 'C:\HRData\job_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

BULK INSERT salary
FROM 'C:\HRData\salary.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

BULK INSERT department
FROM 'C:\HRData\department.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

BULK INSERT attrition
FROM 'C:\HRData\attrition.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

SELECT 'employee_master' AS TableName, EmployeeNumber, COUNT(*) as Dupes
FROM employee_master GROUP BY EmployeeNumber HAVING COUNT(*) > 1;

SELECT * FROM employee_master
WHERE Age IS NULL OR Gender IS NULL OR HireDate IS NULL;

SELECT m.EmployeeNumber, 'Missing in Salary' as Issue
FROM employee_master m
LEFT JOIN salary s ON m.EmployeeNumber = s.EmployeeNumber
WHERE s.EmployeeNumber IS NULL;

SELECT 
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRate
FROM attrition;

SELECT 
    d.Department,
    ROUND(SUM(CASE WHEN a.Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRate
FROM attrition a
JOIN department d ON a.EmployeeNumber = d.EmployeeNumber
GROUP BY d.Department;