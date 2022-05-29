-- ������� 1: ������� name, class �� ��������, ���������� ����� 1920
select name, class 
from ships  
where launched > 1920

-- ������� 2: ������� name, class �� ��������, ���������� ����� 1920, �� �� ������� 1942
--
select name, class 
from ships  
where launched > 1920 and  launched < 1942
-- ������� 3: ����� ���������� �������� � ������ ������. ������� ���������� � class

select class, count(*)
from classes
group by class

-- ������� 4: ��� ������� ��������, ������ ������ ������� �� ����� 16, ������� ����� � ������. (������� classes)
--
select class, country
from classes
where bore >=16

-- ������� 5: ������� �������, ����������� � ��������� � �������� ��������� (������� Outcomes, North Atlantic). �����: ship.
--
select ship
from outcomes
where battle = 'North Atlantic' and result = 'sunk'

-- ������� 6: ������� �������� (ship) ���������� ������������ �������

select ship
from outcomes
join battles
on outcomes.battle = battles.name
where result = 'sunk' and date = (select max(date)
								  from outcomes
								  join battles
								  on outcomes.battle = battles.name
								  where result = 'sunk')

								  
-- ������� 7: ������� �������� ������� (ship) � ����� (class) ���������� ������������ �������
--
select ship, class 
from 
(select ship
from outcomes
join battles
on outcomes.battle = battles.name
where result = 'sunk' and date = (select max(date)
								  from outcomes
								  join battles
								  on outcomes.battle = battles.name
								  where result = 'sunk')) as n
left join ships
on n.ship = ships.name 
  
								  
-- ������� 8: ������� ��� ����������� �������, � ������� ������ ������ �� ����� 16, � ������� ���������. �����: ship, class
--
select ship, class
from classes
full join outcomes
on classes.class = outcomes.ship
where result = 'sunk' and bore > 16


-- ������� 9: ������� ��� ������ ��������, ���������� ��� (������� classes, country = 'USA'). �����: class
--
select class
from classes
where country = 'USA'

-- ������� 10: ������� ��� �������, ���������� ��� (������� classes & ships, country = 'USA'). �����: name, class

select name, classes.class
from classes 
join ships
on classes.class = ships.class
where country = 'USA'


--������� 20: ������� ������� ������ hd PC ������� �� ��� ��������������, ������� ��������� � ��������. �������: maker, ������� ������ HD.


select pc_maker.maker, avg(hd)
from 
	(select *
	from product 
	join pc
	on product.model = pc.model) as pc_maker
join 
	(select *
	from product 
	join printer 
	on product.model = printer.model) as printer_maker
on pc_maker.maker = printer_maker.maker
group by pc_maker.maker


