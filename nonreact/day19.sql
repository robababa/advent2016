/*
select generate_series(15663, 3004953, 29999) as possible_answer
intersect
select generate_series(15543, 3004953, 30001) as possible_answer;
*/

with recursive game(players, last_player_had_turn, previous_length) as
(
  with
  player_count as (
    select (:PLAYER_COUNT)::int as player_count
--    select 13::int as player_count
  ),
  source as (
    select chr((generate_series(0, player_count - 1, 1) % :MODULUS) + 1) as player
--    select chr((generate_series(0, player_count - 1, 1) % 3) + 1) as player
--    select chr((generate_series(0, player_count - 1, 1) % 5) + 1) as player
--    select chr(generate_series(1, player_count, 1)) as player
    from player_count
  )
  select
    regexp_replace(string_agg(player, ''), '(.).', '\1', 'g') as players,
    (select player_count % 2 = 0 from player_count) as last_player_had_turn,
    (select player_count from player_count) as previous_length
  from
  source
  UNION ALL
  select
    case
      when
        -- the last player had a turn last round
        last_player_had_turn
      then
        -- just remove every 2nd player
        regexp_replace(players, '(.).', '\1', 'g')
      else
        -- the last player removes the first player, and we are done for the round
        substring(players, 2)
      end
    as players,
    case
      when
        last_player_had_turn
      then
        -- did the last player have a turn this round?  If the number of players
        -- this round was even, then yes, else no
        length(players) % 2 = 0
      else
        -- the last player DIDN'T have a turn last round, but we made sure
        -- he did this round
        true
    end
    as last_player_had_turn,
    length(players) as previous_length
  from
  game
  where
  previous_length > 1
)
--select ascii(players), * from game;
select ascii(players) from game where previous_length = 1;

