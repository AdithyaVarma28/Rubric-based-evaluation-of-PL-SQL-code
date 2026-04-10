-- pl/sql lab 1 solutions
-- question 1: class questions

-- 1.1 function to find sum of 2 integers
create or replace function sum(a int, b int)
returns int as $$
declare 
    c int;
begin 
    c := a + b;
    return c;
end;
$$ language plpgsql;

-- 1.2 function to check even or odd
create or replace function even_odd(a int)
returns varchar(10) as $$
begin 
    if a % 2 = 0 then 
        return 'even';
    else 
        return 'odd';
    end if;
end;
$$ language plpgsql;

-- setup for employee/dept questions
drop table if exists emp cascade;
drop table if exists dept cascade;

create table dept(
    dept_no int primary key,
    dname varchar(10)
);

create table emp(
    eno int primary key,
    ename varchar(10),
    sal numeric(10,2),
    dno int references dept(dept_no)
);

-- 1.3 function to find salary by employee name
create or replace function find_sal(empno emp.eno%type)
returns emp.sal%type as $$
declare 
    salary emp.sal%type;
begin 
    select sal into salary from emp where eno = empno;
    return salary;
end;
$$ language plpgsql;

-- 1.4 function to count employees in a department
create or replace function emp_count(deptno emp.dno%type)
returns int as $$
declare 
    num int;
begin
    select count(eno) into num from emp where dno = deptno;
    return num;
end;
$$ language plpgsql;

-- 1.5 function to give 10% hike if salary is less than dept average
create or replace function promo(empno emp.eno%type)
returns void as $$
declare 
    salary emp.sal%type;
    avg_sal int;
begin
    select avg(sal) into avg_sal from emp where dno = (select dno from emp where eno = empno);
    select sal into salary from emp where eno = empno;
    
    if salary < avg_sal then
        salary := salary + (salary * 0.1);
        update emp set sal = salary where eno = empno;
    end if;
end;
$$ language plpgsql;

-- 1.6 function to get department name of an employee
create or replace function emp_dep(empname emp.ename%type)
returns dept.dname%type as $$
declare 
    dep dept.dname%type;
begin
    select dname into dep from dept where dept_no = (select dno from emp where ename = empname);
    return dep;
end;
$$ language plpgsql;


-- question 2: employee & projects

-- setup (dropping previous emp table to avoid conflict)
drop table if exists emp_proj cascade;
drop table if exists emp cascade;

create table emp (
    eno int primary key, 
    ename varchar(50), 
    sal decimal(10,2)
);

create table emp_proj (
    eno int, 
    pno int, 
    prjt_hrs decimal(10,2),
    foreign key (eno) references emp(eno)
);

-- insert dummy data
insert into emp values (101, 'John', 5000);
insert into emp values (102, 'Alice', 7000);
insert into emp values (103, 'Bob', 4000); 

insert into emp_proj values (101, 1, 10);
insert into emp_proj values (101, 2, 20); 
insert into emp_proj values (102, 1, 15); 

-- 2a. function projectload
create or replace function projectload(p_eno int) 
returns decimal as $$
declare
    v_total_hrs decimal := 0;
begin
    select sum(prjt_hrs) into v_total_hrs
    from emp_proj
    where eno = p_eno;
    
    return coalesce(v_total_hrs, 0);
end;
$$ language plpgsql;

-- 2c. update salary based on average (anonymous block)
do $$ 
declare
    v_avg_sal decimal;
begin
    select avg(sal) into v_avg_sal from emp;
    
    update emp
    set sal = sal + (v_avg_sal - sal)
    where sal < v_avg_sal;
    
    raise notice 'salaries updated based on average: %', v_avg_sal;
end $$;


-- question 3: items & transactions

-- setup
drop table if exists transaction cascade;
drop table if exists item cascade;

create table item(
    ino int primary key, 
    iname varchar(50), 
    unit_price decimal(10,2)
);

create table transaction(
    tr_no int primary key, 
    ino int, 
    qty int,
    foreign key (ino) references item(ino)
);

-- insert dummy data
insert into item values (1, 'Keyboard', 20);
insert into item values (2, 'Mouse', 10);
insert into transaction values (100, 1, 5);
insert into transaction values (101, 1, 2); 
insert into transaction values (102, 2, 1); 

-- 3. function to manage items
create or replace function manageitem(p_ino int) 
returns void as $$
declare
    v_count int;
begin
    select count(*) into v_count from transaction where ino = p_ino;
    
    if v_count < 2 then
        delete from item where ino = p_ino;
        raise notice 'item % deleted.', p_ino;
    else
        raise notice 'item % retained.', p_ino;
    end if;
end;
$$ language plpgsql;


-- question 4: bank database

-- setup
drop table if exists accounts cascade;
drop table if exists branches cascade;
drop table if exists customer cascade;

create table branches (
    br_no int primary key, 
    br_name varchar(50), 
    loc varchar(50)
);

create table customer (
    cno int primary key, 
    cname varchar(50), 
    c_type varchar(1)
);

create table accounts (
    ac_no int primary key, 
    br_no int, 
    cust_no int, 
    ac_type varchar(10), 
    bal decimal(10,2),
    foreign key (br_no) references branches(br_no),
    foreign key (cust_no) references customer(cno)
);

-- dummy data
insert into branches values (1, 'Main St', 'NY');
insert into branches values (2, 'High St', 'NJ');
insert into customer values (501, 'Sam', 'B');
insert into accounts values (9001, 1, 501, 'Savings', 1000);

-- 4a. function to update customer type
create or replace function updatecusttype(p_cno int, p_threshold decimal) 
returns void as $$
declare
    v_sum_bal decimal;
begin
    select sum(bal) into v_sum_bal from accounts where cust_no = p_cno;
    
    if v_sum_bal > p_threshold then
        update customer set c_type = 'A' where cno = p_cno;
    else
        update customer set c_type = 'B' where cno = p_cno;
    end if;
end;
$$ language plpgsql;

-- 4b. function closebranch
create or replace function closebranch(p_old_br int, p_new_br int) 
returns void as $$
begin
    -- transfer accounts
    update accounts set br_no = p_new_br where br_no = p_old_br;
    -- remove old branch
    delete from branches where br_no = p_old_br;
    
    raise notice 'branch closed and accounts transferred.';
end;
$$ language plpgsql;

-- 4c. function safewithdraw
create or replace function safewithdraw(p_ac_no int, p_amount decimal) 
returns void as $$
declare
    v_bal decimal;
begin
    -- lock row for update
    select bal into v_bal from accounts where ac_no = p_ac_no for update;
    
    if not found then
        raise notice 'account not found.';
        return;
    end if;
    
    if v_bal >= p_amount then
        update accounts set bal = bal - p_amount where ac_no = p_ac_no;
        raise notice 'withdrawal successful. new balance: %', (v_bal - p_amount);
    else
        raise notice 'insufficient funds.';
    end if;
end;
$$ language plpgsql;