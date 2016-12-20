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

with recursive blocked_segments(
  merge_round, blocked, starting_segment, segment_count
) as
(
  -- initial set
  (with
  source as (
    select
    1 as merge_round,
    blocked,
    row_number() over (order by blocked) as starting_segment
    from
    blocked_range
    order by 2
  )
  select
  merge_round,
  blocked,
  starting_segment,
  1::bigint as segment_count
  from
  source)
UNION ALL
  -- recursive part
 (
  with
  identify_merges as (
    select
    merge_round + 1 as merge_round,
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
    from blocked_segments
    order by blocked
  ),
  identify_final_segments as (
    select
    merge_round,
    blocked,
    starting_segment,
    merge_segment,
    max(merge_segment) over (rows unbounded preceding) as final_segment
    from
    identify_merges
    order by starting_segment
  ),
  merge_final_segments as (
    select
    merge_round,
    sum(blocked) as blocked,
    final_segment as starting_segment,
    count(*) as segment_count
    from
    identify_final_segments
    group by
    merge_round,
    final_segment
  )
  select merge_round, blocked, starting_segment, segment_count from merge_final_segments where 1 = 0
 )
)
select * from blocked_segments;
--- select * from blocked_segments;

