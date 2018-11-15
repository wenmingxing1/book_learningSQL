# 第10章 再谈连接 
use test;

##### 10.1 外连接 

#### 10.1.2 三路外连接 
SELECT 
    a.account_id,
    a.product_cd,
    CONCAT(i.fname, ' ', i.lname) person_name,
    b.name business_name
FROM
    account a
        LEFT OUTER JOIN
    individual i ON a.cust_id = i.cust_id
        LEFT OUTER JOIN
    business b ON a.cust_id = b.cust_id;
    
SELECT 
    account_ind.account_id,
    account_ind.product_cd,
    account_ind.person_name,
    b.name business_name
FROM
    (SELECT 
        a.account_id,
            a.product_cd,
            a.cust_id,
            CONCAT(i.fname, ' ', i.lname) person_name
    FROM
        account a
    LEFT JOIN individual i ON a.cust_id = i.cust_id) account_ind
        LEFT JOIN
    business b ON account_ind.cust_id = b.cust_id;
    
    
#### 10.1.3 自外连接 
SELECT 
    e.fname,
    e.lname,
    e_mgr.fname mgr_fname,
    e_mgr.lname mgr_lname
FROM
    employee e
        LEFT JOIN
    employee e_mgr ON e.superior_emp_id = e_mgr.emp_id;    
    
##### 10.2 交叉连接 
select * from product;
select * from product_type;
select pt.name, p.product_cd, p.name from product p cross join product_type pt;    

SELECT 
    ones.num + tens.num + hundreds.num
FROM
    (SELECT 0 num UNION ALL SELECT 1 num UNION ALL SELECT 2 num UNION ALL SELECT 3 num UNION ALL SELECT 4 num UNION ALL SELECT 5 num UNION ALL SELECT 6 num UNION ALL SELECT 7 num UNION ALL SELECT 8 num UNION ALL SELECT 9 num) ones
        CROSS JOIN
    (SELECT 0 num UNION ALL SELECT 10 num UNION ALL SELECT 20 num UNION ALL SELECT 30 num UNION ALL SELECT 40 num UNION ALL SELECT 50 num UNION ALL SELECT 60 num UNION ALL SELECT 70 num UNION ALL SELECT 80 num UNION ALL SELECT 90 num) tens
        CROSS JOIN
    (SELECT 0 num UNION ALL SELECT 100 num UNION ALL SELECT 200 num UNION ALL SELECT 300 num) hundreds;
    

SELECT 
    DATE_ADD('2008-01-01',
        INTERVAL (ones.num + tens.num + hundreds.num) DAY) dt
FROM
    (SELECT 0 num UNION ALL SELECT 1 num UNION ALL SELECT 2 num UNION ALL SELECT 3 num UNION ALL SELECT 4 num UNION ALL SELECT 5 num UNION ALL SELECT 6 num UNION ALL SELECT 7 num UNION ALL SELECT 8 num UNION ALL SELECT 9 num) ones
        CROSS JOIN
    (SELECT 0 num UNION ALL SELECT 10 num UNION ALL SELECT 20 num UNION ALL SELECT 30 num UNION ALL SELECT 40 num UNION ALL SELECT 50 num UNION ALL SELECT 60 num UNION ALL SELECT 70 num UNION ALL SELECT 80 num UNION ALL SELECT 90 num) tens
        CROSS JOIN
    (SELECT 0 num UNION ALL SELECT 100 num UNION ALL SELECT 200 num UNION ALL SELECT 300 num) hundreds
WHERE
    DATE_ADD('2008-01-01',
        INTERVAL (ones.num + tens.num + hundreds.num) DAY) < '2009-01-01'
ORDER BY 1;


SELECT 
    days.dt, COUNT(t.txn_id)
FROM
    transaction t
        RIGHT JOIN
    (SELECT 
        DATE_ADD('2008-01-01', INTERVAL (ones.num + tens.num + hundreds.num) DAY) dt
    FROM
        (SELECT 0 num UNION ALL SELECT 1 num UNION ALL SELECT 2 num UNION ALL SELECT 3 num UNION ALL SELECT 4 num UNION ALL SELECT 5 num UNION ALL SELECT 6 num UNION ALL SELECT 7 num UNION ALL SELECT 8 num UNION ALL SELECT 9 num) ones
    CROSS JOIN (SELECT 0 num UNION ALL SELECT 10 num UNION ALL SELECT 20 num UNION ALL SELECT 30 num UNION ALL SELECT 40 num UNION ALL SELECT 50 num UNION ALL SELECT 60 num UNION ALL SELECT 70 num UNION ALL SELECT 80 num UNION ALL SELECT 90 num) tens
    CROSS JOIN (SELECT 0 num UNION ALL SELECT 100 num UNION ALL SELECT 200 num UNION ALL SELECT 300 num) hundreds
    WHERE
        DATE_ADD('2008-01-01', INTERVAL (ones.num + tens.num + hundreds.num) DAY) < '2009-01-01') days ON days.dt = t.txn_date
GROUP BY days.dt
ORDER BY 1;
    
##### 10.3 自然连接 
SELECT 
    a.account_id, a.cust_id, c.cust_type_cd, c.fed_id
FROM
    account a
        NATURAL JOIN
    customer c;

SELECT 
    a.account_id, a.cust_id, a.open_branch_id, b.name
FROM
    account a
        NATURAL JOIN
    branch b;
    

################################################ test

# test 10-1
select * from account;
select * from product;

SELECT 
    p.name, a.account_id
FROM
    product p
        LEFT JOIN
    account a ON p.product_cd = a.product_cd;

# test 10-2
SELECT 
    p.name, a.account_id
FROM
    account a
        RIGHT JOIN
    product p ON a.product_cd = p.product_cd;

# test 10-3
select * from account;
select * from individual;
select * from business;

SELECT 
    a.account_id, a.product_cd, i.fname, i.lname, b.name
FROM
    account a
        LEFT JOIN
    individual i ON a.cust_id = i.cust_id
        LEFT JOIN
    business b ON a.cust_id = b.cust_id;

# test 10-4
select ones.num + 10*tens.num + 1 number from 
(select 0 num union all
 select 1 num union all
 select 2 num union all
 select 3 num union all
 select 4 num union all
 select 5 num union all
 select 6 num union all
 select 7 num union all
 select 8 num union all
 select 9 num
) ones cross join 
(select 0 num union all
 select 1 num union all
 select 2 num union all
 select 3 num union all
 select 4 num union all
 select 5 num union all
 select 6 num union all
 select 7 num union all
 select 8 num union all
 select 9 num
) tens;

    
    
    
    
    
