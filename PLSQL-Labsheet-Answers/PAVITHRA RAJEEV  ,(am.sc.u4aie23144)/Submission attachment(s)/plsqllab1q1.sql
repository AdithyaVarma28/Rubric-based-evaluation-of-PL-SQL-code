--PL-SQL Lab 1--
--Pavithra Rajeev--
--AM.SC.U4AIE23144--

--Q1--
create or replace function sumint(a int, b int)
	returns int as
$$
	Declare
		c int;
	Begin
		c =a+b;
		return c;
	End;
$$
Language 'plpgsql';

select sumint(44, 2)



--Q2--
create or replace function check_even_odd(a int)
	returns varchar as
$$
	Begin
		if a % 2 =0 then
			return 'even';
		else
			return 'odd';
		End if;
	End;
$$
Language 'plpgsql';

select check_even_odd(44)



create table Dept(dept_no int PRIMARY KEY, dname varchar(50));
create table Emp (eno int PRIMARY KEY, ename varchar(50), sal decimal(10,2), dno int, foreign key (dno) references Dept(dept_no) );
select * from Emp;

select * from Emp;
select * from Dept;

insert into Dept (dept_no, dname) values
    (10, 'CS'),
    (20, 'EEE'),
    (30, 'MEE'),
    (40, 'AI');

insert into Emp (eno, ename, sal, dno) values
    (1, 'Pavithra', 50000.00, 10),
    (2, 'Swetha', 55000.00, 20),
    (3, 'Resh', 54000.00, 30),
    (4, 'Kashi', 60000.00, 40),
	(5, 'Deva', 60000.00, 10),
	(6, 'Keerthana', 40000.00, 20),
	(7, 'Nira', 40000.00, 10);

--1--
create or replace function emp_sal(emp_no Emp.eno%type)
	returns Emp.sal%type as
$$
	Declare
		salary Emp.sal%type;
	Begin
		select sal into salary from Emp where eno=emp_no;
		return salary;
	End;
$$
Language 'plpgsql';

select emp_sal(2)

--2--
create or replace function no_of_employees(mydep_no Emp.dno%type)
	returns int as
$$
	Declare
		countemp int;
	Begin
		select count(eno) into countemp from Emp where mydep_no=dno;
		return countemp;
	End;
$$
Language 'plpgsql';

select no_of_employees(10);

--3--
create or replace function increase_sal(emp_no Emp.eno%type)
	returns varchar as
$$
	Declare
		salary Emp.sal%type;
	Begin
		select sal into salary from Emp where eno=emp_no;
		if (salary< (select avg(sal) from Emp where dno= (select dno from Emp where eno=emp_no))) then
			update Emp set sal = sal + (sal*(0.10)) where eno=emp_no;
		End if;
		return 'salary updated';
	End;
$$
Language 'plpgsql';
select increase_sal(3)
			
			
--4--
create or replace function dep_name(empname Emp.ename%type)
	returns Dept.dname%type as
$$
	Declare
		mydeptname Dept.dname%type;
	Begin
		select D.dname into mydeptname from Emp E join Dept D on E.dno = D.dept_no where E.ename= empname;
		return mydeptname;
	End;
$$
Language 'plpgsql';

select dep_name('Pavithra');
