// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Caml_array from "rescript/lib/es6/caml_array.js";

var keys = {
  arrowUp: false,
  arrowDown: false
};

var ballVectorTable = [
  [
    5,
    0.3
  ],
  [
    4,
    1.2
  ],
  [
    3,
    2
  ]
];

function init(config) {
  var fieldWidth = Math.imul(config.field_size, 22);
  var fieldHeight = config.field_size / 30 * 440;
  var playerSize = Math.imul(config.player_size, 10);
  var leftPlayerY = (fieldHeight - playerSize) / 2;
  var rightPlayerY = (fieldHeight - playerSize) / 2;
  var rightPlayerX = fieldWidth - 14;
  var ballSize = config.ball_size;
  var ballX = (fieldWidth - ballSize) / 2;
  var ballY = (fieldHeight - ballSize) / 2;
  return {
          offsetLeft: 300,
          offsetTop: 50,
          fieldWidth: fieldWidth,
          fieldHeight: fieldHeight,
          playerSize: playerSize,
          playerWidth: 14,
          leftPlayerX: 0,
          leftPlayerY: leftPlayerY,
          rightPlayerX: rightPlayerX,
          rightPlayerY: rightPlayerY,
          leftPlayerCenterX: 0 + 14 / 2,
          rightPlayerCenterX: rightPlayerX + 14 / 2,
          ballSize: ballSize,
          ballX: ballX,
          ballY: ballY
        };
}

function make(param) {
  var fieldHeight = param.fieldHeight;
  return {
          rightPlayerY: param.rightPlayerY,
          leftPlayerY: param.leftPlayerY,
          rightPlayerControl: /* Human */0,
          leftPlayerControl: /* Human */0,
          playerWidth: param.playerWidth,
          keys: keys,
          game: /* NotStarted */2,
          ball: {
            x: param.ballX,
            y: param.ballY,
            size: param.ballSize,
            speed: 2,
            horizontalDirection: /* Left */0,
            verticalDirection: /* Down */0,
            vector: /* Slight */0,
            predictedY: fieldHeight / 2
          },
          fieldLimits: {
            bottom: fieldHeight,
            right: param.fieldWidth
          },
          playerSize: param.playerSize,
          oldTime: 0
        };
}

function getVector(vec) {
  switch (vec) {
    case /* Slight */0 :
        return Caml_array.get(ballVectorTable, 0);
    case /* Medium */1 :
        return Caml_array.get(ballVectorTable, 1);
    case /* Sharp */2 :
        return Caml_array.get(ballVectorTable, 2);
    
  }
}

export {
  keys ,
  ballVectorTable ,
  init ,
  make ,
  getVector ,
  
}
/* No side effect */
