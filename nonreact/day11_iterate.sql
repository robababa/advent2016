insert into sprawl
(position_id, distance, prior_position_id)
select
outreach.id_new, latest_sprawl.distance + 1, min(latest_sprawl.position_id)
from
round
inner join
sprawl as latest_sprawl
on
round.round = latest_sprawl.distance
inner join
outreach
on
latest_sprawl.position_id = outreach.id_old
left join
sprawl as old_sprawl
on
outreach.id_new = old_sprawl.position_id
where
old_sprawl.position_id is null
group by
outreach.id_new, latest_sprawl.distance + 1;

update round set round = round + 1;
