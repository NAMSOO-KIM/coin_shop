

create cluster shipment_clu
(shipment_id number(9))
size 1k
tablespace users;



create index shipment_index
on cluster shipment_clu;


create table c_shipment
cluster shipment_clu(id)
as
select * from shipment;


rename shipment to old_shipment;
rename c_shipment to shipment;


create index shipment_id_clu_idx
on shipment(id);

