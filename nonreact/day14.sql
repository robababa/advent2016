create table md5s (num int not null primary key, hash varchar(32) not null);

insert into md5s with source as (select generate_series(1, 500000, 1) as num) select num, md5('yjdafjpo' || num::varchar) from source;

create table md5_triples as select * from md5s where hash ~ E'(.)\\1\\1';

create table md5_quintuples as select * from md5_triples where hash ~ E'(.)\\1\\1\\1\\1';
