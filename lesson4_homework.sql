--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type

select product.model, maker, type
from product
join laptop
on product.model = laptop.model
union ALL
	select product.model, maker, type
	from product
	join pc
	on product.model = pc.model
union ALL
	select product.model, maker, product.type
	from product
	join printer
	on product.model = printer.model


--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"
select *,
case 
	when price > (select avg(price) from pc)
	then '1'
	else '0'
end
from printer

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

select *
from ships s 
where class is null

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

select name
from battles
where year(date) not in
     (select launched
      from ships
      where launched is not null)

 
--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
 
select battle 
from outcomes
where ship in (select name
               from ships
               where class = 'Kongo')
               
--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag

create view all_products_flag_300 as 

select model, price, 
case when price > 300
then 1 
else 0 
end flag
from 
	(
	select product.model, price
	from product
	join laptop
	on product.model = laptop.model
	union
		select product.model, price
		from product
		join pc
		on product.model = pc.model
	union
		select product.model, price
		from product
		join printer
		on product.model = printer.model
	) as all_product

select *
from all_products_flag_300            
               
--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag

create view all_products_flag_avg_price as 

with all_product as (
	select product.model, price
	from product
	join laptop
	on product.model = laptop.model
	union
		select product.model, price
		from product
		join pc
		on product.model = pc.model
	union
		select product.model, price
		from product
		join printer
		on product.model = printer.model
		) 
select model, price, 
case when price > (select avg(price) from all_product)
then 1 
else 0 
end flag
from all_product

select *
from all_products_flag_avg_price

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
with pr_printer as
	(   select maker, product.model, price
		from product 
		join printer 
		on product.model = printer.model
	)

select model 
from pr_printer
where maker = 'A' and price > (select avg(price) from pr_printer where maker = 'D' or maker = 'C')

--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
with all_pr as
	(   select maker, product.model, price, product.type
		from product 
		join printer 
		on product.model = printer.model
		union 
		select maker, product.model, price, product.type
		from product 
		join pc 
		on product.model = pc.model
		union
		select maker, product.model, price, product.type
	    from product
	    join laptop
	    on product.model = laptop.model
	)

select model 
from all_pr
where maker = 'A' and price > (select avg(price) from all_pr where type = 'Printer' and (maker = 'D' or maker = 'C'))


--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)

with all_pr as
	(   select maker, product.model, price, product.type
		from product 
		join printer 
		on product.model = printer.model
		union 
		select maker, product.model, price, product.type
		from product 
		join pc 
		on product.model = pc.model
		union
		select maker, product.model, price, product.type
	    from product
	    join laptop
	    on product.model = laptop.model
	)
	
select type, avg(price)
from all_pr
where maker = 'A'
group by type
	    
	    
	    
--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

create view count_products_by_makers as 

with all_pr as
	(   select maker, product.model, price, product.type
		from product 
		join printer 
		on product.model = printer.model
		union 
		select maker, product.model, price, product.type
		from product 
		join pc 
		on product.model = pc.model
		union
		select maker, product.model, price, product.type
	    from product
	    join laptop
	    on product.model = laptop.model
	)
	
select *
from count_products_by_makers


--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)
select *
from count_products_by_makers

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

create table printer_updated as
	(select *
     from printer
     where model in 
			(select model
			from product
			where maker != 'D')
	)

select *
from printer_updated	


--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

create view printer_updated_with_makers as 
		(
		select code, printer_updated.model, color, printer_updated.type, price, maker
		from printer_updated
		join product
		on printer_updated.model = product.model
		)

select *
from printer_updated_with_makers

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

create view sunk_ships_by_classes as 
		(
		select count(outcomes.ship),
		case 
			when class is null
			then '0'
			else cast(class as char(20))
		end as class
		
		from outcomes
		left join  ships
		on outcomes.ship = ships.name 
		where result = 'sunk'
		group by class
		)

select *
from sunk_ships_by_classes

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)
-- Ответ в colab
select *
from sunk_ships_by_classes 

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

create table classes_with_flag as
	(select *,
	case 
	when numguns >= '9'	
	then 1 
	else 0 
	end flag
    from classes
    )
	
select *
from classes_with_flag

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

select country, count(type)
from classes
group by country

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

select distinct(ship)
from (
select ship
from outcomes
union
select name
from ships) as name_ships
where ship like 'O%' or ship like 'M%';


--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

select count(ship)
from (
select ship
from outcomes
union
select name
from ships) as name_ships
where ship like '_% _%';

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

select launched as year, count(name)
from ships
group by launched
