#!/bin/bash

cd $(dirname $0)

psql --file=./day17_setup.sql

### part 1
###DONE=0
###ATTEMPTS=0
###
###while [[ $DONE -eq 0 ]]
###do
###  ATTEMPTS=$(expr $ATTEMPTS + 1)
###  ###echo "Attempt #${ATTEMPTS}"
###  psql --file="./day17_iterate.sql"
###  DONE=$(psql --no-align --tuples-only --command="select count(*) from position where room = 44")
###done
###
###echo "Done after $ATTEMPTS attempts"
###echo "Solution:"
###psql --no-align --tuples-only --command="select md5_source from position where room = 44"

DONE=1
ATTEMPTS=0

while [[ $DONE -gt 0 ]]
do
  ATTEMPTS=$(expr $ATTEMPTS + 1)
  ###echo "Attempt #${ATTEMPTS}"
  psql --file="./day17_iterate.sql"
  DONE=$(psql --no-align --tuples-only --command="select count(*) from position inner join round on position.round = round.round")
done

echo "Done after $ATTEMPTS attempts"
echo "Solution:"
psql --no-align --tuples-only --command="select max(round) from position where room = 44"
