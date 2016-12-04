import React, { Component } from 'react';

const BATHROOM_CODE="ULL\nRRDDD\nLURDL\nUUUUD"

export default class Day2 extends Component {
  constructor() {
    super();
    this.state = {
      currentKey: '5',
      secretCode: '',
      instructions: BATHROOM_CODE.split("\n"),
      history: []
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
    this.setState({
      currentKey: this.state.currentKey,
      instructions: this.state.instructions,
      history: this.state.history
    });
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

