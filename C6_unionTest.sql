## 第6章 使用集合
use test;

desc product;
desc customer;

SELECT 1 num, 'abc' str 
UNION SELECT 9 num, 'xyz' str;

SELECT 
    'IND' type_cd, cust_id, lname name
FROM
    individual 
UNION ALL SELECT 
    'BUS' type_cd, cust_id, name
FROM
    business;

select 'IND' type_cd, cust_id, lname name from individual;
select 'BUS' type_cd, cust_id, name from business;

SELECT 
    'IND' type_cd, cust_id, lname name
FROM
    individual 
UNION ALL SELECT 
    'BUS' type_cd, cust_id, name
FROM
    business 
UNION ALL SELECT 
    'BUS' type_cd, cust_id, name
FROM
    business;


SELECT 
    emp_id
FROM
    employee
WHERE
    assigned_branch_id = 2
        AND (title = 'Teller'
        OR title = 'Head Teller') 
UNION SELECT DISTINCT
    open_emp_id
FROM
    account
WHERE
    open_branch_id = 2;

# select emp_id from employee where assigned_branch_id = 2 and (title = 'Teller' or title = 'Head Teller')
# except/intersect
# select distinct open_emp_id from account where open_branch_id = 2;

SELECT 
    emp_id, assigned_branch_id
FROM
    employee
WHERE
    title = 'Teller' 
UNION SELECT 
    open_emp_id, open_branch_id
FROM
    account
WHERE
    product_cd = 'SAV'
ORDER BY emp_id;

SELECT 
    cust_id
FROM
    account
WHERE
    product_cd IN ('SAV' , 'MM') 
UNION ALL SELECT 
    a.cust_id
FROM
    account a
        INNER JOIN
    branch b ON a.open_branch_id = b.branch_id
WHERE
    b.name = 'Woburn Branch' 
UNION SELECT 
    cust_id
FROM
    account
WHERE
    avail_balance BETWEEN 500 AND 2500;

##################################### test

# test 6-2
select * from customer;
select * from employee;
select * from officer;
select * from individual;

SELECT 
    lname, fname
FROM
    individual 
UNION SELECT 
    lname, fname
FROM
    employee;

# test 6-3
SELECT 
    lname, fname
FROM
    individual 
UNION SELECT 
    lname, fname
FROM
    employee
ORDER BY lname;

















