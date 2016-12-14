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
