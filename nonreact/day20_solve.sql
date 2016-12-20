-- -- part 1l
-- with
-- candidates as (
--   -- it would be 0 if no range contained zero
--   select 0
--   union all
--   select upper(blocked) as candidate from blocked_range
--   order by 1
-- )
-- select
-- min(candidate)
-- from
-- candidates
-- where
-- not exists(
--   select 1 from blocked_range where blocked @> candidate
-- );

-- part 2

drop aggregate if exists sum(int8range);

create aggregate sum(int8range) (sfunc = range_union, stype = int8range, initcond = 'empty');

with
source as (
  select
  blocked,
  row_number() over (order by blocked) as starting_segment
  from
  blocked_range
  order by 2
),
segment_count as (
  select count(*) as segment_count from source
),
identify_merges as (
  select
  blocked,
  starting_segment,
  case
    -- when this blocked range overlaps (&&) or is adjacent to (-|-) the
    -- preceding range, then we can merge it.
    when (blocked && lag(blocked) over () or blocked -|- lag(blocked) over ())
    then null::int8
  else starting_segment
  end
    as merge_segment
  from source
  order by blocked
),
identify_final_segments as (
  select
  blocked,
  starting_segment,
  merge_segment,
  max(merge_segment) over (rows unbounded preceding) as final_segment
  from
  identify_merges
  order by starting_segment
)
select
sum(blocked) as blocked,
final_segment as starting_segment
from identify_final_segments
group by
final_segment;
