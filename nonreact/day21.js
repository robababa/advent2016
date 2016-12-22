//import { PUZZLE_INPUT, INSTRUCTION_ARRAY } from './day21_data';

var INSTRUCTION_ARRAY =
`swap position 4 with position 0
swap letter d with letter b
reverse positions 0 through 4
rotate left 1 step
move position 1 to position 4
move position 3 to position 0
rotate based on position of letter b
rotate based on position of letter d`
.replace(
  /swap position/g, "swapPosition"
).replace(
  /swap letter/g,"swapLetter"
).replace(
  /reverse positions/g,"reversePositions"
).replace(
  /rotate left/g,"rotateLeft"
).replace(
  /rotate right/g,"rotateRight"
).replace(
  /move position/g,"movePosition"
).replace(
  /rotate based on position of letter/g,"rotateSpecial"
).replace(
  /with position|with letter|through|to position/g,""
).replace(
  / steps| step/g,""
).replace(
  / +/g," "
).split(
  "\n"
).map(
  function(element, index){ return element.split(" ");
});

var s = 'abcde';

function swapPosition(s, p1, p2) {
  return s.split("").map((element, index) => {
    if (index === p1) {
      return s[p2]
    } else if (index === p2) {
      return s[p1]
    } else {
      return s[index]
    }
  }).join("");
}

console.log(swapPosition(s, 4, 0));

console.log(INSTRUCTION_ARRAY);
