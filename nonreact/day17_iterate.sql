insert into position (round, room, md5_source)
with
position_detail
as
(
  -- the first four conditions express position boundary limitations
  -- the last four conditions express md5 checksum security limitations
  select
  p.round,
  p.room,
  p.md5_source,
  case when p.room < 20     then B'0111' else B'1111' end &
  case when p.room > 40     then B'1011' else B'1111' end &
  case when p.room % 10 = 1 then B'1101' else B'1111' end &
  case when p.room % 10 = 4 then B'1110' else B'1111' end &
  case when substr(md5(p.md5_source), 1, 1) not in ('b','c','d','e','f') then B'0111' else B'1111' end &
  case when substr(md5(p.md5_source), 2, 1) not in ('b','c','d','e','f') then B'1011' else B'1111' end &
  case when substr(md5(p.md5_source), 3, 1) not in ('b','c','d','e','f') then B'1101' else B'1111' end &
  case when substr(md5(p.md5_source), 4, 1) not in ('b','c','d','e','f') then B'1110' else B'1111' end &
  -- if we reached room 44, our destination, then stop
  case when p.room = 44 then B'0000' else B'1111' end
  as
  bitstring_code
  from
  position as p inner join round as r on p.round = r.round
)
-- up, down, left, right
select pd.round + 1,  pd.room - 10, pd.md5_source || 'U' from position_detail as pd where pd.bitstring_code | B'0111' = B'1111' UNION ALL
select pd.round + 1,  pd.room + 10, pd.md5_source || 'D' from position_detail as pd where pd.bitstring_code | B'1011' = B'1111' UNION ALL
select pd.round + 1,  pd.room - 1,  pd.md5_source || 'L' from position_detail as pd where pd.bitstring_code | B'1101' = B'1111' UNION ALL
select pd.round + 1,  pd.room + 1,  pd.md5_source || 'R' from position_detail as pd where pd.bitstring_code | B'1110' = B'1111';

update round set round = round + 1;
