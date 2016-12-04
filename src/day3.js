import React, { Component } from 'react';
import { SHORT_LIST as INITIAL_LIST } from './day3_data';

export default class Day3 extends Component {
  constructor() {
    super();
    this.state = {
      validTriangleCount: 0,
      triangleList: INITIAL_LIST,
      history: []
    }
  }

  componentDidUpdate(prevProps, prevState) {
    // keep going if we have more triangle candidates to inspect
    if (this.state.triagleList.length > 0) {
      this.tick();
    }
  }

  tick() {
    this.setState({
      validTriangleCount: this.state.validTriangleCount + 1,
      triangleList:  this.state.triangleList.slice(1),
      history: this.state.history
    });
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
        <p><code>validTriangleCount: {this.state.validTriangleCount}</code></p>
        <p><code>triangleList: {this.displayTriangleList()}</code></p>
        <code><pre>history: {this.displayHistory()}</pre></code>
      </div>
    );
  }
}


