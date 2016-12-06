create table matches
(
  num integer not null,
  md5sum varchar not null,
  password_char varchar(1) not null,
  position_char varchar(1) not null
);

-- run this 8 times.  Hacky, but it works
insert into matches (num, md5sum, password_char, position_char)
with
max_num
as
(
  select coalesce(max(num), 0) as max_num from matches
),
already_found
as
(
  select position_char from matches
),
source
as
(
  select generate_series(max_num + 1, 200000000 + max_num, 1) as num from max_num
),
middle
as
(
  select num, md5('wtnhxymk' || num::varchar) as md5sum
  from source
  where
    md5('wtnhxymk' || num::varchar) like '00000%'
    and
    substr(md5('wtnhxymk' || num::varchar), 6, 1) in
      ('0','1','2','3','4','5','6','7')
    and
    substr(md5('wtnhxymk' || num::varchar), 6, 1) NOT IN
      (select position_char from already_found)
    limit 1
)
select
num,
md5sum,
substr(md5sum, 7, 1) as password_char,
substr(md5sum, 6, 1) as position_char
from
middle;

-- if you want to check on progress in the middle of the 8 runs:
select * from matches order by position_char;

-- after 8 times, here is the answer:
select
array_to_string(array_agg(password_char), '')
from
(
  select password_char from matches order by position_char
) as source;
