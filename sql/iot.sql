
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

ALTER TABLE ORDERS
ADD CONSTRAINT ORDERS_customer_buyer_id_fk FOREIGN KEY(customer_id)
REFERENCES customer(id);

ALTER TABLE ORDERS
ADD CONSTRAINT ORDERS_product_id_fk FOREIGN KEY (product_id, product_customer_id)
REFERENCES product(id, customer_id);
