create table emp_salary(eno varchar(10) primary key,ename varchar(15),basic_sal numeric(7,2),comsn int,tax_amt int,sal_adv int,gross_sal numeric(8,2),dno int);
insert into emp_salary(eno,ename,basic_sal,comsn,tax_amt,sal_adv,gross_sal,dno)values('E20','anu',20000.00,1000,1200,5000,NULL,10),('E25','anju',25000.50,2500,2750,15000,175000.50,12),('E30','ria',50000.00,3500,4250,7500,200000.00,18);
select * from emp_salary;

create or replace function fn_employ(dept_no int)
       returns numeric(8,2) AS
$$
  Declare
         cur_gross cursor for select gross_sal from emp_salary where dno = dept_no;
         gr_sal emp_salary.gross_sal%type;

  Begin
       open cur_gross;
       fetch cur_gross into gr_sal;
       while found
            Loop 
               gr_sal = emp_salary.basic_sal + emp_salary.comsn - emp_salary.tax_amt - emp_salary.sal_adv;
               update emp_salary set gross_sal=gr_sal where dno=dept_no;
            End loop;
       fetch next from cur_gross into gr_sal;
       close cur_gross;
      return"Table updated";
  End
 $$
   language 'plpgsql';
   
 select fn_employ(12); 
           
               
              
  