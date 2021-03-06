import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';
//import Day1 from './day1';
//import Day2 from './day2';
//import Day3 from './day3';
//import Day4 from './day4';
//import Day8 from './day8';
//import Day10 from './day10';
//import Day9 from './day9';
import Day12 from './day12';

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
          <Day12 />
        </div>
      </div>
    );
  }
//        <div>
//          <Day9 />
//        </div>
//        <div>
//          <Day10 />
//        </div>
//        <div>
//          <Day8 />
//        </div>
//        <div>
//          <Day4 />
//        </div>
//        <div>
//          <Day3 />
//        </div>
//        <div>
//          <Day2 />
//        </div>
//        <div>
//          <Day1 />
//        </div>
//      </div>
}

export default App;
