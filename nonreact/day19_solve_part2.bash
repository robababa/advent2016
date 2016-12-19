#!/bin/bash

DIRNAME=$(dirname $0)
###ELF_COUNT=5
###MODULUS1=2
###MODULUS2=3
ELF_COUNT=3004953
MODULUS1=30001
MODULUS2=29999

REMAINDER1=$(psql --tuples-only --no-align --variable=PLAYER_COUNT=${ELF_COUNT} --variable=MODULUS=${MODULUS1} --file=${DIRNAME}/day19_part2.sql)
REMAINDER2=$(psql --tuples-only --no-align --variable=PLAYER_COUNT=${ELF_COUNT} --variable=MODULUS=${MODULUS2} --file=${DIRNAME}/day19_part2.sql)

ANSWER_QUERY="
select generate_series($REMAINDER1, $ELF_COUNT, $MODULUS1) as possible_answer
intersect
select generate_series($REMAINDER2, $ELF_COUNT, $MODULUS2) as possible_answer"

ANSWER=$(psql --tuples-only --no-align --command="$ANSWER_QUERY")

echo "In the game with ${ELF_COUNT} elves, the one with all the presents is:"
echo "ELF #${ANSWER}"

