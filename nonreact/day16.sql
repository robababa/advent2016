drop table if exists data;

create table data as select '01110110101001000'::"bit" as source_data, null::"bit" as checksum, 35651584::int as disk_length;

select length(source_data), disk_length from data;

-- as many times as needed
update data set source_data = source_data || B'0' || (reverse((~source_data)::varchar))::"bit";

-- just once
update data set source_data = substring(source_data, 1, disk_length);


-- just once
update data
set checksum =
(select
  string_agg(case when r[1] in ('11','00') then '1' else '0' end, '')::"bit"
  from
  (
    select regexp_matches(source_data::varchar, E'\\d\\d', 'g') as r from data
  ) as source
);

-- simplified the checksum process with this observation:
-- (1) if the disk_length is m * 2**n where m is odd, then the checksum length
--     is m.
-- (2) Each digit of the checksum will be computed from successive strings of
--     data of length 2**n
-- (3) The checksum of a 2**n string is 1 if the number of 1s in the string is
--     even, 0 if it is odd.  This can be shown easily by induction.
-- (4) So to compute the checksum, just count the 1s in consecutive 2**n
--     segments, apply the rule in (3), and merge those results together.
--
-- for this particular problem, 35651584 = 17 * 2**21
with
source
  as (select generate_series(0, 17 - 1, 1) as offset),
source2
as
(
select
case
  length(
      replace(
            substring(source_data, 1 + source.offset*2*1024*1024, 2*1024*1024)::varchar,
                '0',''
                  )
                ) % 2
when 0 then '1'
else '0'
end as checksum_char
from
source
cross join
data
order by source)
select string_agg(source2.checksum_char, '') from source2;



;
