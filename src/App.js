import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';
import Day1 from './day1';

class App extends Component {
  render() {
    return (
      <div>
        <div className="App">
          <div className="App-header">
            <img src={logo} className="App-logo" alt="logo" />
            <h2>Welcome to Advent of Code 2016 by Rob Johnson</h2>
          </div>
          <p className="App-intro">
            To get started, edit <code>src/App.js</code> and save to reload.
          </p>
        </div>
        <div>
          <Day1 />
        </div>
      </div>
    );
  }
}

export default App;
