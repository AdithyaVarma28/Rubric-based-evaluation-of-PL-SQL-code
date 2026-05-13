create table ACCOUNTS(ac_no varchar(15),cno varchar (15),ac_type varchar(10),bal_amt int,br_no varchar(15),primary key (ac_no,cno) ,foreign key (cno) references CUSTOMERS(cno));
create table CUSTOMERS(cno varchar(15) primary key ,ac_no varchar(15) ,cname varchar(15));
create table BRANCHES (br_no varchar(15) primary key,br_name_loc varchar(30));
insert into ACCOUNTS (ac_no,cno,ac_type ,bal_amt,br_no) values ('A123','C456','Savings',152484,'B6'),('A345','C434','Credit',114578,'B5'),('A578','C406','Savings',1178457,'B3');
insert into CUSTOMERS(cno ,ac_no,cname) values ('C456','A123','Aswathy'), ('C434','A345','Aswin'),('C406','A578','Asin');
insert into BRANCHES (br_no,br_name_loc) values ('B6','Thevalakkara'),('B5','Kollam'),('B3','Ernakulam');

create or replace function transfer (giver varchar2(15),receiver varchar2(15),amount int) returns varchar As
$$
Declare
	m_curbal ACCOUNTS.bal_amt%type;
	m_minbal int :=15000;
	m_temp int;
	

Begin
	IF m_curbal >m_minbal THEN
	{
		m.temp:=m_curbal.ACCOUNTS-amount;
		update ACCOUNTS set m_curbal=m.temp where giver =ac_no.ACCOUNTS;
		m.temp:=m_curbal.ACCOUNTS+amount;
		update ACCOUNTS set m_curbal=m.temp where receiver =ac_no.ACCOUNTS;
		return "Your table is updated";
	}
	ELSE
	{
		return "Your balance is in sufficient";
	}

END;
$$
language 'plpgsql';

select transfer ('A123','A345',5000);
	
		