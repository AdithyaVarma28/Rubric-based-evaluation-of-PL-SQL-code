create table emp_dept(eno int, ename varchar(30), sal float, dno int);
insert into emp_dept values(3,'Ben',8000,10),(4,'Jack',5000,10),(5,'Rijo',6000,10);

drop table emp_dept;

create or replace function increment_salary(deptno int, n float)
returns varchar as
$$
   Declare
	emp_cur cursor for select eno from emp_dept where dno=dept_no;
	cur_rec emp_dept.eno%type;
	averge float:=0;
	salinc int:=0;
   Begin
	open emp_cur;
	
	select avg(sal) into averge
	from emp_dept
	where dno=deptno;

	salinc:=averge*(n/100);
	
	fetch emp_cur into cur_rec;
	while Found
	loop
		update emp_dept
		set sal=sal+averge
		where eno=cur_rec;		
		fetch next from emp_cur into cur_rec;
	end loop;
		

	close emp_cur;
	
	return 'Updation Succesful';
  End;
$$
language 'plpgsql';

select increment_salary(10,5);



update emp_dept
set sal=sal+100
where dno=10;

