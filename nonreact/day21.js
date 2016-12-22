// run this in node with
// cat day21_input.js day21.js | node

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

function swapLetter(s, letter1, letter2) {
  return s.split("").map((element, index) => {
    if (element === letter1) {
      return letter2
    } else if (element === letter2) {
      return letter1
    } else {
      return s[index]
    }
  }).join("");
}

function reversePositions(s, p1, p2) {
  return s.split("").map((element, index) => {
    if (index >= p1 && index <= p2) {
      return s[p2 - index + p1]
    } else {
      return s[index]
    }
  }).join("");
}

function rotateLeft(s, left) {
  return s.split("").map((element, index) => {
    return s[(s.length * 2 + index + left) % s.length]
  }).join("");
}

function rotateRight(s, right) {
  return rotateLeft(s, right * -1);
}

function movePosition(s, oldPos, newPos) {
  // remove the character at the old position
  return (s.substring(0, oldPos) + s.substring(oldPos + 1))
    .split("")
    .map((element, index) => {
      if (index === newPos) {
        // insert the moved character before the current character
        return s[oldPos] + element
      } else {
        return element
      }
    }).join("") +
    // if the new position is at the end, put the moved character there
    (newPos === s.length - 1 ? s[oldPos] : '')
}

function rotateSpecial(s, letter) {
  return rotateRight(
    s,
    1 + s.indexOf(letter) + (s.indexOf(letter) >= 4 ? 1 : 0)
  )
}

var command = [];

for (var i = 0; i < INSTRUCTION_ARRAY.length; i++) {
  command = INSTRUCTION_ARRAY[i]
  //console.log(command)
  switch (command[0]) {
    case 'swapPosition':
      s = swapPosition(s, Number.parseInt(command[1]), Number.parseInt(command[2]))
      break
    case 'swapLetter':
      s = swapLetter(s, command[1], command[2])
      break
    case 'reversePositions':
      s = reversePositions(s, Number.parseInt(command[1]), Number.parseInt(command[2]))
      break
    case 'rotateLeft':
      s = rotateLeft(s, Number.parseInt(command[1]))
      break
    case 'rotateRight':
      s = rotateRight(s, Number.parseInt(command[1]))
      break
    case 'movePosition':
      s = movePosition(s, Number.parseInt(command[1]), Number.parseInt(command[2]))
      break
    case 'rotateSpecial':
      s = rotateSpecial(s, command[1])
      break
    default:
      break
  }
  console.log(s)
}

// console.log(INSTRUCTION_ARRAY);
// console.log('start: ', s);
// s = swapPosition(s, 4, 0);
// console.log('after swapPosition: ', s);
// s = swapLetter(s, 'd', 'b');
// console.log('after swapLetter: ', s);
// s = reversePositions(s, 0, 4);
// console.log('after reversePositions: ', s);
// s = rotateLeft(s, 1);
// console.log('after rotateLeft: ', s);
// s = movePosition(s, 1, 4);
// console.log('after movePosition: ', s);
// s = movePosition(s, 3, 0);
// console.log('after movePosition: ', s);
// s = rotateSpecial(s, 'b');
// console.log('after rotateSpecial: ', s);
// s = rotateSpecial(s, 'd');
// console.log('after rotateSpecial: ', s);

