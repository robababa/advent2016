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

function unrotateSpecial(s, letter) {
  var newIndex = s.indexOf(letter);
  var oldIndex = -1; // we will replace this!
  for (var i = 0; i < s.length; i++) {
    if ((i + 1 + i + ( i >= 4 ? 1 : 0)) % s.length === newIndex) {
      //console.log('index', i, 'matches')
      oldIndex = i
    }
  }
  // now that we know where the letter was, let's see how many places we
  // must go to get back
  var leftAmount = (s.length - oldIndex + newIndex) % s.length;
  //console.log('calling rotateLeft with', leftAmount);
  return rotateLeft(s, leftAmount)
}

var command = [];

// part 1
//for (var i = 0; i < INSTRUCTION_ARRAY.length; i++) {
//  command = INSTRUCTION_ARRAY[i]
//  //console.log(command)
//  switch (command[0]) {
//    case 'swapPosition':
//      s = swapPosition(s, Number.parseInt(command[1]), Number.parseInt(command[2]))
//      break
//    case 'swapLetter':
//      s = swapLetter(s, command[1], command[2])
//      break
//    case 'reversePositions':
//      s = reversePositions(s, Number.parseInt(command[1]), Number.parseInt(command[2]))
//      break
//    case 'rotateLeft':
//      s = rotateLeft(s, Number.parseInt(command[1]))
//      break
//    case 'rotateRight':
//      s = rotateRight(s, Number.parseInt(command[1]))
//      break
//    case 'movePosition':
//      s = movePosition(s, Number.parseInt(command[1]), Number.parseInt(command[2]))
//      break
//    case 'rotateSpecial':
//      s = rotateSpecial(s, command[1])
//      break
//    default:
//      break
//  }
//  console.log(s)
//}

// part 2
for (var i = INSTRUCTION_ARRAY.length - 1; i >= 0; i--) {
  command = INSTRUCTION_ARRAY[i]
  console.log(command)
  switch (command[0]) {
    case 'swapPosition':
      // function is its own inverse
      s = swapPosition(s, Number.parseInt(command[1]), Number.parseInt(command[2]))
      break
    case 'swapLetter':
      // function is its own inverse
      s = swapLetter(s, command[1], command[2])
      break
    case 'reversePositions':
      // function is its own inverse
      s = reversePositions(s, Number.parseInt(command[1]), Number.parseInt(command[2]))
      break
    case 'rotateLeft':
      // rotateLeft and rotateRight are inverses of each other
      s = rotateRight(s, Number.parseInt(command[1]))
      break
    case 'rotateRight':
      // ditto
      s = rotateLeft(s, Number.parseInt(command[1]))
      break
    case 'movePosition':
      // movePosition's inverse is itself with operands reversed
      s = movePosition(s, Number.parseInt(command[2]), Number.parseInt(command[1]))
      break
    case 'rotateSpecial':
      // I had to create a new function for this inverse
      s = unrotateSpecial(s, command[1])
      break
    default:
      break
  }
  console.log(s)
}
