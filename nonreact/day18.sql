with recursive
tiles (tile_row, tile_row_number) as (
  select '.^^.^.^^^^', 1
UNION ALL
  (
    with
      source as (select tile_row::text as s, tile_row_number from tiles),
      source2 as
      (
        select
        substring('.' || s || '.', generate_series(1, length(s), 1), 3)
          as tiles_above,
        length(s) as tile_row_length,
        source.tile_row_number
        from
        source
      )
      select
      string_agg(
        case
          when tiles_above in ('^^.','^..','..^','.^^')
          then '^'
          else '.'
        end,
        ''
      ),
      min(tile_row_number) + 1
      from
      source2
      having
      min(tile_row_number) < min(tile_row_length)
  )
)
-- for a simple tile display, just
-- select * from tiles
select sum(length(replace(tile_row, '^', ''))) from tiles;


-- select tiles.tile_row, tiles.tile_row_number + 1
-- from
-- tiles
-- where
-- tiles.tile_row_number < length(tiles.tile_row)
-- )
-- select * from tiles;

/*
with recursive
tiles (tile_row, tile_row_number) as (
select '..^^.', 1
UNION ALL
select tiles.tile_row, tiles.tile_row_number + 1
from
tiles
where
tiles.tile_row_number < length(tiles.tile_row)
)
select * from tiles;

with
source as (select '..^^.'::text as s),
source2 as
(
  select
  substring('.' || s || '.', generate_series(1, length(s), 1), 3)
    as tiles_above
  from
  source
)
select
string_agg(
  case
    when tiles_above in ('^^.','^..','..^','.^^')
    then '^'
    else '.'
  end,
  ''
)
from
source2;
*/

---- with
---- source
----   as (select generate_series(0, 17 - 1, 1) as offset),
---- source2
---- as
---- (
---- select
---- case
----   length(
----       replace(
----             substring(source_data, 1 + source.offset*2*1024*1024, 2*1024*1024)::varchar,
----                 '0',''
----                   )
----                 ) % 2
---- when 0 then '1'
---- else '0'
---- end as checksum_char
---- from
---- source
---- cross join
---- data
---- order by source)
---- select string_agg(source2.checksum_char, '') from source2;
