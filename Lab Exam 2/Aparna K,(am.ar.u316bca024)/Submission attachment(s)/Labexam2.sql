create table Film(fid varchar(10),fname varchar (20),rel_year int,no_of_actors int,director varchar(20));
insert into Film values('F111','Ezra',2017,25,'Sidharth');
insert into Film values('F112','Sakhav',2017,30,'Manik');
insert into Film values('F113','Niram',2000,19,'Ravi');
insert into Film values('F114','Kilukkam',1999,40,'Parth');
insert into Film values('F115','Thilakkam',2000,35,'Aalia');

create or replace function Movie()returns varchar as
$$
Declare
Film_cur cursor for select rel_year from Film;
Film2  Film%rowtype;
year2  Film.rel_year%rowtype;
 Begin
 open Film_cur;
 fetch Film_cur into Film2;
 while found
 loop
 select year2 into rel_year where Film.rel_year=Film2.Year2;
 fetch next from Film_cur into year2;
 end loop       
close Film_cur;
End;
$$
language'plpgsql';
select Movie();
select * from Film;