create table emp_sal(e_no varchar(10),e_name varchar(10),basic_sal int,commission int,tax_amt int,sal_adv int,gross_sal int,d_no varchar(10));
insert into emp_sal values('A001','manasa',100000,100,500,5000,94600,'a001');
insert into emp_sal values('A002','vaishma',200000,200,600,6000,193600,'b002');
insert into emp_sal values('A003','thillai',300000,300,700,7000,292600,'c003');
insert into emp_sal values('A004','srinithi',400000,400,800,8000,393200,'d004');

create function emp_sal(int) returns varchar AS
$$
Begin
update table emp_sal where gross_sal >=100000
End
$$
language'plpgsql';
      