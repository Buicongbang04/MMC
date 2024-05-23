-- Active: 1716210568065@@127.0.0.1@3306@testing_system_db
USE testing_system_db;

-- Question 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban sale
CREATE VIEW vw_SaleEmployee AS
SELECT `AccountID`,  `Username`, `Email`, `DepartmentID`
FROM `Account` 
WHERE `DepartmentID` = (SELECT `DepartmentID` 
                        FROM department 
                        WHERE `DepartmentName` = 'Sale');

SELECT * FROM vw_SaleEmployee

-- Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nhất
CREATE VIEW vw_MostGroupAccount AS
SELECT a.*
FROM `account` a JOIN `groupaccount` ga ON a.`AccountID` = ga.`AccountID`
GROUP BY a.`AccountID`
HAVING COUNT(ga.`GroupID`) = (SELECT MAX(NumOfGroup) 
                              FROM (SELECT COUNT(`GroupID`) AS NumOfGroup 
                                    FROM `groupaccount` 
                                    GROUP BY `AccountID`) AS temp);

SELECT * FROM vw_MostGroupAccount;

-- Question 3: Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ được coi là quá dài) và xóa nó đi
CREATE VIEW vw_LongContentQuestion AS
SELECT *
FROM `question`
WHERE LENGTH(`Content`) > 300;

DELETE FROM `question`
WHERE `QuestionID` IN (SELECT `QuestionID` FROM vw_LongContentQuestion);
-- Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất
DROP VIEW IF EXISTS vw_MostEmployeeDepartment;
CREATE VIEW vw_MostEmployeeDepartment AS
SELECT d.`DepartmentID`, d.`DepartmentName`, COUNT(a.`AccountID`) AS NumOfEmployee
FROM `department` d JOIN `account` a ON d.`DepartmentID` = a.`DepartmentID`
GROUP BY d.`DepartmentID`
HAVING COUNT(a.`AccountID`) >= ALL(SELECT COUNT(a.`AccountID`)
                                   FROM `department` d JOIN `account` a ON d.`DepartmentID` = a.`DepartmentID`
                                   GROUP BY d.`DepartmentID`);
-- Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo
DROP VIEW IF EXISTS vw_NguyenQuestion;
CREATE VIEW vw_NguyenQuestion AS
SELECT *
FROM `question`
WHERE `CreatorID` IN (SELECT `AccountID` 
                      FROM `account` 
                      WHERE `FullName` LIKE 'Nguyen%' OR `FullName` LIKE 'Nguyễn%');

