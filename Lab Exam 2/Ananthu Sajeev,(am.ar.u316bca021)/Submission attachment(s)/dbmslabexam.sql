create table Emp(e_id varchar(15) primary key,e_name varchar(15),salary int,job varchar(15),date_of_join date);

create table works(e_id varchar(15),d_id int ,pct_time varchar(10),primary key(e_id,d_id));

create table dpt(d_id int primary key,budget int,mgrid varchar(15));

insert into Emp values ('a1','athul',5000,'1-01-2010');
insert into Emp values ('a2','deepu',6000,'1-01-2010');
insert into Emp values ('a3','gopi',7000,'1-01-2010');

insert into dpt values ('b1',6000,'sam');
insert into dpt values ('b2',7000,'rohit');
insert into dpt values ('b1',10000,'vishnu');

insert into works values ('a1','b1','10:30 am');
insert into works values ('a2','b2','3:00 pm');
insert into works values ('a3','b3','12:15 pm');

create or replace function salary()RETURNS int AS
$$
declare
avg salary;
new salary;
BEGIN
end;
$$
  LANGUAGE 'plpgsql';






