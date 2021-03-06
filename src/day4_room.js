const CHECKSUM_LENGTH = 5;

export default class Day4Room {

  constructor(roomName) {
    // roomName = "fubrjhqlf-edvnhw-dftxlvlwlrq-803[wjvzd]"
    // split_dashes = ["fubrjhqlf", "edvnhw", "dftxlvlwlrq", "803[wjvzd]"]
    var split_dashes = roomName.split('-');
    // actualName = ["fubrjhqlf", "edvnhw", "dftxlvlwlrq"]
    this.actualName = split_dashes.slice(0, -1);
    // lastPart = "803[wjvzd]"
    var lastPart = split_dashes[split_dashes.length - 1];
    // sectorId = 803
    this.sectorId = Number.parseInt(lastPart.split('[')[0], 10);
    // checksum = wjvzd
    this.checksum = lastPart.split('[')[1].slice(0, -1);
    // array of the letters, with duplicates
    this.sortedLetters = this.actualName.join('').split('').sort();
    // "fubrjhqlf-edvnhw-dftxlvlwlrq"
    this.roomCode = this.actualName.join('-');
    // for decryption
    this.letterShift = this.sectorId % 26;
  }

  getSectorId() {
    return this.sectorId;
  }

  getRoomCode() {
    return `${this.roomCode}[${this.sectorId}]`;
  }

  getDecryptedNameAndSector() {
    return `${this.getDecryptedName()}[${this.sectorId}]`;
  }

  getDecryptedName() {
    return this.roomCode.split('').map((letter) => {
      if (letter === '-') {
        return ' ';
      } else {
        var charCode = letter.charCodeAt(0);
        var zCode = 'z'.charCodeAt(0);
        charCode += this.letterShift;
        if (charCode > zCode) {
          charCode -= 26
        }
        return String.fromCharCode(charCode);
      }
    }).join('');
  }

  isValid() {
    return (this.checksum === this.computeChecksum());
  }

  computeChecksum() {
    var answer = '';
    var letters = this.sortedLetters;
    for (var freq = letters.length; freq >= 1; freq--) {
      for (var i = 0; i < letters.length; i++) {
        var currentLetter = letters[i];
        if (answer.indexOf(letters[i]) !== -1) {
          // this letter is already in our answer, move on
          continue;
        }

        // if this letter occurs the right number of times, then add it!
        if (this.countFrequency(letters, currentLetter) === freq) {
          answer += currentLetter;
        }

        // if our answer has built up to the checksum length, then we're done
        if (answer.length === CHECKSUM_LENGTH) {
          return answer;
        }
      }
    }
    // shouldn't get here, but just in case
    return answer;
  }

  countFrequency(letters, letter) {
    return letters.filter(function same(el) { return el === letter}).length;
  }

}
