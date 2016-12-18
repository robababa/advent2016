with recursive
tiles (tile_row, tile_row_number) as (
  select '.^^.^^^..^.^..^.^^.^^^^.^^.^^...^..^...^^^..^^...^..^^^^^^..^.^^^..^.^^^^.^^^.^...^^^.^^.^^^.^.^^.^.', 1
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
      -- min(tile_row_number) < min(tile_row_length)
      min(tile_row_number) < 400000
  )
)
-- for a simple tile display, just
-- select * from tiles;
select sum(length(replace(tile_row, '^', ''))) from tiles;
