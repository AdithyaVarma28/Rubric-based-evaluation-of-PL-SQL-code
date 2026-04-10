--PL-SQL Lab 1--
--Pavithra Rajeev--
--AM.SC.U4AIE23144--

--Q4--

create table customer(
    cno varchar(10) primary key,
    cname varchar(50),
    c_type varchar(10)
);

create table branches(
    br_no varchar(10) primary key,
    br_name varchar(50),
    loc varchar(50)
);

create table accounts(
    ac_no varchar(10) primary key,
    br_no varchar(10),
    cust_no varchar(10),
    ac_type varchar(20),
    bal numeric(12,2),
    foreign key (br_no) references branches(br_no),
    foreign key (cust_no) references customer(cno)
);



insert into customer values ('C1', 'PAVITHRA', 'A');
insert into customer values ('C2', 'SWETHA', 'B');
insert into customer values ('C3', 'RESH', 'A');
insert into customer values ('C4', 'KASHI', 'B');

insert into branches values ('BR1', 'MAIN BRANCH', 'CHENNAI');
insert into branches values ('BR2', 'CITY BRANCH', 'BANGALORE');
insert into branches values ('BR3', 'TOWN BRANCH', 'MUMBAI');

insert into accounts values ('A1', 'BR1', 'C1', 'SAVINGS', 60000.00);
insert into accounts values ('A2', 'BR1', 'C2', 'CURRENT', 30000.00);
insert into accounts values ('A3', 'BR2', 'C3', 'SAVINGS', 75000.00);
insert into accounts values ('A4', 'BR2', 'C1', 'CURRENT', 20000.00);
insert into accounts values ('A5', 'BR3', 'C4', 'SAVINGS', 15000.00);
insert into accounts values ('A6', 'BR3', 'C2', 'CURRENT', 50000.00);

select * from customer;
select * from branches;
select * from accounts;

--a--
create or replace function update_custype(threshold numeric, cust_id customer.cno%type)
    returns varchar as
$$
    Declare
        total_bal numeric;
    Begin
        select sum(bal) into total_bal from accounts where cust_no = cust_id;

        if total_bal > threshold then
            update customer set c_type = 'A' where cno = cust_id;
        else
            update customer set c_type = 'B' where cno = cust_id;
        end if;
        return 'customer type updated';
    end;
$$
language 'plpgsql';
select update_custype(50000.00, 'C1')

--b--
create or replace function closebranch(close_br branches.br_no%type, new_br branches.br_no%type)
    returns varchar as
$$
    Declare
        cnt int;
    Begin
        update accounts set br_no = new_br where br_no = close_br;
        delete from branches where br_no = close_br;

        return 'branch closed and accounts transferred';
    end;
$$
language plpgsql;
select closebranch('BR1', 'BR3')

--c--
create or replace function safe_withdraw(accno accounts.ac_no%type, amt numeric)
    returns varchar as
$$
    Declare
        curr_bal numeric;
    Begin
        select bal into curr_bal from accounts where ac_no = accno;

        if curr_bal >= amt then
            update accounts set bal = bal - amt where ac_no = accno;
            return 'withdrawal successful';
        else
            return 'insufficient funds – withdrawal denied';
        end if;
    end;
$$
language plpgsql;
select safe_withdraw('A1', 30000)
