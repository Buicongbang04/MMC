USE testing_system_db;
-- Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các account thuộc phòng ban đó
DROP PROCEDURE IF EXISTS Account_By_DepName;
DELIMITER $$
CREATE PROCEDURE Account_By_DepName (IN in_depName NVARCHAR(50))
BEGIN 
	SELECT *
	FROM `Account` a INNER JOIN department d ON a.DepartmentID = d.DepartmentID
	WHERE d.DepartmentName = in_depName;
END$$
DELIMITER ;

CALL Account_By_DepName(N'giám đốc');

-- Question 2: Tạo store để in ra số lượng account trong mỗi group
DROP PROCEDURE IF EXISTS SL_Account;
DELIMITER $$
CREATE PROCEDURE SL_Account()
BEGIN
	SELECT g.GroupID, COUNT(ga.AccountID) AS number_of_account
    FROM GroupAccount ga RIGHT JOIN `Group` g ON g.GroupID = ga.GroupID
    GROUP BY g.GroupID;
END$$
DELIMITER ;

CALL SL_Account();

-- Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo trong tháng hiện tại
DROP PROCEDURE IF EXISTS SL_Questions_In_Month;
DELIMITER $$
CREATE PROCEDURE SL_Questions_In_Month()
BEGIN
	SELECT tq.TypeID, tq.TypeName, COUNT(q.QuestionID) AS SL_Cau_hoi
	FROM question q LEFT JOIN typequestion tq ON q.TypeID = tq.TypeID
	WHERE MONTH(q.CreateDate) = MONTH(NOW())
	GROUP BY tq.TypeID, tq.TypeName;
END $$
DELIMITER ;

CALL SL_Questions_In_Month();

-- Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất
DROP PROCEDURE IF EXISTS max_sl_questions;
DELIMITER $$
CREATE PROCEDURE max_sl_questions()
BEGIN 
	SELECT tq.TypeID, tq.TypeName, COUNT(q.QuestionID) AS SL_Cau_hoi
	FROM question q LEFT JOIN typequestion tq ON q.TypeID = tq.TypeID
	WHERE MONTH(q.CreateDate) = 4
	GROUP BY tq.TypeID, tq.TypeName
    HAVING COUNT(q.QuestionID) >= ALL (SELECT COUNT(q.QuestionID)
									   FROM question q LEFT JOIN typequestion tq ON q.TypeID = tq.TypeID
									   WHERE MONTH(q.CreateDate) = 4
									   GROUP BY tq.TypeID, tq.TypeName);
END$$
DELIMITER ;

CALL max_sl_questions();

-- Question 5: Sử dụng store ở question 4 để tìm ra tên của type question
DROP PROCEDURE IF EXISTS max_type_question_name;
DELIMITER $$
CREATE PROCEDURE max_type_question_name(OUT type_name NVARCHAR(50))
BEGIN 
	SELECT tq.TypeName INTO type_name
	FROM question q LEFT JOIN typequestion tq ON q.TypeID = tq.TypeID
	WHERE MONTH(q.CreateDate) = 4
	GROUP BY tq.TypeID, tq.TypeName
    HAVING COUNT(q.QuestionID) >= ALL (SELECT COUNT(q.QuestionID)
									   FROM question q LEFT JOIN typequestion tq ON q.TypeID = tq.TypeID
									   WHERE MONTH(q.CreateDate) = 4
									   GROUP BY tq.TypeID, tq.TypeName);
END$$
DELIMITER ;

SET @type_name = '';
CALL max_type_question_name(@type_name);
SELECT @type_name;

-- Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên
-- chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa chuỗi của người dùng nhập vào
DROP PROCEDURE IF EXISTS find_string;
DELIMITER $$
CREATE PROCEDURE find_string(IN input NVARCHAR(50))
BEGIN 
	SELECT *
    FROM `Group`
    WHERE GroupName LIKE CONCAT('%', input, '%');
    
    SELECT *
    FROM `Account`
    WHERE Username LIKE CONCAT('%', input, '%');
END$$
DELIMITER ;

CALL find_string('system');

-- Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và trong store sẽ tự động gán:
-- username sẽ giống email nhưng bỏ phần @..mail đi
-- positionID: sẽ có default là developer
-- departmentID: sẽ được cho vào 1 phòng chờ
-- Sau đó in ra kết quả tạo thành công
DROP PROCEDURE IF EXISTS find_user;
DELIMITER $$
CREATE PROCEDURE find_user(IN inp_fullName 		NVARCHAR(50),
						   IN inp_email 	 	NVARCHAR(50),
						   OUT out_username 	NVARCHAR(50),
						   OUT out_positionID 	TINYINT,
					       OUT out_departmentID TINYINT)
BEGIN 
	SELECT SUBSTRING_INDEX(Email, '@', 1) INTO out_username 
	FROM (SELECT Email
		  FROM `Account`
		  WHERE FullName = inp_fullname 
		  AND Email = inp_email) AS T;
          
	SELECT PositionID INTO out_positionID 
    FROM (SELECT PositionID
		  FROM `Account`
		  WHERE FullName = inp_fullname 
		  AND Email = inp_email) AS T;
    
	SELECT DepartmentID INTO out_departmentID 
    FROM (SELECT DepartmentID
		  FROM `Account`
		  WHERE FullName = inp_fullname 
		  AND Email = inp_email) AS T;
END$$
DELIMITER ;

CALL find_user('Bùi Công Bằng', 'buicongbang1010@gmail.com', @out_username, @out_positionID, @out_departmentID);
SELECT @out_username, @out_positionID, @out_departmentID;

-- Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice 
-- để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất
DROP PROCEDURE IF EXISTS longest_content;
DELIMITER $$
CREATE PROCEDURE longest_content(IN keyword ENUM('Esssay', 'Multiple-Choice'))
BEGIN 
	SELECT q.*
	FROM question q JOIN typequestion tq ON q.TypeID = tq.TypeID
    WHERE tq.TypeName = keyword
    AND LENGTH(q.Content) >= ALL(SELECT LENGTH(q.Content)
								 FROM question q JOIN typequestion tq ON q.TypeID = tq.TypeID
								 WHERE tq.TypeName = keyword);
END$$
DELIMITER ;

CALL longest_content('Multiple-Choice');

-- Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID
DROP PROCEDURE IF EXISTS delete_exam_by_ID;
DELIMITER $$
CREATE PROCEDURE delete_exam_by_ID(IN ID TINYINT)
BEGIN 
	DELETE FROM Exam
    WHERE ExamID = ID;
END$$
DELIMITER ;

CALL delete_exam_by_ID(2);
SELECT * FROM Exam;

-- Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi (sử dụng store ở câu 9 để xóa)
-- Sau đó in số lượng record đã remove từ các table liên quan trong khi removing
DROP PROCEDURE IF EXISTS find_year_and_delete;
DELIMITER $$
CREATE PROCEDURE find_year_and_delete()
BEGIN 
	
END$$
DELIMITER ;

CALL find_year_and_delete();

-- Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách người dùng nhập
-- vào tên phòng ban và các account thuộc phòng ban đó sẽ được chuyển về phòng ban
-- default là phòng ban chờ việc
DROP PROCEDURE IF EXISTS delete_department;
DELIMITER $$
CREATE PROCEDURE delete_department(IN inp_departmentName NVARCHAR(50))
BEGIN 
	DECLARE DeptID TINYINT;
    DECLARE defaultID TINYINT;
    
    SELECT DepartmentID INTO defaultID FROM Department
    WHERE DepartmentName = N'Chờ việc';
    
    SELECT DepartmentID INTO DeptID FROM Department
    WHERE DepartmentName = inp_departmentName;
     
	UPDATE `Account` SET DepartmentID = defaultID
    WHERE DepartmentID = DeptID;  
    
	DELETE FROM Department
    WHERE DepartmentID = DeptID;
END$$
DELIMITER ;

CALL delete_department('Bảo vệ');

-- Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay
DROP PROCEDURE IF EXISTS number_of_question_in_year;
DELIMITER $$
CREATE PROCEDURE number_of_question_in_year()
BEGIN     
	DECLARE this_year INT;
    SET this_year = YEAR(NOW());
	
    SELECT MONTH(CreateDate) AS 'Month', COUNT(QuestionID) AS SL_cau_hoi
    FROM Question
    WHERE YEAR(CreateDate) = this_year
    GROUP BY MONTH(CreateDate);
END$$
DELIMITER ;

CALL number_of_question_in_year();

-- Question 13: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6 tháng
-- gần đây nhất (Nếu tháng nào không có thì sẽ in ra là "không có câu hỏi nào trong tháng")
DROP PROCEDURE IF EXISTS question_in_closed_6_month;
DELIMITER $$
CREATE PROCEDURE question_in_closed_6_month()
BEGIN     
	DECLARE start_date DATE;
    DECLARE end_date DATE;
    SET start_date = DATE_ADD(NOW(), INTERVAL -6 MONTH);
    SET end_date = NOW();
    
    DROP TABLE IF EXISTS Closed_Month;
	CREATE TABLE Closed_Month(
		start_month INT
    );
    
    WHILE (start_date <= end_date) DO 
		INSERT INTO Closed_Month(start_month) VALUES (MONTH(start_date));
        SET start_date = DATE_ADD(start_date, INTERVAL 1 MONTH);
    END WHILE;
	
    SELECT t.`MONTH`, IFNULL(t.SL_cau_hoi, N'Chưa có câu hỏi được tạo!') AS SL_cau_hoi
    FROM Closed_Month cm LEFT JOIN (SELECT MONTH(CreateDate) AS 'MONTH', COUNT(QuestionID) AS SL_cau_hoi
									FROM Question
									WHERE MONTH(CreateDate) BETWEEN MONTH(DATE_ADD(NOW(), INTERVAL -6 MONTH)) AND MONTH(MONTH(NOW()))
									GROUP BY MONTH(CreateDate)) AS t ON cm.start_month = t.`MONTH`
	ORDER BY cm.start_month;
    DROP TABLE IF EXISTS Closed_Month;
END$$
DELIMITER ;

CALL question_in_closed_6_month();
