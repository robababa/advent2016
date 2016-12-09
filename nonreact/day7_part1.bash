#!/bin/bash

# sed -r:
#   replace 4 or more repeated alphanumeric characters with N
#   replace 4 letter palindromes with Y
#   replace N with nothing
#   replace lower case letters with nothing
#   replace empty brackets with nothing
# grep lines with Y
# remove lines with any Y in brackets
# count the lines

sed -r 's#(\w)\1{3,}#N#g; s#(\w)(\w)\2\1#Y#g; s#N##g; s#[a-z]##g; s#\[]##g' day7_part1.txt \
  | grep Y \
  | egrep -v '\[Y+]' \
  | wc -l
