--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--�������: ��� ������� ������ ���������� ����� �������� ����� ������, ����������� � ���������. �������: ����� � ����� ����������� ��������.

select classes.class, COUNT(s.ship)
from classes
left join
	(
	select * 
	from outcomes
	left join ships
	on outcomes.ship = ships.name
	where result = 'sunk'
	) as s
on  s.class = classes.class OR s.ship = classes.class
GROUP BY classes.class

--task2
--�������: ��� ������� ������ ���������� ���, ����� ��� ������ �� ���� ������ ������� ����� ������. ���� ��� ������ �� ���� ��������� ������� ����������, ���������� ����������� ��� ������ �� ���� �������� ����� ������. �������: �����, ���.

select classes.class, a.min_launched
from classes
left join
	(
	SELECT class, MIN(launched) AS min_launched 
	FROM ships
	GROUP BY class
	) AS a 
ON classes.class = a.class


--task3
--�������: ��� �������, ������� ������ � ���� ����������� �������� � �� ����� 3 �������� � ���� ������, ������� ��� ������ � ����� ����������� ��������.


SELECT c.class, SUM(sh.sunked)
FROM classes c
  LEFT JOIN (
     SELECT t.name AS name, t.class AS class,
           CASE WHEN o.result = 'sunk' THEN 1 ELSE 0 END AS sunked
     FROM
     (
      SELECT name, class
      FROM ships
       UNION
      SELECT ship, ship
      FROM outcomes
     )
     AS t
    LEFT JOIN outcomes o ON t.name = o.ship
  ) sh ON sh.class = c.class
GROUP BY c.class
HAVING COUNT(DISTINCT sh.name) >= 3 AND SUM(sh.sunked) > 0

--task4
--�������: ������� �������� ��������, ������� ���������� ����� ������ ����� ���� �������� ������ �� ������������� (������ ������� �� ������� Outcomes).

with ship_class as
(
  select name, class 
  from ships
  union
  select ship, ship
  from outcomes
)
select
  name
  from ship_class 
  join classes
  on ship_class.class=classes.class
  where numguns >= all(
    select ci.numguns
    from classes ci
    where ci.displacement=classes.displacement and ci.class in (
    															select ship_class.class
    															from ship_class)
    )

--task5
--������������ �����: ������� �������������� ���������, ������� ���������� �� � ���������� ������� RAM � � ����� ������� ����������� ����� ���� ��, ������� ���������� ����� RAM. �������: Maker
   
with maker_r as 
(
	select p.maker, ram, speed
	from 
	(
		select maker, Product.model
		from Product
		join printer
		on Product.model = printer.model
	) as p
	inner join 
	(
		select maker, ram, speed
		from Product
		left join Pc
		on Product.model = PC.model
	) as h
	on p.maker = h.maker
	where ram = (select min(ram) from pc) 
)

select distinct(maker)
from maker_r
where speed = (select max(speed) from maker_r)
