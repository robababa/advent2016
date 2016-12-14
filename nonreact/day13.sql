drop table if exists points;

create table points (
  x int not null,
  y int not null,
  wall_or_space varchar(1) not null
    check (wall_or_space in ('#', '.'))
);

create or replace function
  f_wall_or_space (x int, y int, favorite int)
  returns text
as
$$
select
case
  length(
    replace((x*x + 3*x + 2*x*y + y + y*y + favorite)::bit(10)::text,
            '0',
            '')
  ) % 2
when 0 then '.'
else '#'
end;
$$ language sql;

insert into point

insert into points (x, y, wall_or_space)
with
  x_set as (select generate_series(0, 9, 1) as x),
  y_set as (select generate_series(0, 9, 1) as y)
select x, y, f_wall_or_space(x, y, 10)
from x_set cross join y_set;

-- this works, but how do I ensure that the values in the array are ordered by x?
-- select y, array_to_string(array_agg(wall_or_space), '') as x from points group by y order by y;


