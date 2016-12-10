import React, { Component } from 'react';
import { INSTRUCTION_ARRAY } from './day10_data';

export default class Day10 extends Component {
  constructor() {
    super();
    this.state = {
      instructionArray: INSTRUCTION_ARRAY,
      botChips: {},

    }
    console.log(INSTRUCTION_ARRAY);
  }

  updateState(arr) {
    this.setState(this.state);
  }

  renderInstructionArray() {
    return (
      <div>
        { this.state.instructionArray.map(function(element, index){
           return <div key={index}><code>{element.join(",")}</code><br/></div>;
          })
        }
      </div>
    );
  }

  render() {
    return (
      <div>
        <h3>Day 10</h3>
        <p onClick={() => this.tick()}>Click me to run!</p>
        <div>
          <code>Current State:</code><br/>
          <code>Instructions:</code><br/>
          { this.renderInstructionArray() }
        </div>
      </div>
    );
  }

  tick() {
    var sum = 0;
    return sum;
  }
}
