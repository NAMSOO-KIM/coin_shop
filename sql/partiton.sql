
DROP TABLE product CASCADE CONSTRAINTS;

create table PRODUCT (
  id       number(9) NOT NULL,
  customer_id      number(9) NOT NULL,
  name             varchar2(50) NOT NULL,
  infomation       varchar2(200 CHAR),
  price            number(9) NOT NULL,
  category_id      number(9) NOT NULL,
  category_name    varchar2(50) NOT NULL, 
  product_status   VARCHAR2(10 CHAR) NOT NULL, 
  shipment_id      number(9) NOT NULL
  )
partition by list(category_id) 
(
  
  partition P_CLOTHING    values (1,2),
  
  partition P_DIGITAL    values (3,4),

  partition P_FURNITURE   values (5,6),
 
  partition P_BOOK    values (7,8),

  partition P_ETC    values (9,10)
 
);

