import React, { Component } from 'react';

//const DIRECTIONS="R1, R3, L1, L10";

const DIRECTIONS="R3, L2, L2, R4, L1, R2, R3, R4, L2, R4, L2, L5, L1, R5, R2, R2, L1, R4, R1, L5, L3, R4, R3, R1, L1, L5, L4, L2, R5, L3, L4, R3, R1, L3, R1, L3, R3, L4, R2, R5, L190, R2, L3, R47, R4, L3, R78, L1, R3, R190, R4, L3, R4, R2, R5, R3, R4, R3, L1, L4, R3, L4, R1, L4, L5, R3, L3, L4, R1, R2, L4, L3, R3, R3, L2, L5, R1, L4, L1, R5, L5, R1, R5, L4, R2, L2, R1, L5, L4, R4, R4, R3, R2, R3, L1, R4, R5, L2, L5, L4, L1, R4, L4, R4, L4, R1, R5, L1, R1, L5, R5, R1, R1, L3, L1, R4, L1, L4, L4, L3, R1, R4, R1, R1, R2, L5, L2, R4, L1, R3, L5, L2, R5, L4, R5, L5, R3, R4, L3, L3, L2, R2, L5, L5, R3, R4, R3, R4, R3, R1";

export default class Day1 extends Component {
  constructor() {
    super();
    this.state = {
      direction: 'N',
      xPosition: 0,
      yPosition: 0,
      instructions: DIRECTIONS.split(", "),
      history: []
    }
  }

  newDirection(currentDirection, instruction) {
    // combine current direction with the turn
    var input  = currentDirection + instruction.substr(0, 1);
    // calculate the new direction
    // example: if East turning left, or West turning right, then it is North
    if ((input === 'EL' || input === 'WR')) {
      return 'N';
    } else if((input === 'SL' || input === 'NR')) {
      return 'E';
    } else if ((input === 'WL' || input === 'ER')) {
      return 'S';
    } else if ((input === 'NL' || input === 'SR')) {
      return 'W'; }
    else {
      console.log('newDirection could not understand input = ', input);
    }
  }

  condensedState() {
    var s = this.state;
    return(
      `dir: ${s.direction}, x: ${s.xPosition}, y: ${s.yPosition} instr: ${s.instructions}`
    );
  }

  jumpSize(instruction) {
    return (Number.parseInt(instruction.substr(1), 10))
  }

  newXPosition(nextDirection, nextJump) {
    var curX = this.state.xPosition;
    if (nextDirection === 'E') {
      return curX + nextJump
    } else if (nextDirection === 'W') {
      return curX - nextJump
    } else {
      return curX
    }
  }

  newYPosition(nextDirection, nextJump) {
    var curY = this.state.yPosition;
    if (nextDirection === 'N') {
      return curY + nextJump
    } else if (nextDirection === 'S') {
      return curY - nextJump
    } else {
      return curY
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
    var nextInstruction = this.state.instructions[0];
    var nextDirection = this.newDirection(this.state.direction, nextInstruction);
    var nextJump = this.jumpSize(nextInstruction);
    var nextX = this.newXPosition(nextDirection, nextJump);
    var nextY = this.newYPosition(nextDirection, nextJump);
    var archivedState = this.condensedState();
    // set the next state
    this.setState({
      direction: nextDirection,
      xPosition: nextX,
      yPosition: nextY,
      instructions: this.state.instructions.slice(1),
      history: [archivedState, this.state.history]
    });
  }

  render() {
    return (
      <div>
        <h3>Day 1</h3>
        <p onClick={() => this.tick()}>Click me to advance one instruction!</p>
        <p><code>Current State:</code></p>
        <p><code>direction: {this.state.direction}</code></p>
        <p><code>xPosition: {this.state.xPosition}</code></p>
        <p><code>yPosition: {this.state.yPosition}</code></p>
        <p><code>instructions: {this.state.instructions}</code></p>
        <code>history: {this.state.history}</code>
      </div>
    );
  }
}
