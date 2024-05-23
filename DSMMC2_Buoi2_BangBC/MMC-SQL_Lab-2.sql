DROP DATABASE IF EXISTS Testing_System_Db;
CREATE DATABASE Testing_System_Db;
USE Testing_System_Db;

DROP TABLE IF EXISTS Department;
CREATE TABLE Department(
	DepartmentID	TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    DepartmentName	NVARCHAR(30) NOT NULL UNIQUE KEY
 );
 
DROP TABLE IF EXISTS Positions;
CREATE TABLE Positions(
	PositionID	 	TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    PositionName	ENUM('DEV', 'TEST', 'SCRUM MASTER', 'PM') NOT NULL UNIQUE KEY
 );
 
DROP TABLE IF EXISTS account;
CREATE TABLE account(
	AccountID						TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Email							VARCHAR(50) NOT NULL UNIQUE KEY,
    Username						VARCHAR(20) NOT NULL UNIQUE KEY,
    FullName 						VARCHAR(20) NOT NULL,
    DepartmentID					TINYINT UNSIGNED NOT NULL,
    PositionID						TINYINT UNSIGNED NOT NULL,
    CreateDate						DATETIME DEFAULT NOW(),
    FOREIGN KEY(DepartmentID) 		REFERENCES Department(DepartmentID) ON DELETE CASCADE,
    FOREIGN KEY(PositionID)		 	REFERENCES Positions(PositionID) ON DELETE CASCADE
 );
 
 DROP TABLE IF EXISTS `Group`;
 CREATE TABLE `Group`(
	 GroupID					TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
     GroupName					NVARCHAR(50) NOT NULL UNIQUE KEY,
     CreatorID					TINYINT UNSIGNED NOT NULL,
     CreateDate					DATETIME DEFAULT NOW(),
     FOREIGN KEY(CreatorID) 	REFERENCES account(AccountID) ON DELETE CASCADE
 );
 
 DROP TABLE IF EXISTS GroupAccount;
 CREATE TABLE GroupAccount(
	GroupID 								TINYINT UNSIGNED NOT NULL,
    AccountID								TINYINT UNSIGNED NOT NULL,
    JoinDate								DATETIME DEFAULT NOW(),
    PRIMARY KEY (GroupID, AccountID),
    FOREIGN KEY(GroupID) 					REFERENCES `Group`(GroupID) ON DELETE CASCADE
 );
 
 DROP TABLE IF EXISTS TypeQuestion;
 CREATE TABLE TypeQuestion(
	TypeID		TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    TypeName	ENUM('ESSSAY', 'MULTIPLE-CHOICE') NOT NULL UNIQUE KEY
 );
 
 DROP TABLE IF EXISTS CategoryQuestion;
 CREATE TABLE CategoryQuestion(
	CategoryID		TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    CategoryName	NVARCHAR(50) NOT NULL UNIQUE KEY
 );
 
 DROP TABLE IF EXISTS Question;
 CREATE TABLE Question(
	QuestionID					TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Content						NVARCHAR(100) NOT NULL,
    CategoryID					TINYINT UNSIGNED NOT NULL,
    TypeID						TINYINT UNSIGNED NOT NULL,
    CreatorID 					TINYINT UNSIGNED NOT NULL,
    CreateDate 					DATETIME DEFAULT NOW(),
    FOREIGN KEY(CategoryID) 	REFERENCES CategoryQuestion(CategoryID) ON DELETE CASCADE,
    FOREIGN KEY(TypeID) 		REFERENCES TypeQuestion(TypeID) ON DELETE CASCADE,
    FOREIGN KEY(CreatorID) 		REFERENCES	ACCOUNT(AccountID) ON DELETE CASCADE
 );
 
 DROP TABLE IF EXISTS Answer;
 CREATE TABLE Answer(
	AnswerID	TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Content 	NVARCHAR(100) NOT NULL,
    QuestionID	TINYINT UNSIGNED NOT NULL,
    isCorrect	BOOLEAN DEFAULT TRUE,
    FOREIGN KEY(QuestionID) REFERENCES Question(QuestionID) ON DELETE CASCADE
 );
 
 DROP TABLE IF EXISTS Exam;
 CREATE TABLE Exam(
	ExamID		TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Code 		CHAR(10) NOT NULL,
    Title 		NVARCHAR(50) NOT NULL,
    CategoryID	TINYINT UNSIGNED NOT NULL,
    Duration	INT UNSIGNED NOT NULL,
    CreatorID	TINYINT UNSIGNED NOT NULL,
    CreateDate 	DATETIME DEFAULT NOW(),
    FOREIGN KEY(CategoryID) REFERENCES CategoryQuestion(CategoryID) ON DELETE CASCADE,
    FOREIGN KEY(CreatorID) REFERENCES ACCOUNT(AccountID) ON DELETE CASCADE
 );
 
 DROP TABLE IF EXISTS ExamQuestion;
 CREATE TABLE ExamQuestion(
	ExamID 						TINYINT UNSIGNED NOT NULL,
    QuestionID					TINYINT UNSIGNED NOT NULL,
    PRIMARY KEY(ExamID, QuestionID),
    FOREIGN KEY(ExamID) 		REFERENCES Exam(ExamID) ON DELETE CASCADE,
    FOREIGN KEY(QuestionID) 	REFERENCES Question(QuestionID) ON DELETE CASCADE
 );
 
 INSERT INTO Department(DepartmentName)
 VALUES (N'Chờ việc'),
		(N'Marketing'),
		(N'Sale'),
		(N'Bảo vệ'),
		(N'Nhân sự'),
		(N'Kỹ thuật'),
		(N'Tài chính'),
		(N'Phó giám đốc'),
		(N'Giám đốc'),
		(N'Thư kí'),
        (N'FS-Developer'),
		(N'Project Management'),
		(N'Security'),
		(N'AI-Engineer'),
		(N'Tester'),
		(N'FE-Developer'),
		(N'BE-Developer');

INSERT INTO Positions(PositionName) 
VALUES ('Dev'),
	   ('Test'),
	   ('Scrum Master'),
	   ('PM');
 
INSERT INTO `Account`(Email, Username, FullName, DepartmentID, PositionID, CreateDate)
VALUES  ('haidang29productions@gmail.com', 'dangblack','Nguyễn hải Đăng','5', '1','2020-03-05'),
	    ('account1@gmail.com', 'quanganh','Nguyen Chien Thang2','1','2','2020-03-05'),
        ('account2@gmail.com', 'vanchien','Nguyen Van Chien','2','3','2020-03-07'),
        ('account3@gmail.com', 'cocoduongqua','Duong Do','3','4','2020-03-08'),
		('account4@gmail.com', 'doccocaubai','Nguyen Chien Thang1','4','4','2020-03-10'),
		('dapphatchetngay@gmail.com', 'khabanh','Ngo Ba Kha','6','3','2020-04-05'),
		('songcodaoly@gmail.com', 'huanhoahong','Bui Xuan Huan','7', '2','2020-05-10'),
		('sontungmtp@gmail.com', 'tungnui','Nguyen Thanh Tung','8','1','2020-04-07'),
		('duongghuu@gmail.com', 'duongghuu','Duong Van Huu','9','2','2020-04-07'),
        ('vtiaccademy@gmail.com', 'vtiaccademy','Vi Ti Ai','9','1','2020-04-09'),
        ('buicongbang1010@gmail.com', 'bangbc', 'Bùi Công Bằng', '13', '1', '2024-05-13'),
        ('thuchnfpt@gmail.com', 'thuchn', 'Hoàng Ngọc Thức', '10', '3', '2020-05-12'),
        ('longthb608@gmail.com', 'longthb', 'Trần Hà Bảo Long', '13', '1', '2021-10-25'),
        ('doanhld0394@gmail.com', 'doanhld', 'Lương Đăng Doanh', '12', '2', '2023-12-31'),
        ('quyenpq123@gmail.com', 'quyenpq', 'Phạm Quốc Quyền', '15', '1', '2022-10-11'),
        ('hoangnn@gmail.com', 'hoangnn','Nguyễn Nam Hoàng', '14', '2', '2022-08-11');
        
INSERT INTO `Group`	(GroupName, CreatorID, CreateDate)
VALUES 	(N'Testing System',5,'2019-03-05'),
		(N'Development',1,'2020-03-07'),
		(N'VTI Sale 01',2,'2020-03-09'),
        (N'VTI Sale 02',3,'2020-03-10'),
        (N'VTI Sale 03',4,'2020-03-28'),
        (N'VTI Creator',6,'2020-04-06'),
        (N'VTI Marketing 01',7,'2020-04-07'),
		(N'Management', 8, '2020-04-08'),
        (N'Chat with love', 9, '2020-04-09'),
        (N'Vi Ti Ai', 10, '2020-04-10'),
        ('FBUD AI', 11, '2022-11-25'),
        ('Pied', 16, '2022-11-25');
        
INSERT INTO `GroupAccount`(GroupID,AccountID,JoinDate)
VALUES  (1,1,'2019-03-05'),
		(1,2,'2020-03-07'),
		(3,3,'2020-03-09'),
		(3,4,'2020-03-10'),
		(5,5,'2020-03-28'),
		(1,3,'2020-04-06'),
		(1,7,'2020-04-07'),
		(8,3,'2020-04-08'),
		(1,9,'2020-04-09'),
		(10,10,'2020-04-10'),
        (11,11,'2022-11-25'),
        (11,13,'2022-11-25'),
        (11,14,'2022-11-25'),
        (12,11,'2022-11-25'),
        (12,12,'2022-11-25'),
        (12,13,'2022-11-25'),
        (12,14,'2022-11-25'),
        (12,15,'2022-11-25'),
        (12,16,'2022-11-25');
        
INSERT INTO TypeQuestion(TypeName) 
VALUES ('ESSSAY'), 
	   ('MULTIPLE-CHOICE');

INSERT INTO CategoryQuestion(CategoryName)
VALUES  ('Java'),
	    ('ASP.NET'),
		('ADO.NET'),
		('SQL'),
		('Postman'),
		('Ruby'),
		('Python'),
		('C++'),
		('C Sharp'),
		('PHP');
        
INSERT INTO Question(Content, CategoryID, TypeID, CreatorID	, CreateDate )
VALUES 	(N'Câu hỏi về Java Câu hỏi về Java Câu hỏi về Java Câu hỏi về Java',1,'1','2','2020-04-05'),
		(N'Câu Hỏi về PHP',10,'2','2','2020-04-05'),
		(N'Hỏi về C#',9,'2','3','2020-04-06'),
		(N'Hỏi về Ruby',6,'1','4','2020-04-06'),
		(N'Hỏi về Postman',5,'1','5','2020-04-06'),
		(N'Hỏi về ADO.NET',3,'2','6','2020-04-06'),
		(N'Hỏi về ASP.NET',2,'1','7','2020-04-06'),
		(N'Hỏi về C++',8,'1','8','2020-04-07'),
		(N'Hỏi về SQL',4,'2','9','2020-04-07'),
		(N'Hỏi về Python',7,'1','10','2020-04-07'),
        (N'Data structure trong python',7,'1','11','2022-04-10');
        
INSERT INTO Answer(Content,QuestionID,isCorrect)
VALUES 	(N'Trả lời 01',1,0),
		(N'Trả lời 02',1,1),
        (N'Trả lời 03',1,0),
		(N'Trả lời 04',1,1),
		(N'Trả lời 05',2,1),
        (N'Trả lời 06',3,1),
		(N'Trả lời 07',4,0),
        (N'Trả lời 08',8,0),
        (N'Trả lời 09',9,1),
        (N'Trả lời 10',10,1),
        (N'Trả lời 11',11,1);
        
INSERT INTO Exam(`Code`, Title, CategoryID, Duration, CreatorID, CreateDate)
VALUES 	('VTIQ001', N'Đề thi C#',1,60,'5','2019-04-05'),
		('VTIQ002', N'Đề thi PHP',10,60,'2','2019-04-05'),
		('VTIQ003', N'Đề thi C++',9,120,'2','2019-04-07'),
		('VTIQ004', N'Đề thi Java',6,60,'3','2020-04-08'),
        ('VTIQ005', N'Đề thi Ruby',5,120,'4','2020-04-10'),
		('VTIQ006', N'Đề thi Postman',3,60,'6','2020-04-05'),
        ('VTIQ007', N'Đề thi SQL',2,60,'7','2020-04-05'),
		('VTIQ008', N'Đề thi Python',8,60,'8','2020-04-07'),
		('VTIQ009', N'Đề thi ADO.NET',4,90,'9','2020-04-07'),
        ('VTIQ010', N'Đề thi ASP.NET',7,90,'10','2020-04-08'),
        ('Hackathon',N'Cuộc thi lập trình Hackathon-2024',7,480,'11','2024-06-05');
        
INSERT INTO ExamQuestion(ExamID,QuestionID) 
VALUES 	(1,5),
		(2,10), 
		(3,4), 
		(4,3), 
		(5,7), 
		(6,10), 
		(7,2), 
		(8,10), 
		(9,9), 
		(10,8),
        (11,11); 