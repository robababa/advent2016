with recursive game(players) as
(
  with
  player_count as (
    select (:PLAYER_COUNT)::int as player_count
  ),
  source as (
    select chr((generate_series(0, player_count - 1, 1) % :MODULUS) + 1) as player
    from player_count
  )
  select
    string_agg(player, '') as players from source
  UNION ALL
  select
  case
    when
      length(players) = 2
    then
      substring(players, 1, 1)
    when
      length(players) = 3
    then
      substring(players, 3, 1) || substring(players, 1, 1)
    else
      -- move the current player to the "end" of the circle, and prepend
      -- the players before the one who was removed, and
      -- the players after the one who was removed
      substring(players, 2, length(players) / 2 - 1) ||
      substring(players, length(players) / 2 + 2)  ||
      substring(players, 1, 1)
  end
    as players
  from
  game
  where
  -- terminate recursion when the last step gave us the answer
  length(players) > 1
)
--select players from game;
select ascii(players) from game where length(players)= 1;

