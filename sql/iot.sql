-- ORDER

CREATE TABLE ORDERS (
    id                   NUMBER(9) NOT NULL,
    contract_date        DATE NOT NULL,
    customer_id          NUMBER(9) NOT NULL,
    product_id           NUMBER(9) NOT NULL,
    product_customer_id  NUMBER(9) NOT NULL,

    PRIMARY KEY(id, customer_id, product_id, product_customer_id)
)ORGANIZATION INDEX;


CREATE INDEX ORDERS_id_idx
ON ORDERS(id);

CREATE INDEX ORDERS_customer_buyer_id_idx
ON ORDERS(customer_id);

CREATE INDEX ORDERS_product_id_idx
ON ORDERS(product_id);

-- ALTER TABLE ORDERS
-- ADD CONSTRAINT ORDERS_id_pk PRIMARY KEY(id);

"""
이부분 복합키에 외래키가 포함되도록..


외래키만 지정할 경우. 식별 값이 없어도 테이블에 삽입이 가능해서.

"""
ALTER TABLE ORDERS
ADD CONSTRAINT ORDERS_customer_buyer_id_fk FOREIGN KEY(customer_id)
REFERENCES customer(id);

ALTER TABLE ORDERS
ADD CONSTRAINT ORDERS_product_id_fk FOREIGN KEY (product_id, product_customer_id)
REFERENCES product(id, customer_id);

---------------------
-- 데이터 삽입
insert into customer values(1,'김남수','1234','1234','01021091323',123,12);
insert into category values(1,'의류');
insert into product values(1,1,'김남수','12441',123,1,1);
insert into orders values(1,'20190210',1,1,1);
select * from orders;
select * from product;

-------------------------------------------------------


