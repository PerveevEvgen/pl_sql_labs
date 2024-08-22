--1 . Вибрати усіх робітників, локація департаменту яких знаходиться у Seattle.
select
    first_name, last_name
from 
    employees
join
    departments on employees.department_id = departments.department_id
join
    locations on departments.location_id = locations.location_id
where locations.city = 'Seattle';
--2 Вибрати всі країни, робітники з яких працюють на посаді «Stock Clerk».
select 
    country_name 
from 
    countries
join
    locations on locations.country_id = countries.country_id
join
    departments on departments.location_id = locations.location_id
join
    employees on employees.department_id = departments.department_id
join
    jobs on jobs.job_id = employees.job_id
where
    job_title = 'Stock Clerk'
group by country_name;

--3  Вибрати всіх робітників з регіону Europe, в яких ЗП не більше 9000 і менше або дорівнює 17000.

select
    employees.first_name, employees.last_name, employees.salary
from
    employees
join
    departments on employees.department_id = departments.department_id
join
    locations on departments.location_id = locations.location_id
join
    countries on locations.country_id = countries.country_id
join
    regions on countries.region_id = regions.region_id
where
    regions.region_name = 'Europe' and employees.salary between 9000 and 170001;

--4 Вивести всі роботи, робітники на яких отримують заробітну плату вище мінімальної згідно атрибуту MIN_SALARY таблиці JOBS
select
    job_title 
from
    employees
join
    jobs on employees.job_id = jobs.job_id
where
    jobs.min_salary < employees.salary
group by 
    job_title;

 
--5 Вивести департаменти, робітники яких працюють на посадах з Максимал--ьною заробітною платою вище 15000.
select
    department_name
from
    departments
join
    employees on departments.department_id = employees.department_id
join
    jobs on employees.job_id = jobs.job_id
where
    max_salary > 15000
group by
    department_name;

--6 Вивести всі департаменти та працівників, що в них працюють з їхньою
заробітною платою.
select
    departments.department_name,
    employees.first_name,
    employees.last_name,
    employees.salary
from
    departments
join
    employees on departments.department_id = employees.department_id;


--7 Вивести всіх працівників, їх посади та країни (COUNTRIES), де вони працюють.
select
    employees.first_name,
    employees.last_name,
    jobs.job_title,
    countries.country_name 
from
    departments
join
    employees on departments.department_id = employees.department_id
join
    jobs on employees.job_id = jobs.job_id
join
    locations on  departments.location_id = locations.location_id
join
    countries on locations.country_id = countries.country_id;


--8.1 Вивести ієрархію робітників
SELECT EMPLOYEE_ID,
            FIRST_NAME || ' ' || LAST_NAME EMPLOYEE_NAME,
            MANAGER_ID,
            PRIOR MANAGER_ID,
            PRIOR FIRST_NAME || ' ' || PRIOR LAST_NAME MANAGER_NAME,
            LEVEL
       FROM EMPLOYEES
 CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID;

--8.2 Повна ієрархія

SELECT EMPLOYEE_ID,
            FIRST_NAME || ' ' || LAST_NAME EMPLOYEE_NAME,
            MANAGER_ID,
            PRIOR MANAGER_ID,
            PRIOR FIRST_NAME || ' ' || PRIOR LAST_NAME MANAGER_NAME,
            LEVEL
       FROM EMPLOYEES
        WHERE LEVEL < 4
 CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID;





