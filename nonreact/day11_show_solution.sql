with recursive
sprawl_positions(position_id, distance) as (
select position_id, distance from sprawl where position_id = 100000000
UNION ALL
select
s.position_id, s.distance
from
sprawl_positions as sp
inner join
outreach as o
on sp.position_id = o.id_new
inner join
sprawl as s
on o.id_old = s.position_id
where
s.distance = sp.distance - 1
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
