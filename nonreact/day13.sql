drop table if exists points cascade;

create table points (
  id serial primary key,
  x int not null,
  y int not null,
  wall_or_space varchar(1) not null
    check (wall_or_space in ('#', '.')),
  unique(x, y)
);

create or replace function
  f_wall_or_space (x int, y int, favorite int)
  returns text
as
$$
select
case
  length(
    replace((x*x + 3*x + 2*x*y + y + y*y + favorite)::bit(32)::text,
            '0',
            '')
  ) % 2
when 0 then '.'
else '#'
end;
$$ language sql;

insert into points (x, y, wall_or_space)
with
  x_set as (select generate_series(0, 60, 1) as x),
  y_set as (select generate_series(0, 60, 1) as y)
select x, y, f_wall_or_space(x, y, 1352)
from x_set cross join y_set;

-- remove the walls from our set of points, because we can't walk through them
delete from points where wall_or_space = '#';

-- this works, but how do I ensure that the values in the array are ordered by x?
-- select y, array_to_string(array_agg(wall_or_space), '') as x from points group by y order by y;

drop table if exists connected;

create table connected (
  id serial,
  point1_id int not null references points,
  point2_id int not null references points,
  distance int not null,
  unique(point1_id, point2_id),
  constraint connected_ordered_points check (point1_id < point2_id)
);

insert into connected (point1_id, point2_id, distance)
select
least(p1.id, p2.id), greatest(p1.id, p2.id), 1
from
points p1, points p2
where
(p1.x     = p2.x and p1.y + 1 = p2.y) or
(p1.x + 1 = p2.x and p1.y     = p2.y);
