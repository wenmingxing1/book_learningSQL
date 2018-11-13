## 第4章 过滤
show databases;
use test;
show tables;

select pt.name product_type, p.name product from product p inner join product_type pt on p.product_type_cd = pt.product_type_cd
where pt.name = 'Customer Accounts';

select pt.name product_type, p.name product from product p inner join product_type pt on p.product_type_cd = pt.product_type_cd
where pt.name <> 'Customer Accounts';	# <> !=

select * from account;

delete from account where status = 'CLOSED' and year(close_date) = 2002;

select emp_id, fname, lname, start_date from employee where start_date between '2005-01-01' and '2007-01-01';	# between

select account_id, product_cd, cust_id, avail_balance from account where product_cd in ('CHK', 'SAV', 'CD', 'MM');	# in

# 使用子查询
select account_id, product_cd, cust_id, avail_balance from account where product_cd in
(select product_cd from product where product_type_cd = 'ACCOUNT');

select account_id, product_cd, cust_id, avail_balance from account where product_cd not in ('CHK', 'SAV', 'CD', 'MM');

select emp_id, fname, lname from employee where left(lname, 1) = 'T';	#开头为T

# 通配符
select lname from employee where lname like '_a%e%';

select cust_id, fed_id from customer where fed_id like '___-__-____';

# 正则表达式
select emp_id, fname, lname from employee where lname like 'F%' or lname like 'G%';
select emp_id, fname, lname from employee where lname regexp '^[FG]';

# NULL
select emp_id, fname, lname, superior_emp_id from employee where superior_emp_id is null;
select emp_id, fname, lname, superior_emp_id from employee where superior_emp_id is not null;

select emp_id, fname, lname, superior_emp_id from employee where superior_emp_id != 6 or superior_emp_id is null;

############################### test

# test 4-3
select account_id, open_date from account where year(open_date) = 2002;
select account_id, open_date from account where open_date between '2002-01-01' and '2002-12-31';

# test 4-4
select cust_id, lname, fname from individual where lname like '_a%e%';









