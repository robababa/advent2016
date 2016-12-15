//const PROGRAM_INPUT = '(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN';
const PROGRAM_INPUT = '(27x12)(20x12)(13x14)(7x10)(1x12)A';
//const PROGRAM_INPUT = '(3x3)XYZ';
//const PROGRAM_INPUT = 'X(8x2)(3x3)ABCY';
const MARKER_PATTERN = /\((\d+)x(\d+)\)/;

var uncompressedLength = 0;
var markers = [];
var tokenNumber = 0;
var readPosition = 0;
var tokenLength = 0;

function updateMarkers(markers, charLength) {
  return (
    markers.map(function (marker) {
      return {width: (marker.width - charLength), copies: marker.copies};
    }).filter(function (marker) {
      return (marker.width > 0);
    })
  );
}

function applyMarkers(markers, tokenLength) {
  if (markers.length === 0) {
    return tokenLength;
  }

  var answer = 0;
  for (var i = 0; i < tokenLength; i++) {
    answer += markers.map(function (marker) {
        return marker.copies;
      }).reduce(function (a, b) { return a * b; }, 1);

    markers = updateMarkers(markers, 1);
  }
  return answer;
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
  PROGRAM_INPUT.match(/\(\d+x\d+\)|\w+/g).forEach(function (element) {
    tokenLength = element.length;
    if (isMarker(element)) {
      // reduce the applied widths of other markers already in force
      markers = updateMarkers(markers, tokenLength);
      // add this new element to the marker array
      markers.push(parseMarker(element));
    } else {
      // we have a string, we need to apply the markers to it
      uncompressedLength += applyMarkers(markers, tokenLength);
      // we don't update the string, because the markers were already updated
    }
    console.log("uncompressedLength is: ", uncompressedLength);
    console.log("Markers are: ", markers);
  });
  console.log("FINAL uncompressedLength is: ", uncompressedLength);
}

processInput();

