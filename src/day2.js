import React, { Component } from 'react';

const BATHROOM_CODE="ULL\nRRDDD\nLURDL\nUUUUD";

//const BATHROOM_CODE="DDDURLURURUDLDURRURULLRRDULRRLRLRURDLRRDUDRUDLRDUUDRRUDLLLURLUURLRURURLRLUDDURUULDURDRUUDLLDDDRLDUULLUDURRLUULUULDLDDULRLDLURURUULRURDULLLURLDRDULLULRRRLRLRULLULRULUUULRLLURURDLLRURRUUUDURRDLURUURDDLRRLUURLRRULURRDDRDULLLDRDDDDURURLLULDDULLRLDRLRRDLLURLRRUDDDRDLLRUDLLLLRLLRUDDLUUDRLRRRDRLRDLRRULRUUDUUDULLRLUDLLDDLLDLUDRURLULDLRDDLDRUDLDDLDDDRLLDUURRUUDLLULLRLDLUURRLLDRDLRRRRUUUURLUUUULRRUDDUDDRLDDURLRLRLLRRUDRDLRLDRRRRRRUDDURUUUUDDUDUDU\nRLULUULRDDRLULRDDLRDUURLRUDDDUULUUUDDRDRRRLDUURDURDRLLLRDDRLURLDRRDLRLUURULUURDRRULRULDULDLRRDDRLDRUDUDDUDDRULURLULUDRDUDDDULRRRURLRRDLRDLDLLRLUULURLDRURRRLLURRRRRLLULRRRDDLRLDDUULDLLRDDRLLUUDRURLRULULRLRUULUUUUUDRURLURLDDUDDLRDDLDRRLDLURULUUDRDLULLURDLLLRRDRURUDDURRLURRDURURDLRUDRULUULLDRLRRDRLDDUDRDLLRURURLUDUURUULDURUDULRLRDLDURRLLDRDUDRUDDRLRURUDDLRRDLLLDULRRDRDRRRLURLDLURRDULDURUUUDURLDLRURRDRULLDDLLLRUULLLLURRRLLLDRRUDDDLURLRRRDRLRDLUUUDDRULLUULDURLDUUURUDRURUDRDLRRLDRURRLRDDLLLULUDDUULDURLRUDRDDD\nRDDRUDLRLDDDRLRRLRRLUULDRLRUUURULRRLUURLLLRLULDDLDLRLULULUUDDDRLLLUDLLRUDURUDDLLDUDLURRULLRDLDURULRLDRLDLDRDDRUDRUULLLLRULULLLDDDULUUDUUDDLDRLRRDLRLURRLLDRLDLDLULRLRDLDLRLUULLDLULRRRDDRUULDUDLUUUUDUDRLUURDURRULLDRURUDURDUULRRULUULULRLDRLRLLRRRLULURLUDULLDRLDRDRULLUUUDLDUUUDLRDULRDDDDDDDDLLRDULLUDRDDRURUDDLURRUULUURURDUDLLRRRRDUDLURLLURURLRDLDUUDRURULRDURDLDRUDLRRLDLDULRRUDRDUUDRLURUURLDLUDLLRDDRDU\nLLDDDDLUDLLDUDURRURLLLLRLRRLDULLURULDULDLDLLDRRDLUDRULLRUUURDRLLURDDLLUDDLRLLRDDLULRLDDRURLUDRDULLRUDDLUURULUUURURLRULRLDLDDLRDLDLLRUURDLUDRRRDDRDRLLUDDRLDRLLLRULRDLLRLRRDDLDRDDDUDUDLUULDLDUDDLRLDUULRULDLDULDDRRLUUURUUUDLRDRULDRRLLURRRDUDULDUDUDULLULLULULURLLRRLDULDULDLRDDRRLRDRLDRLUDLLLUULLRLLRLDRDDRUDDRLLDDLRULLLULRDDDLLLDRDLRULDDDLULURDULRLDRLULDDLRUDDUDLDDDUDRDRULULDDLDLRRDURLLRLLDDURRLRRULLURLRUDDLUURULULURLRUDLLLUDDURRLURLLRLLRRLDULRRUDURLLDDRLDLRRLULUULRRUURRRDULRLRLRDDRDULULUUDULLLLURULURRUDRLL\nUULLULRUULUUUUDDRULLRLDDLRLDDLULURDDLULURDRULUURDLLUDDLDRLUDLLRUURRUDRLDRDDRRLLRULDLLRUUULLLDLDDULDRLRURLDRDUURLURDRUURUULURLRLRRURLDDDLLDDLDDDULRUDLURULLDDRLDLUDURLLLLLRULRRLLUDRUURLLURRLLRDRLLLRRDDDRRRDLRDRDUDDRLLRRDRLRLDDDLURUUUUULDULDRRRRLUDRLRDRUDUDDRULDULULDRUUDUULLUDULRLRRURDLDDUDDRDULLUURLDRDLDDUURULRDLUDDLDURUDRRRDUDRRDRLRLULDRDRLRLRRUDLLLDDDRURDRLRUDRRDDLDRRLRRDLUURLRDRRUDRRDLDDDLRDDLRDUUURRRUULLDDDLLRLDRRLLDDRLRRRLUDLRURULLDULLLUDLDLRLLDDRDRUDLRRDDLUU";

const LEFT_MOVES = {
  '1': '1',
  '2': '2',
  '3': '2',
  '4': '3',
  '5': '5',
  '6': '5',
  '7': '6',
  '8': '7',
  '9': '8',
  'A': 'A',
  'B': 'A',
  'C': 'B',
  'D': 'D'
};

const RIGHT_MOVES = {
  '1': '1',
  '2': '3',
  '3': '4',
  '4': '4',
  '5': '6',
  '6': '7',
  '7': '8',
  '8': '9',
  '9': '9',
  'A': 'B',
  'B': 'C',
  'C': 'C',
  'D': 'D'
};

//     1
//   2 3 4
// 5 6 7 8 9
//   A B C
//     D

const UP_MOVES = {
  '1': '1',
  '2': '2',
  '3': '1',
  '4': '4',
  '5': '5',
  '6': '2',
  '7': '3',
  '8': '4',
  '9': '9',
  'A': '6',
  'B': '7',
  'C': '8',
  'D': 'B'
};

const DOWN_MOVES = {
  '1': '3',
  '2': '6',
  '3': '7',
  '4': '8',
  '5': '5',
  '6': 'A',
  '7': 'B',
  '8': 'C',
  '9': '9',
  'A': 'A',
  'B': 'D',
  'C': 'C',
  'D': 'D'
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

  componentDidUpdate(prevProps, prevState) {
    // keep going only if we haven't found the next key in the code yet
    if (this.state.instructions.length > 0 &&
        this.state.secretCode === prevState.secretCode) {
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
      history: [
        `(currentKey: ${nextKey}, secretCode: ${nextSecretCode}, instructions: [${nextInstructions}])`,
        ...this.state.history ]
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

  displayHistory() {
    return this.state.history.join("\n");
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
        <code><pre>history: {this.displayHistory()}</pre></code>
      </div>
    );
  }
}

