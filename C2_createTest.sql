## 第2章 创建和使用数据库
CREATE database test;
show databases;
use test;
SELECT now();
SHOW CHARACTER SET;

CREATE TABLE person
( person_id SMALLINT UNSIGNED,
  fname VARCHAR(20),
  lname VARCHAR(20),
  gender ENUM('M', 'F'),
  birth_date DATE,
  street VARCHAR(30),
  city VARCHAR(20),
  state VARCHAR(20),
  country VARCHAR(20),
  postal_code VARCHAR(20),
  CONSTRAINT pk_person PRIMARY KEY (person_id)
);

show tables;

desc person;

create table favorite_food
(
  person_id smallint unsigned,
  food varchar(20),
  constraint pk_favorite_food primary key (person_id, food),
  constraint fk_fav_food_person_id foreign key (person_id) references person (person_id)
);

desc favorite_food;

alter table person modify person_id smallint unsigned auto_increment;

alter table favorite_food drop foreign key fk_fav_food_person_id;	##解除外键约束

desc person;

##重新增加外键约束
alter table favorite_food add constraint fk_fav_food_person_id foreign key (person_id) references person (person_id);

desc favorite_food;

insert into person 
(person_id, fname, lname, gender, birth_date)
values (null, 'William', 'Turner', 'M', '1972-05-27');

select * from person;

insert into favorite_food (person_id, food)
values (1, 'pizza');

insert into favorite_food (person_id, food)
values (1, 'cookies');

insert into favorite_food (person_id, food)
values (1, 'nachos');

select * from favorite_food where person_id = 1;

insert into person 
(person_id, fname, lname, gender, birth_date, street, city, state, country, postal_code)
values (null, 'Susan', 'Simth', 'F', '1975-11-2', '23 Maple st', 'Arlington', 'VA', 'USA', '20220');

update person
set street = '1225 Tremont St.',
city = 'Boston',
state = 'MA',
country = 'USA',
postal_code = '02138'
where person_id = 1;

update person 
set street = '23 Maple st.'
where person_id = 2;

##insert into favorite_food (person_id, food) values (999, 'banana');

update person
set birth_date = '1980-12-21'
where person_id = 1;

select * from person where person_id = 1;

show tables;

drop table person;
drop table favorite_food;

desc customer;

