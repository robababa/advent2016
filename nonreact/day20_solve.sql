-- part 1
with
candidates as (
  -- it would be 0 if no range contained zero
  select 0 as candidate
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

drop aggregate if exists range_sum(int8range);

create aggregate range_sum(int8range) (sfunc = range_union, stype = int8range, initcond = 'empty');

with recursive blocked_segments(
  merge_round, blocked, starting_segment
) as
(
  -- initial set
  select
  1 as merge_round,
  blocked,
  row_number() over (order by blocked) as starting_segment
  from
  blocked_range
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
    when (
      (blocked && lag(blocked) over ())
      or
      blocked -|- lag(blocked) over ()
    )
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
    order by blocked, starting_segment
  ),
  merge_final_segments as (
    select
    merge_round,
    range_sum(blocked order by blocked asc) as blocked,
    final_segment as starting_segment
    from
    identify_final_segments
    group by
    merge_round,
    final_segment
    order by merge_round, final_segment
  )
  select merge_round, blocked, starting_segment from merge_final_segments where merge_round <= 10
 )
)
--select * from blocked_segments order by merge_round, blocked;
--select merge_round, count(*) from blocked_segments
select
merge_round,
4294967295 + 1 - (sum(upper(blocked)) - sum(lower(blocked)))
  as allowed_address_count
from
blocked_segments
group by merge_round
order by merge_round;

