create table emp (eid int primary key,ename varchar(20),salary numeric(8,2),job varchar(20),doj date);
create table works (eid int references emp(eid),did int references dept(did),pct_time varchar(10),primary key(eid,did));
create table dept (did int primary key,budget numeric(10,2),mgrid int);


insert into emp values(1,'Rahul','10000.50','accounts','12-11-04');
insert into emp values(2,'Abhirami','20000.75','finance','12-11-04');
insert into emp values(3,'Anakha','20000.00','accounts','12-12-12');

insert into dept values(101,'100000',24);
insert into dept values(102,'150000',25);
insert into dept values(103,'100000',26);

insert into works values(1,101,'11:05');
insert into works values(2,102,'12:00');
insert into works values(3,103,'12:30');


create function accept_emp(empid int,depid int) returns varchar as
$$
declare
budg dept.budget %type;
sal emp.salary %type;
begin
select budget into budg from dept where did=depid;
select sum(salary) into sal from emp where eid=empid;

if sal<budg then
    update emp set salary=0.1+salary where eid=empid;
    return 'updated';
else
    return 'not found';
end if;
end;
$$
language plpgsql;

 select accept_emp(1,101);
 select * from emp;
