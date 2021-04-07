
DROP TABLE product CASCADE CONSTRAINTS;

create table PRODUCT (
  id       number(9) NOT NULL,
  customer_id      number(9) NOT NULL,
  name             varchar2(50) NOT NULL,
  infomation       varchar2(200 CHAR),
  price            number(9) NOT NULL,
  category_id      number(9) NOT NULL,
  category_name    varchar2(50) NOT NULL, -- 새로 추가됨
  product_status   VARCHAR2(10 CHAR) NOT NULL, --판매 상태 정보 추가 (READY,ORDER)
  shipment_id      number(9) NOT NULL
  )
partition by list(category_id)  -- category_id로 파티셔닝 했는데 category_name으로 하는게 좋을거 같아요
(
  --partition P_CLOTHING    values ('clothing','fashion'),
  partition P_CLOTHING    values (1,2),
  --partition P_DIGITAL    values ('digital','home appliances'),
  partition P_DIGITAL    values (3,4),
  --partition P_FURNITURE   values ('furniture','interior'),
  partition P_FURNITURE   values (5,6),
  --partition P_BOOK    values ('book,ticket'),
  partition P_BOOK    values (7,8),
  --partition P_ETC    values ('etc','unknown')
  partition P_ETC    values (9,10)
  --partition P_ETC values (default)
);


-- 샘플데이터
-- insert into product values(1,1,'asdf','124',123,1,'의류',1);



-- 참고: https://jack-of-all-trades.tistory.com/66

-- CREATE INDEX product_id_idx
-- ON product(id);

-- CREATE INDEX product_customer_id_idx
-- ON product(customer_id);

-- CREATE INDEX product_shipment_id_idx
-- ON product(shipment_id);

-- CREATE INDEX product_category_id_idx
-- ON product(category_id);

-- ALTER TABLE product 
-- ADD CONSTRAINT product_id_customer_id_pk PRIMARY KEY(id, customer_id);

-- ALTER TABLE product
-- ADD CONSTRAINT product_shipment_id_nn
-- CHECK(shipment_id IS NOT NULL);

-- ALTER TABLE product 
-- ADD CONSTRAINT product_shipment_id_uk UNIQUE(shipment_id);

-- ALTER TABLE product
-- ADD CONSTRAINT product_category_id_nn CHECK(category_id IS NOT NULL);

-- ALTER TABLE product
-- ADD CONSTRAINT product_category_id_fk FOREIGN KEY(category_id)
-- REFERENCES category(id);

-- ALTER TABLE product
-- ADD CONSTRAINT product_customer_id_fk FOREIGN KEY(customer_id)
-- REFERENCES customer(id);

