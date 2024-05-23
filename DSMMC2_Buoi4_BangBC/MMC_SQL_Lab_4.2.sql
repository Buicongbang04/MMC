USE testing_system_db;

-- EXERCISE 1
-- Question 1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
SELECT a.accountID , a.email, a.username, a.fullname, d.departmentid, d.departmentname
FROM `account` a JOIN department d ON a.DepartmentID = d.DepartmentID;

-- Question 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010
SELECT * 
FROM `account`
WHERE createdate > '2010-12-20';

-- Question 3: Viết lệnh để lấy ra tất cả các developer
SELECT *
FROM `Account` a JOIN Positions p on a.positionid = p.positionid
WHERE p.positionname = 'dev';

-- Question 4: Viết lệnh để lấy ra danh sách các phòng ban có > 3 nhân viên
SELECT d.departmentid, d.departmentname, COUNT(a.accountID) AS number_of_account
FROM `account` a JOIN department d ON a.departmentid = d.departmentid
GROUP BY d.departmentid, d.departmentname
HAVING COUNT(a.accountID) > 3;

-- Question 5: Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhất
SELECT q.QuestionID, q.Content, COUNT(e.ExamID) AS usetime
FROM ExamQuestion e JOIN Question q ON e.QuestionID = q.QuestionID
GROUP BY q.QuestionID, q.Content
HAVING COUNT(e.ExamID) = (select max(usetime)
							  from (SELECT q.QuestionID, q.Content, COUNT(e.ExamID) usetime
									FROM ExamQuestion e JOIN Question q ON e.QuestionID = q.QuestionID
									GROUP BY q.QuestionID, q.Content) AS T);
                                    
-- Question 6: Thông kê mỗi category Question được sử dụng trong bao nhiêu Question
SELECT c.categoryID, c.CategoryName, COUNT(q.questionid) AS 'Usages'
FROM CategoryQuestion c JOIN Question q ON c.CategoryID = q.CategoryID
GROUP BY c.CategoryID, CategoryName;

-- Question 7: Thông kê mỗi Question được sử dụng trong bao nhiêu Exam
SELECT q.questionid, q.content, COUNT(e.examid) AS 'Exam_usages'
FROM EXAM e JOIN QUESTION q ON e.categoryId = q.categoryId
GROUP BY q.questionid, q.content;

-- Question 8: Lấy ra Question có nhiều câu trả lời nhất
SELECT q.QuestionID, q.Content, COUNT(AnswerID) AS Number_of_answers
FROM Answer a JOIN Question q ON a.QuestionID = q.QuestionID
GROUP BY q.QuestionID, q.Content
HAVING COUNT(AnswerID) >= ALL(SELECT COUNT(AnswerID) AS Number_of_answers
							  							FROM Answer a JOIN Question q ON a.QuestionID = q.QuestionID
							  							GROUP BY q.QuestionID, q.Content); 

-- Question 9: Thống kê số lượng account trong mỗi group
SELECT GroupId, COUNT(AccountID) AS Number_of_account
FROM GroupAccount
GROUP BY groupid;

-- Question 10: Tìm chức vụ có ít người nhất                               
SELECT p.*, T.SL_Nhan_Su
FROM Positions p JOIN (SELECT PositionID, COUNT(AccountID) AS SL_Nhan_Su
						FROM `Account`
						GROUP BY PositionID
						HAVING COUNT(AccountID) <= All(SELECT COUNT(AccountID)
													   FROM `Account`
													   GROUP BY PositionID)) AS T
				 ON p.PositionID = T.PositionID;

-- Question 11: Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM
SELECT d.DepartmentID, d.DepartmentName, p.PositionName, COUNT(p.PositionID) AS SL_Nhan_Su
FROM Department d JOIN `Account` a ON d.DepartmentID = a.DepartmentID
				  JOIN Positions p ON p.PositionID = a.PositionID
GROUP BY d.DepartmentID, d.DepartmentName, p.PositionName
ORDER BY `DepartmentName`;

-- Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của
-- question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, …
SELECT q.QuestionID, q.Content, cq.CategoryName, tq.TypeName, a.FullName, q.CreateDate
FROM Question q JOIN CategoryQuestion cq ON q.CategoryID = cq.CategoryID
				JOIN TypeQuestion tq ON q.TypeID = tq.TypeID
                JOIN `Account` a ON q.CreatorID = a.AccountID;

-- Question 13: Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
SELECT TypeName, COUNT(QuestionID) AS SL_cau_hoi
FROM (SELECT q.QuestionID, q.Content, cq.CategoryName, tq.TypeName, a.FullName, q.CreateDate
	  FROM Question q JOIN CategoryQuestion cq ON q.CategoryID = cq.CategoryID
					  JOIN TypeQuestion tq ON q.TypeID = tq.TypeID
					  JOIN `Account` a ON q.CreatorID = a.AccountID) AS T
GROUP BY T.TypeName;

-- Question 14: Lấy ra group không có account nào
SELECT g.*
FROM `Group` g LEFT JOIN GroupAccount ga ON g.GroupID = ga.GroupID
WhERE ga.GroupID IS NULL;

-- Question 15: Lấy ra group không có account nào
SELECT *
FROM `Group` 
WhERE GroupID NOT IN (SELECT GroupID 
						FROM GroupAccount);

-- Question 16: Lấy ra question không có answer nào
SELECT q.*
FROM Question q LEFT JOIN Answer a ON q.QuestionID = a.QuestionID
WHERE a.QuestionID IS NULL;


-- Exercise 2: Union
-- Question 17:
-- a) Lấy các account thuộc nhóm thứ 1
SELECT AccountID
FROM GroupAccount
WHERE GroupID = 1;
-- b) Lấy các account thuộc nhóm thứ 2
SELECT AccountID
FROM GroupAccount
WHERE GroupID = 2;
-- c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau
SELECT AccountID
FROM GroupAccount
WHERE GroupID = 1
UNION
SELECT AccountID
FROM GroupAccount
WHERE GroupID = 2;
-- Question 18:
-- a) Lấy các group có lớn hơn 5 thành viên
SELECT GroupID
FROM GroupAccount
GROUP BY GroupID
HAVING COUNT(AccountID) > 5;
-- b) Lấy các group có nhỏ hơn 7 thành viên
SELECT GroupID
FROM GroupAccount
GROUP BY GroupID
HAVING COUNT(AccountID) < 7;
-- c) Ghép 2 kết quả từ câu a) và câu b)
SELECT GroupID
FROM GroupAccount
GROUP BY GroupID
HAVING COUNT(AccountID) > 5
UNION
SELECT GroupID
FROM GroupAccount
GROUP BY GroupID
HAVING COUNT(AccountID) < 7
ORDER BY GroupID;

