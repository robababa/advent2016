with
words
as
(values
('eedadn'),
('drvtee'),
('eandsr'),
('raavrd'),
('atevrs'),
('tsrnev'),
('sdttsa'),
('rasrtv'),
('nssdts'),
('ntnada'),
('svetve'),
('tesnvt'),
('vntsnd'),
('vrdear'),
('dvrsen'),
('enarar')
),
word_length
as
(
  select length(column1) as word_length from words limit 1
),
spots as
(
  select generate_series(1, (select word_length from word_length), 1) as spot
),
most_frequent_letters
as
(
select
  distinct on (spot)
  spot,
  substr(column1, spot, 1) as letter,
  count(*) as frequency
  from
  words cross join spots
  group by
  spot,
  substr(column1, spot, 1)
  order by
  spot, count(*) desc
)
select
string_agg(letter, '')
from
most_frequent_letters;
