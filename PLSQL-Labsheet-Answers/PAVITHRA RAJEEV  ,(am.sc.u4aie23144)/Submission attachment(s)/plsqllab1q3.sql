--PL-SQL Lab 1--
--Pavithra Rajeev--
--AM.SC.U4AIE23144--


--Q3--

create table item(
    ino int primary key,
    iname varchar(50),
    unit_price numeric(10,2)
);

create table transaction(
    tr_no int primary key,
    ino int,
    qty int,
    foreign key (ino) references item(ino)
);

insert into item values (101, 'Puffs', 10.00);
insert into item values (102, 'Burger', 50.00);
insert into item values (103, 'Pizza', 5.00);
insert into item values (104, 'Roll', 8.00);
insert into item values (105, 'Custard', 25.00);

insert into transaction values (1, 101, 5);
insert into transaction values (2, 101, 3);
insert into transaction values (3, 102, 10);
insert into transaction values (4, 103, 2);
insert into transaction values (5, 103, 4);
insert into transaction values (6, 104, 1);



create or replace function delete_item(ino_input item.ino%type)
    returns varchar as
$$
    Declare
        trans_count int;
    Begin
        select count(*) into trans_count from transaction where ino = ino_input;
        if trans_count < 2 then
            delete from item where ino = ino_input;
            return 'item deleted';
        else
            return 'item not deleted';
        end if;
    end;
$$
language 'plpgsql';

select delete_item(101);

