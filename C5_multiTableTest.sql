## 第5章 多表查询
use test;
show tables;

desc employee;
desc department;

select e.fname, e.lname, d.name from employee e inner join department d using (dept_id);
select e.fname, e.lname, d.name from employee e inner join department d on e.dept_id = d.dept_id;
select e.fname, e.lname, d.name from employee e, department d where e.dept_id = d.dept_id;

SELECT 
    a.account_id, c.fed_id
FROM
    account a
        INNER JOIN
    customer c ON a.cust_id = c.cust_id
WHERE
    c.cust_type_cd = 'B';

SELECT 
    a.account_id, c.fed_id, e.fname, e.lname
FROM
    account a
        INNER JOIN
    customer c ON a.cust_id = c.cust_id
        INNER JOIN
    employee e ON a.open_emp_id = e.emp_id
WHERE
    c.cust_type_cd = 'B';

SELECT 
    emp_id, assigned_branch_id
FROM
    employee
WHERE
    start_date < '2007-01-01'
        AND (title = 'Teller'
        OR title = 'Head Teller');

select branch_id from branch where name = 'Woburn Branch';

SELECT 
    a.account_id, a.cust_id, a.open_date, a.product_cd
FROM
    account a
        INNER JOIN
    (SELECT 
        emp_id, assigned_branch_id
    FROM
        employee
    WHERE
        start_date < '2007-01-01'
            AND (title = 'Teller'
            OR title = 'Head Teller')) e ON a.open_emp_id = e.emp_id
        INNER JOIN
    (SELECT 
        branch_id
    FROM
        branch
    WHERE
        name = 'Woburn Branch') b ON e.assigned_branch_id = b.branch_id;
        


SELECT 
    a.account_id,
    e.emp_id,
    b_a.name open_branch,
    b_e.name emp_branch
FROM
    account a
        INNER JOIN
    branch b_a ON a.open_branch_id = b_a.branch_id
        INNER JOIN
    employee e ON a.open_emp_id = e.emp_id
        INNER JOIN
    branch b_e ON e.assigned_branch_id = b_e.branch_id
WHERE
    a.product_cd = 'CHK';


# 自连接
SELECT 
    e.fname,
    e.lname,
    e_mgr.fname mgr_fname,
    e_mgr.lname mgr_lname
FROM
    employee e
        INNER JOIN
    employee e_mgr ON e.superior_emp_id = e_mgr.emp_id;

SELECT 
    e.emp_id, e.fname, e.lname, e.start_date
FROM
    employee e
        INNER JOIN
    product p ON e.start_date >= p.date_offered
        AND e.start_date <= p.date_retired
WHERE
    p.name = 'no-fee checking';

select e1.fname, e1.lname, 'VS' vs, e2.fname, e2.lname from employee e1 inner join employee e2 on e1.emp_id > e2.emp_id 
where e1.title = 'Teller' and e2.title = 'Teller';

show tables;
desc branch;
desc business;

########################### test

# test 5-1
select e.emp_id, e.fname, e.lname, b.name from employee e inner join branch b on e.assigned_branch_id = b.branch_id;

# test 5-2
select * from customer;
select * from product;
select * from account;
desc customer;
desc product;
desc account;

SELECT 
    a.account_id, c.fed_id, p.name
FROM
    customer c
        INNER JOIN
    account a ON c.cust_id = a.cust_id
        INNER JOIN
    product p ON a.product_cd = p.product_cd
WHERE
    c.cust_type_cd = 'I';


# test 5-3
select * from employee;

SELECT 
    e1.emp_id, e1.fname, e1.lname
FROM
    employee e1
        INNER JOIN
    employee e2 ON e1.superior_emp_id = e2.emp_id
WHERE
    e1.dept_id != e2.dept_id; 
