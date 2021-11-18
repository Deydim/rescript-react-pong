// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Belt_Option from "rescript/lib/es6/belt_Option.js";

function make(param, param$1) {
  var match = param.ball;
  var ballSize = match.size;
  var ballCenterX = match.x + ballSize / 2;
  var limit = ballSize / 2 + param$1.playerWidth / 2;
  if (match.horizontalDirection) {
    if (param$1.rightPlayerCenterX - ballCenterX === limit) {
      return /* Right */1;
    } else {
      return ;
    }
  } else if (ballCenterX - param$1.leftPlayerCenterX === limit) {
    return /* Left */0;
  } else {
    return ;
  }
}

var Broad = {
  make: make
};

function make$1(dir, param) {
  var playerSize = param.playerSize;
  var match = param.ball;
  var ballSize = match.size;
  var ballY = match.y;
  var leftPlayerY = param.leftPlayerY;
  var rightPlayerY = param.rightPlayerY;
  if (dir) {
    if (ballY + ballSize > rightPlayerY && ballY < rightPlayerY + playerSize) {
      return /* Left */0;
    } else {
      return ;
    }
  } else if (ballY + ballSize > leftPlayerY && ballY < leftPlayerY + playerSize) {
    return /* Right */1;
  } else {
    return ;
  }
}

var Narrow = {
  make: make$1
};

function make$2(param) {
  var match = param.ball;
  var ballY = match.y;
  if (ballY === 10 || ballY === param.fieldLimits.bottom - match.size + 10) {
    if (match.verticalDirection === /* Down */0) {
      return /* Up */1;
    } else {
      return /* Down */0;
    }
  }
  
}

var Vertical = {
  make: make$2
};

function make$3(state, init) {
  return [
          Belt_Option.flatMap(make(state, init), (function (dir) {
                  return make$1(dir, state);
                })),
          make$2(state)
        ];
}

export {
  Broad ,
  Narrow ,
  Vertical ,
  make$3 as make,
  
}
/* No side effect */
