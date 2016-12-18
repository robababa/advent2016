drop table if exists data;

create table data as select '10000'::"bit" as source_data, null::"bit" as checksum, 20::int as disk_length;

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


select checksum, length(checksum) from data;

-- until the checksum length is odd
update data set checksum = (
  with t as
  (
    select regexp_matches(checksum::varchar, E'\\d\\d', 'g') as r from data
  )
  select
  string_agg(
    case when r[1] in ('11','00') then '1' else '0' end, null
  )::"bit" from t
);
