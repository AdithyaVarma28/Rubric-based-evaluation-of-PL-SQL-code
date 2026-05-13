create table accounts(ac_no varchar(20),ac_type varchar(20),bal_amt int,br_no varchar(20)primary key);
create table branches(br_no varchar(20) references accounts(br_no),br_name_loc varchar(20));
create table customers(cno varchar(20),ac_no varchar(20),cname varchar(20));

insert into accounts values('ac45','current',2000,'br45');
insert into accounts values('ac46','current',3000,'br46');
insert into accounts values('ac47','current',7000,'br47');
insert into branches values('br45','kollam');
insert into branches values('br46','kozhikode');
insert into branches values('br47','alpy');
insert into customers values('cno45','ac45','ameta');
insert into customers values('cno46','ac46','aron');
insert into customers values('cno47','ac47','anzy');


Create or replace function fn_transfer(giver varchar(2),receiver varchar(2),amount int) returns
 varchar AS
 $$
 Declare

 Begin
 update account bal_amt ac_no.accounts=ac_no.customers;
 LOOP
 if giver.transfer==1000;
 ac_no.accounts=acno.customer
 END LOOP
 END;
 $$
 language 'plpgsql';
 