# 第14章 视图 

use test;

##### 14.1 什么是视图 
CREATE VIEW customer_vw (cust_id , fed_id , cust_type_cd , address , city , state , zipcode) AS
    SELECT 
        cust_id,
        CONCAT('ends in ', SUBSTR(fed_id, 8, 4)) fed_id,
        cust_type_cd,
        address,
        city,
        state,
        postal_code
    FROM
        customer;
        
SELECT 
    cust_id, fed_id, cust_type_cd
FROM
    customer_vw;
    
desc customer_vw;

SELECT 
    cust_type_cd, COUNT(*)
FROM
    customer_vw
WHERE
    state = 'MA'
GROUP BY cust_type_cd
ORDER BY 1;

SELECT 
    cst.cust_id, cst.fed_id, bus.name
FROM
    customer_vw cst
        INNER JOIN
    business bus ON cst.cust_id = bus.cust_id;
    
##### 14.2 为什么使用视图 

#### 14.2.1 数据安全 

#### 14.2.2 数据聚合 
CREATE VIEW customer_totals_vw (cust_id , cust_type_cd , cust_name , num_accounts , tot_deposits) AS
    SELECT 
        cst.cust_id,
        cst.cust_type_cd,
        CASE
            WHEN
                cst.cust_type_cd = 'B'
            THEN
                (SELECT 
                        bus.name
                    FROM
                        business bus
                    WHERE
                        bus.cust_id = cst.cust_id)
            ELSE (SELECT 
                    CONCAT(ind.fname, ' ', ind.lname)
                FROM
                    individual ind
                WHERE
                    ind.cust_id = cst.cust_id)
        END cust_name,
        SUM(CASE
            WHEN act.status = 'ACTIVE' THEN 1
            ELSE 0
        END) tot_active_accounts,
        SUM(CASE
            WHEN act.status = 'ACTIVE' THEN act.avail_balance
            ELSE 0
        END) tot_balance
    FROM
        customer cst
            INNER JOIN
        account act ON act.cust_id = cst.cust_id
    GROUP BY cst.cust_id , cst.cust_type_cd;
    
CREATE TABLE customer_totals AS SELECT * FROM
    customer_totals_vw;

show tables;
select * from customer_totals;
drop table customer_totals;
drop view customer_vw;
drop view customer_totals_vw;

CREATE OR REPLACE VIEW customer_totals_vw (cust_id, cust_type_cd, cust_name, num_accounts, tot_deposits) AS
    SELECT 
        cust_id, cust_type_cd, cust_name, num_accounts, tot_deposits
    FROM
        customer_totals;  
        
#### 14.2.3 隐藏复杂性 
CREATE VIEW branch_activity_vw (branch_name , city , state , num_employee , num_active_accounts , tot_transactions) AS
    SELECT 
        br.name,
        br.city,
        br.state,
        (SELECT 
                COUNT(*)
            FROM
                employee emp
            WHERE
                emp.assigned_branch_id = br.branch_id) num_emps,
        (SELECT 
                COUNT(*)
            FROM
                account acnt
            WHERE
                acnt.status = 'ACTIVE'
                    AND acnt.open_branch_id = br.branch_id) num_accounts,
        (SELECT 
                COUNT(*)
            FROM
                transaction txn
            WHERE
                txn.execution_branch_id = br.branch_id) num_txns
    FROM
        branch br;  
        
#### 14.2.4 连接分区数据  
CREATE VIEW transaction_vw (txn_date , account_id , txn_type_cd , amount , teller_emp_id , execution_branch_id , funds_avail_date) AS
    SELECT 
        txn_date,
        account_id,
        txn_type_cd,
        amount,
        teller_emp_id,
        execution_branch_id,
        funds_avail_date
    FROM
        transaction_historic 
    UNION ALL SELECT 
        txn_date,
        accout_id,
        txn_type_cd,
        amount,
        teller_emp_id,
        execution_branch_id,
        funds_avail_date
    FROM
        transaction_current;
        
##### 14.3 可更新的视图  

#### 14.3.1 更新简单视图 
SELECT DISTINCT
    city
FROM
    customer;
    
CREATE VIEW customer_vw (cust_id , fed_id , cust_type_cd , address , city , state , zipcode) AS
    SELECT 
        cust_id,
        CONCAT('ends in ', SUBSTR(fed_id, 8, 4)) fed_id,
        cust_type_cd,
        address,
        city,
        state,
        postal_code
    FROM
        customer;
        
UPDATE customer_vw 
SET 
    city = 'Wooburn'
WHERE
    city = 'Woburn';
    
set sql_safe_updates = 0;    

UPDATE customer_vw 
SET 
    city = 'Woburn',
    fed_id = '999999999'
WHERE
    city = 'Wooburn';
    
insert into customer_vw (cust_id, cust_type_cd, city) values(9999, 'I', 'Worcester');

#### 14.3.2 更新复杂视图 
CREATE VIEW business_customer_vw (cust_id , fed_id , address , city , state , postal_code , business_name , state_id , incorp_date) AS
    SELECT 
        cst.cust_id,
        cst.fed_id,
        cst.address,
        cst.city,
        cst.state,
        cst.postal_code,
        bsn.name,
        bsn.state_id,
        bsn.incorp_date
    FROM
        customer cst
            INNER JOIN
        business bsn ON cst.cust_id = bsn.cust_id
    WHERE
        cust_type_cd = 'B';  
        
UPDATE business_customer_vw 
SET 
    postal_code = '99999'
WHERE
    cust_id = 10;
    
UPDATE business_customer_vw 
SET 
    incorp_date = '2008-11-17'
WHERE
    cust_id = 10;
    
UPDATE business_customer_vw 
SET 
    postal_code = '99999',
    incorp_date = '2008-11-17'
WHERE
    cust_id = 10;
    
insert into business_customer_vw (cust_id, fed_id, address, city, state, postal_code)
values (99, '04-9999999', '99 Main St.', 'Peabody', 'MA', '01075');

insert into business_customer_vw (cust_id, business_name, state_id, incorp_date) 
values (99, 'Ninety-Nine Restaurant', '99-999-999', '1999-01-01');

############################################### test

# test 14-1
select * from employee;

CREATE VIEW test14_1_vw (supervisor_name , employee_name) AS
    SELECT 
        CONCAT(e2.fname, ' ', e2.lname) supervisor_name,
        CONCAT(e1.fname, ' ', e1.lname) employee_name
    FROM
        employee e2
            RIGHT JOIN
        employee e1 ON e2.emp_id = e1.superior_emp_id;

select * from test14_1_vw;
drop view test14_1_vw;

# test 14-2 
select * from branch;
select * from account;

CREATE VIEW test14_2_vw (tot_balance , branch_name , branch_city) AS
    SELECT 
        SUM(avail_balance) tot_balance,
        b.name branch_name,
        b.city branch_city
    FROM
        account a
            INNER JOIN
        branch b ON a.open_branch_id = b.branch_id
    GROUP BY open_branch_id; 

select * from test14_2_vw;



