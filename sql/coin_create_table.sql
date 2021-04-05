
DROP TABLE customer CASCADE CONSTRAINTS;
DROP TABLE product CASCADE CONSTRAINTS;
DROP TABLE shipment CASCADE CONSTRAINTS;
DROP TABLE shipment_company CASCADE CONSTRAINTS;
DROP TABLE orders CASCADE CONSTRAINTS;
DROP TABLE category CASCADE CONSTRAINTS;



drop sequence customer_id_seq;
drop sequence product_id_seq;
drop sequence ORDERS_id_seq;
drop sequence shipment_id_seq;
drop sequence shipment_company_id_seq;
drop sequence category_id_seq;


CREATE SEQUENCE customer_id_seq
START WITH 1
INCREMENT BY 1
MAXVALUE 999999
MINVALUE 1
NOCYCLE;

CREATE SEQUENCE product_id_seq
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 999999999
NOCYCLE;


CREATE SEQUENCE ORDERS_id_seq
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 999999999
NOCYCLE;


CREATE SEQUENCE shipment_id_seq
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 999999999
NOCYCLE;


CREATE SEQUENCE shipment_company_id_seq
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 999999999
NOCYCLE;

CREATE SEQUENCE category_id_seq
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 999999999
NOCYCLE;
-------------------------------------------------------

CREATE TABLE category (
    id    NUMBER(9) NOT NULL,
    name  VARCHAR2(50 CHAR) NOT NULL
);
CREATE INDEX category_id_idx
ON category(id);

ALTER TABLE category
ADD CONSTRAINT category_id_pk PRIMARY KEY(id);




CREATE TABLE customer (
    id                      NUMBER(9) NOT NULL,
    name                    VARCHAR2(20 CHAR) NOT NULL,
    password                VARCHAR2(20 CHAR) NOT NULL,
    zipcode                 VARCHAR2(50 CHAR) NOT NULL,
    phone_number            VARCHAR2(14 CHAR) NOT NULL,
    coin                    NUMBER(9) NOT NULL,
    volunteer_working_time  NUMBER(9) NOT NULL
);


CREATE INDEX customer_id_idx
ON customer(id);

ALTER TABLE customer
ADD CONSTRAINT customer_id_pk PRIMARY KEY(id);



CREATE TABLE shipment_company (
    id    NUMBER(9) NOT NULL,
    name  VARCHAR2(20 CHAR) NOT NULL
)
LOGGING;

ALTER TABLE shipment_company ADD CONSTRAINT shipment_company_id_pk PRIMARY KEY ( id );



create table PRODUCT (
  id       number(9) NOT NULL,
  customer_id      number(9) NOT NULL,
  name             varchar2(50) NOT NULL,
  information       varchar2(200 CHAR),
  price            number(9) NOT NULL,
  category_id      number(9) NOT NULL,
  category_name    varchar2(50) NOT NULL, 
  product_status   VARCHAR2(10 CHAR) NOT NULL,
  shipment_id      number(9) NOT NULL,
  buy_customer_id  number(9)   
  )
partition by list(category_id)
(
  
  partition P_CLOTHING    values (1,2),
  
  partition P_DIGITAL    values (3,4),
  
  partition P_FURNITURE   values (5,6),
  
  partition P_BOOK    values (7,8),
  
  partition P_ETC    values (9,10)
  
);





CREATE INDEX product_id_idx
ON product(id);


CREATE INDEX product_customer_id_idx
ON product(customer_id);

CREATE INDEX product_shipment_id_idx
ON product(shipment_id);

CREATE INDEX product_category_id_idx
ON product(category_id);

ALTER TABLE product 
ADD CONSTRAINT product_id_customer_id_pk PRIMARY KEY(id, customer_id);

ALTER TABLE product
ADD CONSTRAINT product_shipment_id_nn
CHECK(shipment_id IS NOT NULL);

ALTER TABLE product 
ADD CONSTRAINT product_shipment_id_uk UNIQUE(shipment_id);

ALTER TABLE product
ADD CONSTRAINT product_category_id_nn CHECK(category_id IS NOT NULL);

ALTER TABLE product
ADD CONSTRAINT product_customer_id_fk FOREIGN KEY(customer_id)
REFERENCES customer(id);



ALTER TABLE PRODUCT ENABLE ROW MOVEMENT; 



CREATE TABLE shipment (
    id                      NUMBER(9) NOT NULL,
    shipment_company_id     NUMBER(9) NOT NULL,
    product_id              NUMBER(9) NOT NULL,
    product_customer_id     NUMBER(9) NOT NULL
)
LOGGING;

CREATE INDEX shipment_id_idx
ON shipment(id);

CREATE INDEX shipment_product_id_idx
ON shipment(product_id);

CREATE INDEX shipment_shipment_company_id_idx
ON shipment(shipment_company_id);

ALTER TABLE shipment ADD CONSTRAINT shipment_id_pk PRIMARY KEY(id);

ALTER TABLE shipment
ADD CONSTRAINT shipment_product_id_nn
CHECK (product_id is not null); 



ALTER TABLE shipment
ADD CONSTRAINT shipment_product_id UNIQUE(product_id);

CREATE TABLE temp_shipment (
    id                      NUMBER(9) NOT NULL,

    shipment_company_id     NUMBER(9) NOT NULL,
    product_id              NUMBER(9) NOT NULL,
    product_customer_id     NUMBER(9) NOT NULL
)
LOGGING;

CREATE INDEX shipment_id_idx
ON temp_shipment(id);

CREATE INDEX shipment_product_id_idx
ON temp_shipment(product_id);

CREATE INDEX shipment_shipment_company_id_idx
ON temp_shipment(shipment_company_id);

ALTER TABLE temp_shipment ADD CONSTRAINT shipment_id_pk PRIMARY KEY(id);

ALTER TABLE temp_shipment
ADD CONSTRAINT shipment_product_id_nn
CHECK (product_id is not null); 


ALTER TABLE temp_shipment
ADD CONSTRAINT shipment_product_id UNIQUE(product_id);


create cluster shipment_clu
(shipment_id number(9))
size 1k
tablespace users;


create index shipment_index
on cluster shipment_clu;




create table shipment
cluster shipment_clu(id)
as
select * from temp_shipment;
commit;

create index shipment_id_clu_idx
on shipment(id);









ALTER TABLE product
ADD CONSTRAINT product_shipment_id_fk
FOREIGN KEY(shipment_id) REFERENCES shipment(id)
deferrable initially deferred;




CREATE TABLE ORDERS (
    id                   NUMBER(9) NOT NULL,
    contract_date        DATE NOT NULL,
    customer_id          NUMBER(9) NOT NULL,
    product_id           NUMBER(9) NOT NULL,
    product_customer_id  NUMBER(9) NOT NULL,

    PRIMARY KEY(id, customer_id, product_id, product_customer_id)
)ORGANIZATION INDEX;

-- 오류 발생 시     set sqlblanklines on 

CREATE INDEX ORDERS_id_idx
ON ORDERS(id);

CREATE INDEX ORDERS_customer_buyer_id_idx
ON ORDERS(customer_id);

CREATE INDEX ORDERS_product_id_idx
ON ORDERS(product_id);


ALTER TABLE ORDERS
ADD CONSTRAINT ORDERS_customer_buyer_id_fk FOREIGN KEY(customer_id)
REFERENCES customer(id);

ALTER TABLE ORDERS
ADD CONSTRAINT ORDERS_product_id_fk FOREIGN KEY (product_id, product_customer_id)
REFERENCES product(id, customer_id);




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
	
	

create or replace view all_product_view
AS
SELECT p.id, p.name, p.information, p.price, c.name as product_custmoer_name, p.category_name, p.product_status, sp.name as ship_company_name, (select name from customer where id= p.buy_customer_id) as buy_custmoer_name
FROM product p
INNER JOIN customer c on p.customer_id = c.id
INNER JOIN shipment s on p.shipment_id = s.id
INNER JOIN shipment_company sp on sp.id = s.shipment_company_id;



-------------------------------------------------------


-- https://coding-factory.tistory.com/422--
-- Oracle SQL Developer Data Modeler ��� ������: 
-- 
-- CREATE TABLE                             6
-- CREATE INDEX                             2
-- ALTER TABLE                             13
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0