# 第9章 子查询
use test;

SELECT 
    account_id, product_cd, cust_id, avail_balance
FROM
    account
WHERE
    account_id = (SELECT 
            MAX(account_id)
        FROM
            account);

SELECT 
    account_id, product_cd, cust_id, avail_balance
FROM
    account
WHERE
    open_emp_id <> (SELECT 
            e.emp_id
        FROM
            employee e
                INNER JOIN
            branch b ON e.assigned_branch_id = b.branch_id
        WHERE
            e.title = 'Head Teller'
                AND b.city = 'Woburn');

SELECT 
    branch_id, name, city
FROM
    branch
WHERE
    name IN ('Headquarters' , 'Quincy Branch');

SELECT 
    emp_id, fname, lname, title
FROM
    employee
WHERE
    emp_id IN (SELECT 
            superior_emp_id
        FROM
            employee);

SELECT 
    emp_id, fname, lname, title
FROM
    employee
WHERE
    emp_id NOT IN (SELECT 
            superior_emp_id
        FROM
            employee
        WHERE
            superior_emp_id IS NOT NULL);


# 使用all会报错？？？
SELECT 
    emp_id, fname, lname, title
FROM
    employee
WHERE
    emp_id != ALL (SELECT 
            superior_emp_id
        FROM
            employee
        WHERE
            superior_emp_id IS NOT NULL);

SELECT 
    account_id, cust_id, product_cd, avail_balance
FROM
    account
WHERE
    avail_balance < ALL (SELECT 
            a.avail_balance
        FROM
            account a
                INNER JOIN
            individual i ON a.cust_id = i.cust_id
        WHERE
            i.fname = 'Frank' AND i.lname = 'Tucker');

SELECT 
    account_id, product_cd, cust_id
FROM
    account
WHERE
    (open_branch_id , open_emp_id) IN (SELECT 
            b.branch_id, e.emp_id
        FROM
            branch b
                INNER JOIN
            employee e ON b.branch_id = e.assigned_branch_id
        WHERE
            b.name = 'Woburn Branch'
                AND (e.title = 'Teller'
                OR e.title = 'Head Teller'));
                
                
SELECT 
    c.cust_id, c.cust_type_cd, c.city
FROM
    customer c
WHERE
    2 = (SELECT 
            COUNT(*)
        FROM
            account a
        WHERE
            a.cust_id = c.cust_id);

SELECT 
    c.cust_id, c.cust_type_cd, c.city
FROM
    customer c
WHERE
    (SELECT 
            SUM(a.avail_balance)
        FROM
            account a
        WHERE
            a.cust_id = c.cust_id) BETWEEN 5000 AND 10000;

SELECT 
    a.account_id, a.product_cd, a.cust_id, a.avail_balance
FROM
    account a
WHERE
    EXISTS( SELECT 
            1
        FROM
            transaction t
        WHERE
            t.account_id = a.account_id
                AND t.txn_date = '2008-09-22');
                
SELECT 
    a.account_id, a.product_cd, a.cust_id
FROM
    account a
WHERE
    EXISTS( SELECT 
            t.txn_id, 'hello', 3.1415927
        FROM
            transaction t
        WHERE
            t.account_id = a.account_id
                AND t.txn_date = '2008-9-22');
                
SELECT 
    a.account_id, a.product_cd, a.cust_id
FROM
    account a
WHERE
    NOT EXISTS( SELECT 
            1
        FROM
            business b
        WHERE
            b.cust_id = a.cust_id);
            
SELECT 
    a.account_id, a.product_cd, a.cust_id
FROM
    account a
WHERE
    a.cust_id NOT IN (SELECT 
            cust_id
        FROM
            business);

set sql_safe_updates = 0;

UPDATE account a 
SET 
    a.last_activity_date = (SELECT 
            MAX(t.txn_date)
        FROM
            transaction t
        WHERE
            t.account_id = a.account_id);

UPDATE account a 
SET 
    a.last_activity_date = (SELECT 
            MAX(t.txn_date)
        FROM
            transaction t
        WHERE
            t.account_id = a.account_id)
WHERE
    EXISTS( SELECT 
            1
        FROM
            transaction t
        WHERE
            t.account_id = a.account_id);


DELETE FROM department 
WHERE
    NOT EXISTS( SELECT 
        1
    FROM
        employee
    
    WHERE
        employee.dept_id = department.dept_id); #delete中使用关联子查询不能使用表别名

##### 9.5 何时使用子查询 

#### 9.5.1 子查询作为数据源 
SELECT 
    d.dept_id, d.name, e_cnt.how_many num_employee
FROM
    department d
        INNER JOIN
    (SELECT 
        dept_id, COUNT(*) how_many
    FROM
        employee
    GROUP BY dept_id) e_cnt ON d.dept_id = e_cnt.dept_id;

SELECT 
    dept_id, COUNT(*) how_many
FROM
    employee
GROUP BY dept_id;

# 数据加工 
SELECT 'Small Fry' name, 0 low_limit, 4999.99 high_limit 
UNION ALL SELECT 'Average Joes' name, 5000 low_limit, 9999.99 high_limit 
UNION ALL SELECT 'Heavy Hitters' name, 10000 low_limit, 999999.99 high_limit;

SELECT 
    groups.name, COUNT(*) num_customers
FROM
    (SELECT 
        SUM(a.avail_balance) cust_balance
    FROM
        account a
    INNER JOIN product p ON a.product_cd = p.product_cd
    WHERE
        p.product_type_cd = 'ACCOUNT'
    GROUP BY a.cust_id) cust_rollup
        INNER JOIN
    (SELECT 'Small Fry' name, 0 low_limit, 4999.99 high_limit 
    UNION ALL 
    SELECT 'Average Joes' name, 5000 low_limit, 9999.99 high_limit 
    UNION ALL 
    SELECT 'Heavy Hitters' name, 10000 low_limit, 999999.99 high_limit) groups ON cust_rollup.cust_balance BETWEEN groups.low_limit AND groups.high_limit
GROUP BY groups.name;

# 面向任务的子查询 
SELECT 
    p.name product,
    b.name branch,
    CONCAT(e.fname, ' ', e.lname) name,
    SUM(a.avail_balance) tot_deposits
FROM
    account a
        INNER JOIN
    employee e ON a.open_emp_id = e.emp_id
        INNER JOIN
    branch b ON a.open_emp_id = b.branch_id
        INNER JOIN
    product p ON a.product_cd = p.product_cd
WHERE
    p.product_type_cd = 'ACCOUNT'
GROUP BY p.name , b.name , e.fname , e.lname
ORDER BY 1 , 2;


SELECT 
    product_cd,
    open_branch_id branch_id,
    open_emp_id emp_id,
    SUM(avail_balance) tot_deposits
FROM
    account
GROUP BY product_cd , open_branch_id , open_emp_id;

SELECT 
    p.name product,
    b.name branch,
    CONCAT(e.fname, ' ', e.lname) name,
    account_groups.tot_deposits
FROM
    (SELECT 
        product_cd,
            open_branch_id branch_id,
            open_emp_id emp_id,
            SUM(avail_balance) tot_deposits
    FROM
        account
    GROUP BY product_cd , open_branch_id , open_emp_id) account_groups
        INNER JOIN
    employee e ON e.emp_id = account_groups.emp_id
        INNER JOIN
    branch b ON b.branch_id = account_groups.branch_id
        INNER JOIN
    product p ON p.product_cd = account_groups.product_cd
WHERE
    p.product_type_cd = 'ACCOUNT';
    
    
#### 9.5.2 过滤条件中的子查询 
SELECT 
    open_emp_id, COUNT(*) how_maney
FROM
    account
GROUP BY open_emp_id
HAVING COUNT(*) = (SELECT 
        MAX(emp_cnt.how_many)
    FROM
        (SELECT 
            COUNT(*) how_many
        FROM
            account
        GROUP BY open_emp_id) emp_cnt);
        

#### 9.5.3 子查询作为表达式生成器 
SELECT 
    (SELECT 
            p.name
        FROM
            product p
        WHERE
            p.product_cd = a.product_cd
                AND p.product_type_cd = 'ACCOUNT') product,
    (SELECT 
            b.name
        FROM
            branch b
        WHERE
            b.branch_id = a.open_emp_id) branch,
    (SELECT 
            CONCAT(e.fname, ' ', e.lname)
        FROM
            employee e
        WHERE
            e.emp_id = a.open_emp_id) name,
    SUM(avail_balance) tot_deposits
FROM
    account a
GROUP BY a.product_cd , a.open_branch_id , a.open_emp_id
ORDER BY 1 , 2;

SELECT 
    emp.emp_id,
    CONCAT(emp.fname, ' ', emp.lname) emp_name,
    (SELECT 
            CONCAT(boss.fname, ' ', boss.lname)
        FROM
            employee boss
        WHERE
            boss.emp_id = emp.superior_emp_id) boss_name
FROM
    employee emp
WHERE
    emp.superior_emp_id IS NOT NULL
ORDER BY (SELECT 
        boss.lname
    FROM
        employee boss
    WHERE
        boss.emp_id = emp.superior_emp_id) , emp.lname;

########################################### test

# test 9-1
select * from account;
select * from product;
SELECT 
    a.account_id, a.product_cd, a.cust_id, a.avail_balance
FROM
    account a
WHERE
    a.product_cd IN (SELECT 
            product_cd
        FROM
            product
        WHERE
            product_type_cd = 'LOAN');
            
SELECT 
    a.account_id, a.product_cd, a.cust_id, a.avail_balance
FROM
    account a,
    product p
WHERE
    a.product_cd = p.product_cd
        AND p.product_type_cd = 'LOAN';
        
# test 9-2
SELECT 
    a.account_id, a.product_cd, a.cust_id, a.avail_balance
FROM
    account a
WHERE
    EXISTS( SELECT 
            1
        FROM
            product
        WHERE
            product_cd = a.product_cd
                AND product_type_cd = 'LOAN'); 
                
# test 9-3
select * from employee;

select 'trainee' name, '2004-01-01' start_dt, '2005-12-31' end_dt
union all
select 'worker' name, '2002-01-01' start_dt, '2003-12-31' end_dt
union all 
select 'mentor' name, '2000-01-01' start_dt, '2001-12-31' end_dt

SELECT 
    e.emp_id, e.fname, e.lname, levels.name
FROM
    employee e
        INNER JOIN
    (SELECT 'trainee' name, '2004-01-01' start_dt, '2005-12-31' end_dt 
    UNION ALL 
    SELECT 'worker' name, '2002-01-01' start_dt, '2003-12-31' end_dt 
    UNION ALL SELECT 'mentor' name, '2000-01-01' start_dt, '2001-12-31' end_dt) levels 
		ON e.start_date BETWEEN levels.start_dt AND levels.end_dt;
        
# test 9-4
select * from employee;
select * from department;
select * from branch;

SELECT 
    e.emp_id, e.fname, e.lname, d.name, b.name
FROM
    employee e,
    department d,
    branch b
WHERE
    e.dept_id = d.dept_id
        AND e.assigned_branch_id = b.branch_id;

SELECT 
    e.emp_id,
    e.fname,
    e.lname,
    (SELECT 
            name
        FROM
            department
        WHERE
            department.dept_id = e.dept_id) dept_name,
    (SELECT 
            name
        FROM
            branch
        WHERE
            branch.branch_id = e.assigned_branch_id) branch_name
FROM
    employee e;





