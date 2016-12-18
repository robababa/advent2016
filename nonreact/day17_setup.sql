drop table if exists position, round cascade;

create table round
(
  id bigint primary key check (id = 0),
  round bigint
);

insert into round (id, round) values (0, 0);

create table position
(
  round int not null,
  room int not null check (room in (11, 12, 13, 14,
                                               21, 22, 23, 24,
                                               31, 32, 33, 34,
                                               41, 42, 43, 44)),
  md5_source varchar);

insert into position (round, room, md5_source) values (0, 11, 'pslxynzg');
