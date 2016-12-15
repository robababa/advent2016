-- last condition was added for part 2
with source as (select generate_series(0, 10000000, 1) as t)
select t from source
where
(1 + 5 + t) % 17 = 0 and
(2 + 8 + t) % 19 = 0 and
(3 + 1 + t) % 7 = 0 and
(4 + 7 + t) % 13 = 0 and
(5 + 1 + t) % 5 = 0 and
(6 + 0 + t) % 3 = 0 and
(7 + 0 + t) % 11 = 0;

