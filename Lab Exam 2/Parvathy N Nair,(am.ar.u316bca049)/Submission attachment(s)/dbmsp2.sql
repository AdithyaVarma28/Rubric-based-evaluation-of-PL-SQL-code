create table ac49(ac_no int primary key,cno int,ac_type varchar(5),bal_amt int,br_no int, foreign key(br_no) references br49(br_no),foreign key(cno) references cus49(cno));
create table br49(br_no int primary key,br_name_loc varchar(5));
create table cus49(cno int primary key,ac_no int,cname varchar(5),foreign key(ac_no) references ac49(ac_no));

insert into ac49 values (101,201,'A11',5000,301);
insert into ac9 values (102,202,'A22',3000,302);
insert into ac49 values (103,203,'A33',4000,303);

insert into br49 values (301,'b1');
insert into br49 values (302,'b2');
insert into br9 values (303,'b3');

insert into cus49 values (201,101,'c1');
insert into cus49 values (202,102,'c2');
insert into cus49 values (203,103,'c3');

create function transfer(giver VARCHAR,receiver VARCHAR,amount int)
returns int AS;
$$
Declare
cur_trans cursor for select ac_no,bal_amnt from accounts;





