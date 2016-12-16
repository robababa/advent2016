<<<<<<< HEAD
-- create the position with the elevator, microchips and generators

drop table if exists position, connected cascade;

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

-- the id for the sample starting position is 42 (really)
select * from position where
e = 1 and m1 = 1 and g1 = 2 and m2 = 1 and g2 = 3;
-- the id for the final position is 484
select * from position where
e = 4 and m1 = 4 and g1 = 4 and m2 = 4 and g2 = 4;

-- create the connections table, which connect one position to another
create table connected (
  id serial,
  position1_id int not null references position,
  position2_id int not null references position,
  distance int not null,
  unique(position1_id, position2_id),
  constraint connected_ordered_positions check (position1_id < position2_id)
);

-- for each existing position, find its neighbors
-- each match will be doubled up, because a position finds its neighbor
-- and its neighbor finds the position.
-- use the constraint on id's to ensure no duplication in the connections
-- table

---insert into connected (position1_id, position2_id, distance)
---select
---least(p1.id, p2.id), greatest(p1.id, p2.id), 1
---from
---position p1, position p2
---where
---(p1.x     = p2.x and p1.y + 1 = p2.y) or
---(p1.x + 1 = p2.x and p1.y     = p2.y);
=======
drop table if exists building, move_count;

create table building (floor int not null, slot int not null, thing varchar(2) not null);

create table move_count (move_count int not null default 0);

create or replace function init_building() returns void
language plpgsql
as
$$
begin
  -- reset the move counter
  delete from move_count;
  insert into move_count values (0);
  -- clear out the building
  delete from building;
  -- initial positions for microchips and generators
  insert into building (floor, slot, thing)
  values
    (1,0,'E'), -- elevator
    (1,1,'1M'), -- first microchip
    (1,2,'1G'), -- first generator
    (1,3,'2M'), -- second microchip
    (1,4,'2G'), -- second generator
    (1,5,'3M'), -- third microchip
    (1,6,'3G'), -- third generator
    (2,7,'4M'), -- fourth microchip on second floor
    (1,8,'4G'), -- fourth generator
    (2,9,'5M'), -- fifth microchip on fifth floor
    (1,10,'5G') -- fifth generator
  ;
  -- fill in the empty slots with periods
  insert into building (floor, slot, thing)
  select empties.floor, empties.slot, '.'::varchar(2) as thing
  from
  (
    (select generate_series(1,4,1) as floor) as empty_floor
    cross join
    (select generate_series(0,10,1) as slot) as empty_slot
  ) as empties
  left join
  building
  on
  empties.floor = building.floor and
  empties.slot = building.slot
  where
  building.thing is null;
end;
$$;

-- move one item in the elevator
create or replace function move(old_floor int, new_floor int, item1 varchar) returns void
language plpgsql as
$$
begin
  -- move the elevator - remove from old floor, add to new floor
  update building set thing = '.' where thing = 'E' and floor = old_floor;
  update building set thing = 'E' where slot = 0 and floor = new_floor;
  -- move the item - add to new floor, remove from old floor
  update building set thing = item1 where floor = new_floor and slot = (select slot from building where thing = item1);
  update building set thing = '.' where floor = old_floor and thing = item1;
  -- update the move counter
  update move_count set move_count = move_count + 1;
end;
$$;

-- move two items in the elevator
create or replace function move(old_floor int, new_floor int, item1 varchar, item2 varchar) returns void
language plpgsql as
$$
begin
  -- move the elevator - remove from old floor, add to new floor
  update building set thing = '.' where thing = 'E' and floor = old_floor;
  update building set thing = 'E' where slot = 0 and floor = new_floor;
  -- move the items - add to new floor, remove from old floor
  update building set thing = item1 where floor = new_floor and slot = (select slot from building where thing = item1);
  update building set thing = '.' where floor = old_floor and thing = item1;
  update building set thing = item2 where floor = new_floor and slot = (select slot from building where thing = item2);
  update building set thing = '.' where floor = old_floor and thing = item2;
  -- update the move counter
  update move_count set move_count = move_count + 1;
end;
$$;

-- -- initialize the building
-- select init_building();
-- 
-- -- view the arrangement
-- select floor, slot, thing from building order by floor desc, slot \crosstabview
>>>>>>> fbf9644409df6cce64f4104aea1ced8f0cd6702c
