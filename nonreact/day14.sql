drop table md5s, md5_triples, md5_quintuples cascade;

create table md5s (num int not null primary key, hash varchar(32) not null);

insert into md5s
with
source
as
(
  select generate_series(1, 500000, 1) as num
)
select
num,
md5('yjdafjpo' || num::varchar)
from
source;

create table md5_triples
as
select
num,
hash,
(regexp_matches(hash, E'(\\w)\\1\\1'))[1]::varchar(1) as first_char
from
md5s
where
hash ~ E'(.)\\1\\1';

create table md5_quintuples
as
select
num,
hash,
(regexp_matches(hash, E'(\\w)\\1\\1\\1\\1'))[1]::varchar(1) as first_char
from
md5_triples
where
hash ~ E'(.)\\1\\1\\1\\1';

select
distinct on (t.num)
t.num,
q.num
from
md5_triples as t,
md5_quintuples as q
where
t.first_char = q.first_char
and
q.num between (t.num + 1) and (t.num + 1000)
order by
t.num, q.num
limit 64;
