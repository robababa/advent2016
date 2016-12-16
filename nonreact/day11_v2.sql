-- create the position with the elevator, microchips and generators

drop table if exists position, connected, sprawl cascade;

create table position
(
  id serial not null primary key,
  e int not null check (e in (1,2,3,4)),
  m1 int not null check (m1 in (1,2,3,4)),
  g1 int not null check (g1 in (1,2,3,4)),
  m2 int not null check (m2 in (1,2,3,4)),
  g2 int not null check (g2 in (1,2,3,4)),
  m3 int not null check (m2 in (1,2,3,4)),
  g3 int not null check (g2 in (1,2,3,4)),
  m4 int not null check (m2 in (1,2,3,4)),
  g4 int not null check (g2 in (1,2,3,4)),
  m5 int not null check (m2 in (1,2,3,4)),
  g5 int not null check (g2 in (1,2,3,4))
);

insert into position (e, m1, g1, m2, g2, m3, g3, m4, g4, m5, g5)
select e, m1, g1, m2, g2, m3, g3, m4, g4, m5, g5
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
cross join
(select generate_series(1,4,1) as m3) as m3
cross join
(select generate_series(1,4,1) as g3) as g3
cross join
(select generate_series(1,4,1) as m4) as m4
cross join
(select generate_series(1,4,1) as g4) as g4
cross join
(select generate_series(1,4,1) as m5) as m5
cross join
(select generate_series(1,4,1) as g5) as g5
where
-- the elevator is not by itself
arraycontains(ARRAY[m1, g1, m2, g2, m3, g3, m4, g4, m5, g5], ARRAY[e])
and
-- no microchip is on a floor with a generator
-- but without its own generator
(m1 = g1 or not (arraycontains(ARRAY[g1,g2,g3,g4,g5], ARRAY[m1]))) and
(m2 = g2 or not (arraycontains(ARRAY[g1,g2,g3,g4,g5], ARRAY[m2]))) and
(m2 = g3 or not (arraycontains(ARRAY[g1,g2,g3,g4,g5], ARRAY[m2]))) and
(m2 = g4 or not (arraycontains(ARRAY[g1,g2,g3,g4,g5], ARRAY[m2]))) and
(m2 = g5 or not (arraycontains(ARRAY[g1,g2,g3,g4,g5], ARRAY[m2])));

-- result is 484 rows, out of a possible 1024, so a little
-- over half were removed as impossible

-- the id for the sample starting position is 42 (really), but we
-- change it to zero as a trick to help us peek ahead for answers
update position
set id = 0
where e = 1 and
m1 = 2 and g1 = 1 and
m2 = 2 and g2 = 1 and
m3 = 2 and g3 = 1 and
m4 = 2 and g4 = 1 and
m5 = 2 and g5 = 1;

-- update the id for the final position so it is assuredly the
-- highest
update position
set id = 100000000
where e = 4
and
m1 = 4 and g1 = 4 and
m2 = 4 and g2 = 4 and
m3 = 4 and g3 = 4 and
m4 = 4 and g4 = 4 and
m5 = 4 and g5 = 4;

-- create the connections table, which connect one position to another
create table connected (
  id serial,
  position1_id int not null references position,
  position2_id int not null references position,
  distance int not null,
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
language plpgsql immutable;

-- for each existing position, find its neighbors
-- each match will be doubled up, because a position finds its neighbor
-- and its neighbor finds the position.
-- use the constraint on id's to ensure no duplication in the connections
-- table


insert into connected (position1_id, position2_id, distance)
select
distinct
least(p1.id, p2.id), greatest(p1.id, p2.id), 1
from
position p1, position p2
where
(
  -- the elevator moved up one, taking one element with it
  p1.e + 1 = p2.e and compare_positions(p1.e,
    array[
      [p1.m1, p2.m1],
      [p1.g1, p2.g1],
      [p1.m2, p2.m2],
      [p1.g2, p2.g2],
      [p1.m3, p2.m3],
      [p1.g3, p2.g3],
      [p1.m4, p2.m4],
      [p1.g4, p2.g4],
      [p1.m5, p2.m5],
      [p1.g5, p2.g5]
      ]) =
    'ONE_UP'
)
or
(
  -- the elevator moved up one, taking two elements with it
  p1.e + 1 = p2.e and compare_positions(p1.e,
    array[
      [p1.m1, p2.m1],
      [p1.g1, p2.g1],
      [p1.m2, p2.m2],
      [p1.g2, p2.g2],
      [p1.m3, p2.m3],
      [p1.g3, p2.g3],
      [p1.m4, p2.m4],
      [p1.g4, p2.g4],
      [p1.m5, p2.m5],
      [p1.g5, p2.g5]
      ]) =
    'TWO_UP'
)
or
(
  -- the elevator moved down one, taking one element with it
  p1.e - 1 = p2.e and compare_positions(p1.e,
    array[
      [p1.m1, p2.m1],
      [p1.g1, p2.g1],
      [p1.m2, p2.m2],
      [p1.g2, p2.g2],
      [p1.m3, p2.m3],
      [p1.g3, p2.g3],
      [p1.m4, p2.m4],
      [p1.g4, p2.g4],
      [p1.m5, p2.m5],
      [p1.g5, p2.g5]
      ]) =
    'ONE_DOWN'
)
or
(
  -- the elevator moved down one, taking one element with it
  p1.e - 1 = p2.e and compare_positions(p1.e,
    array[
      [p1.m1, p2.m1],
      [p1.g1, p2.g1],
      [p1.m2, p2.m2],
      [p1.g2, p2.g2],
      [p1.m3, p2.m3],
      [p1.g3, p2.g3],
      [p1.m4, p2.m4],
      [p1.g4, p2.g4],
      [p1.m5, p2.m5],
      [p1.g5, p2.g5]
      ]) =
    'TWO_DOWN'
);

--delete from position
--where
--id not in (select position1_id from connected)
--and
--id not in (select position2_id from connected);

-- this table will start with positions immediately next to
-- position 0, and spread out from there until one of the paths
-- reaches the final position.  For sample data, this will be
-- the 11th round.  Each iteration will be much smaller than they
-- were before, but they also will take longer to find the final
-- destination
create table sprawl
(
  position_id int not null primary key,
  distance int not null
);

-- initialize the sprawl table with our initial position
insert into sprawl (position_id, distance) values (0, 0);

