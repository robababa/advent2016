import React, { Component } from 'react';
import { INSTRUCTION_ARRAY } from './day10_data';

export default class Day10 extends Component {
  constructor() {
    super();
    this.state = {
      instructionArray: INSTRUCTION_ARRAY,
      botChips: {},
      outputChips: {},
      currentInstruction: 0,
      completedInstructions: []
    }
  }


  instructionsLeft() {
    var s = this.state;
    return (s.completedInstructions.length < s.instructionArray.length);
  }

  componentDidUpdate() {
    if (this.instructionsLeft())
    {
      this.processNextInstruction();
    }
  }

  // from where we are, which instruction will be next?
  computeNextInstruction() {
    var instrCount = this.state.instructionArray.length;
    return ((this.state.currentInstruction + 1) % instrCount);
  }

  // We might skip an instruction if we already ran it, or we can't run it
  skipInstruction() {
    var newState = this.state;
    newState.currentInstruction = this.computeNextInstruction();
    this.setState(newState);
    console.log(this.state);
  }

  markInstructionComplete(botChips, outputChips) {
    var s = this.state;
    var arr = s.completedInstructions;
    arr.push(s.currentInstruction);
    this.setState({
      instructionArray: INSTRUCTION_ARRAY,
      botChips: botChips,
      outputChips: outputChips,
      currentInstruction: this.computeNextInstruction(),
      completedInstructions: arr
    });
    console.log(this.state);
  }

  getInstruction() {
    return this.state.instructionArray[this.state.currentInstruction];
  }

  processTakeChip() {
    var [_1, chip, _2, bot] = this.getInstruction();
    var botChips = this.state.botChips;
    if (botChips[bot] === undefined) {
      botChips[bot] = [];
    }
    botChips[bot].push(chip);
    console.log(`Bot ${bot} is TAKING chip ${chip}`);
    this.markInstructionComplete(botChips, this.state.outputChips);
  }

  processPassChips() {
    var myInstruction = this.getInstruction();
    var [_, bot, lowType, lowNumber, highType, highNumber] = myInstruction;
    var {botChips, outputChips} = this.state;
    var [lowChip, highChip] = botChips[bot].sort();
    console.log(
      `Bot ${bot} is GIVING chip ${lowChip} to ${lowType} ${lowNumber}`,
      `and chip ${highChip} to ${highType} ${highNumber}`
    );
    // add the low and high chips to the bots/outputs, and remove them from
    // the donor bot
    if (lowType === 'bot') {
      if (botChips[lowNumber] === undefined) {botChips[lowNumber] = [];}
      botChips[lowNumber].push(lowChip);
    } else {
      if (outputChips[lowNumber] === undefined) {outputChips[lowNumber] = [];}
      outputChips[lowNumber].push(lowChip);
    }
    if (highType === 'bot') {
      if (botChips[highNumber] === undefined) {botChips[highNumber] = [];}
      botChips[highNumber].push(highChip);
    } else {
      if (outputChips[highNumber] === undefined) {outputChips[highNumber] = [];}
      outputChips[highNumber].push(highChip);
    }
    botChips[bot] = [];

    this.markInstructionComplete(this.state.botChips, this.state.outputChips);
  }

  impossiblePassInstruction() {
    var instruct = this.getInstruction();

    if (instruct[0] === 'bot' &&
        (this.state.botChips[instruct[1]]  === undefined
         ||
         this.state.botChips[instruct[1]].length < 2)
       ) {
      return true;
    } else {
      return false;
    }
  }

  shouldSkipInstruction() {
    var s = this.state;
    var curInst = s.currentInstruction
    if (s.completedInstructions.includes(curInst)) {
      console.log(`Will skip instruction ${curInst} - already done`);
      return true;
    }

    if (this.impossiblePassInstruction()) {
      console.log(`Will skip instruction ${curInst} - cannot do`);
      return true;
    } else {
      return false;
    }
  }

  processNextInstruction() {
    if (! this.instructionsLeft() ) {
      return;
    }
    if (this.shouldSkipInstruction()) {
      this.skipInstruction();
    } else {
      if (this.state.instructionArray[this.state.currentInstruction][0] === 'bot') {
        this.processPassChips();
      } else {
        this.processTakeChip();
      }
    }
  }

  tick() {
    if (this.instructionsLeft())
    {
      this.processNextInstruction();
    }
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
