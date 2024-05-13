USE sale_management;

CREATE TABLE Customer(
	customer_id				INT PRIMARY KEY AUTO_INCREMENT,
    first_name				VARCHAR(20),
    last_name				VARCHAR(20),
    email_address			VARCHAR(100),
    number_of_complaints	INT
);

CREATE TABLE Sales(
	purchase_number		INT PRIMARY KEY AUTO_INCREMENT,
    date_of_purchase	DATE,
    customer_id			INT,
    item_code			VARCHAR(3)
);

CREATE TABLE Items(
	item_code					VARCHAR(3),
    item						VARCHAR(20),
    unit_price_usd				INT,
    company_id					INT,
    company						VARCHAR(20),
    headquarters_phone_number	VARCHAR(20)	
);