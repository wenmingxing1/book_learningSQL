## 第8章 分组与聚集
use test;

select open_emp_id from account;
select open_emp_id from account group by open_emp_id;
select open_emp_id, count(*) count from account group by open_emp_id;

select open_emp_id, count(*) count from account group by open_emp_id having count > 6;

select max(avail_balance) max_balance, min(avail_balance) min_balance, avg(avail_balance) avg_balance, sum(avail_balance) sum_bablance,
count(*) num_accounts from account where product_cd = 'CHK';

select product_cd, max(avail_balance), min(avail_balance), avg(avail_balance), sum(avail_balance), count(*) from account group by product_cd;

select * from account;
select open_emp_id, count(account_id) from account group by open_emp_id;

select max(pending_balance - avail_balance) max_uncleared from account;

create table number_tbl (val smallint);
insert into number_tbl values(1);
insert into number_tbl values(3);
insert into number_tbl values(5);

select count(*) num_rows, count(val) num_vals, sum(val) sum_val, max(val) max_val, avg(val) avg_val from number_tbl;

insert into number_tbl values(null);

select * from account;
select product_cd, sum(avail_balance) prod_balance from account group by product_cd;

select product_cd, open_branch_id, sum(avail_balance) tot_balance from account group by product_cd, open_branch_id;

select year(start_date) year, count(*) count from employee group by year order by year;

select product_cd, open_branch_id, sum(avail_balance) sum_balance from account group by product_cd, open_branch_id with rollup;

select product_cd, sum(avail_balance) prod_balance from account where status = 'ACTIVE' group by product_cd having sum(avail_balance)>=10000;

select product_cd, sum(avail_balance) prod_balance from account where status = 'ACTIVE' group by product_cd 
having min(avail_balance) >= 1000 and max(avail_balance) <= 10000;


############################################### test

# test 8-1
select * from account;
select count(*) from account;

# test 8-2
select cust_id, count(account_id) from account group by cust_id;

# test 8-3
select cust_id, count(account_id) from account group by cust_id having count(account_id) >= 2;

# test 8-4
select * from account;
select product_cd, open_branch_id, count(account_id) count_account, sum(avail_balance) sum_balance from account 
group by product_cd, open_branch_id having count(account_id) >= 1 order by sum_balance desc;







