-- do this repeatedly until either
-- (1) we connect the two buildings we want
-- (2) we aren't adding any more buildings to the connected table
insert into connected (building1_id, building2_id, distance)
with
first_candidates
as
(
  select
  least(c1.building1_id, c2.building1_id) as building1_id,
  greatest(c1.building1_id, c2.building1_id) as building2_id,
  c1.distance + c2.distance as new_distance
  from
  connected as c1 inner join
  connected as c2
  on
  c1.building2_id = c2.building2_id -- the two connections have a common endbuilding
  where
  c1.id <> c2.id -- the connections are distinct
),
second_candidates
as
(
  select
  least(c1.building2_id, c2.building2_id) as building1_id,
  greatest(c1.building2_id, c2.building2_id) as building2_id,
  c1.distance + c2.distance
  from
  connected as c1 inner join
  connected as c2
  on
  c1.building1_id = c2.building1_id -- the two connections have a common endbuilding
  where
  c1.id <> c2.id -- the connections are distinct
),
third_candidates
as
(
  select
  least(c1.building2_id, c2.building1_id) as building1_id,
  greatest(c1.building2_id, c2.building1_id) as building2_id,
  c1.distance + c2.distance
  from
  connected as c1 inner join
  connected as c2
  on
  c1.building1_id = c2.building2_id -- the two connections have a common endbuilding
  where
  c1.id <> c2.id -- the connections are distinct
),
fourth_candidates
as
(
  select
  least(c1.building1_id, c2.building2_id) as building1_id,
  greatest(c1.building1_id, c2.building2_id) as building2_id,
  c1.distance + c2.distance
  from
  connected as c1 inner join
  connected as c2
  on
  c1.building2_id = c2.building1_id -- the two connections have a common endbuilding
  where
  c1.id <> c2.id -- the connections are distinct
),
combined_candidates
as
(
  select * from first_candidates  UNION ALL
  select * from second_candidates UNION ALL
  select * from third_candidates  UNION ALL
  select * from fourth_candidates
)
select
distinct on (cc.building1_id, cc.building2_id)
cc.building1_id, cc.building2_id, cc.new_distance
from
combined_candidates as cc left join connected as c
on
cc.building1_id = c.building1_id and
cc.building2_id = c.building2_id
where
c.building1_id is null
order by
cc.building1_id, cc.building2_id, cc.new_distance;

-- do we have a result?
select c.*
from
buildings as p1
inner join
connected as c on p1.id = c.building1_id
inner join
buildings as p2 on c.building2_id = p2.id
where
(p1.e = 1 and p1.m1 = 1 and p1.g1 = 2 and p1.m2 = 1 and p1.g2 = 3)
and
(p2.e = 4 and p2.m1 = 4 and p2.g1 = 4 and p2.m2 = 4 and p2.g2 = 4);

-- part 2
-- select
-- /* building (1,1 itself) adds one */
-- count(*) + 1
-- from buildings as p,
-- connected as c
-- where
-- p.x = 1 and p.y = 1
-- and
-- (p.id = c.building1_id or p.id = c.building2_id)
-- and
-- c.distance <= 50;
