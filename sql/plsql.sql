
CREATE OR REPLACE PROCEDURE C_NAMECHECK
(
  c_name IN customer.name%TYPE,
  R OUT NUMBER
)
IS
BEGIN
  SELECT COUNT(*) INTO R
  FROM customer
  WHERE name = c_name ;

END;
/



CREATE OR REPLACE PROCEDURE customer_insert_version2
(
	name IN customer.name%TYPE,
	password IN customer.password%TYPE,
	zipcode IN customer.zipcode%TYPE,
	phone_number IN customer.phone_number%TYPE,
	coin IN customer.coin%TYPE,
	volunteer_working_time IN customer.volunteer_working_time%TYPE,
    possible OUT NUMBER
)
IS
  MR NUMBER;
BEGIN
 
  C_NAMECHECK(name, MR);
  IF MR = 0 THEN
   
    INSERT INTO CUSTOMER(id,name,password,zipcode,phone_number,coin, volunteer_working_time)
	VALUES(customer_id_seq.nextval,name, password, zipcode, phone_number, coin,  volunteer_working_time);
    possible := 1 ; 
    COMMIT;
  ELSE
    possible := 0 ;
  END IF;
  DBMS_OUTPUT.PUT_LINE(TO_CHAR(MR));
END ;
/


CREATE OR REPLACE PROCEDURE customer_login_check
(
  c_name IN customer.name%TYPE,
  c_password IN customer.password%TYPE,
  R OUT NUMBER
)
IS
BEGIN
  SELECT COUNT(*) INTO R
  FROM customer
  WHERE name = c_name AND password = c_password ;

END;
/

CREATE OR REPLACE PROCEDURE customer_login
(
    
	name IN customer.name%TYPE,
	password IN customer.password%TYPE,
    possible OUT NUMBER
)
IS
  MR NUMBER;
BEGIN
  
  customer_login_check(name,password, MR);
  IF MR = 0 THEN
	
    possible := 0 ; 
	
  ELSE
  
    possible := 1 ;
	
  END IF;
  DBMS_OUTPUT.PUT_LINE(TO_CHAR(MR));
END ;
/



CREATE OR REPLACE procedure sp_get_customer_info ( c_name IN customer.name%TYPE, record_list OUT SYS_REFCURSOR )
AS
BEGIN
OPEN record_list FOR
SELECT *
FROM Customer
WHERE name = c_name;
END;
/


CREATE OR REPLACE procedure ALL_product
(
ALL_PRODUCT_record  OUT SYS_REFCURSOR
)
AS
BEGIN
OPEN ALL_PRODUCT_record FOR
SELECT p.id, p.name, p.information, p.price, c.name, p.category_name, p.product_status, sp.name, (select name from customer where id= p.buy_customer_id) as buy_custmoer_name
FROM product p
INNER JOIN customer c on p.customer_id = c.id
INNER JOIN shipment s on p.shipment_id = s.id
INNER JOIN shipment_company sp on sp.id = s.shipment_company_id;
END;
/

CREATE OR REPLACE procedure all_product_view_select
(
	all_product_view_record  OUT 		SYS_REFCURSOR
)
IS
BEGIN
	OPEN all_product_view_record FOR
	SELECT *
	FROM all_product_view;
END;
/


CREATE OR REPLACE procedure select_productListAll
(
	productList_record  OUT 		SYS_REFCURSOR
)
AS
BEGIN
OPEN productList_record FOR
SELECT name,price,customer_id
FROM product;
END;
/

var p_all refcursor;
exec select_productListAll(:p_all);
print p_all;


CREATE OR REPLACE PROCEDURE select_category
(
    customer_id IN product.customer_id%TYPE,
	category_id IN product.category_id%TYPE,
	category_name IN product.category_name%TYPE,
	s_category_record OUT SYS_REFCURSOR
	
)
IS
BEGIN
  
  
	OPEN s_category_record FOR
	SELECT p.name, p.price, (select name from customer where id= customer_id), p.category_name, p.product_status
	FROM PRODUCT p inner join category c
	on p.category_id = c.id
	order by p.id asc;
	
END ;
/


var category_select refcursor;
exec select_category(1,1,'clothing',:category_select);
print category_select;




CREATE OR REPLACE procedure product_detail
(
	p_id 			IN 		product.id%TYPE,
	product_detail_record  OUT 		SYS_REFCURSOR
)
AS
BEGIN
	OPEN product_detail_record FOR
	SELECT name, information , price
	FROM product
	WHERE customer_id = p_id;
END;
/


CREATE OR REPLACE procedure customer_sell_product
(
	c_id 			IN 		customer.id%TYPE,
	customer_sell_record  OUT 		SYS_REFCURSOR
)
AS
BEGIN
	OPEN customer_sell_record FOR
	SELECT name, price, product_status
	FROM product
	WHERE customer_id = c_id;
END;
/

CREATE OR REPLACE PROCEDURE product_insert
(

	customer_id IN customer.id%TYPE, 
    p_name IN product.name%Type, 
	information IN product.information%TYPE, 
	price IN product.price%TYPE, 
    category_name IN category.name%TYPE,
	shipment_name IN shipment_company.name%TYPE
	
)
IS 
	category_id NUMBER;
	shipcom_id NUMBER;
	ship_id NUMBER := shipment_id_seq.nextval;
	product_id NUMBER :=product_id_seq.nextval;
	
BEGIN


	SELECT id INTO category_id
	FROM category
	where name=category_name;
	
	SELECT id INTO shipcom_id
	FROM shipment_company
	where name=shipment_name;
	
	
	insert into product(id,customer_id,name,information,price,category_id,category_name,product_status,shipment_id)
	values(product_id,customer_id,p_name, information, price,
	category_id,category_name, 'READY', ship_id);

	
	insert into shipment(id,shipment_company_id,product_id, PRODUCT_CUSTOMER_ID)
	values(ship_id, shipcom_id, product_id, customer_id);
	
	commit;
	
END; 
/

CREATE OR REPLACE PROCEDURE buy_item 
(
   
   p_id IN product.id%Type, 
   product_customer_name IN customer.name%Type, 
   c_id IN customer.id%TYPE,
   contract_date IN orders.contract_date%Type, 
   
   ispossible OUT NUMBER
)   
IS
   seller_id NUMBER;
   p_product_status CLOB;
    
BEGIN  
   
   
   select product_status into p_product_status
   from product
   where p_id=id;
   
   IF p_product_status = 'READY' THEN
	   SELECT id INTO seller_id
	   FROM customer
	   where name = product_customer_name;
	   
		  
	   UPDATE product SET PRODUCT_STATUS = 'PROGRESS', buy_customer_id = c_id WHERE p_id = id;
	   
	   INSERT INTO orders(id, contract_date, customer_id, product_id, product_customer_id)
	   VALUES(ORDERS_id_seq.nextval, contract_date, c_id, p_id, seller_id);
	   ispossible := 1;
	   commit;
	   
	ELSE
	   ispossible := 0;
	
    END IF;
END ;
/

CREATE OR REPLACE TRIGGER TRIG_TEST
	AFTER UPDATE OF PRODUCT_STATUS ON PRODUCT  
	FOR EACH ROW
DECLARE


BEGIN

	
	IF :NEW.PRODUCT_STATUS = 'FINISH' THEN
		UPDATE CUSTOMER
		SET coin = coin + :NEW.PRICE +100
		WHERE :NEW.CUSTOMER_ID = ID;
		
		
		UPDATE CUSTOMER
		SET coin = coin + :NEW.PRICE +100
		WHERE :NEW.BUY_CUSTOMER_ID = ID;
		
		DBMS_OUTPUT.PUT_LINE('거래성공!!  + 마일리지 100 지급!!');
		
	ELSIF :NEW.PRODUCT_STATUS = 'PROGRESS' THEN
		
		UPDATE CUSTOMER
		SET coin = coin - :NEW.price
		where :NEW.CUSTOMER_ID = id;
		DBMS_OUTPUT.PUT_LINE('거래 신청 완료!!');
	END IF;
	
END;
/


CREATE OR REPLACE PROCEDURE receipt_click
(

 
   p_id IN product.id%TYPE
   
)
IS 
BEGIN
  
   UPDATE product SET PRODUCT_STATUS = 'FINISH' WHERE p_id = id;
   commit;
END;
/







CREATE OR REPLACE procedure category_allbox
(
	category_list_record  OUT 		SYS_REFCURSOR
)
IS
BEGIN
	OPEN category_list_record FOR
	SELECT name
	FROM category;
END;
/


CREATE OR REPLACE procedure shipment_company_allbox
(
	shipcom_list_record  OUT 		SYS_REFCURSOR
)
IS
BEGIN
	OPEN shipcom_list_record FOR
	SELECT name
	FROM shipment_company;
END;
/

var ship_com_all refcursor;
exec shipment_company_allbox(:ship_com_all);
print ship_com_all;



ALTER TABLE PRODUCT ENABLE ROW MOVEMENT; 

CREATE OR REPLACE PROCEDURE mysell_product_update
(
   p_id IN product.id%TYPE,
   customer_id IN customer.id%TYPE, 
    p_name IN product.name%Type,
   P_information IN product.information%TYPE, 
   p_price IN product.price%TYPE, 
    p_category_name IN category.name%TYPE, 
   shipment_name IN shipment_company.name%TYPE 
   
)
IS 
c_category_id NUMBER;
shipcom_id NUMBER;
BEGIN

   SELECT id INTO c_category_id
   FROM category
   where name=p_category_name;
   
   SELECT id INTO shipcom_id
   FROM shipment_company
   where name=shipment_name;

   UPDATE product SET
   name= p_name,
   information= P_information,
   price = p_price,
   category_id= c_category_id,
   category_name= p_category_name
   where p_id = id ;
   
   DBMS_OUTPUT.PUT_LINE(shipcom_id);
   UPDATE shipment SET shipment_company_id = shipcom_id
   where id = p_id ;
   
   commit;
END;
/


CREATE OR REPLACE PROCEDURE mybuy_product
(

	c_id IN customer.id%TYPE, 
	mybuy_list_record OUT SYS_REFCURSOR
	
)
IS 	
BEGIN

	OPEN mybuy_list_record FOR
	SELECT name, price, category_name, product_status
	FROM product
	where customer_id=buy_customer_id;
	
END; 
/

var s refcursor;
exec mybuy_product(1,:s);
print s;

CREATE OR REPLACE PROCEDURE mysell_product_cancel
(
	p_id IN product.id%TYPE

)
IS 	
BEGIN

	
	DELETE FROM product
	where p_id = id ;
	
	
	DELETE FROM shipment
	where p_id = product_id ;
	
	commit;
END; 
/

CREATE OR REPLACE procedure select_coinRanking
(
	ranking_cursor  OUT 		SYS_REFCURSOR
)
AS
BEGIN
	OPEN ranking_cursor FOR
SELECT c.name, c.coin
FROM customer c
ORDER BY c.coin DESC;
END;
/
