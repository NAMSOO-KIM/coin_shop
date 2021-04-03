CREATE OR REPLACE procedure ALL_product
(
	ALL_PRODUCT_record  OUT 		SYS_REFCURSOR
)
AS
BEGIN
OPEN ALL_PRODUCT_record FOR
SELECT p.id,p.name,p.price, c.name, p.category_name, p.product_status, sp.name
FROM product p
INNER JOIN customer c on p.customer_id = c.id
INNER JOIN shipment s on p.shipment_id = s.id
INNER JOIN shipment_company sp on sp.id = s.shipment_company_id;
END;
/


var  ALL_P refcursor;
exec ALL_product(:ALL_P);
print ALL_P;