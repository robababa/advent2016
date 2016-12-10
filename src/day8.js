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
    this.rect(1,1);
    this.rotateRow(0,5);
    this.rect(1,1);
    this.rotateRow(0,5);
    this.rect(1,1);
    this.rotateRow(0,5);
    this.rect(1,1);
    this.rotateRow(0,5);
    this.rect(1,1);
    this.rotateRow(0,2);
    this.rect(1,1);
    this.rotateRow(0,2);
    this.rect(1,1);
    this.rotateRow(0,3);
    this.rect(1,1);
    this.rotateRow(0,3);
    this.rect(2,1);
    this.rotateRow(0,2);
    this.rect(1,1);
    this.rotateRow(0,3);
    this.rect(2,1);
    this.rotateRow(0,2);
    this.rect(1,1);
    this.rotateRow(0,3);
    this.rect(2,1);
    this.rotateRow(0,5);
    this.rect(4,1);
    this.rotateRow(0,5);
    this.rotateColumn(0,1);
    this.rect(4,1);
    this.rotateRow(0,10);
    this.rotateColumn(5,2);
    this.rotateColumn(0,1);
    this.rect(9,1);
    this.rotateRow(2,5);
    this.rotateRow(0,5);
    this.rotateColumn(0,1);
    this.rect(4,1);
    this.rotateRow(2,5);
    this.rotateRow(0,5);
    this.rotateColumn(0,1);
    this.rect(4,1);
    this.rotateColumn(40,1);
    this.rotateColumn(27,1);
    this.rotateColumn(22,1);
    this.rotateColumn(17,1);
    this.rotateColumn(12,1);
    this.rotateColumn(7,1);
    this.rotateColumn(2,1);
    this.rotateRow(2,5);
    this.rotateRow(1,3);
    this.rotateRow(0,5);
    this.rect(1,3);
    this.rotateRow(2,10);
    this.rotateRow(1,7);
    this.rotateRow(0,2);
    this.rotateColumn(3,2);
    this.rotateColumn(2,1);
    this.rotateColumn(0,1);
    this.rect(4,1);
    this.rotateRow(2,5);
    this.rotateRow(1,3);
    this.rotateRow(0,3);
    this.rect(1,3);
    this.rotateColumn(45,1);
    this.rotateRow(2,7);
    this.rotateRow(1,10);
    this.rotateRow(0,2);
    this.rotateColumn(3,1);
    this.rotateColumn(2,2);
    this.rotateColumn(0,1);
    this.rect(4,1);
    this.rotateRow(2,13);
    this.rotateRow(0,5);
    this.rotateColumn(3,1);
    this.rotateColumn(0,1);
    this.rect(4,1);
    this.rotateRow(3,10);
    this.rotateRow(2,10);
    this.rotateRow(0,5);
    this.rotateColumn(3,1);
    this.rotateColumn(2,1);
    this.rotateColumn(0,1);
    this.rect(4,1);
    this.rotateRow(3,8);
    this.rotateRow(0,5);
    this.rotateColumn(3,1);
    this.rotateColumn(2,1);
    this.rotateColumn(0,1);
    this.rect(4,1);
    this.rotateRow(3,17);
    this.rotateRow(2,20);
    this.rotateRow(0,15);
    this.rotateColumn(13,1);
    this.rotateColumn(12,3);
    this.rotateColumn(10,1);
    this.rotateColumn(8,1);
    this.rotateColumn(7,2);
    this.rotateColumn(6,1);
    this.rotateColumn(5,1);
    this.rotateColumn(3,1);
    this.rotateColumn(2,2);
    this.rotateColumn(0,1);
    this.rect(14,1);
    this.rotateRow(1,47);
    this.rotateColumn(9,1);
    this.rotateColumn(4,1);
    this.rotateRow(3,3);
    this.rotateRow(2,10);
    this.rotateRow(1,8);
    this.rotateRow(0,5);
    this.rotateColumn(2,2);
    this.rotateColumn(0,2);
    this.rect(3,2);
    this.rotateRow(3,12);
    this.rotateRow(2,10);
    this.rotateRow(0,10);
    this.rotateColumn(8,1);
    this.rotateColumn(7,3);
    this.rotateColumn(5,1);
    this.rotateColumn(3,1);
    this.rotateColumn(2,1);
    this.rotateColumn(1,1);
    this.rotateColumn(0,1);
    this.rect(9,1);
    this.rotateRow(0,20);
    this.rotateColumn(46,1);
    this.rotateRow(4,17);
    this.rotateRow(3,10);
    this.rotateRow(2,10);
    this.rotateRow(1,5);
    this.rotateColumn(8,1);
    this.rotateColumn(7,1);
    this.rotateColumn(6,1);
    this.rotateColumn(5,1);
    this.rotateColumn(3,1);
    this.rotateColumn(2,2);
    this.rotateColumn(1,1);
    this.rotateColumn(0,1);
    this.rect(9,1);
    this.rotateColumn(32,4);
    this.rotateRow(4,33);
    this.rotateRow(3,5);
    this.rotateRow(2,15);
    this.rotateRow(0,15);
    this.rotateColumn(13,1);
    this.rotateColumn(12,3);
    this.rotateColumn(10,1);
    this.rotateColumn(8,1);
    this.rotateColumn(7,2);
    this.rotateColumn(6,1);
    this.rotateColumn(5,1);
    this.rotateColumn(3,1);
    this.rotateColumn(2,1);
    this.rotateColumn(1,1);
    this.rotateColumn(0,1);
    this.rect(14,1);
    this.rotateColumn(39,3);
    this.rotateColumn(35,4);
    this.rotateColumn(20,4);
    this.rotateColumn(19,3);
    this.rotateColumn(10,4);
    this.rotateColumn(9,3);
    this.rotateColumn(8,3);
    this.rotateColumn(5,4);
    this.rotateColumn(4,3);
    this.rotateRow(5,5);
    this.rotateRow(4,5);
    this.rotateRow(3,33);
    this.rotateRow(1,30);
    this.rotateColumn(48,1);
    this.rotateColumn(47,5);
    this.rotateColumn(46,5);
    this.rotateColumn(45,1);
    this.rotateColumn(43,1);
    this.rotateColumn(38,3);
    this.rotateColumn(37,3);
    this.rotateColumn(36,5);
    this.rotateColumn(35,1);
    this.rotateColumn(33,1);
    this.rotateColumn(32,5);
    this.rotateColumn(31,5);
    this.rotateColumn(30,1);
    this.rotateColumn(23,4);
    this.rotateColumn(22,3);
    this.rotateColumn(21,3);
    this.rotateColumn(20,1);
    this.rotateColumn(12,2);
    this.rotateColumn(11,2);
    this.rotateColumn(3,5);
    this.rotateColumn(2,5);
    this.rotateColumn(1,3);
    this.rotateColumn(0,4);
  }
}
