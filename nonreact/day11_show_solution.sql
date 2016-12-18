with recursive
sprawl_positions(position_id, distance, prior_position_id) as (
select position_id, distance, prior_position_id
from sprawl
where position_id = 100000000
UNION ALL
select
s.position_id, s.distance, s.prior_position_id
from
sprawl_positions as sp
inner join
sprawl as s
on
s.position_id = sp.prior_position_id
)
--select position_id, distance from sprawl_positions order by distance;
select
sprawl_positions.distance,
position.id,
position.e,
position.m_code,
position.g_code
from sprawl_positions inner join position
on sprawl_positions.position_id = position.id
order by sprawl_positions.distance;
