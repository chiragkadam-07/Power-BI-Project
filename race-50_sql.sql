-- how many states represented in the race
select count(distinct state) from race_csv;
select distinct state from race_csv;

-- what was the avereage time of men vs women
select Gender, avg(Minutes) from race_csv group by Gender;

-- what were the youngest and oldest ages in race
select Gender, min(Age) as 'Youngest person Age',max(Age) as 'Oldest person Age'  from race_csv group by Gender;

-- what was the average time for each age group
with age as(
select Minutes,
case 
	when Age < 30 then '20-29'
	when Age < 40 then '30-39'
	when Age < 50 then '40-49'
	when Age < 60 then '50-59'
	else '60+' 
end as 'Age_Group'
from race_csv)
select Age_Group, avg(Minutes) from  age group by Age_Group order by 1;

select avg(Minutes),
case
	when Age > 20 and Age < 30 then '20-29'
	when Age >= 30 and Age < 40 then '30-39'
	when Age >= 40 and Age < 50 then '40-49'
	when Age >= 50 and Age < 60 then '50-59'
	else '60+'
end as 'Age_Group'
from race_csv group by `Age_Group` order by 2;

with cte as(
select avg(Minutes) as 'Average_Time',
case
	when Age > 20 and Age < 30 then '20-29'
	when Age > 30 and Age < 40 then '30-39'
	when Age > 40 and Age < 50 then '40-49'
	when Age > 50 and Age < 60 then '50-59'
	else '60+'
end as 'Age_Group'
from race_csv group by `Age_Group` order by 2)
select Age_Group, Average_Time, rank() over(order by Average_Time) as rnk from cte;

with cte as(
select avg(Minutes) as 'Average_Time',
case
	when Age > 20 and Age < 30 then '20-29'
	when Age > 30 and Age < 40 then '30-39'
	when Age > 40 and Age < 50 then '40-49'
	when Age > 50 and Age < 60 then '50-59'
	else '60+'
end as 'Age_Group'
from race_csv group by `Age_Group` order by 2),
cte1 as(
select *, rank() over(order by Average_Time) as rnk from cte)
(select Age_Group,Average_Time from cte1 where rnk in (1,2,3));

-- top 3 males and females
with cte as(
select Name,Gender,Minutes, row_number() over(partition by Gender order by Minutes) as rnk
from race_csv)
select * from cte where rnk in (1,2,3) order by Gender desc;

-- 
create view `Top 3` as
with cte as(
select Name,Gender,Minutes, row_number() over(partition by Gender order by Minutes) as rnk
from race_csv)
select * from cte where rnk in (1,2,3) order by Gender desc;