create table film(fid varchar(10),fname varchar(30),rel_year int,no_of_actors int,director varchar(20));
insert into film values('f1','ffseries',2008,4,'anu');
insert into film values('f2','harry porter',2010,3,'ammu');
insert into film values('f3','cinderella',2012,2,'appu');
insert into film values('f4','doctor strange',2014,5,'achu');
insert into film values('f5','twilight',2016,8,'anthu');

create or replace function fn_year(year int) 
	returns int AS
$$
	declare
		year film.rel_year%type;
	begin
		select * from film where rel_year=year;
	end;
$$
language 'plpgsql';
select fn_year(2012);
select * from film;