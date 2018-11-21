## 第3章 查询入门

show databases;
use test;
show tables;
select * from department;

SELECT 
    emp_id, 'ACTIVE', emp_id * 3.14, UPPER(lname)
FROM
    employee;

select version(), user(), database();

SELECT 
    emp_id,
    'ACTIVE' AS status,
    emp_id * 3.14 AS empid_x_pi,
    UPPER(lname) AS last_name_upper
FROM
    employee;

select distinct cust_id from account;

SELECT 
    e.emp_id, e.fname, e.lname
FROM
    (SELECT 
        emp_id, fname, lname, start_date, title
    FROM
        employee) e;

CREATE VIEW employee_vw AS
    SELECT 
        emp_id, fname, lname, YEAR(start_date) start_year
    FROM
        employee;	##创建视图

SELECT 
    emp_id, start_year
FROM
    employee_vw;

SELECT 
    emp_id, fname, lname, start_date, title
FROM
    employee
WHERE
    title = 'Head Teller';

SELECT 
    emp_id, fname, lname, start_date, title
FROM
    employee
WHERE
    title = 'Head Teller'
        OR start_date > '2006-01-01';

SELECT 
    d.name, COUNT(e.emp_id) num_employees
FROM
    department AS d
        INNER JOIN
    employee AS e ON d.dept_id = e.dept_id
GROUP BY d.name
HAVING COUNT(e.emp_id) > 2;

SELECT DISTINCT
    open_emp_id, product_cd
FROM
    account
ORDER BY open_emp_id DESC
LIMIT 0 , 5;

SELECT 
    cust_id, cust_type_cd, city, state, fed_id
FROM
    customer
ORDER BY RIGHT(fed_id, 4);


############################################################# test

## test3-1
SELECT 
    emp_id, fname, lname
FROM
    employee
ORDER BY lname , fname;

## test3-2
SELECT 
    account_id, cust_id, avail_balance
FROM
    account
WHERE
    status = 'ACTIVE'
        AND avail_balance > 2500;

## test3-3
SELECT DISTINCT
    open_emp_id
FROM
    account;

## test3-4
SELECT 
    p.product_cd, a.cust_id, a.avail_balance
FROM
    product p
        INNER JOIN
    account a ON p.product_cd = a.product_cd
WHERE
    p.product_type_cd = 'ACCOUNT'
ORDER BY p.product_cd , a.cust_id;






