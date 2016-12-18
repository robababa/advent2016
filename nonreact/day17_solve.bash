#!/bin/bash

cd $(dirname $0)

psql --file=./day17_setup.sql

DONE=0
ATTEMPTS=0

while [[ $DONE -eq 0 ]]
do
  ATTEMPTS=$(expr $ATTEMPTS + 1)
  echo "Attempt #${ATTEMPTS}"
  psql --file="./day17_iterate.sql"
  DONE=$(psql --no-align --tuples-only --command="select count(*) from position where room = 44")
done

echo "Done after $ATTEMPTS attempts"
echo "Solution:"
psql --no-align --tuples-only --command="select md5_source from position where room = 44"
