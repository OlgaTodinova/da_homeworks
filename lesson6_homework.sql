
--task3  (lesson6)
--Компьютерная фирма: Найдите номер модели продукта (ПК, ПК-блокнота или принтера), имеющего самую высокую цену. Вывести: model

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
-- Компьютерная фирма: Создать таблицу all_products_with_index_task5 как объединение всех данных по ключу code (union all) 
--и сделать флаг (flag) по цене > максимальной по принтеру. Также добавить нумерацию (через оконные функции)
--по каждой категории продукта в порядке возрастания цены (price_index). По этому price_index сделать индекс


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
