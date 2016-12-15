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
