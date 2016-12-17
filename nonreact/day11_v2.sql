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
m1 = 2 and g1 = 1 and
m2 = 2 and g2 = 1 and
m3 = 2 and g3 = 1 and
m4 = 2 and g4 = 1 and
m5 = 2 and g5 = 1;

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

create or replace function reorder_codes(
  in code1 int, in code2 int, out new_code1 int, out new_code2 int
)
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
    row_number() over (order by m desc) as place
    from
    source
   )
  select
  sum(m * pow(10, place - 1))::integer as m_code,
  sum(g * pow(10, place - 1))::integer as g_code
  from
  source2;
$$ language sql immutable;

create or replace function up_one(id int, e int, m_code int, g_code int)
returns table(id_old int, e_new int, m_code_new int, g_code_new int)
as
$$
declare
begin
  e_new = e;
  id_old = id;
  m_code_new = m_code;
  g_code_new = g_code;
  return next;
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

