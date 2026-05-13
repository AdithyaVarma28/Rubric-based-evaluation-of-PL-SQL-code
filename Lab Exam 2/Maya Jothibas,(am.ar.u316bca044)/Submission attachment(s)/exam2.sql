create table emp_dept(eno int,ename varchar(10),sal numeric(10,4),dno int,average_sal int);
insert into emp_dept(eno,ename,sal,dno) values(111,'nivin',2200,222);
insert into emp_dept(eno,ename,sal,dno) values(112,'maya',2100,223);
insert into emp_dept(eno,ename,sal,dno) values(113,'miya',2300,224);
insert into emp_dept(eno,ename,sal,dno) values(114,'riya',2000,225);


create or replace function increment_salary(dno int,n int)
returns int as
$$

declare
	dno int;
	sal numeric;
	average_sal int;
	sal_update cursor select eno,ename,sal,dno,average_sal from emp_dept;
	sal_update.emp_dept.%type;
	select emp_dept into sal_update where avg=average_sal%type;


begin
	while found
	loop
		open cursor sal_update;
		fetch sal_update into emp_dept;


		close cursor;
		end loop
end;
$$ 
language 'plpgsql'

 
