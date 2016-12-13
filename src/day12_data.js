// take the instruction array as text,
// split by line number,
// and parse each command and arguments
export const INSTRUCTION_ARRAY=`cpy 1 a
cpy 1 b
cpy 26 d
jnz c 2
jnz 1 5
cpy 7 c
inc d
dec c
jnz c -2
cpy a c
inc a
dec b
jnz b -2
cpy c b
dec d
jnz d -6
cpy 13 c
cpy 14 d
inc a
dec d
jnz d -2
dec c
jnz c -5`.split("\n").map(function(element) {
  return element.split(" ");
}).map(function(element) {
  if (element[0] === "inc" || element[0] === "dec") {
    return ({command: element[0], arg1: element[1], arg2: '-'});
  }

  var [command, y, z] = element;
  if (Number.isInteger(y)) { y = Number.parseInt(y, 10) }
  if (Number.isInteger(z)) { z = Number.parseInt(z, 10) }
  return ({command: command, arg1: y, arg2: z});
});

