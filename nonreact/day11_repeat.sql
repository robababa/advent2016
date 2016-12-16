-- do this repeatedly until either
-- (1) we connect the two positions we want
-- (2) we aren't adding any more positions to the connected table

insert into connected (position1_id, position2_id, distance)
with
first_candidates
as
(
  select
  least(c1.position1_id, c2.position1_id) as position1_id,
  greatest(c1.position1_id, c2.position1_id) as position2_id,
  c1.distance + c2.distance as new_distance
  from
  connected as c1 inner join
  connected as c2
  on
  c1.position2_id = c2.position2_id -- the two connections have a common endposition
  where
  c1.id <> c2.id -- the connections are distinct
),
second_candidates
as
(
  select
  least(c1.position2_id, c2.position2_id) as position1_id,
  greatest(c1.position2_id, c2.position2_id) as position2_id,
  c1.distance + c2.distance
  from
  connected as c1 inner join
  connected as c2
  on
  c1.position1_id = c2.position1_id -- the two connections have a common endposition
  where
  c1.id <> c2.id -- the connections are distinct
),
third_candidates
as
(
  select
  least(c1.position2_id, c2.position1_id) as position1_id,
  greatest(c1.position2_id, c2.position1_id) as position2_id,
  c1.distance + c2.distance
  from
  connected as c1 inner join
  connected as c2
  on
  c1.position1_id = c2.position2_id -- the two connections have a common endposition
  where
  c1.id <> c2.id -- the connections are distinct
),
fourth_candidates
as
(
  select
  least(c1.position1_id, c2.position2_id) as position1_id,
  greatest(c1.position1_id, c2.position2_id) as position2_id,
  c1.distance + c2.distance
  from
  connected as c1 inner join
  connected as c2
  on
  c1.position2_id = c2.position1_id -- the two connections have a common endposition
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
distinct on (cc.position1_id, cc.position2_id)
cc.position1_id, cc.position2_id, cc.new_distance
from
combined_candidates as cc left join connected as c
on
cc.position1_id = c.position1_id and
cc.position2_id = c.position2_id
where
c.position1_id is null
order by
cc.position1_id, cc.position2_id, cc.new_distance;

-- do we have a result?
select * from connected where position1_id = 0 and position2_id = 100000000;

-- try again, by combining two segments that exist
select min(a.distance + b.distance)
from
connected as a
inner join connected as b
on a.position2_id = b.position1_id
where
a.position1_id = 0 and b.position2_id = 100000000;


-- part 2
-- select
-- /* position (1,1 itself) adds one */
-- count(*) + 1
-- from positions as p,
-- connected as c
-- where
-- p.x = 1 and p.y = 1
-- and
-- (p.id = c.position1_id or p.id = c.position2_id)
-- and
-- c.distance <= 50;
