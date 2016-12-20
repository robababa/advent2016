// since the number of elves is odd, we know that after the first elf
// removal, the next elf will be skipped
// if the number of elves was even, then that next elf would be removed,
// then the following elf skipped
// So this isn't a general solution, but I've already spent more time on this
// than intended, so I wil leave it like this

var elves = 3004953;
var half = (elves - 1) / 2;
var current_source = Array(elves).fill().map((x,i)=>((i+half)%elves + 1));
var current_length = elves;
var current_elf = 0;

var other_source = [];

var discard = 0;
var last = 0;
var cycle = -1; // we add 1 before the filter, so prime it to be one less

//console.log(current_source);
//console.log(other_source);

while (current_length > 0) {
  other_source = current_source.filter(function (element) {
    cycle = (cycle + 1) % 3;
    if (cycle % 3 === 1) {
      last = element;
      return true;
    } else {
      return false;
    }
  });

  // now swap arrays
  [current_source, other_source] = [other_source, []];
  current_length = current_source.length;
}

console.log(`Winner is ${last}`);
