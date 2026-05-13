create table emp0(eid varchar(5) primary key,ename varchar(20),sal numeric(7,2),job varchar(20),doj date);
create table dept0(did varchar(5) primary key,budget numeric(14,2),mgr_id varchar(10));
create table works0(eid varchar(5),did varchar(5),pjt_time varchar(10),foreign key(eid) references emp0(eid),foreign key(did)references dept0(did));

insert into emp0 values('E111','Saroj',2500,'Cashier','12-12-2015');
insert into emp0 values('E222','Shankar',2100,'Salesman','11-12-2015');
insert into emp0 values('E333','Rithika',2700,'Receptionist1','10-12-2015');
insert into emp0 values('E444','Anita',4200,'Manager','09-12-2015');
insert into emp0 values('E555','Balagopal',1700,'Salesman','08-12-2015');
insert into emp0 values('E666','Arun',2700,'Receptionist 2','07-12-2015');
insert into emp0 values('E777','Lathika',3900,'Asst_Manager','06-12-2015');
insert into emp0 values('E888','Ani',4700,'Head_Manager','05-12-2015');
insert into emp0 values('E999','Sarojini',2500,'Cashier','04-12-2015');
select * from emp0;


insert into dept0 values('D154',15000,'MGR001');
insert into dept0 values('D219',4000,'MGR009');
insert into dept0 values('D333',3000,'MGR004');
insert into dept0 values('D543',6000,'MGR006');
select * from dept0;


insert into works0 values('E111','D543','5 hrs');
insert into works0 values('E222','D333','7 hrs');
insert into works0 values('E333','D219','6 hrs');
insert into works0 values('E444','D154','15 hrs');
insert into works0 values('E555','D333','12 hrs');
insert into works0 values('E666','D219','9 hrs');
insert into works0 values('E777','D154','24 hrs');
insert into works0 values('E888','D154','14 hrs');
insert into works0 values('E999','D543','5 hrs');
select * from works0;


create or replace function fn_emp(emp_id varchar)
	returns varchar as
$$
declare
	salary emp0.sal%type;
	sum1 numeric(16,2);
begin
	select sal into salary from emp0 where eid=emp_id;
	select sum(sal) into sum1 from emp0,works0 group by did having emp=emp_id and emp0.eid=works0.eid;
	if(sum1<budget) then
		update emp0 set sal=sal+((10*sal)/100)where eid=emp_id;
		return 'balance updated'; 
	else 
		return 'sum already >budget'; 
end;
$$ 
language 'plpgsql'

select fn_emp('E333');
select *from emp0;
select *from works0;
select *from dept0;



	