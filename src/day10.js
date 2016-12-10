import React, { Component } from 'react';
import { INSTRUCTION_ARRAY } from './day10_data';

export default class Day10 extends Component {
  constructor() {
    super();
    this.state = {
      instructionArray: INSTRUCTION_ARRAY,
      botChips: {},
      outputChips: {},
      // bots are taking chips in the first pass, then
      // passing them out in the second pass
      takingChips: true,
      currentInstruction: 0,
      keepGoing: true

    }
  }

  updateState(botChips, outputChips) {
    // first, see how to advance to the next instruction
    var takingChips = this.state.takingChips;
    var nextInstruction = this.state.currentInstruction + 1;
    var keepGoing = this.state.keepGoing;
    if (nextInstruction >= INSTRUCTION_ARRAY.length && ! takingChips) {
      // we just finished giving back chips, so we are done
      keepGoing = false;
    } else if (nextInstruction >= INSTRUCTION_ARRAY.length) {
      // we just finished taking chips, so now it is time to give them back
      nextInstruction = 0;
      takingChips = false;
    }

    this.setState({
      instructionArray: INSTRUCTION_ARRAY,
      botChips: botChips,
      outputChips: outputChips,
      takingChips: takingChips,
      currentInstruction: nextInstruction,
      keepGoing: keepGoing
    });
    console.log(this.state);
  }

  getInstruction() {
    return this.state.instructionArray[this.state.currentInstruction];
  }

  processTakeChip() {
    var myInstruction = this.getInstruction();
    if (myInstruction[0] === 'value') {
      // this instruction says take a chip, so do it
      var botChips = this.state.botChips;
      var [_, chipNumber, __, botNumber] = myInstruction;
      if (botChips[botNumber] === undefined) {
        botChips[botNumber] = [];
      }
      botChips[botNumber].push(chipNumber);
      console.log("Bot ", botNumber, " is TAKING chip ", chipNumber);

      this.updateState(botChips, this.state.outputChips);
    } else {
      // do nothing (update state with existing values)
      this.updateState(this.state.botChips, this.state.outputChips);
    }
  }

  processPassChips() {
    var myInstruction = this.getInstruction();
    if (myInstruction[0] !== 'bot') {
      // do not change state and return
      this.updateState(this.state.botChips, this.state.outputChips);
      return;
    }
    // this instruction says pass chips, so do it
    var {botChips, outputChips} = this.state;
    var [_, bot, lowType, lowNumber, highType, highNumber] = myInstruction;
    var [lowChip, highChip] = botChips[bot].sort();
    console.log(
      `Bot ${bot} is GIVING chip ${lowChip} to ${lowType} ${lowNumber}`,
      `and chip ${highChip} to ${highType} ${highNumber}`
    );

    this.updateState(this.state.botChips, this.state.outputChips);
  }

  processNextInstruction() {
    if (this.state.takingChips) {
      this.processTakeChip();
    } else {
      this.processPassChips();
    }
  }

  tick() {
    this.processNextInstruction();
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
}
