
-- 클러스터 생성
create cluster shipment_clu
(shipment_id number(9))
size 1k
tablespace users;


-- 클러스터용 인덱스 생성
create index shipment_index
on cluster shipment_clu;

-- 테이블을 클러스터 안에 생성
create table c_shipment
cluster shipment_clu(id)
as
select * from shipment;

-- 이름 바꾸기
rename shipment to old_shipment;
rename c_shipment to shipment;

-- 테이블에 추가 인덱스 생성
create index shipment_id_clu_idx
on shipment(id);


-- 샘플 데이터 삽입
insert into shipment values(1,'asdf','20200120',1,1,1);


-- 실행계획 확인 1 : 단일 테이블
-- select /*+ rule */ * from emp
-- where deptno = 10;


-- set autot on


--  DROP INDEX 인덱스 명; 
-- DROP SEQUENCE 




"""

drop table shipment cascade constraint;
drop sequence shipment_id_seq;
drop index shipment_id_idx;


CREATE SEQUENCE shipment_id_seq
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 999999999
NOCYCLE;



CREATE TABLE shipment (
    id                      NUMBER(9) NOT NULL,
    name                    VARCHAR2(50 CHAR) NOT NULL,
    estimated_arrival_date  DATE,
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
CHECK (product_id is not null); -- 1:1 mandetory not null, unique �Ӽ�, fk

ALTER TABLE shipment
ADD CONSTRAINT shipment_product_id UNIQUE(product_id);

ALTER TABLE shipment
ADD CONSTRAINT shipment_shipment_company_id_fk
FOREIGN KEY(shipment_company_id)
REFERENCES shipment_company(id);

ALTER TABLE shipment
ADD CONSTRAINT shipment_product_id_fk FOREIGN KEY (product_id, product_customer_id)
REFERENCES product(id, customer_id);

"""