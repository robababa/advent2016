#!/bin/bash

cd $(basename $0)

psql --file=./day11_setup.sql

DONE=0
ATTEMPTS=0

while [[ $DONE -eq 0 ]]
do
  ATTEMPTS=$(expr $ATTEMPTS + 1)
  echo "Attempt #${ATTEMPTS}"
  psql --file="./day11_iterate.sql"
  DONE=$(psql --no-align --tuples-only --command="select count(*) from sprawl where position_id = 100000000")
done

echo "Done after $ATTEMPTS attempts"
