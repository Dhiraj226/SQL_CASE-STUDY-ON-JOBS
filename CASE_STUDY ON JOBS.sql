create database New;

use New;

select * from salaries;

/* Q)1.You're a Compensation analyst employed by a multinational corporation. Your Assignment is to Pinpoint Countries who give work fully remotely, for the title
 'managers’ Paying salaries Exceeding $90,000 USD*/
 
select distinct company_location from salaries where job_title like '%Manager' and salary_in_usd > 90000 and remote_ratio=100;


/* Q)2.AS a remote work advocate Working for a progressive HR tech startup who place their freshers’ clients IN large tech firms. you're tasked WITH
Identifying top 5 Country Having  greatest count of large(company size) number of companies.*/

select company_location, count(company_size) from salaries group by company_location order by count(company_size) DESC limit 5;

select company_location, count(*) from salaries where experience_level='EN' and company_size='L' group by company_location order by count(*) DESC limit 5;


/* Q)3. Picture yourself AS a data scientist Working for a workforce management platform. Your objective is to calculate the percentage of employees.
Who enjoy fully remote roles WITH salaries Exceeding $100,000 USD, Shedding light ON the attractiveness of high-paying remote positions IN today's job market.*/


set @total=(select count(*) from salaries where salary_in_usd > 100000);
set @count=(select count(*) from salaries where salary_in_usd > 100000 and remote_ratio=100);

select round((@count/@total)*100,2);


/* Q)4. Imagine you're a data analyst Working for a global recruitment agency. Your Task is to identify the Locations where average salaries exceed the
average salary for that job title in market for entry level, helping your agency guide candidates towards lucrative countries.*/

select t.job_title,company_location,average,avg_per_country from 
(
select job_title,avg(salary_in_usd) as average from salaries group by job_title
)t

inner join 
(
select company_location,job_title,avg(salary_in_usd) as avg_per_country from salaries group by company_location,job_title
) b on t.job_title=b.job_title where avg_per_country > average;

/* Q)5 find out for each jobtitle ,which country pays maximum average salary*/



select a.job_title,mx,company_location from
(select job_title,max(average) as mx from
(
select company_location,job_title,avg(salary_in_usd) as average from salaries group by company_location,job_title
)b group by job_title
)a 
inner join 
(
select company_location,job_title,avg(salary_in_usd) as average from salaries group by company_location,job_title
)c on a.job_title=c.job_title ;


/*6.  AS a data-driven Business consultant, you've been hired by a multinational corporation to analyze salary trends across different company Locations.
 Your goal is to Pinpoint Locations WHERE the average salary Has consistently Increased over the Past few years (Countries WHERE data is available for 3 years Only(this and pst two years) 
 providing Insights into Locations experiencing Sustained salary growth.*/

with dhiraj as
(
	select * from salaries where company_location in
    (
	select company_location from (
	select company_location,avg(salary_in_usd),count(distinct work_year) as nm from salaries where work_year >= year(current_date())-2 
	group by company_location having nm=3)t 
	)
) 

select company_location,
max(case when work_year=2022 then average end) as average_2022,
max(case when work_year=2023 then average end) as average_2023,
max(case when work_year=2024 then average end) as average_2024
from
(
select company_location,work_year,avg(salary_in_usd) as average from dhiraj group by company_location,work_year 
)q group by company_location having average_2024 > average_2023 and average_2024 > average_2022 and average_2023 > average_2022;


/* 7.Picture yourself AS a workforce strategist employed by a global HR tech startup. Your missiON is to determINe the percentage of  fully remote work for each 
 experience level IN 2021 and compare it WITH the correspONdINg figures for 2024, highlightINg any significant INcreASes or decreASes IN remote work adoptiON
 over the years.*/
select m.experience_level,cnt_2021,cnt_2024,total_2021,total_2024,percentage_2021,percentage_2024 from
(
	select t.experience_level,cnt_2021,total_2021,(cnt_2021/total_2021)*100 as percentage_2021 from 
	(
	select experience_level,count(*) as total_2021 from salaries where work_year=2021 group by experience_level
	)t
	inner join
	(
	select experience_level,count(*) as cnt_2021 from salaries where work_year=2021 and remote_ratio=100 group by experience_level
	)b on t.experience_level=b.experience_level
)m 

inner join 
(

	select t.experience_level,cnt_2024,total_2024,(cnt_2024/total_2024)*100 as percentage_2024 from 
	(
	select experience_level,count(*) as total_2024 from salaries where work_year=2024 group by experience_level
	)t
	inner join
	(
    
	select experience_level,count(*) as cnt_2024 from salaries where work_year=2024 and remote_ratio=100 group by experience_level
	)b on t.experience_level=b.experience_level

)n on m.experience_level=n.experience_level;


/* 8. AS a compensatiON specialist at a Fortune 500 company, you're tASked WITH analyzINg salary trends over time. Your objective is to calculate the average 
salary INcreASe percentage for each experience level and job title between the years 2023 and 2024, helpINg the company stay competitive IN the talent market.*/


select t.job_title,t.experience_level,avg_2023,avg_2024,((avg_2024-avg_2023)/avg_2024)*100 as increase_percent from
(
select job_title,experience_level ,avg(salary_in_usd) as avg_2023 from salaries where work_year=2023 group by job_title,experience_level
)t 
inner join
(
 select job_title,experience_level ,avg(salary_in_usd) as avg_2024 from salaries where work_year=2024 group by job_title,experience_level
 )b on t.job_title=b.job_title;
 
 ' 
 









