USE Testing_System_Db;

CREATE TABLE Department(
	DepartmentID	INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName	VARCHAR(20)
 );
 
CREATE TABLE Positions(
	PositionID	 	INT PRIMARY KEY AUTO_INCREMENT,
    PositionName	VARCHAR(20)
 );
 
CREATE TABLE account(
	AccountID		INT PRIMARY KEY AUTO_INCREMENT,
    Email			VARCHAR(20),
    Username		VARCHAR(20),
    FullName 		VARCHAR(20),
    DepartmentID	INT,
    PositionID		INT,
    CreateDate		DATE
 );
 
 CREATE TABLE Group_(
	 GroupID	INT PRIMARY KEY AUTO_INCREMENT,
     GroupName	VARCHAR(20),
     CreatorID	INT,
     CreateDate	DATE
 );
 
 CREATE TABLE GroupAccount(
	GroupID 	INT,
    AccountID	INT,
    JoinDate	DATE,
    PRIMARY KEY (GroupID, AccountID)
 );
 
 CREATE TABLE TypeQuestion(
	TypeID		INT PRIMARY KEY AUTO_INCREMENT,
    TypeName	VARCHAR(20)
 );
 
 
 CREATE TABLE CategoryQuestion(
	CategoryID		INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName	VARCHAR(20)
 );
 
 CREATE TABLE Question(
	QuestionID	INT PRIMARY KEY AUTO_INCREMENT,
    Content		VARCHAR(100),
    CategoryID	INT,
    TypeID		INT,
    CreatorID 	INT,
    CreateDate 	DATE
 );
 
 CREATE TABLE Answer(
	AnswerID	INT PRIMARY KEY AUTO_INCREMENT,
    Content 	VARCHAR(100),
    QuentionID	INT,
    isCorrect	BOOLEAN
 );
 
 CREATE TABLE Exam(
	ExamID		INT PRIMARY KEY AUTO_INCREMENT,
    Code 		VARCHAR(10),
    Title 		VARCHAR(20),
    CategoryID	INT,
    Duration	TIMESTAMP,
    CreatorID	INT,
    CreateDate 	DATE
 );
 
 CREATE TABLE EXAMQUESTION(
	ExamID 		INT,
    QuestionID	INT
 );
 
 