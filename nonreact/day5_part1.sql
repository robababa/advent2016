with
source as
(
  select generate_series(0, 200000000, 1) as num
),
middle as
(
  select
  num,
  md5('wtnhxymk' || num::varchar) as md5sum
  from
  source
  where
  md5('wtnhxymk' || num::varchar) like '00000%'
  limit 8
),
answer_table as
(
  select
  num,
  md5sum,
  substr(md5sum, 6, 1) as password_char
  from
  middle
  order by num
)
select
array_to_string(array_agg(password_char), '') as answer
from
answer_table;
