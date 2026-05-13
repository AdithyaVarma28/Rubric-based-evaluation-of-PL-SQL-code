﻿create table Emp_dept4(eno int,ename varchar(20),sal int,dno int);
insert into Emp_dept4 values(10,'Rajeev',5000,50);
insert into Emp_dept4 values(15,'Amrith',6000,55);
insert into Emp_dept4 values(20,'Suraj',12000,60);
insert into Emp_dept4 values(25,'Reghu',15000,65);


create or replace function Increment_salary(dept_no int,n int) 
returns varchar as
$$
Declare 
        cur_dept cursor for select sal,dno from Emp_dept3;
        
        cur_salary numeric(6,2);
        tot_salary numeric(6,2);
        average numeric(6,2);
 Begin
        open cur_dept;
        fetch cur_dept into cur_salary;

       while found

       loop

             tot_salary:=tot_salary+cur_salary;
             average:=(tot_sal)/4;
              
             
             return average;

             update Emp_dept4 set sal=salary where dno=cur_salary.dept_no;

        end loop;
       close cur_dept;
       return 'average is updated ';
 end;
 $$
 language 'plpgsql';

  select * from Emp_dept4;
  select Increment_salary(50);






