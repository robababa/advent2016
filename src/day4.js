import React, { Component } from 'react';
import { SHORT_LIST as ROOM_LIST } from './day4_data';
import Day4Room from './day4_room';

const BATCH_SIZE = 100;

export default class Day4 extends Component {
  constructor() {
    super();
    this.state = {
      batchRunCount: 0,
      totalRunCount: 0,
      validRoomCount: 0,
      sectorIdTotal: 0,
      validRoomList: [],
      pendingRoomList: ROOM_LIST,
      history: [`(validRoomCount: 0, pendingRoomList: ${ROOM_LIST})`]
    }
  }

//  componentDidUpdate(prevProps, prevState) {
//    // keep going if we have more triangle candidates to inspect
//    if ((this.state.pendingRoomList.length > 0) &&
//        (this.state.batchRunCount !== 0)) {
//      this.tick();
//    }
//  }

  tick() {
    if (this.state.pendingRoomList.length > 0) {
      var nextRoom = new Day4Room(this.state.pendingRoomList[0]);
      var nextRoomValid = nextRoom.isValid();
      //var isValid = isRoomValid(nextRoom);
      if (nextRoomValid) {
        this.setState({
          batchRunCount: (this.state.batchRunCount + 1) % BATCH_SIZE,
          totalRunCount: this.state.totalRunCount + 1,
          validRoomCount: this.state.validRoomCount + 1,
          sectorIdTotal: this.sectorIdTotal + nextRoom.getSectorId(),
          validRoomList: this.validRoomList,
          pendingRoomList: this.state.pendingRoomList.slice(1),
          history: [`(validRoomCount: 0, pendingRoomList: ${ROOM_LIST})`]
        });
      } else {
        this.setState({
          batchRunCount: (this.state.batchRunCount + 1) % BATCH_SIZE,
          totalRunCount: this.state.totalRunCount + 1,
          validRoomCount: this.state.validRoomCount,
          sectorIdTotal: this.sectorIdTotal,
          validRoomList: this.validRoomList,
          pendingRoomList: this.state.pendingRoomList.slice(1),
          history: [`(validRoomCount: 0, pendingRoomList: ${ROOM_LIST})`]
        });
      }

    }
  }

  displayList(list) {
    return list.join(" ");
  }

  render() {
    return (
      <div>
        <h3>Day 4</h3>
        <p onClick={() => this.tick()}>Click me to run!</p>
        <p><code>Current State:</code></p>
        <p><code>batchRunCount: {this.state.batchRunCount}</code></p>
        <p><code>totalRunCount: {this.state.totalRunCount}</code></p>
        <p><code>validRoomCount: {this.state.validRoomCount}</code></p>
        <p><code>sectorIdTotal: {this.state.sectorIdTotal}</code></p>
        <p><code>validRoomList: {this.state.validRoomList}</code></p>
        <p><code>pendingRoomList: {this.displayList(this.state.pendingRoomList)}</code></p>
        <code><pre>history: {this.state.history}</pre></code>
      </div>
    );
  }
}
