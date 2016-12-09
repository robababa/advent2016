import React, { Component } from 'react';

export default class Day8 extends Component {
  constructor() {
    super();
    var arr =[
      ['.','.','.','.','.','.','.','.'],
      ['.','.','.','.','.','.','.','.'],
      ['.','.','.','.','.','.','.','.']
    ]
    this.state = {
      screenPixels: arr,
      litPixelCount: 0
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
      litPixelCount: litPixelCount
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
        <p><code>Current State:</code></p>
        <p><code>{this.state.screenPixels[0]}</code></p>
        <p><code>{this.state.screenPixels[1]}</code></p>
        <p><code>{this.state.screenPixels[2]}</code></p>
        <p><code>Lit Pixel Count: {this.state.litPixelCount}</code></p>
      </div>
    );
  }

  tick() {
    this.rect(3,2);
    this.rotateColumn(1,1);
    this.rotateRow(0,4);
    this.rotateColumn(1,1);
  }
}
