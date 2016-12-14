create table md5s (num int not null primary key, hash varchar(32) not null);

insert into md5s with source as (select generate_series(1, 500000, 1) as num) select num, md5('yjdafjpo' || num::varchar) from source;

create table md5_triples as select * from md5s where hash ~ E'(.)\\1\\1';

create table md5_quintuples as select * from md5_triples where hash ~ E'(.)\\1\\1\\1\\1';

select
t.num,
t.hash,
(regexp_matches(t.hash, E'(\\w)\\1\\1'))[1] as repeat_char,
q.num,
q.hash
from
md5_triples as t,
md5_quintuples as q
where
(regexp_matches(t.hash, E'(\\w)\\1\\1'))[1] =
(regexp_matches(q.hash, E'(\\w)\\1\\1\\1\\1'))[1]
and
q.num between (t.num + 1) and (t.num + 1000)
order by
t.num, q.num;
