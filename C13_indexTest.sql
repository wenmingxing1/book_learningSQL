# 第13章 索引和约束 

use test;

##### 13.1 索引 
SELECT 
    dept_id, name
FROM
    department
WHERE
    name LIKE 'A%';
    
select * from department;

#### 13.1.1 创建索引 
alter table department add index dept_name_idx(name);

show index from department;

alter table department drop index dept_name_idx;

# 唯一索引 
alter table department add unique dept_name_idx(name);

insert into department (dept_id, name) values(999, 'Operations');

# 多列索引 
alter table employee add index emp_names_idx(lname, fname);
show index from employee;

#### 13.1.2 索引类型 
# B树索引  
# 位图索引 
# 文本索引 

#### 13.1.3 如何使用索引 
SELECT 
    emp_id, fname, lname
FROM
    employee
WHERE
    emp_id IN (1 , 3, 9, 15);
    
SELECT 
    cust_id, SUM(avail_balance) tot_bal
FROM
    account
WHERE
    cust_id IN (1 , 5, 9, 11)
GROUP BY cust_id;

explain select cust_id, sum(avail_balance) from account where cust_id in (1,5,9,11) group by cust_id;

#### 13.1.4 索引的不足 

##### 13.2 约束  

#### 13.2.1 创建约束 
CREATE TABLE product (
    product_cd VARCHAR(10) NOT NULL,
    name VARCHAR(50) NOT NULL,
    product_type_cd VARCHAR(10) NOT NULL,
    date_offered DATE,
    date_retired DATE,
    CONSTRAINT fk_product_type_cd FOREIGN KEY (product_type_cd)
        REFERENCES product_type (product_type_cd),		# 指定外键约束
    CONSTRAINT pk_product PRIMARY KEY (product_cd)      # 指定主键约束 
);

alter table product add constraint pk_product primary key (product_cd);

alter table product add constraint fk_product_tupe foreign key (product_type_cd) references product_type (product_type_cd);

alter table product drop primary key;	#删除主键约束 

alter table product drop foreign key fk_product_type_cd;    # 删除外键约束 

#### 13.2.2 约束与索引 

#### 13.2.3 级联约束 
SELECT 
    product_type_cd, name
FROM
    product_type;
    
SELECT 
    product_type_cd, product_cd, name
FROM
    product
ORDER BY product_type_cd;

UPDATE product 
SET 
    product_type_cd = 'XYZ'
WHERE
    product_type_cd = 'LOAN';	#由于存在外键约束，所以会抛出一个错误 
    
UPDATE product_type 
SET 
    product_type_cd = 'XYZ'
WHERE
    product_type_cd = 'LOAN';
    
alter table product drop foreign key fk_product_type_cd;
alter table product add constraint fk_product_type_cd foreign key (product_type_cd) references product_type(product_type_cd) on update cascade;	#自动传播到子行 

UPDATE product_type 
SET 
    product_type_cd = 'XYZ'
WHERE
    product_type_cd = 'LOAN';
    
SELECT 
    product_type_cd, name
FROM
    product_type;
    
UPDATE product 
SET 
    product_type_cd = 'XYZ'
WHERE
    product_type_cd = 'LOAN';

SELECT 
    product_type_cd, product_cd, name
FROM
    product
ORDER BY product_type_cd;

# 删除级联更新 
alter table product add constraint fk_product_type_cd foreign key (product_type_cd) references product_type (product_type_cd) on delete cascade;

########################################## test

# test 13-1
select * from account;

alter table account add constraint account_unq1 unique (cust_id, product_cd);

# test 13-2
alter table transaction add index txn_idx01 (txn_date, amount);



