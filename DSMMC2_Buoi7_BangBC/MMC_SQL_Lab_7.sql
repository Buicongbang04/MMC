USE Testing_System_Db;

-- Question 1: Tạo trigger không cho phép người dùng nhập vào Group có ngày tạo trước 1 năm trước
DROP TRIGGER IF EXISTS trigger_validate_input;
DELIMITER $$
CREATE TRIGGER trigger_validate_input
BEFORE INSERT ON `Group`
FOR EACH ROW
BEGIN
	IF NEW.CreateDate < DATE_ADD(NOW(), INTERVAL -1 YEAR) THEN
		SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT='Create date is long time ago.';
	END IF;
END$$
DELIMITER ;

-- Question 2: Tạo trigger Không cho phép người dùng thêm bất kỳ user nào vào
-- department "Sale" nữa, khi thêm thì hiện ra thông báo "Department "Sale" cannot add more user"
DROP TRIGGER IF EXISTS trigger_prevent_insert_to_sale;
DELIMITER $$
CREATE TRIGGER trigger_prevent_insert_to_sale
BEFORE INSERT ON Department
FOR EACH ROW
BEGIN
	IF NEW.DepartmentName = 'Sale' THEN
		SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT='Department "Sale" cannot add more user';
	END IF;
END$$
DELIMITER ;

-- Question 3: Cấu hình 1 group có nhiều nhất là 5 user
DROP FUNCTION IF EXISTS count_user;
DELIMITER $$
CREATE FUNCTION count_user(group_id VARCHAR(50)) RETURNS INT
BEGIN
	DECLARE count_account TINYINT;
	SELECT COUNT(*) INTO count_account
    FROM GroupAccount
    WHERE GroupID = group_id
    GROUP BY GroupID;
    RETURN count_account;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS trigger_prevent_insert_user;
DELIMITER $$
CREATE TRIGGER trigger_prevent_insert_user
BEFORE INSERT ON GroupAccount
FOR EACH ROW
BEGIN
	DECLARE count_account TINYINT;
    SET count_account = count_user(NEW.GroupID);
    
    IF count_account >= 5 THEN
		SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT='Cannot add more user to this group!';
	END IF;
END$$
DELIMITER ;

-- Question 4: Cấu hình 1 bài thi có nhiều nhất là 10 Question
DROP FUNCTION IF EXISTS count_question;
DELIMITER $$
CREATE FUNCTION count_question(exam_id TINYINT) RETURNS INT
BEGIN
	DECLARE num_question TINYINT;
	SELECT COUNT(*) INTO num_question
    FROM examquestion
    WHERE ExamID = exam_id
    GROUP BY ExamID;
    RETURN num_question;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS trigger_limit_question;
DELIMITER $$
CREATE TRIGGER trigger_limit_question
BEFORE INSERT ON ExamQuestion
FOR EACH ROW
BEGIN
	DECLARE count_question TINYINT;
    SET count_question = count_question(NEW.ExamID);
    
    IF count_question > 10 THEN
		SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT='Cannot add more question to this exam!';
	END IF;
END$$
DELIMITER ;

-- Question 5: Tạo trigger không cho phép người dùng xóa tài khoản có email là
-- admin@gmail.com (đây là tài khoản admin, không cho phép user xóa), còn lại các tài
-- khoản khác thì sẽ cho phép xóa và sẽ xóa tất cả các thông tin liên quan tới user đó.
DROP TRIGGER IF EXISTS trigger_prevent_delete_admin;
DELIMITER $$
CREATE TRIGGER trigger_prevent_delete_admin
BEFORE DELETE ON `Account`
FOR EACH ROW
BEGIN
    IF OLD.Email = 'admin@gmail.com' THEN
		SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT='User cannot delete this admin account';
        
	ELSE
		DELETE FROM `Account` WHERE AccountID = OLD.AccountID;
	END IF;
END$$
DELIMITER ;

-- Question 6: Không sử dụng cấu hình default cho field DepartmentID của table Account, 
-- hãy tạo trigger cho phép người dùng khi tạo account không điền vào departmentID thì sẽ được phân vào phòng ban "waiting Department".
DROP TRIGGER IF EXISTS trigger_default_department;
DELIMITER $$
CREATE TRIGGER trigger_default_department
BEFORE INSERT ON `Account`
FOR EACH ROW
BEGIN
    IF NEW.DepartmentID IS NULL
    THEN SET NEW.DepartmentID = 1;
    END IF;
END$$
DELIMITER ;

-- Question 7: Cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho mỗi question, trong đó có tối đa 2 đáp án đúng.
DROP FUNCTION IF EXISTS amount_question;
DELIMITER $$
CREATE FUNCTION amount_question(question_id TINYINT) RETURNS INT
BEGIN
	DECLARE amount TINYINT;
	SELECT count(questionID) INTO amount
	FROM answer
    WHERE questionID = question_id
	GROUP BY questionID;
    RETURN amount;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS correct_answer;
DELIMITER $$
CREATE FUNCTION correct_answer(question_id TINYINT) RETURNS INT
BEGIN
	DECLARE amount TINYINT;
	SELECT sum(isCorrect) INTO amount
	FROM answer
    WHERE questionID = question_id
	GROUP BY questionID;
    RETURN amount;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS trigger_config_exam;
DELIMITER $$
CREATE TRIGGER trigger_config_exam
BEFORE INSERT ON Answer
FOR EACH ROW
BEGIN
	DECLARE sl_answer 	TINYINT;
    DECLARE sl_correct 	TINYINT;
    SET sl_answer = amount_question(NEW.questionID);
    SET sl_correct = correct_answer(NEW.questionID);
    
    IF sl_answer >= 4 THEN 
		SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT='The amount of the answer is maximum';
	ELSEIF sl_correct = 2 THEN
		SIGNAL SQLSTATE '23456'
        SET MESSAGE_TEXT='This question already have 2 correct answer';
	END IF;    
END$$
DELIMITER ;

-- Question 8: Viết trigger sửa lại dữ liệu cho đúng:
-- ● Nếu người dùng nhập vào gender của account là nam, nữ, chưa xác định
-- ● Thì sẽ đổi lại thành M, F, U cho giống với cấu hình ở database
DROP TRIGGER IF EXISTS trigger_fix_information;
DELIMITER $$
CREATE TRIGGER trigger_fix_information
BEFORE INSERT ON `TABLE_NAME`
FOR EACH ROW
BEGIN
	 IF NEW.Gender = 'nam' THEN SET NEW.Gender = 'M';
     ELSEIF NEW.Gender = 'nu' THEN SET NEW.Gender = 'F';
     ELSE SET NEW.Gender = 'U';
     END IF;
END$$
DELIMITER ;

-- Question 9: Viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày
DROP TRIGGER IF EXISTS trigger_prevent_delete_exam;
DELIMITER $$
CREATE TRIGGER trigger_prevent_delete_exam
BEFORE DELETE ON Exam
FOR EACH ROW
BEGIN
	IF NOW() - OLD.CreateDate <= 2 THEN 
		SIGNAL SQLSTATE '23456'
        SET MESSAGE_TEXT='You cannot delete this exam by now.';
	END IF;
END$$
DELIMITER ;

-- Question 10: Viết trigger chỉ cho phép người dùng chỉ được update, delete các question khi question đó chưa nằm trong exam nào
DROP TRIGGER IF EXISTS trigger_limit_access_update;
DELIMITER $$
CREATE TRIGGER trigger_limit_access_update
BEFORE UPDATE ON Question
FOR EACH ROW
BEGIN
	IF OLD.questionID NOT IN (SELECT q.questionid
								  FROM ExamQuestion eq RIGHT JOIN Question q ON q.QuestionID = eq.QuestionID
								  WHERE eq.ExamID IS NULL) THEN
		SIGNAL SQLSTATE '23456'
        SET MESSAGE_TEXT='This question cannot access';
	END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS trigger_limit_access_delete;
DELIMITER $$
CREATE TRIGGER trigger_limit_access_delete
BEFORE DELETE ON Question
FOR EACH ROW
BEGIN
	IF OLD.questionID NOT IN (SELECT q.questionid
								  FROM ExamQuestion eq RIGHT JOIN Question q ON q.QuestionID = eq.QuestionID
								  WHERE eq.ExamID IS NULL) THEN
		SIGNAL SQLSTATE '23456'
        SET MESSAGE_TEXT='This question cannot access';
	END IF;
END$$
DELIMITER ;

-- Question 12: Lấy ra thông tin exam trong đó:
-- ● Duration <= 30 thì sẽ đổi thành giá trị "Short time"
-- ● 30 < Duration <= 60 thì sẽ đổi thành giá trị "Medium time"
-- ● Duration > 60 thì sẽ đổi thành giá trị "Long time"
SELECT ExamID, Code, Title,
CASE 
	WHEN Duration <= 30 THEN 'Short time'
    WHEN Duration <= 60 THEN 'Medium time'
    ELSE 'Long time'
END AS Duration
FROM exam;

-- Question 13: Thống kê số account trong mỗi group và in ra thêm 1 column nữa có tên là the_number_user_amount 
-- và mang giá trị được quy định như sau:
-- ● Nếu số lượng user trong group =< 5 thì sẽ có giá trị là few
-- ● Nếu số lượng user trong group <= 20 và > 5 thì sẽ có giá trị là normal
-- ● Nếu số lượng user trong group > 20 thì sẽ có giá trị là higher
SELECT GroupID,
CASE 
	WHEN COUNT(AccountID) <=  5 THEN 'FEW'
    WHEN COUNT(AccountID) <= 20 THEN 'NORMAL'
    ELSE 'HIGHER'
END AS the_number_user_amount
FROM groupaccount 
GROUP BY GroupID;

-- Question 14: Thống kê số mỗi phòng ban có bao nhiêu user, nếu phòng ban nào không có user thì sẽ thay đổi giá trị 0 thành "Không có User"
SELECT d.DEPARTMENTID, IF (COUNT(a.ACCOUNTID) = 0, 'KHÔNG CÓ USER', COUNT(a.ACCOUNTID)) AS NUMB_USER
FROM `ACCOUNT` a RIGHT JOIN DEPARTMENT d ON a.DEPARTMENTID = d.DEPARTMENTID
GROUP BY d.DEPARTMENTID;