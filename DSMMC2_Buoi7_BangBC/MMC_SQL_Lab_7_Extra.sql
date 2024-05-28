USE car_management;
-- Question 1: Tạo bảng với ràng buộc và kiểu dữ liệu. Sau đó, thêm ít nhất 5 bản ghi vào bảng.
DROP TABLE IF EXISTS CUSTOMER;
CREATE TABLE CUSTOMER (
    Customer_ID INT PRIMARY KEY AUTO_INCREMENT,
    CUSTOMER_NAME VARCHAR(255) NOT NULL,
    CUSTOMER_PHONE VARCHAR(255) NOT NULL,
    CUSTOMER_EMAIL VARCHAR(255) NOT NULL,
    CUSTOMER_ADDRESS VARCHAR(255) NOT NULL,
    CUSTOMER_NOTE VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS CAR;
CREATE TABLE CAR(
    Car_ID    INT PRIMARY KEY AUTO_INCREMENT,
    CAR_MAKER ENUM('HONDA', 'TOYOTA', 'NISSAN') NOT NULL,
    CAR_MODEL VARCHAR(255) NOT NULL,
    CAR_YEAR  INT NOT NULL,
    CAR_COLOR VARCHAR(255) NOT NULL,
    CAR_NOTE  VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS CAR_ORDER;
CREATE TABLE CAR_ORDER(
    ORDER_ID          INT PRIMARY KEY AUTO_INCREMENT,
    CUSTOMER_ID       INT NOT NULL,
    CAR_ID            INT NOT NULL,
    AMOUNT            DECIMAL(10,2) NOT NULL DEFAULT 1,
    SALE_PRICE        DOUBLE NOT NULL,
    ORDER_DATE        DATE NOT NULL,
    DELIVERY_DATE     DATE NOT NULL,
    DELIVERY_ADDRESS  VARCHAR(255) NOT NULL,
    `STATUS`          ENUM('PENDING', 'DELIVERED', 'CANCELLED') DEFAULT 'PENDING',
    NOTE              VARCHAR(255) NOT NULL,
    FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(Customer_ID) ON DELETE CASCADE,
    FOREIGN KEY (CAR_ID) REFERENCES CAR(Car_ID) ON DELETE CASCADE  
);

-- Insert data
INSERT INTO customer (CUSTOMER_NAME, CUSTOMER_PHONE, CUSTOMER_EMAIL, CUSTOMER_ADDRESS, CUSTOMER_NOTE) 
VALUES ('Nguyen Van A', '0000000000', 'nguyenvana@gmail.com', 'Ha Noi', 'Note 1'),
       ('Nguyen Van B', '1111111111', 'nguyenvanb@gmail.com', 'Ha Tinh', 'Note 2'),
       ('Nguyen Van C', '2222222222', 'nguyenvanc@gmail.com', 'Ha Nam', 'Note 3'),
       ('Nguyen Van D', '3333333333', 'nguyenvand@gmail.com', 'Ha Giang', 'Note 4'),
       ('Nguyen Van E', '4444444444', 'nguyenvane@gmail.com', 'Bac Kan', 'Note 5'),
       ('Nguyen Van F', '5555555555', 'nguyenvanf@gmail.com', 'Bac Ninh', 'Note 6'),
       ('Nguyen Van G', '6666666666', 'nguyenvang@gmail.com', 'Bac Giang', 'Note 7'),
       ('Nguyen Van H', '7777777777', 'nguyenvanh@gmail.com', 'Bac Lieu', 'Note 8'),
       ('Nguyen Van I', '8888888888', 'nguyenvani@gmail.com', 'Bac Can', 'Note 9'),
       ('Nguyen Van K', '9999999999', 'nguyenvank@gmail.com', 'Bac Ninh', 'Note 10');

INSERT INTO car (CAR_MAKER, CAR_MODEL, CAR_YEAR, CAR_COLOR, CAR_NOTE)
VALUES ('HONDA', 'CIVIC', 2021, 'RED', 'Note 1'),
       ('HONDA', 'ACCORD', 2020, 'BLUE', 'Note 2'),
       ('HONDA', 'CRV', 2019, 'WHITE', 'Note 3'),
       ('TOYOTA', 'CAMRY', 2018, 'BLACK', 'Note 4'),
       ('TOYOTA', 'COROLLA', 2017, 'YELLOW', 'Note 5'),
       ('TOYOTA', 'RAV4', 2016, 'GREEN', 'Note 6'),
       ('NISSAN', 'SENTRA', 2015, 'ORANGE', 'Note 7'),
       ('NISSAN', 'ALTIMA', 2014, 'PURPLE', 'Note 8'),
       ('NISSAN', 'MAXIMA', 2013, 'BROWN', 'Note 9'),
       ('NISSAN', 'VERSA', 2012, 'PINK', 'Note 10');

INSERT INTO car_order (CUSTOMER_ID, CAR_ID, AMOUNT, SALE_PRICE, ORDER_DATE, DELIVERY_DATE, DELIVERY_ADDRESS, `STATUS`, NOTE)
VALUES ('1', '1', '1', '10000', '2021-01-01', '2021-01-02', 'Ha Noi', 'PENDING', 'Note 1'),
       ('2', '2', '1', '20000', '2021-02-01', '2021-02-02', 'Ha Tinh', 'DELIVERED', 'Note 2'),
       ('3', '3', '1', '30000', '2021-03-01', '2021-03-02', 'Ha Nam', 'CANCELLED', 'Note 3'),
       ('4', '4', '1', '40000', '2021-04-01', '2021-04-02', 'Ha Giang', 'PENDING', 'Note 4'),
       ('5', '5', '1', '50000', '2021-05-01', '2021-05-02', 'Bac Kan', 'DELIVERED', 'Note 5'),
       ('6', '6', '1', '60000', '2021-06-01', '2021-06-02', 'Bac Ninh', 'CANCELLED', 'Note 6'),
       ('7', '7', '1', '70000', '2021-07-01', '2021-07-02', 'Bac Giang', 'PENDING', 'Note 7'),
       ('8', '8', '1', '80000', '2021-08-01', '2021-08-02', 'Bac Lieu', 'DELIVERED', 'Note 8'),
       ('9', '9', '1', '90000', '2021-09-01', '2021-09-02', 'Bac Can', 'CANCELLED', 'Note 9'),
       ('10', '10', '1', '100000', '2021-10-01', '2021-10-02', 'Bac Ninh', 'PENDING', 'Note 10');

INSERT INTO car_order (CUSTOMER_ID, CAR_ID, AMOUNT, SALE_PRICE, ORDER_DATE, DELIVERY_DATE, DELIVERY_ADDRESS, `STATUS`, NOTE)
VALUES ('1', '3', '2', '30000', '2021-01-01', '2021-01-02', 'Ha Noi', 'PENDING', 'Note 1'),
       ('2', '4', '2', '40000', '2021-02-01', '2021-02-02', 'Ha Tinh', 'DELIVERED', 'Note 2'),
       ('3', '5', '2', '50000', '2021-03-01', '2021-03-02', 'Ha Nam', 'CANCELLED', 'Note 3'),
       ('4', '6', '2', '60000', '2021-04-01', '2021-04-02', 'Ha Giang', 'PENDING', 'Note 4'),
       ('5', '7', '2', '70000', '2021-05-01', '2021-05-02', 'Bac Kan', 'DELIVERED', 'Note 5'),
       ('6', '8', '2', '80000', '2021-06-01', '2021-06-02', 'Bac Ninh', 'CANCELLED', 'Note 6'),
       ('7', '9', '2', '90000', '2021-07-01', '2021-07-02', 'Bac Giang', 'PENDING', 'Note 7'),
       ('8', '10', '2', '100000', '2021-08-01', '2021-08-02', 'Bac Lieu', 'DELIVERED', 'Note 8'),
       ('9', '1', '2', '10000', '2021-09-01', '2021-09-02', 'Bac Can', 'CANCELLED', 'Note 9'),
       ('10', '2', '2', '20000', '2021-10-01', '2021-10-02', 'Bac Ninh', 'PENDING', 'Note 10');

INSERT INTO car_order (CUSTOMER_ID, CAR_ID, AMOUNT, SALE_PRICE, ORDER_DATE, DELIVERY_DATE, DELIVERY_ADDRESS, `STATUS`, NOTE)
VALUES ('4', '2', '5', '20000', '2021-04-01', '2021-04-02', 'Ha Giang', 'PENDING', 'Note 4'),
       ('5', '3', '5', '30000', '2021-05-01', '2021-05-02', 'Bac Kan', 'DELIVERED', 'Note 5'),
       ('6', '4', '5', '40000', '2021-06-01', '2021-06-02', 'Bac Ninh', 'CANCELLED', 'Note 6'),
       ('8', '6', '5', '60000', '2021-08-01', '2021-08-02', 'Bac Lieu', 'DELIVERED', 'Note 8'),
       ('10', '8', '5', '80000', '2021-10-01', '2021-10-02', 'Bac Ninh', 'PENDING', 'Note 10');

-- Question 2: Viết lệnh lấy ra thông tin của khách hàng: tên, số lượng oto khách hàng đã mua và sắp sếp tăng dần theo số lượng oto đã mua.
SELECT c.`CUSTOMER_NAME`, SUM(co.AMOUNT) AS 'TOTAL_CAR'
FROM customer c JOIN car_order co ON c.Customer_ID = co.Customer_ID
GROUP BY c.`Customer_ID`
ORDER BY `TOTAL_CAR`;

-- Question 3: Viết hàm (không có parameter) trả về tên hãng sản xuất đã bán được nhiều oto nhất trong năm nay.
DROP FUNCTION IF EXISTS getBestCarManagement;
DELIMITER $$
CREATE FUNCTION getBestCarManagement() RETURNS TEXT
BEGIN
	DECLARE bestCarMaker TEXT;
	SELECT GROUP_CONCAT(DISTINCT car_maker) INTO bestCarMaker
    FROM (SELECT c.`CAR_MAKER`
		  FROM car_order co join car c on co.`CAR_ID` = c.`Car_ID`
          WHERE YEAR(NOW()) = YEAR(co.ORDER_DATE)
		  GROUP BY c.`CAR_MAKER`
		  HAVING SUM(co.`AMOUNT`) >= ALL (SELECT  SUM(co.`AMOUNT`)
										  FROM car_order co JOIN car c ON co.`CAR_ID` = c.`Car_ID`
										  GROUP BY c.`CAR_MAKER`)) AS T;

	RETURN bestCarMaker;
END$$
DELIMITER ;
SELECT getBestCarManagement() AS Best_Maker;

-- Question 4: Viết 1 thủ tục (không có parameter) để xóa các đơn hàng đã bị hủy của những năm trước. In ra số lượng bản ghi đã bị xóa.
DROP PROCEDURE IF EXISTS deleteCancelOrder;
DELIMITER $$
CREATE PROCEDURE deleteCancelOrder(OUT DEL_COUNT INT)
BEGIN
	DELETE FROM car_order
    WHERE YEAR(ORDER_DATE) < YEAR(NOW()) AND `STATUS` = 'CANCELLED';
    SELECT ROW_COUNT() INTO DEL_COUNT;
END$$
DELIMITER ;

SET @DEL_COUNT = 0;
CALL deleteCancelOrder(@DEL_COUNT);
SELECT @DEL_COUNT;

-- Question 5: Viết 1 thủ tục (có CustomerID parameter) để in ra thông tin của các đơn hàng đã đặt hàng bao gồm: tên của khách hàng, 
-- mã đơn hàng, số lượng oto và tên hãng sản xuất.
DROP PROCEDURE IF EXISTS customer_infor;
DELIMITER $$
CREATE PROCEDURE customer_infor(IN CUSTOMER_ID INT)
BEGIN
	SELECT c.customer_name, GROUP_CONCAT(co.order_id) Orders_ID, SUM(co.amount) SL_oto, GROUP_CONCAT(DISTINCT ca.car_maker) Car_name
    FROM customer c JOIN car_order co ON c.customer_id = co.customer_id
					JOIN car ca ON co.car_id = ca.car_id
	WHERE c.customer_id = CUSTOMER_ID
    GROUP BY c.customer_id, c.customer_name;
END$$
DELIMITER ;

CALL customer_infor(1);

-- Question 6: Viết trigger để tránh trường hợp người dụng nhập thông tin không hợp lệ vào database (DeliveryDate < OrderDate + 15).
DROP TRIGGER IF EXISTS trigger_except_input_invalid;
DELIMITER $$
CREATE TRIGGER trigger_except_input_invalid
BEFORE INSERT ON car_order
FOR EACH ROW 
BEGIN 
	IF NEW.DELIVERY_DATE < DATE_ADD(NEW.ORDER_DATE, INTERVAL 15 DAY) THEN
		SIGNAL SQLSTATE '12345' 
        SET MESSAGE_TEXT='Delivery date must be later than 15 day from order day.';
	END IF;
END $$
DELIMITER ;

INSERT INTO car_order (CUSTOMER_ID, CAR_ID, AMOUNT, SALE_PRICE, ORDER_DATE, DELIVERY_DATE, DELIVERY_ADDRESS, `STATUS`, NOTE)
VALUES ('1', '8', '2', '30000', '2021-01-01', '2021-01-18', 'Ha Noi', 'PENDING', 'Note 1');
