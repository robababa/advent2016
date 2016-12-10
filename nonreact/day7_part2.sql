drop table if exists tls_codes;
create table tls_codes (code text);
\copy tls_codes (code) from './day7_part1.txt';

-- stack overflow
--http://stackoverflow.com/questions/22098706/how-to-use-regular-expression-with-any-array-operator

create or replace function commuted_regexp_match(text,text) returns bool as
'select $2 ~ $1;'
language sql;

drop operator if exists ~!@# (text, text);

create operator ~!@# (
 procedure=commuted_regexp_match(text,text),
 leftarg=text, rightarg=text
);

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
)
select
input_line,
code,
inverted_code,
code_tls_array,
inverted_code_tls_array
from code_arrays
limit 5;
