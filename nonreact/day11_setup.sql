-- create the position with the elevator, microchips and generators

drop table if exists position, dummy, outreach, sprawl, round cascade;
create table dummy(m_code bigint, g_code bigint);

create table position
(
  id serial not null primary key,
  e bigint not null check (e in (1,2,3,4)),
  m1 bigint not null check (m1 in (1,2,3,4)),
  g1 bigint not null check (g1 in (1,2,3,4)),
  m2 bigint not null check (m2 in (1,2,3,4)),
  g2 bigint not null check (g2 in (1,2,3,4)),
  m3 bigint not null check (m2 in (1,2,3,4)),
  g3 bigint not null check (g2 in (1,2,3,4)),
  m4 bigint not null check (m2 in (1,2,3,4)),
  g4 bigint not null check (g2 in (1,2,3,4)),
  m5 bigint not null check (m2 in (1,2,3,4)),
  g5 bigint not null check (g2 in (1,2,3,4)),
  m6 bigint not null check (m2 in (1,2,3,4)),
  g6 bigint not null check (g2 in (1,2,3,4)),
  m7 bigint not null check (m2 in (1,2,3,4)),
  g7 bigint not null check (g2 in (1,2,3,4)),
  m_code bigint not null,
  g_code bigint not null
);

create or replace function reorder_codes(in code1 bigint, in code2 bigint)
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
    m::bigint as m,
    g::bigint as g,
    row_number() over (order by m desc, g desc) as place
    from
    source
   )
  select
  sum(m * pow(10, place - 1))::bigint as m_code,
  sum(g * pow(10, place - 1))::bigint as g_code
  from
  source2;
$$ language sql immutable;

insert into position
(e, m1, g1, m2, g2, m3, g3, m4, g4, m5, g5, m6, g6, m7, g7, m_code, g_code)
select
e, m1, g1, m2, g2, m3, g3, m4, g4, m5, g5, m6, g6, m7, g7, m_code, g_code
from
(
  select e, m1, g1, m2, g2, m3, g3, m4, g4, m5, g5, m6, g6, m7, g7,
    m1 * 1000000 + m2 * 100000 + m3 * 10000 + m4 * 1000
    + m5 * 100 + m6 * 10 + m7 as m_code,
    g1 * 1000000 + g2 * 100000 + g3 * 10000 + g4 * 1000
    + g5 * 100 + g6 * 10 + g7 as g_code
  from
  (select generate_series(1,4,1)::bigint as e) as  e cross join
  (select generate_series(1,4,1)::bigint as m1) as m1 cross join
  (select generate_series(1,4,1)::bigint as g1) as g1 cross join
  (select generate_series(1,4,1)::bigint as m2) as m2 cross join
  (select generate_series(1,4,1)::bigint as g2) as g2 cross join
  (select generate_series(1,4,1)::bigint as m3) as m3 cross join
  (select generate_series(1,4,1)::bigint as g3) as g3 cross join
  (select generate_series(1,4,1)::bigint as m4) as m4 cross join
  (select generate_series(1,4,1)::bigint as g4) as g4 cross join
  (select generate_series(1,4,1)::bigint as m5) as m5 cross join
  (select generate_series(1,4,1)::bigint as g5) as g5 cross join
  (select generate_series(1,4,1)::bigint as m6) as m6 cross join
  (select generate_series(1,4,1)::bigint as g6) as g6 cross join
  (select generate_series(1,4,1)::bigint as m7) as m7 cross join
  (select generate_series(1,4,1)::bigint as g7) as g7
  where
  -- the microchip floors are in ascending order, to eliminate redundancy
  (m1 <= m2 and m2 <= m3 and m3 <= m4 and m4 <= m5 and m5 <= m6 and m6 <= m7)
  and
  -- the elevator is not on a floor by itself
  arraycontains(ARRAY[m1, g1, m2, g2, m3, g3, m4, g4, m5, g5, m6, g6, m7, g7],
    ARRAY[e])
  and
  -- no microchip is on a floor with a generator
  -- but without its own generator
  (m1 = g1 or not (arraycontains(ARRAY[g1,g2,g3,g4,g5,g6,g7], ARRAY[m1]))) and
  (m2 = g2 or not (arraycontains(ARRAY[g1,g2,g3,g4,g5,g6,g7], ARRAY[m2]))) and
  (m3 = g3 or not (arraycontains(ARRAY[g1,g2,g3,g4,g5,g6,g7], ARRAY[m3]))) and
  (m4 = g4 or not (arraycontains(ARRAY[g1,g2,g3,g4,g5,g6,g7], ARRAY[m4]))) and
  (m5 = g5 or not (arraycontains(ARRAY[g1,g2,g3,g4,g5,g6,g7], ARRAY[m5]))) and
  (m6 = g6 or not (arraycontains(ARRAY[g1,g2,g3,g4,g5,g6,g7], ARRAY[m6]))) and
  (m7 = g7 or not (arraycontains(ARRAY[g1,g2,g3,g4,g5,g6,g7], ARRAY[m7])))
) as source
where
-- this is the arrangement that has codes in preferred order
reorder_codes(m_code, g_code) = (m_code, g_code);

-- change the starting position id to zero to make it easy to identify
update position
set id = 0
where e = 1 and
m1 = 1 and g1 = 1 and
m2 = 1 and g2 = 1 and
m3 = 1 and g3 = 1 and
m4 = 1 and g4 = 1 and
m5 = 1 and g5 = 1 and
m6 = 2 and g6 = 1 and
m7 = 2 and g7 = 1;

-- update the id for the final position so it is assuredly the highest
update position
set id = 100000000
where e = 4
and
m1 = 4 and g1 = 4 and
m2 = 4 and g2 = 4 and
m3 = 4 and g3 = 4 and
m4 = 4 and g4 = 4 and
m5 = 4 and g5 = 4 and
m6 = 4 and g6 = 4 and
m7 = 4 and g7 = 4;

create or replace function move_one(
  floor_change bigint, id bigint, e bigint, m_code bigint, g_code bigint
) returns table(id_old bigint, e_new bigint, m_code_new bigint, g_code_new bigint)
as
$$
declare
  code_length bigint := length(m_code::varchar);
  divisor bigint := 1; -- we will replace this value
  reorder_return dummy%ROWTYPE;
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

  -- initialize the new e and (old) id, which are the same for every row
  -- that we return
  e_new := e + floor_change;
  id_old := id;

  for i in reverse code_length..1 loop
    divisor := pow(10, i - 1)::bigint;
    -- if this microchip is on the same floor as the elevator
    -- then move it!  The caller will determine whether the move was legal
    if (m_code / divisor % 10 = e) then
      reorder_return = reorder_codes(m_code + floor_change * divisor, g_code);
      m_code_new := reorder_return.m_code;
      g_code_new := reorder_return.g_code;
    return next;
    end if;

    -- do the same thing for the generators
    if (g_code / divisor % 10 = e) then
      reorder_return = reorder_codes(m_code, g_code + floor_change * divisor);
      m_code_new := reorder_return.m_code;
      g_code_new := reorder_return.g_code;
    return next;
    end if;
  end loop;
  -- we're done
  return;
end;
$$
language plpgsql immutable;

create or replace function move_two(
  floor_change bigint, id bigint, e bigint, m_code bigint, g_code bigint
) returns table(id_old bigint, e_new bigint, m_code_new bigint, g_code_new bigint)
as
$$
declare
  -- the number of microchips (or generators)
  code_length bigint := length(m_code::varchar);
  -- the number of microchips + generators
  double_code_length bigint := code_length * 2;
  divisor bigint;
  divisor2 bigint;
  reorder_return dummy%ROWTYPE;
  item_code bigint := m_code * pow(10, code_length)::bigint + g_code;
  new_item_code bigint;
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

  -- initialize the new e and (old) id, which are the same for every row
  -- that we return
  e_new := e + floor_change;
  id_old := id;

  for i in reverse double_code_length..2 loop
    divisor := pow(10, i - 1)::bigint;
    -- if this item is on the same floor as the elevator...
    if (item_code / divisor % 10 = e) then
      -- look for another item to move with it
      for j in reverse (i-1)..1 loop
        divisor2 := pow(10, j - 1)::bigint;
        -- if this item is also on the same floor as the elevator...
        if (item_code / divisor2 % 10 = e) then
          -- if they're both microchips, or both generators, or
          -- a corresponding microchip and generator
          if  ((i > code_length and j > code_length) or
               (i <= code_length and j <= code_length) or
               (i - j = code_length)) then
            -- move them together!!
            new_item_code = item_code + floor_change * (divisor + divisor2);
            -- put the microchip and generator codes in the preferred order
            reorder_return = reorder_codes(
              new_item_code / pow(10, code_length)::bigint,
              new_item_code % pow(10, code_length)::bigint
            );
            m_code_new := reorder_return.m_code;
            g_code_new := reorder_return.g_code;
            return next;
          end if;
        end if;
      end loop;
    end if;
  end loop;
  return;
end;
$$
language plpgsql immutable;

-- now create the table that shows how one position can move into a new
-- position (which may or may not be valid)
create table outreach (
  id_old bigint not null,
  e_new bigint not null,
  m_code_new bigint not null,
  g_code_new bigint not null,
  id_new bigint
);

insert into outreach (id_old, e_new, m_code_new, g_code_new)
select distinct id_old, e_new, m_code_new, g_code_new
from
position,
lateral (
  select *
  from
  move_one(1, position.id, position.e, position.m_code, position.g_code)
) as lat;

insert into outreach (id_old, e_new, m_code_new, g_code_new)
select distinct id_old, e_new, m_code_new, g_code_new
from
position,
lateral (
  select *
  from
  move_one(-1, position.id, position.e, position.m_code, position.g_code)
) as lat;

insert into outreach (id_old, e_new, m_code_new, g_code_new)
select distinct id_old, e_new, m_code_new, g_code_new
from
position,
lateral (
  select *
  from
  move_two(1, position.id, position.e, position.m_code, position.g_code)
) as lat;

insert into outreach (id_old, e_new, m_code_new, g_code_new)
select distinct id_old, e_new, m_code_new, g_code_new
from
position,
lateral (
  select *
  from
  move_two(-1, position.id, position.e, position.m_code, position.g_code)
) as lat;

-- remove the invalid new positions in outreach
delete from outreach where
(m_code_new, g_code_new) not in (select m_code, g_code from position);

-- now assign the new IDs for outreach entries
update outreach as o
set
id_new = p.id
from
position as p
where
o.e_new = p.e and o.m_code_new = p.m_code and o.g_code_new = p.g_code;

-- after the previous update, none of the id_new values should be null
alter table outreach alter column id_new set not null;

create index on outreach (id_old);

-- this table will start with positions immediately next to
-- position 0, and spread out from there until one of the paths
-- reaches the final position.  For sample data, this will be
-- the 11th round.  Each iteration will be much smaller than they
-- were before, but they also will take longer to find the final
-- destination
create table sprawl
(
  position_id bigint not null primary key,
  distance bigint not null,
  prior_position_id bigint not null
);

-- each time we reach out for more connections, that is a "round"
create table round
(
  id bigint primary key check (id = 0),
  round bigint
);

insert into round (id, round) values (0, 0);

-- initialize the sprawl table with our initial position
insert into sprawl (position_id, distance, prior_position_id)
  values (0, 0, -1);
