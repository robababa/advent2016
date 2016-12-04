import React, { Component } from 'react';
import { FULL_LIST as TRI_LIST } from './day3_data';

const BATCH_SIZE = 100;

export default class Day3 extends Component {
  constructor() {
    super();
    this.state = {
      batchRunCount: 0,
      totalRunCount: 0,
      validCount: 0,
      triangleList: this.transposeInitialList(TRI_LIST),
      history: [`(validCount: 0, triangleList: ${TRI_LIST})`]
    }
  }

  transposeInitialList() {
    console.log(TRI_LIST);
    var newArray = [];
    for (var i=0; i < TRI_LIST.length; i++) {
      if (i % 3 === 0) {
        newArray.push([ TRI_LIST[i][0], TRI_LIST[i+1][0], TRI_LIST[i+2][0] ]);
        newArray.push([ TRI_LIST[i][1], TRI_LIST[i+1][1], TRI_LIST[i+2][1] ]);
        newArray.push([ TRI_LIST[i][2], TRI_LIST[i+1][2], TRI_LIST[i+2][2] ]);
      }
    }
    return newArray;
  }

  componentDidUpdate(prevProps, prevState) {
    // keep going if we have more triangle candidates to inspect
    if ((this.state.triangleList.length > 0) &&
        (this.state.batchRunCount !== 0)) {
      this.tick();
    }
  }

  tick() {
    if (this.state.triangleList.length > 0) {
      var nextValid = this.isValidTriangle(this.state.triangleList[0]);
      var nextBatchRunCount = (this.state.batchRunCount + 1) % BATCH_SIZE;
      var nextTotalRunCount = this.state.totalRunCount + 1;
      var nextValidCount = this.state.validCount + nextValid;
      var nextTriangleList = this.state.triangleList.slice(1);
      this.setState({
        batchRunCount: nextBatchRunCount,
        totalRunCount: nextTotalRunCount,
        validCount: nextValidCount,
        triangleList:  nextTriangleList,
        history: this.state.history
//        history: [
//          `(validCount: ${nextValidCount}, triangleList: ${nextTriangleList})`,
//          ...this.state.history
//        ]
      });
    }
  }

  isValidTriangle(triangleToCheck) {
    var perimeter = triangleToCheck.reduce(function(a,b) { return a + b; }, 0);
    var maxSide = Math.max(...triangleToCheck);
    return (maxSide * 2 < perimeter) ? 1 : 0;
  }


  displayTriangleList() {
    return `(${this.state.triangleList.join("),(")})`
  }

  displayHistory() {
    return this.state.history.join("\n");
  }


  render() {
    return (
      <div>
        <h3>Day 3</h3>
        <p onClick={() => this.tick()}>Click me to run!</p>
        <p><code>Current State:</code></p>
        <p><code>batchRunCount: {this.state.batchRunCount}</code></p>
        <p><code>totalRunCount: {this.state.totalRunCount}</code></p>
        <p><code>validCount: {this.state.validCount}</code></p>
        <p><code>triangleList: {this.displayTriangleList()}</code></p>
        <code><pre>history: {this.displayHistory()}</pre></code>
      </div>
    );
  }
}


