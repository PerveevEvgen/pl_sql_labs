--Виводить працівників, їх департамент та адресу роботи
select em.first_name, em.last_name, dep.department_name, loc.street_address from employees em
join departments dep on em.department_id = dep.department_id
join locations loc on dep.location_id = loc.location_id;


--Виводить працівника без департаменту
select em.first_name, em.last_name, dep.department_name from employees em
left join departments dep on em.department_id = dep.department_id
where dep.department_id is NULL;


--Виводить ті департаменти в яких немає працівників
select em.first_name, em.last_name, dep.department_name, dep.department_id from employees em
right join departments dep on em.department_id = dep.department_id
where em.department_id is NULL;

