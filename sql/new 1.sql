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
var pro_detail refcursor;
exec ALL_product(:pro_detail);
print pro_detail;