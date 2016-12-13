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
      c_value: 0,
      d_value: 0
    }
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
          <code>Instruction Array:</code><br/>
          <code>{this.renderInstructionArray()}</code><br/>
          <code>Value of a:</code><br/>
          <code>{this.state.a_value}</code><br/>
        </p>
      </div>
    );
  }

  processInstructions() {
    var myState = this.state;
  }

  tick() {
    null;
  }
}

