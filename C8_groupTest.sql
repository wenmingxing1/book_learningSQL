## 第8章 分组与聚集
use test;

select open_emp_id from account;
select open_emp_id from account group by open_emp_id;
select open_emp_id, count(*) count from account group by open_emp_id;

select open_emp_id, count(*) count from account group by open_emp_id having count > 6;

SELECT 
    MAX(avail_balance) max_balance,
    MIN(avail_balance) min_balance,
    AVG(avail_balance) avg_balance,
    SUM(avail_balance) sum_bablance,
    COUNT(*) num_accounts
FROM
    account
WHERE
    product_cd = 'CHK';

SELECT 
    product_cd,
    MAX(avail_balance),
    MIN(avail_balance),
    AVG(avail_balance),
    SUM(avail_balance),
    COUNT(*)
FROM
    account
GROUP BY product_cd;

select * from account;
select open_emp_id, count(account_id) from account group by open_emp_id;

select max(pending_balance - avail_balance) max_uncleared from account;

create table number_tbl (val smallint);
insert into number_tbl values(1);
insert into number_tbl values(3);
insert into number_tbl values(5);

SELECT 
    COUNT(*) num_rows,
    COUNT(val) num_vals,
    SUM(val) sum_val,
    MAX(val) max_val,
    AVG(val) avg_val
FROM
    number_tbl;

insert into number_tbl values(null);

select * from account;
select product_cd, sum(avail_balance) prod_balance from account group by product_cd;

SELECT 
    product_cd, open_branch_id, SUM(avail_balance) tot_balance
FROM
    account
GROUP BY product_cd , open_branch_id;

SELECT 
    YEAR(start_date) year, COUNT(*) count
FROM
    employee
GROUP BY year
ORDER BY year;

SELECT 
    product_cd, open_branch_id, SUM(avail_balance) sum_balance
FROM
    account
GROUP BY product_cd , open_branch_id WITH ROLLUP;

SELECT 
    product_cd, SUM(avail_balance) prod_balance
FROM
    account
WHERE
    status = 'ACTIVE'
GROUP BY product_cd
HAVING SUM(avail_balance) >= 10000;

SELECT 
    product_cd, SUM(avail_balance) prod_balance
FROM
    account
WHERE
    status = 'ACTIVE'
GROUP BY product_cd
HAVING MIN(avail_balance) >= 1000
    AND MAX(avail_balance) <= 10000;


############################################### test

# test 8-1
select * from account;
select count(*) from account;

# test 8-2
select cust_id, count(account_id) from account group by cust_id;

# test 8-3
SELECT 
    cust_id, COUNT(account_id)
FROM
    account
GROUP BY cust_id
HAVING COUNT(account_id) >= 2;

# test 8-4
select * from account;

SELECT 
    product_cd,
    open_branch_id,
    COUNT(account_id) count_account,
    SUM(avail_balance) sum_balance
FROM
    account
GROUP BY product_cd , open_branch_id
HAVING COUNT(account_id) >= 1
ORDER BY sum_balance DESC;







