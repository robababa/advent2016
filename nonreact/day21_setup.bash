#!/bin/bash

# modify the input to be like function calls
sed -r '
s#rotate based on position of letter#rotateLetter#g;
s#rotate left#rotateLeft#g;
s#rotate right#rotateRight#g;
s#swap position#swapPosition#g;
s#swap letter#swapLetter#g;
s#move position#movePosition#g;
s#reverse positions#reversePosition#g;
s# (with letter|with position|through|to position) #,#g;
s# (steps|step)##g;
s# #(#g' day21_input.txt | awk '{print $0")"}'
