export default class Day4Room {

  constructor(roomName) {
    //"fubrjhqlf-edvnhw-dftxlvlwlrq-803[wjvzd]"
    var split_dashes = roomName.split('-');
    this.actualName = split_dashes.slice(0, -1);
    var lastPart = split_dashes[split_dashes.length - 1];
    this.sectorId = lastPart.split('[')[0];
    this.checksum = lastPart.split('[')[1].slice(0, -1);
  }

}
