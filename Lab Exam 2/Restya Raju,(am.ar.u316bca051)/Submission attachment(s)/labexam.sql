create table film(fid varchar(20) primary key,fname varchar(20),rel_year int,no_of_act int,director varchar(20));
insert into film values('f01','radha',2015,4,'chandran');
insert into film values('f02','velli moonga',2010,5,'baburaj');
insert into film values('f03','bol bachan',2006,3,'mahesh batt');
insert into film values('f04','dangal',2015,4,'karan johar');
insert into film values('f06','pulimurugan',2015,2,'priya darshan');
insert into film values('f07','gajani',2013,5,'kedhar');

drop table film;
create function rel(yr int) 
returns varchar as
$$
declare 

 yr_cur cursor for select fid ,fname,rel_year,no_of_act,director from film;
 rowfilm film%rowtype;
 yr film.rel_year%type;
 begin
 open yr_cur;
 fetch yr_cur into rowfilm;
 while found
 loop
 
select * from film where rel_year=yr group by rel_year  ;
fetch next from yr_cur into rowfilm;
end loop;
close yr_cur;
return 'details are here';
end;
$$
language 'plpgsql';
select rel(2015); 





 
 
 