import React, { Component } from 'react';
import { INSTRUCTION_ARRAY } from './day12_data';


export default class Day12 extends Component {
  constructor() {
    super();
    this.state = {
      commands: INSTRUCTION_ARRAY,
      nextCommand: 0,
      a_value: 0,
      b_value: 0,
      c_value: 1,
      d_value: 0,
      done: 'NO'
    }
  }

  copyValue(myState, arg1) {
    var returnVal = 0;
    switch(arg1) {
      case 'a':
        returnVal = myState.a_value;
        break;
      case 'b':
        returnVal = myState.b_value;
        break;
      case 'c':
        returnVal = myState.c_value;
        break;
      case 'd':
        returnVal = myState.d_value;
        break;
      default:
        returnVal = Number.parseInt(arg1, 10);
        break;
    }
    return (returnVal);
  }

  processCopy(myState, arg1, arg2) {
    switch(arg2) {
      case 'a':
        myState.a_value = this.copyValue(myState, arg1);
        break;
      case 'b':
        myState.b_value = this.copyValue(myState, arg1);
        break;
      case 'c':
        myState.c_value = this.copyValue(myState, arg1);
        break;
      case 'd':
        myState.d_value = this.copyValue(myState, arg1);
        break;
      default:
        break;
    }
    myState.nextCommand += 1;
  }

  processInc(myState, arg1) {
    switch(arg1) {
      case 'a':
        myState.a_value += 1;
        break;
      case 'b':
        myState.b_value += 1;
        break;
      case 'c':
        myState.c_value += 1;
        break;
      case 'd':
        myState.d_value += 1;
        break;
      default:
        break;
    }
    myState.nextCommand += 1;
  }

  processDec(myState, arg1) {
    switch(arg1) {
      case 'a':
        myState.a_value -= 1;
        break;
      case 'b':
        myState.b_value -= 1;
        break;
      case 'c':
        myState.c_value -= 1;
        break;
      case 'd':
        myState.d_value -= 1;
        break;
      default:
        break;
    }
    myState.nextCommand += 1;
  }

  processJnz(myState, arg1, arg2) {
    var jumpSwitch = 0;
    switch(arg1) {
      case 'a':
        jumpSwitch = myState.a_value;
        break;
      case 'b':
        jumpSwitch = myState.b_value;
        break;
      case 'c':
        jumpSwitch = myState.c_value;
        break;
      case 'd':
        jumpSwitch = myState.d_value;
        break;
      case 0:
        break;
      case '0':
        break;
      default:
        jumpSwitch = Number.parseInt(arg1, 10);
    }
    if (jumpSwitch === 0) {
      myState.nextCommand += 1;
    } else {
      myState.nextCommand += Number.parseInt(arg2, 10);
    }
  }

  processNextInstruction(myState) {
    var {command, arg1, arg2} = myState.commands[myState.nextCommand];
    switch(command) {
      case 'cpy':
        this.processCopy(myState, arg1, arg2);
        break;
      case 'inc':
        this.processInc(myState, arg1);
        break;
      case 'dec':
        this.processDec(myState, arg1);
        break;
      case 'jnz':
        this.processJnz(myState, arg1, arg2);
        break;
      default:
        break;
    }
  }

  processInstructions() {
    var myState = this.state;
    while (myState.nextCommand < myState.commands.length) {
      this.processNextInstruction(myState);
    }
    myState.done = 'YES';
    this.setState(myState);
  }

  tick() {
    this.processInstructions();
  }

  renderInstructionArray() {
    return(
      this.state.commands.map(function(el) {
        return `${el.command}...${el.arg1}...${el.arg2}`;
      }
      ).join(' --- ')
    );
  }

  render() {
    return (
      <div>
        <h3>Day 12</h3>
        <p onClick={() => this.tick()}>Click me to run!</p>
        <p>
          <code>Current State:</code><br/>
          <code>Value of nextCommand:</code><br/>
          <code>{this.state.nextCommand}</code><br/>
          <code>Value of a:</code><br/>
          <code>{this.state.a_value}</code><br/>
          <code>Value of b:</code><br/>
          <code>{this.state.b_value}</code><br/>
          <code>Value of c:</code><br/>
          <code>{this.state.c_value}</code><br/>
          <code>Value of d:</code><br/>
          <code>{this.state.d_value}</code><br/>
          <code>Value of done:</code><br/>
          <code>{this.state.done}</code><br/>
          <code>Instruction Array:</code><br/>
          <code>{this.renderInstructionArray()}</code><br/>
        </p>
      </div>
    );
  }
}

