var elves = 3004953;
var half = (elves - 1) / 2;
var current_source = Array(elves).fill().map((x,i)=>((i+half)%elves + 1));
var current_length = elves;
var current_elf = 0;

var other_source = [];

var discard = 0;
var last = 0;
var cycle = 0;

//console.log(current_source);
//console.log(other_source);

while (current_source.length > 0) {
  // we remove two of every three elements in circular fashion
  if ((cycle % 3 === 0) || (cycle % 3 === 2)) {
    discard = current_source.shift();
    //console.log(`REMOVING ${discard}`);
  } else {
    last = current_source.shift();
    //console.log(`saving ${last}`);
    other_source.push(last);
  }
  cycle = (cycle + 1) % 3;
  current_elf += 1;

  // if we've exhausted the current list of numbers, then swap lists
  if (current_elf >= current_length) {
    [current_source, other_source] = [other_source, []];
    current_elf = 0;
    current_length = current_source.length;
  }

}

console.log(`Winner is ${last}`);
