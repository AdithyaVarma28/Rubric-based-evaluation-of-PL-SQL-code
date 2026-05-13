create table film (fid varchar(20),fname char(100),rel_year int,no_of_actors int,director char(50));

insert into film values ('f101','Vellithira',2002,46,'Sathyan');
insert into film values ('f102','Ooggy and the cockroches',2002,46,'Disney');
insert into film values ('f103','Inferno',2002,46,'Dan Brown');
insert into film values ('f104','da Vinci code',2002,46,'Dan Brown');
insert into film values ('f105','Lucy',2002,46,'Sainta');

select * from film;

create function fn_films(integer) RETURNS varchar AS
$$
DECLARE
	r_year int;
	r_year film.rel_year %type;
	film_cursor cursor for select * from film where rel_year=r_year;
BEGIN
	select * from Film where r_year=rel_year %type;

RETURN(select * from Film where r_year=rel_year %type);
END;
$$
LANGUAGE 'plpgsql';

select fn_films();

















create table faculty(fid varchar(20)primary key,fname varchar(20),age int,salary numeric(8,2),cid varchar(20));
create table deleted_faculty(fid varchar(20),dod date);

insert into faculty values('f101','vrinda',18,78690,'c101');
insert into faculty values('f102','gautham',19,905564);
insert into faculty values('f103','rohith',23,99999);
insert into faculty values('f141','rizwana',19,37860,'c104');
insert into faculty values('f107','roshni',27,479076,'c106');

select * from deleted_faculty;

select * from faculty;

create or replace function faculty_audit() returns varchar as
$$
declare 
emp_cursor cursor for select fid from faculty where cid is NULL;
faculty_id faculty.fid%type;
begin
open emp_cursor;
fetch emp_cursor into faculty_id;
while found
loop
delete from faculty where fid=faculty_id;
insert into deleted_faculty values(faculty_id,current_date);
fetch next from emp_cursor into faculty_id;
end loop;
close emp_cursor;
return'Table Updated';
end;
$$
language'plpgsql';

select faculty_audit();
