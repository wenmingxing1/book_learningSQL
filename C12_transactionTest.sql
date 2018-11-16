# 第12章 事务 

#### 12.2.3 事务保存点 
start transaction;

UPDATE product 
SET 
    date_retired = CURRENT_TIMESTAMP()
WHERE
    product_cd = 'XYZ';
    
savepoint before_close_accounts;

UPDATE account 
SET 
    status = 'CLOSED',
    close_date = CURRENT_TIMESTAMP(),
    last_activity_date = CURRENT_TIMESTAMP()
WHERE
    product_cd = 'XYZ';
    
rollback to savepoint before_close_accounts;

commit;

############################## test

# test 12-1
start transaction;

select i.cust_id, (select a.account_id from account a where a.cust_id = i.cust_id and a.product_cd = 'MM') mm_id,
(select a.account_id from account a where a.cust_id = i.cust_id and a.product_cd = 'CHK') chk_id
into @cst_id, @ mm_id, @chk_id from individual i where i.fname = 'Frank' and i.lname = 'Tucker';

insert into transaction (txn_id, txn_date, account_id, txn_tupe_cd, amount) values (null, now(), @chk_id, 'DBT', 50);

UPDATE account 
SET 
    last_activity_date = NOW(),
    avail_balance = avail_balance - 50
WHERE
    account_id = @mm_id;

UPDATE account 
SET 
    last_activity_date = NOW(),
    avail_balance = avail_balance + 50
WHERE
    account_id = @chk_id;

commit;