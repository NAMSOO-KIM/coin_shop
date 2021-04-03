-- PL/SQL


-----------------------------------------------------------------------------
--                          회원가입                                        --
-----------------------------------------------------------------------------

-- 고객 아이디 중복 체크 프로시저
-- 회원가입 프로시저

"""
-- 중복 체크만 해당
1. OUTPUT PARAM을 이용해 APP에 결과 통보
2. 1 이면 중복 - 가입 불가
3. 0 이면 중복X - 가입가능
"""
-- 아이디 중복 체크
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

-- 실행
VAR R NUMBER;
EXEC C_NAMECHECK('asdf',:R);
print R

-----------------------------------------------------------------------------

-- 회원 가입 프로시저
"""

1. OUTPUT PARAM을 이용해 APP에 결과 통보
possible이 1이면 가입 가능
		  0이면 가입 불가능
"""
-- 시퀀스.nextval 로 자동 입력

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
  -- 중복체크
  C_NAMECHECK(name, MR);
  IF MR = 0 THEN
    --테이블에 데이터 넣기
    INSERT INTO CUSTOMER(id,name,password,zipcode,phone_number,coin, volunteer_working_time)
	VALUES(customer_id_seq.nextval,name, password, zipcode, phone_number, coin,  volunteer_working_time);
    possible := 1 ; --possible 반대,
    COMMIT;
  ELSE
    possible := 0 ;
  END IF;
  DBMS_OUTPUT.PUT_LINE(TO_CHAR(MR));
END ;
/

-- 실행
VAR R NUMBER;
EXEC customer_insert_version2('sadgs','cabw','asdfaseg','1231',1241,132,:R);
PRINT R;  -- 1 리턴되면 회원가입 성공, 0일때 회원가입 실패



-----------------------------------------------------------------------------
--                          로그인                                        --
-----------------------------------------------------------------------------
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
    --id IN customer.id%TYPE,
	name IN customer.name%TYPE,
	password IN customer.password%TYPE,
    possible OUT NUMBER
)
IS
  MR NUMBER;
BEGIN
  -- 중복체크
  customer_login_check(name,password, MR);
  IF MR = 0 THEN
	
    possible := 0 ; -- 0이면 등록된 아이디가 없거나 비밀번호가 틀렸습니다.
	
  ELSE
  
    possible := 1 ; -- 1이면 로그인 성공
	
  END IF;
  DBMS_OUTPUT.PUT_LINE(TO_CHAR(MR));
END ;
/

-- 실행
VAR R NUMBER;
EXEC customer_login('id','pw',:R);
PRINT R; -- 1이 로그인 성공!, 0은 로그인 실패

------------------------------------------------------------------------
-- customer 정보 받아오기

CREATE OR REPLACE procedure sp_get_customer_info ( c_name IN customer.name%TYPE, record_list OUT SYS_REFCURSOR )
AS
BEGIN
OPEN record_list FOR
SELECT *
FROM Customer
WHERE name = c_name;
END;
/


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--                          메인 페이지                                     --
-----------------------------------------------------------------------------

-- 전체 글 조회 프로시저
-- 카테고리 별 조회 프로시저
-- 제품 상세정보
-- 카테고리 별 조회--
"""
-- 샘플데이터
INSERT INTO PRODUCT(id,CUSTOMER_ID,NAME,INFORMATION,PRICE,CATEGORY_ID, SHIPMENT_ID)
	VALUES(1, 1, 'asdf', 'fasdfsgea', 1000, 1, 1);

INSERT INTO Cateogry(id,CUSTOMER_ID,NAME,INFORMATION,PRICE,CATEGORY_ID, SHIPMENT_ID)
	VALUES(1, 1, 'asdf', 'fasdfsgea', 1000, 1, 1);
"""

-- 전체 글 조회
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

-- 실행 확인
var p_all refcursor;
exec select_productListAll(:p_all);
print p_all;

------------------------------------------------------------------------

-- 카테고리 별 조회--

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


-- 샘플 데이터
--insert into product(id,customer_id,name,information,price,category_id,category_name,product_status,shipment_id)
--values (1,1,'asdf','asgsds',1300,1,'clothing','READY',1);


-----------------------------------------------------------------------------
-- 제품 상세정보

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

--실행
var pro_detail refcursor;
exec product_detail(1,:pro_datail)
print pro_detail;

-- 


-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
--                          마이 페이지                                     --
-----------------------------------------------------------------------------

-----------------
-- 내가 올린 상품 보기 |
-- 물품 등록 		|
-- 수령 확인 버튼	|
-- 카테고리 리스트 박스	|
-- 배송회사 리스트 박스	|
-----------------

-- 내가 올린 상품 보기
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

--실행
var category_select refcursor;
exec customer_sell_product(1,:category_select)
print category_select;

------------------------------------------------------------------------------------
-- 물품 등록

"""
--샘플 데이터 등록 (택배회사 정보)

-- insert into shipment(id,name,ESTIMATED_ARRIVAL_DATE,SHIPMENT_COMPANY_ID,PRODUCT_ID,PRODUCT_CUSTOMER_ID)
-- values (1,'hangin','2013-02-12',1,1,1);
"""




 -- 최신버전
CREATE OR REPLACE PROCEDURE product_insert
(

	customer_id IN customer.id%TYPE, -- 고객 id
    p_name IN product.name%Type, -- 제품이름
	information IN product.information%TYPE, --제품 설명
	price IN product.price%TYPE, -- 제품 가격
    category_name IN category.name%TYPE, --카테고리 이름
	shipment_name IN shipment_company.name%TYPE -- 배송회사 이름
	
)
IS 
	category_id NUMBER;
	shipcom_id NUMBER;
	ship_id NUMBER := shipment_id_seq.nextval;
	product_id NUMBER :=product_id_seq.nextval;
	
BEGIN

	--INSERT INTO category(id,name)
	
	--- category 아이디 변수로 저장
	SELECT id INTO category_id
	FROM category
	where name=category_name;
	
	SELECT id INTO shipcom_id
	FROM shipment_company
	where name=shipment_name;
	
	
	
	-- product 테이블에 저장
	
	insert into product(id,customer_id,name,information,price,category_id,category_name,product_status,shipment_id)
	values(product_id,customer_id,p_name, information, price,
	category_id,category_name, 'READY', ship_id);
	
	-- product customer id 판매자
	
	
	insert into shipment(id,shipment_company_id,product_id, PRODUCT_CUSTOMER_ID)
	values(ship_id, shipcom_id, product_id, customer_id);
	
	commit;
	
END; 
/

exec product_insert(1,'충전기 또 팔아연', '좋아요 이거', 1000, 'clothing','hangin');




-----------------------------------------------------------------------------
-- 수령 확인 버튼(미완성)



-- 현재 거래중인 물품만 수령확인 가능(문자열 일치 비교), procedure에서는 update만

CREATE OR REPLACE PROCEDURE product_accept
(
    p_id IN product.id%TYPE,
	
)	
IS
BEGIN  
	--테이블에 데이터 넣기
	UPDATE PRODUCT SET (status = 'FINISH') -- 거래 완료
	where p_id = id
	COMMIT;
	
END ;
/



-- 카테고리 리스트 박스

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

var category_all refcursor;
exec category_allbox(:category_all);
print category_all;

-- 샘플 데이터
--insert into category(id,name) values(2,'book');

--실행
var category_all refcursor;
exec category_allbox(:category_all);
print category_all;

-- 배송회사 리스트 박스

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


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--                          차트 페이지                                     --
-----------------------------------------------------------------------------

-- 전체 상품 마일리지 랭킹

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

-- 실행
var c refcursor;
exec select_coinRanking(:c);
print c


---------------------------------------------------------------------------------



