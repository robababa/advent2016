-- part 1
with
candidates as (
  -- it would be 0 if no range contained zero
  select 0
  union all
  select upper(blocked) as candidate from blocked_range
  order by 1
)
select
min(candidate)
from
candidates
where
not exists(
  select 1 from blocked_range where blocked @> candidate
);

-- part 2
with source as (
  select '[1,4]'::int8range as blocked UNION ALL
  select '[2,5]'::int8range UNION ALL
  select '[7,10]'::int8range UNION ALL
  select '[11, 13]'::int8range
  order by 1
)
select
blocked,
case
  when (blocked && lag(blocked) over () or blocked -|- lag(blocked) over ())
  then true
  else false
end
  as merge_it
from source
order by blocked;
