-- do this repeatedly until either
-- (1) we connect the two points we want
-- (2) we aren't adding any more points to the connected table
insert into connected (point1_id, point2_id, distance)
with
first_candidates
as
(
  select
  least(c1.point1_id, c2.point1_id) as point1_id,
  greatest(c1.point1_id, c2.point1_id) as point2_id,
  c1.distance + c2.distance as new_distance
  from
  connected as c1 inner join
  connected as c2
  on
  c1.point2_id = c2.point2_id -- the two connections have a common endpoint
  where
  c1.id <> c2.id -- the connections are distinct
),
second_candidates
as
(
  select
  least(c1.point2_id, c2.point2_id) as point1_id,
  greatest(c1.point2_id, c2.point2_id) as point2_id,
  c1.distance + c2.distance
  from
  connected as c1 inner join
  connected as c2
  on
  c1.point1_id = c2.point1_id -- the two connections have a common endpoint
  where
  c1.id <> c2.id -- the connections are distinct
),
third_candidates
as
(
  select
  least(c1.point2_id, c2.point1_id) as point1_id,
  greatest(c1.point2_id, c2.point1_id) as point2_id,
  c1.distance + c2.distance
  from
  connected as c1 inner join
  connected as c2
  on
  c1.point1_id = c2.point2_id -- the two connections have a common endpoint
  where
  c1.id <> c2.id -- the connections are distinct
),
fourth_candidates
as
(
  select
  least(c1.point1_id, c2.point2_id) as point1_id,
  greatest(c1.point1_id, c2.point2_id) as point2_id,
  c1.distance + c2.distance
  from
  connected as c1 inner join
  connected as c2
  on
  c1.point2_id = c2.point1_id -- the two connections have a common endpoint
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
distinct on (cc.point1_id, cc.point2_id)
cc.point1_id, cc.point2_id, cc.new_distance
from
combined_candidates as cc left join connected as c
on
cc.point1_id = c.point1_id and
cc.point2_id = c.point2_id
where
c.point1_id is null
order by
cc.point1_id, cc.point2_id, cc.new_distance;

-- do we have a result?
select c.*
from
points as p1
inner join
connected as c on p1.id = c.point1_id
inner join
points as p2 on c.point2_id = p2.id
where p1.x = 1 and p1.y = 1 and
p2.x = 31 and p2.y = 39;

-- part 2
select
/* point (1,1 itself) adds one */
count(*) + 1
from points as p,
connected as c
where
p.x = 1 and p.y = 1
and
(p.id = c.point1_id or p.id = c.point2_id)
and
c.distance <= 50;
