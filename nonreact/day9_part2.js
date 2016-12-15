const PROGRAM_INPUT =
  '(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN'.match(
    /\(\d+x\d+\)|\w+/g);

const MARKER_PATTERN = /\((\d+)x(\d+)\)/;

var uncompressedLength = 0;
var markers = [];
var tokenNumber = 0;
var readPosition = 0;
var tokenLength = 0;

function applyMarkers(markers, tokenLength) {
  return (
    markers.map(function (element) {
      // console.log("Applying marker with width ", element.width, " and copies ", element.copies);
      return element.copies * Math.min(element.width, tokenLength);
    }).reduce(function (a, b) { return a + b; }, 0)
  );
}

function updateMarkers(markers, tokenLength) {
  return (
    markers.map(function (element) {
      return {width: element.width - tokenLength, copies: element.copies };
    }).filter(function (element) {
      return (element.width > 0);
    })
  );
}

function isMarker(token) {
  return (token.search(MARKER_PATTERN) !== -1);
}

function parseMarker(token) {
  var arr = token.match(MARKER_PATTERN);
  return ( {width: Number.parseInt(arr[1], 10), copies: Number.parseInt(arr[2], 10)} );
}

function processInput() {
  //console.log(program_input)
  PROGRAM_INPUT.forEach(function (element) {
    tokenLength = element.length;
    if (markers.length === 0) {
      uncompressedLength += tokenLength;
    } else {
      uncompressedLength += applyMarkers(markers, tokenLength);
    }
    console.log("uncompressedLength is: ", uncompressedLength);
    markers = updateMarkers(markers, tokenLength);
    if (isMarker(element)) {
      markers.push(parseMarker(element));
    }
  });
  console.log("uncompressedLength is: ", uncompressedLength);
}

processInput();

