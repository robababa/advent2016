drop table if exists tls_codes;
create table tls_codes (code text);
\copy tls_codes (code) from './day7_part1.txt';


drop table if exists aba_bab;

create table aba_bab
as
(
with
candidates
as
(
  select
  code,
  '[' || replace(replace(replace(code, '[', '!'), ']', '['), '!', ']') || ']' as inverted_code
  from
  tls_codes
),
code_arrays
as
(
  select
  row_number() over () as input_line,
  code,
  inverted_code,
  string_to_array(regexp_replace(code, E'\\[(\\w+)\\]', ',', 'g'), ',') as code_tls_array,
  string_to_array(regexp_replace(inverted_code, E'\\[(\\w+)\\]', ',', 'g'), ',') as inverted_code_tls_array
  from
  candidates
),
everything as (select input_line, code, inverted_code, code_tls_array, inverted_code_tls_array from code_arrays),
aba_source as (select input_line, unnest(code_tls_array) as aba_source                         from everything),
bab_source as (select input_line, unnest(inverted_code_tls_array) as bab_source                from everything),
aba_lined_source as (select input_line, aba_source, row_number() over (partition by input_line) as aba_sub_line from aba_source),
bab_lined_source as (select input_line, bab_source, row_number() over (partition by input_line) as bab_sub_line from bab_source),
aba_candidates as (select input_line, aba_sub_line, aba_source from aba_lined_source),
bab_candidates as (select input_line, bab_sub_line, bab_source from bab_lined_source where length(bab_source) > 0)
select
a.input_line,
a.aba_sub_line,
b.bab_sub_line,
a.aba_source,
b.bab_source
from
aba_candidates as a join bab_candidates as b on a.input_line = b.input_line
where
length(b.bab_source) > 0);

with first_aba_source as
(
  select distinct on (input_line, aba_sub_line, g)
  input_line,
  aba_sub_line,
  aba_source,
  generate_series(1, length(aba_source) - 2, 1) as g
  from aba_bab
),
aba_patterns
as
(
  select input_line, aba_sub_line, substr(aba_source, g, 3) as aba_pattern
  from first_aba_source
),
aba_matches
as
(
select
input_line, aba_sub_line, aba_pattern
from
aba_patterns
where
aba_pattern ~ E'(\\w)\\w\\1' and aba_pattern !~ E'(\\w)\\1\\1'
),
first_bab_source as
(
  select distinct on (input_line, bab_sub_line, g)
  input_line,
  bab_sub_line,
  bab_source,
  generate_series(1, length(bab_source) - 2, 1) as g
  from aba_bab
),
bab_patterns
as
(
  select input_line, bab_sub_line, substr(bab_source, g, 3) as bab_pattern
  from first_bab_source
),
bab_matches
as
(
select
input_line, bab_sub_line, bab_pattern
from
bab_patterns
where
bab_pattern ~ E'(\\w)\\w\\1' and bab_pattern !~ E'(\\w)\\1\\1'
)
select
distinct on (aba_matches.input_line)
aba_matches.input_line,
aba_sub_line,
bab_sub_line,
aba_pattern,
bab_pattern
from
aba_matches inner join bab_matches
on
aba_matches.input_line = bab_matches.input_line
where
substr(aba_pattern, 1, 1) = substr(bab_pattern, 2, 1)
and
substr(aba_pattern, 2, 1) = substr(bab_pattern, 1, 1)
order by
aba_matches.input_line,
aba_sub_line,
bab_sub_line;
