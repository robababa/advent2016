drop table if exists md5s, md5_triples, md5_quintuples cascade;

create table md5s (num int not null primary key, hash varchar(32) not null);

-- part 2
-- run these commands once
--create or replace function md5_2 (t text) returns text as $$ select md5(md5(t)); $$ language sql;
--create or replace function md5_4 (t text) returns text as $$ select md5_2(md5_2(t)); $$ language sql;
--create or replace function md5_8 (t text) returns text as $$ select md5_4(md5_4(t)); $$ language sql;
--create or replace function md5_16 (t text) returns text as $$ select md5_8(md5_8(t)); $$ language sql;
--create or replace function md5_32 (t text) returns text as $$ select md5_16(md5_16(t)); $$ language sql;
--create or replace function md5_64 (t text) returns text as $$ select md5_32(md5_32(t)); $$ language sql;
--create or replace function md5_128 (t text) returns text as $$ select md5_64(md5_64(t)); $$ language sql;
--create or replace function md5_256 (t text) returns text as $$ select md5_128(md5_128(t)); $$ language sql;
--create or replace function md5_512 (t text) returns text as $$ select md5_256(md5_256(t)); $$ language sql;
--create or replace function md5_1024 (t text) returns text as $$ select md5_512(md5_512(t)); $$ language sql;

insert into md5s
with
source
as
(
  select generate_series(1, 50000, 1) as num
)
select
num,
-- part 1
--md5(md5(md5('yjdafjpo' || num::varchar)))
-- part 2
md5_1024(md5_512(md5_256(md5_128(md5_64(md5_32(md5('yjdafjpo' || num::varchar)))))))
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
