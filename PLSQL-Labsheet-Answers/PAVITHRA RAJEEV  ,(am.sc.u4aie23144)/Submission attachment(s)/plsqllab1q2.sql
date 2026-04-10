--PL-SQL Lab 1--
--Pavithra Rajeev--
--AM.SC.U4AIE23144--


--Q2--
select * from Emp;
select * from EMP_PROJ;

create table EMP_PROJ(
    eno int,
    pno int,
    prjt_hrs decimal(10,2),
    foreign key (eno) references emp(eno)
);

insert into emp_proj (eno, pno, prjt_hrs) values
    (1, 101, 12.5),
    (1, 102, 15.0),
    (2, 103, 20.0),
    (3, 104, 18.0),
    (4, 105, 10.0),
    (5, 106, 22.0),
    (6, 107, 16.5),
    (7, 108, 14.0),
    (7, 109, 19.0);
--a--
create or replace function projectload(emp_no emp.eno%type)
    returns numeric as
$$
    Declare
        total_hrs numeric;
    Begin
        select coalesce(sum(prjt_hrs)) into total_hrs from emp_proj where eno = emp_no;
        return total_hrs;
    end;
$$
language 'plpgsql';

select projectload(1);


--b--
create or replace function update_sal(emp_no emp.eno%type)
    returns varchar as
$$
    Declare
        avg_sal numeric;
        curr_sal numeric;
		new_sal numeric;

    Begin
        select sal into curr_sal from emp where eno = emp_no;
        select avg(sal) into avg_sal from emp;
        if curr_sal < avg_sal then
            update emp
            set sal = sal + (avg_sal - curr_sal)
            where eno = emp_no;
        end if;
        select sal into new_sal from emp where eno = emp_no;

        return new_sal;
    end;
$$
language 'plpgsql';

select update_sal(3);


