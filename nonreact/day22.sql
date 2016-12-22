drop table if exists filesystem;

create table filesystem (
  x int not null,
  y int not null,
  sz int not null,
  used int not null,
  avail int not null);

\copy filesystem from program './day22_input.bash' delimiter ' ';

select
--a.x, a.y, b.x, b.y
count(*)
from filesystem as a cross join filesystem as b
where
a.used > 0 and
(a.x, a.y) <> (b.x, b.y) and
a.used <= b.avail;

