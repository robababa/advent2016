-- create the position with the elevator, microchips and generators

drop table if exists position, round, connected cascade;

create table position
(
  id serial not null primary key,
  e int not null check (e in (1,2,3,4)),
  m1 int not null check (m1 in (1,2,3,4)),
  g1 int not null check (g1 in (1,2,3,4)),
  m2 int not null check (m2 in (1,2,3,4)),
  g2 int not null check (g2 in (1,2,3,4))
);

insert into position (e, m1, g1, m2, g2)
select e, m1, g1, m2, g2
from
(select generate_series(1,4,1) as e) as e
cross join
(select generate_series(1,4,1) as m1) as m1
cross join
(select generate_series(1,4,1) as g1) as g1
cross join
(select generate_series(1,4,1) as m2) as m2
cross join
(select generate_series(1,4,1) as g2) as g2
where
-- the elevator is not by itself
arraycontains(ARRAY[m1, g1, m2, g2], ARRAY[e])
and
-- no microchip is on a floor with a generator
-- but without its own generator
(m1 = g1 or not (arraycontains(ARRAY[g1,g2], ARRAY[m1]))) and
(m2 = g2 or not (arraycontains(ARRAY[g1,g2], ARRAY[m2])));

-- result is 484 rows, out of a possible 1024, so a little
-- over half were removed as impossible

-- the id for the sample starting position is 42 (really), but we
-- change it to zero as a trick to help us peek ahead for answers
update position
set id = 0
where e = 1 and m1 = 1 and g1 = 2 and m2 = 1 and g2 = 3;
-- update the id for the final position so it is assuredly the
-- highest
update position
set id = 100000000
where e = 4 and m1 = 4 and g1 = 4 and m2 = 4 and g2 = 4;

create table round (round int not null);
insert into round values (0);

-- create the connections table, which connect one position to another
create table connected (
  id serial,
  position1_id int not null references position,
  position2_id int not null references position,
  distance int not null,
  round int not null,
  unique(position1_id, position2_id),
  constraint connected_ordered_positions check (position1_id < position2_id)
);

create or replace function compare_positions(
  elevator_start_floor int, before_after int[][])
returns varchar
as
$$
declare
  up_count int := 0;
  down_count int := 0;
  item int[];
begin
  foreach item slice 1 in array before_after loop
    if item[1] = item[2] then
      continue;
    end if;

    if (item[1] <> elevator_start_floor) then
      -- items can't move without the elevator
      return 'NO_GOOD';
    elsif (abs(item[1] - item[2]) > 1) then
      -- items can't move more than one floor
      return 'NO_GOOD';
    elsif (item[1] + 1 = item[2]) then
      -- this item moved up
      up_count = up_count + 1;
    elsif (item[1] - 1 = item[2]) then
      -- this item moved down
      down_count = down_count + 1;
    end if;
  end loop;

  -- if we had valid movement, return it
  if (up_count = 1 and down_count = 0) then
    return 'ONE_UP';
  elsif (up_count = 2 and down_count = 0) then
    return 'TWO_UP';
  elsif (up_count = 0 and down_count = 1) then
    return 'ONE_DOWN';
  elsif (up_count = 0 and down_count = 2) then
    return 'TWO_DOWN';
  end if;

  -- the movement must have been invalid, return NO_GOOD
  return 'NO_GOOD';
end;
$$
language plpgsql;

-- for each existing position, find its neighbors
-- each match will be doubled up, because a position finds its neighbor
-- and its neighbor finds the position.
-- use the constraint on id's to ensure no duplication in the connections
-- table

update round set round = round + 1;

insert into connected (position1_id, position2_id, distance, round)
select
distinct
least(p1.id, p2.id), greatest(p1.id, p2.id), 1, (select round from round)
from
position p1, position p2
where
(
  -- the elevator moved up one, taking one element with it
  p1.e + 1 = p2.e and compare_positions(p1.e,
    array[[p1.m1, p2.m1],[p1.g1, p2.g1],[p1.m2, p2.m2],[p1.g2, p2.g2]]) =
    'ONE_UP'
)
or
(
  -- the elevator moved up one, taking two elements with it
  p1.e + 1 = p2.e and compare_positions(p1.e,
    array[[p1.m1, p2.m1],[p1.g1, p2.g1],[p1.m2, p2.m2],[p1.g2, p2.g2]]) =
    'TWO_UP'
)
or
(
  -- the elevator moved down one, taking one element with it
  p1.e - 1 = p2.e and compare_positions(p1.e,
    array[[p1.m1, p2.m1],[p1.g1, p2.g1],[p1.m2, p2.m2],[p1.g2, p2.g2]]) =
    'ONE_DOWN'
)
or
(
  -- the elevator moved down one, taking one element with it
  p1.e - 1 = p2.e and compare_positions(p1.e,
    array[[p1.m1, p2.m1],[p1.g1, p2.g1],[p1.m2, p2.m2],[p1.g2, p2.g2]]) =
    'TWO_DOWN'
);

delete from position
where
id not in (select position1_id from connected)
and
id not in (select position2_id from connected);
