## 第7章 数据生成、转换和操作
use test;

create table string_tbl (char_fld char(30), vchar_fld varchar(30), text_fld text);

drop table string_tbl;

show tables;

insert into string_tbl (char_fld, vchar_fld, txt_fld) 
values ('This is char data', 'This is varchar data', 'This is text data');

set sql_safe_updates = 0;

UPDATE string_tbl 
SET 
    vchar_fld = 'This is a piece of extremely long varchar data';

select @@session.sql_mode;
set sql_mode = 'ansi';

select vchar_fld from string_tbl;

#update string_tbl set text_fld = 'This string doesn't work';
UPDATE string_tbl 
SET 
    txt_fld = 'This string didn\'t work, but it does now';

select txt_fld from string_tbl;

select quote(txt_fld) from string_tbl;	#quote 显示转译符 

select char(97,98,99,100,101,102,103);

select concat('danke sch', char(148), 'n');

select ascii('a');

delete from string_tbl;

select * from string_tbl;

insert into string_tbl (char_fld, vchar_fld, text_fld)
values ('This string is 28 characters', 'This string is 28 characters', 'This string is 28 characters');

select length(char_fld) char_length, length(vchar_fld) varchar_length, length(text_fld) text_length from string_tbl;

select position('characters' in vchar_fld) from string_tbl;

select locate('is', vchar_fld, 5) from string_tbl;

delete from string_tbl;
insert into string_tbl (vchar_fld) values('abcd');
insert into string_tbl (vchar_fld) values('xyz');
insert into string_tbl (vchar_fld) values('QRSTUV');
insert into string_tbl (vchar_fld) values('qrstuv');
insert into string_tbl (vchar_fld) values('12345');
select vchar_fld from string_tbl order by vchar_fld;

select strcmp('12345', '12345') 12345_12345, strcmp('abcd', 'QRSTUV') abcd_QRSTUV, strcmp('abcd', 'xyz') abcd_xyz;

select name, name like '%ns' ends_in_ns from department;

delete from string_tbl;
insert into string_tbl (text_fld) values('This string was 29 characters');
select text_fld from string_tbl;

update string_tbl set text_fld = concat(text_fld, ', but now it is longer');

select concat(fname, ' ', lname, ' has been a ', title, ' since ', start_date) emp_narrative from employee where title = 'Teller' or title = 'Head Teller';

select insert('goodbye world', 9, 0, 'cruel ') string;	# 0 插入
select insert('goodbye world', 1, 7, 'hello') string;

select replace('goodbye world', 'goodbye', 'hello') string;

select substring('goodbye world', 1, 7) string;

select mod(10,4);
select pow(8,2);
select pow(2,10) kilobyte, pow(2,20) megabyte, pow(2,30) gigabyte, pow(2,40) terabyte;

select ceil(5.6), floor(5.6), round(5.655, 2), truncate(5.655, 2);

select sign(1), sign(-1), abs(-1);

select @@global.time_zone, @@session.time_zone;

set sql_safe_updates = 0;

update individual set birth_date = str_to_date('September 17, 2008', '%M %d, %Y') where cust_id = 9999;

select current_date(), current_time(), current_timestamp();

select date_add(current_date(), interval 5 day);

update transaction set txn_date = date_add(txn_date, interval '3:27:11' hour_second);

select last_day('2008-9-17');

select dayname('2008-9-17');

select extract(year from '2008-9-27'), extract(month from '2008-9-27');

select datediff( current_date(), '1994-2-22');


######################################################### test

# test 7-1
SELECT 
    SUBSTRING('Please find the substring in this string',
        17,
        1),
    SUBSTRING('Please find the substring in this substring',
        25,
        1);

# test 7-2
SELECT ABS(- 25.76823), SIGN(- 25.76823), ROUND(ABS(- 25.76823), 2);

# test 7-3
SELECT MONTH(CURRENT_DATE());












