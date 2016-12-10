import React, { Component } from 'react';

export default class Day8 extends Component {
  constructor() {
    super();
    var arr =[
      '..................................................'.split(''),
      '..................................................'.split(''),
      '..................................................'.split(''),
      '..................................................'.split(''),
      '..................................................'.split(''),
      '..................................................'.split('')
    ]
    this.state = {
      screenPixels: arr,
      litPixelCount: 0,
      readyFor: 102
    }
  }

  countPixels(arr) {
    var sum = 0;
    for (var i=0; i< arr[0].length; i++) {
      for (var j=0; j < arr.length; j++) {
      sum += (arr[j][i] === '#' ? 1 : 0);
      }
    }
    return sum;
  }

  updateState(arr) {
    var litPixelCount = this.countPixels(arr);
    this.setState({
      screenPixels: arr,
      litPixelCount: litPixelCount,
      readyFor: this.state.readyFor + 1
    });
  }

  rect(x, y) {
    // array is "a"
    var arr = this.state.screenPixels;
    for (var i=0; i< x; i++) {
      for (var j=0; j < y; j++) {
        arr[j][i] = '#';
      }
    }
    this.updateState(arr);
  }

  rotateColumn(y, amount) {
    var arr = this.state.screenPixels;
    var height = arr.length;
    var tmp = [];
    // copy column y in the array to tmp
    for (var j = 0; j < height; j++) {
      tmp.push(arr[j][y]);
    }

    // now "rotate" the column using the values in tmp
    for (var k = 0; k < height; k++) {
      arr[(k + amount) % height][y] = tmp[k];
    }
    this.updateState(arr);
  }

  rotateRow(x, amount) {
    var arr = this.state.screenPixels;
    var lngth = arr[x].length;
    var tmp = [];
    // copy row x to tmp
    for (var i = 0; i < lngth; i++) {
      tmp.push(arr[x][i]);
    }

    // now "rotate" the row using the values in tmp
    for (var h = 0; h < lngth; h++) {
      arr[x][(h + amount) % lngth] = tmp[h];
    }
    this.updateState(arr);
  }



  render() {
    return (
      <div>
        <h3>Day 8</h3>
        <p onClick={() => this.tick()}>Click me to run!</p>
        <p>
          <code>Current State:</code><br/>
          <code>{this.state.screenPixels[0]}</code><br/>
          <code>{this.state.screenPixels[1]}</code><br/>
          <code>{this.state.screenPixels[2]}</code><br/>
          <code>{this.state.screenPixels[3]}</code><br/>
          <code>{this.state.screenPixels[4]}</code><br/>
          <code>{this.state.screenPixels[5]}</code><br/>
        </p>
        <p><code>readyFor: {this.state.readyFor}</code></p>
        <p><code>Lit Pixel Count: {this.state.litPixelCount}</code></p>
      </div>
    );
  }

  tick() {
    if (this.state.readyFor === 102) {this.rect(1,1);}
    if (this.state.readyFor === 103) {this.rotateRow(0,5);}
    if (this.state.readyFor === 104) {this.rect(1,1);}
    if (this.state.readyFor === 105) {this.rotateRow(0,5);}
    if (this.state.readyFor === 106) {this.rect(1,1);}
    if (this.state.readyFor === 107) {this.rotateRow(0,5);}
    if (this.state.readyFor === 108) {this.rect(1,1);}
    if (this.state.readyFor === 109) {this.rotateRow(0,5);}
    if (this.state.readyFor === 110) {this.rect(1,1);}
    if (this.state.readyFor === 111) {this.rotateRow(0,2);}
    if (this.state.readyFor === 112) {this.rect(1,1);}
    if (this.state.readyFor === 113) {this.rotateRow(0,2);}
    if (this.state.readyFor === 114) {this.rect(1,1);}
    if (this.state.readyFor === 115) {this.rotateRow(0,3);}
    if (this.state.readyFor === 116) {this.rect(1,1);}
    if (this.state.readyFor === 117) {this.rotateRow(0,3);}
    if (this.state.readyFor === 118) {this.rect(2,1);}
    if (this.state.readyFor === 119) {this.rotateRow(0,2);}
    if (this.state.readyFor === 120) {this.rect(1,1);}
    if (this.state.readyFor === 121) {this.rotateRow(0,3);}
    if (this.state.readyFor === 122) {this.rect(2,1);}
    if (this.state.readyFor === 123) {this.rotateRow(0,2);}
    if (this.state.readyFor === 124) {this.rect(1,1);}
    if (this.state.readyFor === 125) {this.rotateRow(0,3);}
    if (this.state.readyFor === 126) {this.rect(2,1);}
    if (this.state.readyFor === 127) {this.rotateRow(0,5);}
    if (this.state.readyFor === 128) {this.rect(4,1);}
    if (this.state.readyFor === 129) {this.rotateRow(0,5);}
    if (this.state.readyFor === 130) {this.rotateColumn(0,1);}
    if (this.state.readyFor === 131) {this.rect(4,1);}
    if (this.state.readyFor === 132) {this.rotateRow(0,10);}
    if (this.state.readyFor === 133) {this.rotateColumn(5,2);}
    if (this.state.readyFor === 134) {this.rotateColumn(0,1);}
    if (this.state.readyFor === 135) {this.rect(9,1);}
    if (this.state.readyFor === 136) {this.rotateRow(2,5);}
    if (this.state.readyFor === 137) {this.rotateRow(0,5);}
    if (this.state.readyFor === 138) {this.rotateColumn(0,1);}
    if (this.state.readyFor === 139) {this.rect(4,1);}
    if (this.state.readyFor === 140) {this.rotateRow(2,5);}
    if (this.state.readyFor === 141) {this.rotateRow(0,5);}
    if (this.state.readyFor === 142) {this.rotateColumn(0,1);}
    if (this.state.readyFor === 143) {this.rect(4,1);}
    if (this.state.readyFor === 144) {this.rotateColumn(40,1);}
    if (this.state.readyFor === 145) {this.rotateColumn(27,1);}
    if (this.state.readyFor === 146) {this.rotateColumn(22,1);}
    if (this.state.readyFor === 147) {this.rotateColumn(17,1);}
    if (this.state.readyFor === 148) {this.rotateColumn(12,1);}
    if (this.state.readyFor === 149) {this.rotateColumn(7,1);}
    if (this.state.readyFor === 150) {this.rotateColumn(2,1);}
    if (this.state.readyFor === 151) {this.rotateRow(2,5);}
    if (this.state.readyFor === 152) {this.rotateRow(1,3);}
    if (this.state.readyFor === 153) {this.rotateRow(0,5);}
    if (this.state.readyFor === 154) {this.rect(1,3);}
    if (this.state.readyFor === 155) {this.rotateRow(2,10);}
    if (this.state.readyFor === 156) {this.rotateRow(1,7);}
    if (this.state.readyFor === 157) {this.rotateRow(0,2);}
    if (this.state.readyFor === 158) {this.rotateColumn(3,2);}
    if (this.state.readyFor === 159) {this.rotateColumn(2,1);}
    if (this.state.readyFor === 160) {this.rotateColumn(0,1);}
    if (this.state.readyFor === 161) {this.rect(4,1);}
    if (this.state.readyFor === 162) {this.rotateRow(2,5);}
    if (this.state.readyFor === 163) {this.rotateRow(1,3);}
    if (this.state.readyFor === 164) {this.rotateRow(0,3);}
    if (this.state.readyFor === 165) {this.rect(1,3);}
    if (this.state.readyFor === 166) {this.rotateColumn(45,1);}
    if (this.state.readyFor === 167) {this.rotateRow(2,7);}
    if (this.state.readyFor === 168) {this.rotateRow(1,10);}
    if (this.state.readyFor === 169) {this.rotateRow(0,2);}
    if (this.state.readyFor === 170) {this.rotateColumn(3,1);}
    if (this.state.readyFor === 171) {this.rotateColumn(2,2);}
    if (this.state.readyFor === 172) {this.rotateColumn(0,1);}
    if (this.state.readyFor === 173) {this.rect(4,1);}
    if (this.state.readyFor === 174) {this.rotateRow(2,13);}
    if (this.state.readyFor === 175) {this.rotateRow(0,5);}
    if (this.state.readyFor === 176) {this.rotateColumn(3,1);}
    if (this.state.readyFor === 177) {this.rotateColumn(0,1);}
    if (this.state.readyFor === 178) {this.rect(4,1);}
    if (this.state.readyFor === 179) {this.rotateRow(3,10);}
    if (this.state.readyFor === 180) {this.rotateRow(2,10);}
    if (this.state.readyFor === 181) {this.rotateRow(0,5);}
    if (this.state.readyFor === 182) {this.rotateColumn(3,1);}
    if (this.state.readyFor === 183) {this.rotateColumn(2,1);}
    if (this.state.readyFor === 184) {this.rotateColumn(0,1);}
    if (this.state.readyFor === 185) {this.rect(4,1);}
    if (this.state.readyFor === 186) {this.rotateRow(3,8);}
    if (this.state.readyFor === 187) {this.rotateRow(0,5);}
    if (this.state.readyFor === 188) {this.rotateColumn(3,1);}
    if (this.state.readyFor === 189) {this.rotateColumn(2,1);}
    if (this.state.readyFor === 190) {this.rotateColumn(0,1);}
    if (this.state.readyFor === 191) {this.rect(4,1);}
    if (this.state.readyFor === 192) {this.rotateRow(3,17);}
    if (this.state.readyFor === 193) {this.rotateRow(2,20);}
    if (this.state.readyFor === 194) {this.rotateRow(0,15);}
    if (this.state.readyFor === 195) {this.rotateColumn(13,1);}
    if (this.state.readyFor === 196) {this.rotateColumn(12,3);}
    if (this.state.readyFor === 197) {this.rotateColumn(10,1);}
    if (this.state.readyFor === 198) {this.rotateColumn(8,1);}
    if (this.state.readyFor === 199) {this.rotateColumn(7,2);}
    if (this.state.readyFor === 200) {this.rotateColumn(6,1);}
    if (this.state.readyFor === 201) {this.rotateColumn(5,1);}
    if (this.state.readyFor === 202) {this.rotateColumn(3,1);}
    if (this.state.readyFor === 203) {this.rotateColumn(2,2);}
    if (this.state.readyFor === 204) {this.rotateColumn(0,1);}
    if (this.state.readyFor === 205) {this.rect(14,1);}
    if (this.state.readyFor === 206) {this.rotateRow(1,47);}
    if (this.state.readyFor === 207) {this.rotateColumn(9,1);}
    if (this.state.readyFor === 208) {this.rotateColumn(4,1);}
    if (this.state.readyFor === 209) {this.rotateRow(3,3);}
    if (this.state.readyFor === 210) {this.rotateRow(2,10);}
    if (this.state.readyFor === 211) {this.rotateRow(1,8);}
    if (this.state.readyFor === 212) {this.rotateRow(0,5);}
    if (this.state.readyFor === 213) {this.rotateColumn(2,2);}
    if (this.state.readyFor === 214) {this.rotateColumn(0,2);}
    if (this.state.readyFor === 215) {this.rect(3,2);}
    if (this.state.readyFor === 216) {this.rotateRow(3,12);}
    if (this.state.readyFor === 217) {this.rotateRow(2,10);}
    if (this.state.readyFor === 218) {this.rotateRow(0,10);}
    if (this.state.readyFor === 219) {this.rotateColumn(8,1);}
    if (this.state.readyFor === 220) {this.rotateColumn(7,3);}
    if (this.state.readyFor === 221) {this.rotateColumn(5,1);}
    if (this.state.readyFor === 222) {this.rotateColumn(3,1);}
    if (this.state.readyFor === 223) {this.rotateColumn(2,1);}
    if (this.state.readyFor === 224) {this.rotateColumn(1,1);}
    if (this.state.readyFor === 225) {this.rotateColumn(0,1);}
    if (this.state.readyFor === 226) {this.rect(9,1);}
    if (this.state.readyFor === 227) {this.rotateRow(0,20);}
    if (this.state.readyFor === 228) {this.rotateColumn(46,1);}
    if (this.state.readyFor === 229) {this.rotateRow(4,17);}
    if (this.state.readyFor === 230) {this.rotateRow(3,10);}
    if (this.state.readyFor === 231) {this.rotateRow(2,10);}
    if (this.state.readyFor === 232) {this.rotateRow(1,5);}
    if (this.state.readyFor === 233) {this.rotateColumn(8,1);}
    if (this.state.readyFor === 234) {this.rotateColumn(7,1);}
    if (this.state.readyFor === 235) {this.rotateColumn(6,1);}
    if (this.state.readyFor === 236) {this.rotateColumn(5,1);}
    if (this.state.readyFor === 237) {this.rotateColumn(3,1);}
    if (this.state.readyFor === 238) {this.rotateColumn(2,2);}
    if (this.state.readyFor === 239) {this.rotateColumn(1,1);}
    if (this.state.readyFor === 240) {this.rotateColumn(0,1);}
    if (this.state.readyFor === 241) {this.rect(9,1);}
    if (this.state.readyFor === 242) {this.rotateColumn(32,4);}
    if (this.state.readyFor === 243) {this.rotateRow(4,33);}
    if (this.state.readyFor === 244) {this.rotateRow(3,5);}
    if (this.state.readyFor === 245) {this.rotateRow(2,15);}
    if (this.state.readyFor === 246) {this.rotateRow(0,15);}
    if (this.state.readyFor === 247) {this.rotateColumn(13,1);}
    if (this.state.readyFor === 248) {this.rotateColumn(12,3);}
    if (this.state.readyFor === 249) {this.rotateColumn(10,1);}
    if (this.state.readyFor === 250) {this.rotateColumn(8,1);}
    if (this.state.readyFor === 251) {this.rotateColumn(7,2);}
    if (this.state.readyFor === 252) {this.rotateColumn(6,1);}
    if (this.state.readyFor === 253) {this.rotateColumn(5,1);}
    if (this.state.readyFor === 254) {this.rotateColumn(3,1);}
    if (this.state.readyFor === 255) {this.rotateColumn(2,1);}
    if (this.state.readyFor === 256) {this.rotateColumn(1,1);}
    if (this.state.readyFor === 257) {this.rotateColumn(0,1);}
    if (this.state.readyFor === 258) {this.rect(14,1);}
    if (this.state.readyFor === 259) {this.rotateColumn(39,3);}
    if (this.state.readyFor === 260) {this.rotateColumn(35,4);}
    if (this.state.readyFor === 261) {this.rotateColumn(20,4);}
    if (this.state.readyFor === 262) {this.rotateColumn(19,3);}
    if (this.state.readyFor === 263) {this.rotateColumn(10,4);}
    if (this.state.readyFor === 264) {this.rotateColumn(9,3);}
    if (this.state.readyFor === 265) {this.rotateColumn(8,3);}
    if (this.state.readyFor === 266) {this.rotateColumn(5,4);}
    if (this.state.readyFor === 267) {this.rotateColumn(4,3);}
    if (this.state.readyFor === 268) {this.rotateRow(5,5);}
    if (this.state.readyFor === 269) {this.rotateRow(4,5);}
    if (this.state.readyFor === 270) {this.rotateRow(3,33);}
    if (this.state.readyFor === 271) {this.rotateRow(1,30);}
    if (this.state.readyFor === 272) {this.rotateColumn(48,1);}
    if (this.state.readyFor === 273) {this.rotateColumn(47,5);}
    if (this.state.readyFor === 274) {this.rotateColumn(46,5);}
    if (this.state.readyFor === 275) {this.rotateColumn(45,1);}
    if (this.state.readyFor === 276) {this.rotateColumn(43,1);}
    if (this.state.readyFor === 277) {this.rotateColumn(38,3);}
    if (this.state.readyFor === 278) {this.rotateColumn(37,3);}
    if (this.state.readyFor === 279) {this.rotateColumn(36,5);}
    if (this.state.readyFor === 280) {this.rotateColumn(35,1);}
    if (this.state.readyFor === 281) {this.rotateColumn(33,1);}
    if (this.state.readyFor === 282) {this.rotateColumn(32,5);}
    if (this.state.readyFor === 283) {this.rotateColumn(31,5);}
    if (this.state.readyFor === 284) {this.rotateColumn(30,1);}
    if (this.state.readyFor === 285) {this.rotateColumn(23,4);}
    if (this.state.readyFor === 286) {this.rotateColumn(22,3);}
    if (this.state.readyFor === 287) {this.rotateColumn(21,3);}
    if (this.state.readyFor === 288) {this.rotateColumn(20,1);}
    if (this.state.readyFor === 289) {this.rotateColumn(12,2);}
    if (this.state.readyFor === 290) {this.rotateColumn(11,2);}
    if (this.state.readyFor === 291) {this.rotateColumn(3,5);}
    if (this.state.readyFor === 292) {this.rotateColumn(2,5);}
    if (this.state.readyFor === 293) {this.rotateColumn(1,3);}
    if (this.state.readyFor === 294) {this.rotateColumn(0,4);}
  }
}
