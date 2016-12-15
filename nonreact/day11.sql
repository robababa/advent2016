drop table if exists building;

create table building (floor int not null, slot int not null, thing varchar(2) not null);

create or replace function init_building() returns void
language plpgsql
as
$$
begin
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

-- initialize the building
select init_building();

-- view the arrangement
select floor, slot, thing from building order by floor desc, slot \crosstabview
