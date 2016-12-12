import React, { Component } from 'react';

import { INPUT_DATA } from './day9_data_sample';

const COMPRESS_REGEX = /\((\d+)x(\d+)\)/;

export default class Day9 extends Component {
  constructor() {
    super();
    var initialInputData = this.addPhonyPrefix(INPUT_DATA);
    this.state = {
      inputData: initialInputData,
      parsedData: this.computeParsedData(initialInputData),
      uncompressedLength: null
    }
    console.log('parsedData is');
    console.log(this.state.parsedData);
  }

  // if the input data starts with ordinary characters, prefix it
  // with a compression command that doesn't actually change it
  addPhonyPrefix(str) {
    // don't add a prefix to an empty string
    if (str.length === 0) {
      return str;
    }
    var match = str.match(COMPRESS_REGEX);
    // if the string has no compression commands, add one to the beginning
    if (match === null) {
      return (`(${str.length}x1)${str}`);
    }
    // if the first match is not at the beginning of the string, add it
    var firstPos = match.index;
    if (firstPos > 0) {
      return `(${firstPos}x1)${str}`;
    }
    // the compress command is already at the beginning, return str as-is
    return str;
  }

  // all we do to update state is compute the uncompressed length
  updateState() {
    this.setState({
      inputData: this.state.inputData,
      parsedData: this.state.parsedData,
      uncompressedLength: this.uncompressedLength()
    });
   }

  uncompressedLength() {
    return (
      this.state.parsedData.map(function(element) {
        return element.times * element.str.length
        }
      ).reduce(function(a, b) { return a + b }, 0)
    );
  }

  dummyParsedData() {
    // just the answer for the sample data, which is:
    // ADVENTA(1x5)BC(3x3)XYZA(2x2)BCD(2x2)EFG(6x1)(1x3)AX(8x2)(3x3)ABCY
    return([
      {times: 1, str: 'ADVENTA'},
      {times: 5, str: 'B'},
      {times: 1, str: 'C'},
      {times: 3, str: 'XYZ'},
      {times: 1, str: 'A'},
      {times: 2, str: 'BC'},
      {times: 1, str: 'D'},
      {times: 2, str: 'EF'},
      {times: 1, str: 'G'},
      {times: 1, str: '(1x3)A'},
      {times: 1, str: 'X'},
      {times: 2, str: '(3x3)ABC'},
      {times: 1, str: 'Y'},
    ]);
  }


  findNextRegex(inputData) {
    return(inputData.match(COMPRESS_REGEX));
  }

  // run by the characters in the array to create another array
  // with decompression instructions and data.
  computeParsedData(inputData) {
//    return this.dummyParsedData();
    // initialize our return value
    var parsedData = [];
    var remainingData = this.addPhonyPrefix(inputData);
    var compressCommandLength = 0;
    var compressLength = 0;
    var compressTimes = 0;
    var nextRegex = {};
    // the string being compressed
    var str = '';
    var offset = 0;
    while (remainingData.length > 0) {
      nextRegex = this.findNextRegex(remainingData);
      [compressCommandLength, compressLength, compressTimes] =
        [nextRegex[0].length,
        Number.parseInt(nextRegex[1], 10),
        Number.parseInt(nextRegex[2], 10)
        ];
      console.log(`remainingData: ${remainingData}`);
      console.log(`compressCommandLength: ${compressCommandLength}`);
      console.log(`compressLength: ${compressLength}`);
      str = remainingData.substr(compressCommandLength, compressLength);
      parsedData.push({times: compressTimes, str: str });
      offset = compressCommandLength + compressLength;
      console.log(`offset: ${offset}`);
      remainingData = this.addPhonyPrefix(remainingData.substr(offset));
      console.log(`new remainingData: ${remainingData}`);
    }
    return parsedData;
  }

  processNextInstruction() {
    this.updateState();
  }

  tick() {
    this.processNextInstruction();
  }

  renderParsedData() {
    return (
      this.state.parsedData.map(function(element) {
        return(`times: ${element.times}, str: ${element.str}`);
      }).join(' --- ')
    );
  }

  render() {
    console.log(this.state);
    return (
      <div>
        <h3>Day 9</h3>
        <p onClick={() => this.tick()}>Click me to run!</p>
        <div>
          <code>Current State:</code><br/>
          <code>Input Data:</code><br/>
          <code>{this.state.inputData}</code><br/>
          <code>Parsed Data:</code><br/>
          <code>{this.renderParsedData()}</code><br/>
          <code>Uncompressed Length:</code><br/>
          <code>{this.state.uncompressedLength}</code><br/>
        </div>
      </div>
    );
  }
}

