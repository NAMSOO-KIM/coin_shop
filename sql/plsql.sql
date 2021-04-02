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

CREATE OR REPLACE PROCEDURE customer_insert_version2
(
    --id IN customer.id%TYPE,
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
	VALUES(id, name, password, zipcode, phone_number, coin,  volunteer_working_time);
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
EXEC customer_insert_version2(3,'sadgs','cabw','asdfaseg','1231',1241,132,:R);
PRINT R;



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
EXEC customer_login(3,'sadgs','cabw','asdfaseg','1231',1241,132,:R);
PRINT R; -- 1이 로그인 성공!, 0은 로그인 실패

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--                          메인 페이지                                     --
-----------------------------------------------------------------------------

-- 전체 글 조회 프로시저
-- 카테고리 별 조회 프로시저
-- 제품 상세정보
"""
-- 샘플데이터
INSERT INTO PRODUCT(id,CUSTOMER_ID,NAME,INFORMATION,PRICE,CATEGORY_ID, SHIPMENT_ID)
	VALUES(1, 1, 'asdf', 'fasdfsgea', 1000, 1, 1);

INSERT INTO Cateogry(id,CUSTOMER_ID,NAME,INFORMATION,PRICE,CATEGORY_ID, SHIPMENT_ID)
	VALUES(1, 1, 'asdf', 'fasdfsgea', 1000, 1, 1);
"""
------ to do
-- 전체 글 조회
CREATE OR REPLACE procedure select_productListAll
(
	productList_record  OUT 		SYS_REFCURSOR
)
AS
BEGIN
OPEN productList_record FOR
SELECT name,price, 
FROM product;
END;
/

-- 실행 확인
var p_all refcursor;
exec select_productListAll(:p_all);
print p_all;

------------------------------------------------------------------------
-- 카테고리 별 조회--

-- 카테고리는 파티셔닝 되어있음. 확인-
CREATE OR REPLACE procedure product_Category_ListAll
(
    categ_id IN category.id%TYPE,
    category_record OUT SYS_REFCURSOR
)
AS
BEGIN
OPEN category_record FOR
SELECT *
FROM product
where category_id=categ_id;
END;
/

var category_select refcursor;
exec product_Category_ListAll(1,:category_select)
print category_select;

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

-- 내가 올린 상품 보기
-- 물품 등록
-- 수령 확인 버튼

-- 내가 올린 상품 보기
CREATE OR REPLACE procedure customer_sell_product
(
	c_id 			IN 		customer.id%TYPE,
	customer_sell_record  OUT 		SYS_REFCURSOR
)
AS
BEGIN
	OPEN customer_sell_record FOR
	SELECT name, price, status
	FROM product
	WHERE customer_id = c_id;
END;
/

--실행
var category_select refcursor;
exec product_Category_ListAll(1,:category_select)
print category_select;

------------------------------------------------------------------------------------
-- 물품 등록

"""
--샘플 데이터 등록 (택배회사 정보)

-- insert into shipment(id,name,ESTIMATED_ARRIVAL_DATE,SHIPMENT_COMPANY_ID,PRODUCT_ID,PRODUCT_CUSTOMER_ID)
-- values (1,'hangin','2013-02-12',1,1,1);
"""

CREATE OR REPLACE PROCEDURE product_insert
(
	id IN product.id%TYPE,
	customer_id IN customer.id%TYPE,
    name In product.name%Type, --다이어그램에 추가, name
	information IN product.information%TYPE,
	price IN product.price%TYPE,
	category_id IN category.id%TYPE,
    category_name IN category.name%TYPE, --category_name
    status IN product.status%TYPE, -- product 상태 ( 거래대기,거래중, 거래완료)
	shipment_id IN shipment.id%TYPE

)
IS 
BEGIN

	INSERT INTO product(id,customer_id,name,information,price,category_id,category_name,status, shipment_id)
	VALUES(id, customer_id,name, information, price, category_id,category_name,status, shipment_id);

    INSERT INTO category(id,name)
	VALUES(category_id, category_name);

	COMMIT;
END; 
/


--프로시저 실행

exec product_insert(1, 1,'asdf', 'is good!!!', 1000, 1, '의류', 'READY',1);


-----------------------------------------------------------------------------
-- 수령 확인 버튼



-- 
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



-- 
"""
CREATE OR REPLACE PROCEDURE product_accept
(
    p_id IN product.id%TYPE,
	
    customer_cnt OUT NUMBER
)	
IS
  MR NUMBER;
BEGIN
  -- 중복체크
  P_STATUSCHECK(name, MR);
  
  IF MR = 0 THEN
    --테이블에 데이터 넣기
    INSERT INTO CUSTOMER(id,name,password,zipcode,phone_number,coin, volunteer_working_time)
	VALUES(id, name, password, zipcode, phone_number, coin,  volunteer_working_time);
    customer_cnt := 1 ;
    COMMIT;
  ELSE
    customer_cnt := 0 ;
  END IF;
  DBMS_OUTPUT.PUT_LINE(TO_CHAR(MR));
END ;
/
"""

-- 
-- 




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



