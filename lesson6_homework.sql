
--task3  (lesson6)
--������������ �����: ������� ����� ������ �������� (��, ��-�������� ��� ��������), �������� ����� ������� ����. �������: model

select model
from
(
	select *, row_number() over (partition by type order by price desc) as r
	from
	(
	select  product.type, product.model, price
			from product
			join pc
			on product.model = pc.model
			union all
			select product.type, product.model, price
			from product
			join printer
			on product.model = printer.model
			union all
			select product.type, product.model, price
			from product
			join laptop
			on product.model = laptop.model
	) as foo	
) as foo1
where r = '1'
		


--task5  (lesson6)
-- ������������ �����: ������� ������� all_products_with_index_task5 ��� ����������� ���� ������ �� ����� code (union all) 
--� ������� ���� (flag) �� ���� > ������������ �� ��������. ����� �������� ��������� (����� ������� �������)
--�� ������ ��������� �������� � ������� ����������� ���� (price_index). �� ����� price_index ������� ������


create table all_products_with_index_task5 as 

select product.model, maker, price, type, row_number() over (partition by type order by price desc) as price_index,
 case  
 when price > (select max(price) from printer) then 1 
 else 0 
 end flag
 from  
 (
	 select code, model, price 
	 from pc  
	 union all 
	 select code, model, price 
	 from laptop l  
	 union all 
	 select code, model, price 
	 from printer
 ) as all_products 
 join product  
 on all_products.model = product.model 
 
 
 create index price_idx5 on all_products_with_index_task5 (price_index)
