import React, { Component } from 'react';

const BATHROOM_CODE="ULL\nRRDDD\nLURDL\nUUUUD";

// 789
// 456
// 123

const LEFT_MOVES = {
  '1': '1',
  '2': '1',
  '3': '2',
  '4': '4',
  '5': '4',
  '6': '5',
  '7': '7',
  '8': '7',
  '9': '8'
};

const RIGHT_MOVES = {
  '1': '2',
  '2': '3',
  '3': '3',
  '4': '5',
  '5': '6',
  '6': '6',
  '7': '8',
  '8': '9',
  '9': '9'
};

const UP_MOVES = {
  '1': '4',
  '2': '5',
  '3': '6',
  '4': '7',
  '5': '8',
  '6': '9',
  '7': '7',
  '8': '8',
  '9': '9'
};

const DOWN_MOVES = {
  '1': '1',
  '2': '2',
  '3': '3',
  '4': '1',
  '5': '2',
  '6': '3',
  '7': '4',
  '8': '5',
  '9': '6'
};

export default class Day2 extends Component {
  constructor() {
    super();
    const INITIAL_INSTRUCTIONS = BATHROOM_CODE.split("\n");
    this.state = {
      currentKey: '5',
      secretCode: '',
      instructions: INITIAL_INSTRUCTIONS,
      history: [`(currentKey: 5, secretCode: , instructions: [${INITIAL_INSTRUCTIONS}])`]
    }
  }

  componentDidUpdate() {
    if (this.state.instructions.length > 0) {
      this.tick();
    }
  }

  tick() {
    // we only do work if there are more instructions to follow
    if (this.state.instructions.length > 0)
    {
      this.advanceOne();
    }
  }

  advanceOne() {
    if (this.state.instructions[0].length === 0) {
      this.addCurrentKeyToCode();
    } else {
      this.applyInstruction();
   }
  }

  addCurrentKeyToCode() {
    this.updateState(this.state.currentKey,
        this.state.secretCode + this.state.currentKey,
        this.state.instructions.slice(1));
  }

  applyInstruction() {
    var currentLine = this.state.instructions[0];
    var futureLines = this.state.instructions.slice(1);
    var nextMove = currentLine.substr(0, 1);
    var movesAfterThat = currentLine.substr(1);
    var nextKey = this.computeNext(nextMove);
    this.updateState(nextKey,
        this.state.secretCode,
        [movesAfterThat, ...futureLines]);
  }

  updateState(nextKey, nextSecretCode, nextInstructions) {
    this.setState({
      currentKey: nextKey,
      secretCode: nextSecretCode,
      instructions: nextInstructions,
      history: [ ...this.state.history ]
    });
  }


  computeNext(nextMove) {
    var curKey = this.state.currentKey;
    switch(nextMove) {
      case 'U':
        return UP_MOVES[curKey];
      case 'D':
        return DOWN_MOVES[curKey];
      case 'L':
        return LEFT_MOVES[curKey];
      case 'R':
        return RIGHT_MOVES[curKey];
      default:
        // should never get here
        return this.state.currentKey;
    }
  }

  displayInstructions() {
    return this.state.instructions.join(",")
  }

  render() {
    return (
      <div>
        <h3>Day 2</h3>
        <p onClick={() => this.tick()}>Click me to run!</p>
        <p><code>Current State:</code></p>
        <p><code>currentKey: {this.state.currentKey}</code></p>
        <p><code>secretCode: {this.state.secretCode}</code></p>
        <p><code>instructions: {this.displayInstructions()}</code></p>
        <code>history: {this.state.history}</code>
      </div>
    );
  }
}

