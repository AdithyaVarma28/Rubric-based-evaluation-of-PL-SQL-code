create table Emp_sals(eno varchar(10),ename varchar(15),basic_sal numeric(7,2),commission numeric(7,2),tax_amt numeric(7,2),sal_adv numeric(7,2),gross_sal numeric(7,2),dno varchar(10));

insert into Emp_sals values('e1','richu',20000,1000,500,9000,1500,'d1');
insert into Emp_sals values('e2','lincy',15000,500,200,7000,8300,'d2');
insert into Emp_sals values('e3','mahi',10000,200,100,5000,5100,'d3');
insert into Emp_sals values('e4','riya',12000,400,500,6000,5900,'d4');
insert into Emp_sals values('e5','veni',14000,500,600,4000,9900,'d5');

create function gross_count(dept_no varchar) 
	returns int as
$$
declare
	gross_update cursor for select dept_no=dno from Emp_sals;
	gross_row Emp_sals %row type;
	gross_salary Emp_sals.gross_sal %type;
begin
	open gross_update;
	fetch gross_update into gross_row;
	while found
	loop
		gross_sal=basic_sal+commission-tax_amt-sal_adv;
		update Emp_sals set gross_salary=gross_sal where dept_no=dno;
	end loop;
	close gross_update;
	fetch next from gross_update into gross_row;
	return emp_sals table updated;
	end;
$$
language'plpgsql';	
select gross_count('d1');
select * from emp_sals;
	
	
	

	



