// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";

function updateState(state, action) {
  if (typeof action === "number") {
    switch (action) {
      case /* Up */0 :
          return {
                  rightPlayerY: state.rightPlayerY - 5 | 0,
                  keys: state.keys,
                  game: state.game,
                  ball: state.ball
                };
      case /* Down */1 :
          return {
                  rightPlayerY: state.rightPlayerY + 5 | 0,
                  keys: state.keys,
                  game: state.game,
                  ball: state.ball
                };
      case /* Nothing */2 :
          return state;
      case /* Start */3 :
          return {
                  rightPlayerY: state.rightPlayerY,
                  keys: state.keys,
                  game: /* Playing */0,
                  ball: state.ball
                };
      case /* Pause */4 :
          return {
                  rightPlayerY: state.rightPlayerY,
                  keys: state.keys,
                  game: /* Paused */2,
                  ball: state.ball
                };
      
    }
  } else {
    var type_ = action._0;
    switch (action._1) {
      case " " :
          return {
                  rightPlayerY: state.rightPlayerY,
                  keys: state.keys,
                  game: state.game === /* Paused */2 ? /* Playing */0 : /* Paused */2,
                  ball: state.ball
                };
      case "ArrowDown" :
          var init = state.keys;
          return {
                  rightPlayerY: state.rightPlayerY,
                  keys: {
                    arrowUp: init.arrowUp,
                    arrowDown: type_ === "keydown"
                  },
                  game: state.game,
                  ball: state.ball
                };
      case "ArrowUp" :
          var init$1 = state.keys;
          return {
                  rightPlayerY: state.rightPlayerY,
                  keys: {
                    arrowUp: type_ === "keydown",
                    arrowDown: init$1.arrowDown
                  },
                  game: state.game,
                  ball: state.ball
                };
      default:
        return state;
    }
  }
}

function Update$Tick(Props) {
  var state = Props.state;
  var dispatch = Props.dispatch;
  var match = React.useState(function () {
        return 0;
      });
  var setTimer = match[1];
  var timer = match[0];
  var match$1 = React.useState(function () {
        return 0;
      });
  var setFrameCount = match$1[1];
  var tick = function (param) {
    Curry._1(setFrameCount, (function (prev) {
            return prev + 1 | 0;
          }));
    var match = state.keys;
    var arrowDown = match.arrowDown;
    var arrowUp = match.arrowUp;
    if (arrowUp) {
      if (arrowDown) {
        Curry._1(dispatch, /* Nothing */2);
      } else if (arrowUp) {
        Curry._1(dispatch, /* Up */0);
      }
      
    } else if (arrowDown) {
      Curry._1(dispatch, /* Down */1);
    } else if (arrowUp) {
      Curry._1(dispatch, /* Up */0);
    }
    
  };
  React.useEffect((function () {
          if (state.game === /* Playing */0) {
            Curry._1(setTimer, (function (param) {
                    return requestAnimationFrame(tick);
                  }));
          }
          return (function (param) {
                    cancelAnimationFrame(timer);
                    
                  });
        }), [
        match$1[0],
        state.game
      ]);
  return null;
}

var Tick = {
  make: Update$Tick
};

export {
  updateState ,
  Tick ,
  
}
/* react Not a pure module */
