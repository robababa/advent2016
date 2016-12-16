-- do this repeatedly until we get the answer

insert into sprawl
(position_id, distance)
select
source.position_id, source.new_distance
from
(
select
c.position2_id as position_id, s1.distance + 1 as new_distance
from
connected c
inner join sprawl as s1 on
position1_id = s1.position_id
UNION
select
c.position1_id as position_id, s2.distance + 1 as new_distance
from
connected c inner join sprawl as s2 on
position2_id = s2.position_id
) as source
left join
sprawl as already_sprawl
on
source.position_id = already_sprawl.position_id
where
already_sprawl.position_id is null;

-- look for our destination row
select * from sprawl where position_id = 100000000;

