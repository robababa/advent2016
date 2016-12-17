-- create the position with the elevator, microchips and generators

drop table if exists position, dummy, outreach, connected, sprawl cascade;
create table dummy(m_code int, g_code int);
create table outreach (id_old int, e_new int, m_code_new int, g_code_new int);

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
  g5 int not null check (g2 in (1,2,3,4)),
  m_code int not null,
  g_code int not null
);

insert into position (e, m1, g1, m2, g2, m3, g3, m4, g4, m5, g5, m_code, g_code)
select e, m1, g1, m2, g2, m3, g3, m4, g4, m5, g5,
  m1 * 10000 + m2 * 1000 + m3 * 100 + m4 * 10 + m5 as m_code,
  g1 * 10000 + g2 * 1000 + g3 * 100 + g4 * 10 + g5 as g_code
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
-- the microchip floors are in ascending order, to eliminate redundancy
(m1 <= m2 and m2 <= m3 and m3 <= m4 and m4 <= m5)
and
-- the elevator is not on a floor by itself
arraycontains(ARRAY[m1, g1, m2, g2, m3, g3, m4, g4, m5, g5], ARRAY[e])
and
-- no microchip is on a floor with a generator
-- but without its own generator
(m1 = g1 or not (arraycontains(ARRAY[g1,g2,g3,g4,g5], ARRAY[m1]))) and
(m2 = g2 or not (arraycontains(ARRAY[g1,g2,g3,g4,g5], ARRAY[m2]))) and
(m2 = g3 or not (arraycontains(ARRAY[g1,g2,g3,g4,g5], ARRAY[m2]))) and
(m2 = g4 or not (arraycontains(ARRAY[g1,g2,g3,g4,g5], ARRAY[m2]))) and
(m2 = g5 or not (arraycontains(ARRAY[g1,g2,g3,g4,g5], ARRAY[m2])));

-- change the starting position id to zero to make it easy to identify
update position
set id = 0
where e = 1 and
m1 = 1 and g1 = 2 and
m2 = 1 and g2 = 2 and
m3 = 1 and g3 = 2 and
m4 = 2 and g4 = 2 and
m5 = 2 and g5 = 2;

-- update the id for the final position so it is assuredly the highest
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


create or replace function reorder_codes(in code1 int, in code2 int)
returns dummy
as
$$
  with
  source
  as
  (
    select
    unnest(string_to_array(code1::varchar, null)) as m,
    unnest(string_to_array(code2::varchar, null)) as g
  ),
  source2
  as
  (
    select
    m::int as m,
    g::int as g,
    row_number() over (order by m desc, g desc) as place
    from
    source
   )
  select
  sum(m * pow(10, place - 1))::integer as m_code,
  sum(g * pow(10, place - 1))::integer as g_code
  from
  source2;
$$ language sql immutable;

-- deleting redundant codes the lazy way, after the fact
-- delete positions that aren't in the proper order, because there is another
-- position that is the same and is in the proper order
delete from position where (m_code, g_code) <> reorder_codes(m_code, g_code);
delete from position as p1 where
exists(
  select 1
  from position as p2
  where
  p2.e = p1.e and
  p2.m_code = p1.m_code and
  p2.g_code = p1.g_code and
  p2.id < p1.id
);


create or replace function move_one(
  floor_change int, id int, e int, m_code int, g_code int
) returns setof outreach
as
$$
declare
  code_length int := length(m_code::varchar);
  divisor int := 1; -- we will replace this value
  reorder_return dummy%ROWTYPE;
  o outreach%rowtype;
begin
  -- can't move except up or down one floor
  if (floor_change <> -1 and floor_change <> 1) then
    return;
  end if;
  -- cannot go up from the fourth floor
  if (e >= 4 and floor_change = 1) then
    return;
  end if;
  -- cannot go down from the first floor
  if (e <= 1 and floor_change = -1) then
    return;
  end if;

  -- iniitialize the new e and (old) id, which are the same for every row
  -- that we return
  o.e_new := e + floor_change;
  o.id_old := id;

  for i in reverse code_length..1 loop
    divisor := pow(10, i - 1)::int;
    -- if this microchip is on the same floor as the elevator
    -- then move it!  The caller will determine whether the move was legal
    if (m_code / divisor % 10 = e) then
      reorder_return = reorder_codes(m_code + floor_change * divisor, g_code);
      o.m_code_new := reorder_return.m_code;
      o.g_code_new := reorder_return.g_code;
    return next o;
    end if;

    -- do the same thing for the generators
    if (g_code / divisor % 10 = e) then
      reorder_return = reorder_codes(m_code, g_code + floor_change * divisor);
      o.m_code_new := reorder_return.m_code;
      o.g_code_new := reorder_return.g_code;
    return next o;
    end if;
  end loop;
  -- we're done
  return;
end;
$$
language plpgsql immutable;

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

