USE testing_system_db;

-- Question 1: Add 10 records to each table
INSERT INTO Department(DepartmentName)
 VALUES (N'Quản lý nhà hàng'),
		(N'Quản lý nhân sự'),
		(N'Chăm sóc khách hàng'),
		(N'Logistic'),
        (N'Shipper'),
        (N'Giáo viên'),
        (N'Giáo sư'),
        (N'Chiến lược'),
        (N'Kĩ sư'),
        (N'KOL'),
        (N'Quản lý database');

INSERT INTO `Account`(Email, Username, FullName, DepartmentID, PositionID, CreateDate)
VALUES  ('hai228development@gmail.com', 'dangblack1','Nguyễn Hoàng Đăng','5', '1','2020-03-05'),
	    ('account5@gmail.com', 'quanganh1','Nguyen Chien Thang2','1','2','2020-03-05'),
        ('account6@gmail.com', 'vanchien1','Nguyen Van Chien','2','3','2020-03-07'),
        ('account7@gmail.com', 'cocoduongqua1','Duong Do','3','4','2020-03-08'),
		('account8@gmail.com', 'doccocaubai1','Nguyen Chien Thang1','4','4','2020-03-10'),
		('work@gmail.com', 'khabanh2','Ngo Ba Kha','6','3','2020-04-05'),
		('mmcds@gmail.com', 'huanhoahong1','Bui Xuan Huan','7', '4','2020-05-10'),
        ('AIOwork@gmail.com', 'khabanh1','Ngo Ba Kha','6','1','2020-04-05'),
		('fptsoftware@gmail.com', 'huanhoahong3','Bui Xuan Huan','7', '2','2020-05-10'),
		('abcprogrammer@gmail.com', 'tungnui1','Nguyen Thanh Tung','8','3','2020-04-07');

INSERT INTO `Group`	(GroupName, CreatorID, CreateDate)
VALUES 	(N'Database System',5,'2019-03-15'),
		(N'Stategery Development',1,'2020-03-23'),
		(N'VTI Sale 04',2,'2020-03-29'),
        (N'VTI Sale 05',3,'2020-03-17'),
        (N'VTI Sale 06',4,'2020-03-22'),
        (N'VTI Creator 02',6,'2020-10-06'),
        (N'VTI Marketing 02',7,'2020-05-07'),
		(N'Sale Management', 8, '2020-02-28'),
        (N'Chat CSKH', 9, '2020-04-09'),
        (N'VNPT', 10, '2020-04-10');
        
INSERT INTO `GroupAccount`(GroupID,AccountID,JoinDate)
VALUES  (1,17,'2019-03-05'),
		(12,18,'2020-03-07'),
		(11,16,'2020-03-09'),
		(7,19,'2020-03-10'),
		(12,20,'2020-03-28'),
		(8,11,'2020-04-06'),
		(3,14,'2020-04-07'),
		(8,13,'2020-04-08'),
		(2,19,'2020-04-09'),
		(10,23,'2020-04-10'),
        (8,12,'2022-11-25');

INSERT INTO Question(Content, CategoryID, TypeID, CreatorID	, CreateDate )
VALUES 	(N'Design pattern trong Java',2,'1','2','2020-04-05'),
		(N'Câu Hỏi về PHP lập trình web',10,'2','2','2020-04-05'),
		(N'Hỏi về C# thiết kế game',9,'2','3','2020-04-06'),
		(N'Hỏi về Ruby research',6,'1','4','2020-04-06'),
		(N'Hỏi về block Postman',5,'1','5','2020-04-06'),
		(N'Hỏi về ADO.NET in C#',3,'2','6','2020-04-06'),
		(N'Hỏi về ASP.NET in C#',2,'1','7','2020-04-06'),
		(N'Hỏi về C++ vector',8,'1','8','2020-04-07'),
		(N'Hỏi về SQL Non-relational và Relational',4,'2','9','2020-04-07'),
		(N'Hỏi về Python OOP hay lập trình hàm',7,'1','10','2020-04-07'),
        (N'Framework nổi tiếng của python',7,'1','11','2022-04-10');
INSERT INTO Answer(Content,QuestionID,isCorrect)
VALUES 	(N'Trả lời 12',12,0),
		(N'Trả lời 13',13,1),
        (N'Trả lời 14',13,0),
		(N'Trả lời 15',15,1),
		(N'Trả lời 16',20,1),
        (N'Trả lời 17',21,1),
		(N'Trả lời 18',13,0),
        (N'Trả lời 19',11,0),
        (N'Trả lời 20',13,1),
        (N'Trả lời 21',15,1),
        (N'Trả lời 22',11,1);

-- Question 2: Lấy ra tất cả các phòng ban Department
SELECT *
FROM Department
ORDER BY DepartmentID;

-- Question 3: Lấy ra id của phòng ban "Sale"
SELECT DepartmentID
FROM Department
WHERE DepartmentName = 'Sale';

-- Question 4: lấy ra thông tin account có full name dài nhất
SELECT *
FROM `Account`
WHERE length(Fullname) = (SELECT MAX(LENGTH(FullName)) 
						  FROM `Account`);

-- Question 5: Lấy ra thông tin account có full name dài nhất và thuộc phòng ban có id = 3
SELECT *
FROM `Account`
WHERE length(Fullname) = (SELECT MAX(LENGTH(FullName)) 
						  FROM `Account`
                          WHERE DepartmentID = 3)
AND DepartmentID = 3;

-- Question 6: Lấy ra tên group đã tham gia trước ngày 20/12/2019
SELECT *
FROM `Group`
WHERE CreateDate < '2019-12-20';

-- Question 7: Lấy ra ID của question có >= 4 câu trả lời
SELECT q.QuestionID, COUNT(a.AnswerID) AS 'Number Answers'
FROM Question q LEFT JOIN Answer a ON q.QuestionID = a.QuestionID
GROUP BY q.QuestionID
HAVING COUNT(a.AnswerID) >= 4;

-- Question 8: Lấy ra các mã đề thi có thời gian thi >= 60 phút và được tạo trước ngày 20/12/2019
SELECT *
FROM Exam
WHERE Duration >= 60
AND CreateDate < '2019-12-20';

-- Question 9: Lấy ra 5 group được tạo gần đây nhất
SELECT *
FROM `Group`
ORDER BY CreateDate DESC
LIMIT 5;

-- Question 10: Đếm số nhân viên thuộc department có id = 2
SELECT COUNT(DepartmentID) AS 'SL Nhân Viên'
FROM `Account`
WHERE DepartmentID = 2;

-- Question 11: Lấy ra nhân viên có tên bắt đầu bằng chữ "D" và kết thúc bằng chữ "o"
SELECT *
FROM `Account`
WHERE FullName LIKE 'D%o';

-- Question 12: Xóa tất cả các exam được tạo trước ngày 20/12/2019
DELETE FROM Exam
WHERE CreateDate < '2019-12-20';

-- Question 13: Xóa tất cả các question có nội dung bắt đầu bằng từ "câu hỏi"
DELETE FROM Question
WHERE Content LIKE N'câu hỏi%';

-- Question 14: Update thông tin của account có id = 5 thành tên "Lô Văn Đề" và email thành lo.vande@mmc.edu.vn
UPDATE `Account`
SET Username = 'Lô Văn Đề', Email = 'lo.vande@mmc.edu.vn'
WHERE AccountID = 5;

-- Question 15: Update account có id = 5 sẽ thuộc group có id = 4
UPDATE GroupAccount
SET GroupID = 4
WHERE AccountID = 5;
