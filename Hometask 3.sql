-- Hometask 3

-- 1. Several grouping queries. Include HAVING clause ✅
-- 2. Use INSERT SELECT statement ✅
-- 3. Use TRUNCATE statement ✅
-- 4. Use DELETE based on JOIN ✅
-- 5. Use UPDATE based on JOIN ✅
-- 6. Rewrite an UPDATE based on JOIN with MERGE COMMAND ✅


-- 1 --

-- GROUP BY
SELECT Gender, COUNT(Users.Gender) AS GenderCount FROM Users
INNER JOIN Clients ON Clients.Id = Users.Id
GROUP BY Gender

-- HAVING
SELECT Age, COUNT(Users.Age) AS AgeCountColumn FROM Users
GROUP BY Age
HAVING Age > 30

-- 2 --

-- INSERT SELECT
CREATE TABLE NewTable(
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Email NVARCHAR(100) NOT NULL UNIQUE
)

INSERT INTO NewTable SELECT FirstName, LastName, Email FROM Users 
WHERE Users.Age > 30
SELECT * FROM NewTable

-- 3 --

-- TRUNCATE
TRUNCATE TABLE NewTable
SELECT * FROM NewTable

DECLARE @FillInQuery NVARCHAR(200) = 'INSERT INTO NewTable SELECT FirstName, LastName, Email FROM Users 
WHERE Users.Age > 30
SELECT * FROM NewTable';

EXEC Sp_ExecuteSQL @FillInQuery
SELECT * FROM NewTable

-- 4 --

-- DELETE & JOIN
DELETE FROM [Services]
FROM [Services] INNER JOIN Specialists ON Specialists.Id = [Services].SpecialistId
WHERE Specialists.Domain LIKE 'M%'

SELECT * FROM [Services]
SELECT * FROM Specialists

-- 5 --

-- UPDATE & JOIN
UPDATE [Services]
SET [Services].Price = Specialists.WorkExperience * [Services].Price
FROM [Services]
INNER JOIN Specialists ON Specialists.Id = [Services].SpecialistId

-- 6 --

-- UPDATE & MERGE
CREATE TABLE SpecialistsSource(
    Id INT PRIMARY KEY,
    [Name] VARCHAR(50) NOT NULL,
    NumberOfClients INT NOT NULL,
	Price DECIMAL(10, 2) NOT NULL
)

CREATE TABLE SpecialistsTarget(
    Id INT PRIMARY KEY,
    [Name] VARCHAR(50) NOT NULL,
    NumberOfClients INT NOT NULL,
	Price DECIMAL(10, 2) NOT NULL
)
    
INSERT INTO SpecialistsSource(Id, [Name], NumberOfClients, Price) VALUES(1, 'John', 43, 120)
INSERT INTO SpecialistsSource(Id, [Name], NumberOfClients, Price) VALUES(2, 'Helga', 27, 150)
INSERT INTO SpecialistsSource(Id, [Name], NumberOfClients, Price) VALUES(3, 'Sia', 12, 70)
INSERT INTO SpecialistsSource(Id, [Name], NumberOfClients, Price) VALUES(4, 'Rogger', 53, 200)
    
INSERT INTO SpecialistsTarget(Id, [Name], NumberOfClients, Price) VALUES(1, 'John', 43, 100)
INSERT INTO SpecialistsTarget(Id, [Name], NumberOfClients, Price) VALUES(2, 'Helga', 27, 100)
INSERT INTO SpecialistsTarget(Id, [Name], NumberOfClients, Price) VALUES(5, 'Adams', 55, 145)
INSERT INTO SpecialistsTarget(Id, [Name], NumberOfClients, Price) VALUES(6, 'Sam', 11, 65)

SELECT * FROM SpecialistsSource
SELECT * FROM SpecialistsTarget

MERGE SpecialistsTarget AS Target
USING SpecialistsSource	AS Source
ON Source.Id = Target.Id
    
WHEN NOT MATCHED BY Target THEN
    INSERT (Id, [Name], NumberOfClients, Price) 
    VALUES (Source.Id, Source.[Name], Source.NumberOfClients, Source.Price)
    
WHEN MATCHED THEN UPDATE SET
    Target.[Name] = Source.[Name],
    Target.NumberOfClients = Source.NumberOfClients,
	Target.Price = Source.Price;

SELECT * FROM SpecialistsSource
SELECT * FROM SpecialistsTarget