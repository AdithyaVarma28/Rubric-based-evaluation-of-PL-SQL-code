create table ACCOUNTS(ac_no varchar(10),cno varchar(10),ac_type varchar(10),bal_amt varchar(10),br_no varchar(10));
create table BRANCHES(br_no varchar (10),br_ name_location varchar(10));
create table CUSTOMERS(cno  varchar(10),ac_no varchar(10),cname varchar(10));
insert into ACCOUNTS values('z123','a11','FD','25000','E10');
insert into ACCOUNTS values('x124','a12','FD','55000','E11');
insert into ACCOUNTS values('x125','a13','FD','35000','E12');
insert into ACCOUNTS values('x126','a14','FD','45000','E13');

insert into BRANCHES values('x124','a12','FD','55000','E11');
insert into BRANCHES values('x124','a12','FD','55000','E11');
insert into BRANCHES values('x124','a12','FD','55000','E11');
insert into BRANCHES values('x124','a12','FD','55000','E11');

insert into CUSTOMERS values('x124','a12','FD','55000','E11');
insert into CUSTOMERS values('x124','a12','FD','55000','E11');
insert into CUSTOMERS values('x124','a12','FD','55000','E11');
insert into CUSTOMERS values('x124','a12','FD','55000','E11');






