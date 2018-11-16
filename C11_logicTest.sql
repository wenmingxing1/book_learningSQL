# 第11章 条件逻辑 
use test;

##### 11.1 什么是条件逻辑 
SELECT 
    c.cust_id,
    c.fed_id,
    c.cust_type_cd,
    CONCAT(i.fname, ' ', i.lname) indiv_name,
    b.name business_name
FROM
    customer c
        LEFT JOIN
    individual i ON c.cust_id = i.cust_id
        LEFT JOIN
    business b ON c.cust_id = b.cust_id;
    
SELECT 
    c.cust_id,
    c.fed_id,
    CASE
        WHEN c.cust_type_cd = 'I' THEN CONCAT(i.fname, ' ', i.lname)
        WHEN c.cust_type_cd = 'B' THEN b.name
        ELSE 'Unknown'
    END name
FROM
    customer c
        LEFT JOIN
    individual i ON c.cust_id = i.cust_id
        LEFT JOIN
    business b ON c.cust_id = b.cust_id;
    
##### 11.2 case表达式 

#### 11.2.1 查找型case表达式 
SELECT 
    c.cust_id,
    c.fed_id,
    CASE
        WHEN
            c.cust_type_cd = 'I'
        THEN
            (SELECT 
                    CONCAT(i.fname, ' ', i.lname)
                FROM
                    individual i
                WHERE
                    i.cust_id = i.cust_id)
        WHEN
            c.cust_type_cd = 'B'
        THEN
            (SELECT 
                    b.name
                FROM
                    business b
                WHERE
                    c.cust_id = b.cust_id)
        ELSE 'Unknown'
    END name
FROM
    customer c;
    
#### 11.2.2 简单case表达式 

##### 11.3 case表达式范例 

#### 11.3.1 结果集变换 
SELECT 
    YEAR(open_date) year, COUNT(*) how_many
FROM
    account
WHERE
    open_date > '1999-12-31'
        AND open_date < '2006-01-01'
GROUP BY YEAR(open_date);

SELECT 
    SUM(CASE
        WHEN YEAR(open_date) = 2000 THEN 1
        ELSE 0
    END) year_2000,
    SUM(CASE
        WHEN YEAR(open_date) = 2001 THEN 1
        ELSE 0
    END) year_2001,
    SUM(CASE
        WHEN YEAR(open_date) = 2002 THEN 1
        ELSE 0
    END) year_2002,
    SUM(CASE
        WHEN YEAR(open_date) = 2003 THEN 1
        ELSE 0
    END) year_2003,
    SUM(CASE
        WHEN YEAR(open_date) = 2004 THEN 1
        ELSE 0
    END) year_2004,
    SUM(CASE
        WHEN YEAR(open_date) = 2005 THEN 1
        ELSE 0
    END) year_2005
FROM
    account
WHERE
    open_date > '1999-12-31'
        AND open_date < '2006-01-01';
        
#### 11.3.2 选择性聚合 

SELECT 
    CONCAT('ALERT! : Account #',
            a.account_id,
            ' Has Incorrect Balance')
FROM
    account a
WHERE
    (a.avail_balance , a.pending_balance) <> (SELECT 
            SUM(CASE
                    WHEN t.funds_avail_date > CURRENT_TIMESTAMP() THEN 0
                    WHEN t.txn_type_cd = 'DBT' THEN t.amount * - 1
                    ELSE t.amount
                END),
                SUM(CASE
                    WHEN t.txn_type_cd = 'DBT' THEN t.amount * - 1
                    ELSE t.amount
                END)
        FROM
            transaction t
        WHERE
            t.account_id = a.account_id);
            
#### 11.3.3 存在性检查 
SELECT 
    c.cust_id,
    c.fed_id,
    c.cust_type_cd,
    CASE
        WHEN
            EXISTS( SELECT 
                    1
                FROM
                    account a
                WHERE
                    a.cust_id = c.cust_id
                        AND a.product_cd = 'CHK')
        THEN
            'Y'
        ELSE 'N'
    END has_checking,
    CASE
        WHEN
            EXISTS( SELECT 
                    1
                FROM
                    account a
                WHERE
                    a.cust_id = c.cust_id
                        AND a.product_cd = 'SAV')
        THEN
            'Y'
        ELSE 'N'
    END has_savings
FROM
    customer c;
    
SELECT 
    c.cust_id,
    c.fed_id,
    c.cust_type_cd,
    CASE (SELECT 
            COUNT(*)
        FROM
            account a
        WHERE
            a.cust_id = c.cust_id)
        WHEN 0 THEN 'None'
        WHEN 1 THEN '1'
        WHEN 2 THEN '2'
        ELSE '3+'
    END num_accounts
FROM
    customer c;

#### 11.3.4 除零错误 
select 100/0;

SELECT 
    a.cust_id,
    a.product_cd,
    a.avail_balance / CASE
        WHEN prod_tots.tot_balance = 0 THEN 1
        ELSE prod_tots.tot_balance
    END percent_pf_total
FROM
    account a
        INNER JOIN
    (SELECT 
        a.product_cd, SUM(a.avail_balance) tot_balance
    FROM
        account a
    GROUP BY a.product_cd) prod_tots ON a.product_cd = prod_tots.product_cd;
    
#### 11.3.5 有条件更新 
UPDATE account 
SET 
    last_activity_date = CURRENT_TIMESTAMP(),
    pending_balance = pending_balance + (SELECT 
            t.amount * CASE t.txn_type_cd
                    WHEN 'DBT' THEN - 1
                    ELSE 1
                END
        FROM
            transaction t
        WHERE
            t.txn_id = 999),
    avail_balance = avail_balance + (SELECT 
            CASE
                    WHEN t.funds_avail_date > CURRENT_TIMESTAMP() THEN 0
                    ELSE t.amount * CASE t.txn_type_cd
                        WHEN 'DBT' THEN - 1
                        ELSE 1
                    END
                END
        FROM
            transaction t
        WHERE
            t.txn_id = 999)
WHERE
    account.account_id = (SELECT 
            t.account_id
        FROM
            transaction t
        WHERE
            t.txn_id = 999);  
            
##### 11.3.6 null值处理 
SELECT 
    emp_id,
    fname,
    lname,
    CASE
        WHEN title IS NULL THEN 'Unknown'
        ELSE title
    END title
FROM
    employee;
    
######################################## test

# test 11-1
SELECT 
    emp_id,
    CASE
        WHEN
            title = 'President'
                OR title = 'Vice President'
                OR title = 'Treasurer'
                OR title = 'Loan Manager'
        THEN
            'Management'
        WHEN
            title = 'Operations Manager'
                OR title = 'Head Teller'
                OR title = 'Teller'
        THEN
            'Operations'
        ELSE 'Unknown'
    END title
FROM
    employee;

SELECT 
    emp_id,
    CASE
        WHEN
            title IN ('President' , 'Vice President',
                'Treasurer',
                'Loan Manager')
        THEN
            'Management'
        WHEN title IN ('Operations Manager' , 'Head Teller', 'Teller') THEN 'Operations'
        ELSE 'Unknown'
    END title
FROM
    employee;
    
# test 11-2
SELECT 
    SUM(CASE
        WHEN open_branch_id = 1 THEN 1
        ELSE 0
    END) branch_1,
    SUM(CASE
        WHEN open_branch_id = 2 THEN 1
        ELSE 0
    END) branch_2,
    SUM(CASE
        WHEN open_branch_id = 3 THEN 1
        ELSE 0
    END) branch_3,
    SUM(CASE
        WHEN open_branch_id = 4 THEN 1
        ELSE 0
    END) branch_4
FROM
    account;
