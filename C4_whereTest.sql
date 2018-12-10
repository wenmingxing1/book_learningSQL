## 第4章 过滤
show databases;
use test;
show tables;

SELECT 
    pt.name product_type, p.name product
FROM
    product p
        INNER JOIN
    product_type pt ON p.product_type_cd = pt.product_type_cd
WHERE
    pt.name = 'Customer Accounts';

SELECT 
    pt.name product_type, p.name product
FROM
    product p
        INNER JOIN
    product_type pt ON p.product_type_cd = pt.product_type_cd
WHERE
    pt.name <> 'Customer Accounts';	# <> !=

select * from account;

DELETE FROM account 
WHERE
    status = 'CLOSED'
    AND YEAR(close_date) = 2002;

SELECT 
    emp_id, fname, lname, start_date
FROM
    employee
WHERE
    start_date BETWEEN '2005-01-01' AND '2007-01-01';	# between

SELECT 
    account_id, product_cd, cust_id, avail_balance
FROM
    account
WHERE
    product_cd IN ('CHK' , 'SAV', 'CD', 'MM');	# in

# 使用子查询
SELECT 
    account_id, product_cd, cust_id, avail_balance
FROM
    account
WHERE
    product_cd IN (SELECT 
            product_cd
        FROM
            product
        WHERE
            product_type_cd = 'ACCOUNT');

SELECT 
    account_id, product_cd, cust_id, avail_balance
FROM
    account
WHERE
    product_cd NOT IN ('CHK' , 'SAV', 'CD', 'MM');

SELECT 
    emp_id, fname, lname
FROM
    employee
WHERE
    LEFT(lname, 1) = 'T';	#开头为T

# 通配符
SELECT 
    lname
FROM
    employee
WHERE
    lname LIKE '_a%e%';

SELECT 
    cust_id, fed_id
FROM
    customer
WHERE
    fed_id LIKE '___-__-____';

# 正则表达式
SELECT 
    emp_id, fname, lname
FROM
    employee
WHERE
    lname LIKE 'F%' OR lname LIKE 'G%';
    
SELECT 
    emp_id, fname, lname
FROM
    employee
WHERE
    lname REGEXP '^[FG]';

# NULL
SELECT 
    emp_id, fname, lname, superior_emp_id
FROM
    employee
WHERE
    superior_emp_id IS NULL;
    
SELECT 
    emp_id, fname, lname, superior_emp_id
FROM
    employee
WHERE
    superior_emp_id IS NOT NULL;

SELECT 
    emp_id, fname, lname, superior_emp_id
FROM
    employee
WHERE
    superior_emp_id != 6
        OR superior_emp_id IS NULL;

############################### test

# test 4-3
SELECT 
    account_id, open_date
FROM
    account
WHERE
    YEAR(open_date) = 2002;
    
SELECT 
    account_id, open_date
FROM
    account
WHERE
    open_date BETWEEN '2002-01-01' AND '2002-12-31';

# test 4-4
SELECT 
    cust_id, lname, fname
FROM
    individual
WHERE
    lname LIKE '_a%e%';









