## 第3章 查询入门
show databases;
use test;
show tables;
select * from department;

select emp_id, 'ACTIVE', emp_id*3.14, upper(lname) from employee;

select version(), user(), database();

select emp_id, 'ACTIVE' as status, emp_id*3.14 as empid_x_pi, upper(lname) as last_name_upper from employee;

select distinct cust_id from account;

select e.emp_id, e.fname, e.lname from (select emp_id, fname, lname, start_date, title from employee) e;

create view employee_vw as select emp_id, fname, lname, year(start_date) start_year from employee;	##创建视图

select emp_id, start_year from employee_vw;

select emp_id, fname, lname, start_date, title from employee where title = 'Head Teller';

select emp_id, fname, lname, start_date, title from employee where title = 'Head Teller' or start_date > '2006-01-01';

select d.name, count(e.emp_id) num_employees from department as d inner join employee as e on d.dept_id = e.dept_id 
group by d.name having count(e.emp_id)>2;

select distinct open_emp_id, product_cd from account order by open_emp_id desc limit 0,5;

select cust_id, cust_type_cd, city, state, fed_id from customer order by right(fed_id, 4);


############################################################# test

## test3-1
select emp_id, fname, lname from employee order by lname, fname;

## test3-2
select account_id, cust_id, avail_balance from account where status = 'ACTIVE' and avail_balance > 2500;

## test3-3
select distinct open_emp_id from account;

## test3-4
select p.product_cd, a.cust_id, a.avail_balance from product p inner join account a on p.product_cd = a.product_cd
where p.product_type_cd = 'ACCOUNT' order by p.product_cd, a.cust_id;






