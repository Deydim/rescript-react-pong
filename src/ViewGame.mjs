// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Model from "./Model.mjs";
import * as React from "react";
import * as Update from "./Update.mjs";

function floatToPx(number) {
  return String(number) + "px";
}

function keyEventHandler(evt, send) {
  var match = evt.key;
  switch (match) {
    case " " :
        evt.preventDefault();
        if (evt.type === "keydown") {
          return Curry._1(send, {
                      TAG: /* KeyEvent */2,
                      _0: evt.type,
                      _1: evt.key
                    });
        } else {
          return ;
        }
    case "ArrowDown" :
    case "ArrowUp" :
    case "a" :
    case "z" :
        break;
    default:
      return ;
  }
  evt.preventDefault();
  return Curry._1(send, {
              TAG: /* KeyEvent */2,
              _0: evt.type,
              _1: evt.key
            });
}

function ViewGame(Props) {
  var config = Props.config;
  var init = Model.init(config);
  var ballSize = init.ballSize;
  var playerWidth = init.playerWidth;
  var playerSize = init.playerSize;
  var offsetTop = init.offsetTop;
  var offsetLeft = init.offsetLeft;
  var match = React.useReducer(Update.updateState, Model.make(init));
  var send = match[1];
  var state = match[0];
  React.useEffect((function () {
          document.addEventListener("keydown", (function (evt) {
                  return keyEventHandler(evt, send);
                }));
          document.addEventListener("keyup", (function (evt) {
                  return keyEventHandler(evt, send);
                }));
          return (function (param) {
                    document.removeEventListener("keyup");
                    document.removeEventListener("keydown");
                    
                  });
        }), [send]);
  React.useEffect((function () {
          Curry._1(send, {
                TAG: /* UpdateConfig */0,
                _0: init
              });
          Curry._1(send, {
                TAG: /* MovePlayer */1,
                _0: /* Up */1,
                _1: /* LeftPlayer */1
              });
          Curry._1(send, {
                TAG: /* MovePlayer */1,
                _0: /* Down */0,
                _1: /* LeftPlayer */1
              });
          Curry._1(send, {
                TAG: /* MovePlayer */1,
                _0: /* Up */1,
                _1: /* RightPlayer */0
              });
          Curry._1(send, {
                TAG: /* MovePlayer */1,
                _0: /* Down */0,
                _1: /* RightPlayer */0
              });
          Curry._1(send, {
                TAG: /* BallMove */3,
                _0: 0
              });
          
        }), [config]);
  var match$1 = state.game;
  var tmp;
  switch (match$1) {
    case /* Playing */0 :
        tmp = null;
        break;
    case /* Paused */1 :
        tmp = "Paused. Press space to resume.";
        break;
    case /* NotStarted */2 :
        tmp = "Press space to start.";
        break;
    
  }
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "field",
                  style: {
                    height: String(init.fieldHeight) + "px",
                    left: String(offsetLeft) + "px",
                    top: String(offsetTop) + "px",
                    width: String(init.fieldWidth) + "px"
                  }
                }), React.createElement("div", {
                  className: "player",
                  style: {
                    height: String(playerSize) + "px",
                    left: String(init.leftPlayerX + offsetLeft) + "px",
                    top: String(state.leftPlayerY + offsetTop) + "px",
                    width: String(playerWidth) + "px"
                  }
                }), React.createElement("div", {
                  className: "player",
                  style: {
                    height: String(playerSize) + "px",
                    left: String(init.rightPlayerX + offsetLeft) + "px",
                    top: String(state.rightPlayerY + offsetTop) + "px",
                    width: String(playerWidth) + "px"
                  }
                }), React.createElement("div", {
                  className: state.ball.isOut ? "ball-out" : "ball-in",
                  style: {
                    height: String(ballSize) + "px",
                    left: String(state.ball.x + offsetLeft) + "px",
                    top: String(state.ball.y + offsetTop) + "px",
                    width: String(ballSize) + "px",
                    borderRadius: String(ballSize / 2) + "px"
                  }
                }), React.createElement("div", {
                  style: {
                    left: String(offsetLeft + init.fieldWidth / 2 - 150) + "px",
                    position: "absolute",
                    textAlign: "center",
                    top: String(offsetTop + init.fieldHeight + 50) + "px",
                    width: "300px"
                  }
                }, tmp), React.createElement(Update.Tick.make, {
                  state: state,
                  send: send
                }));
}

var make = ViewGame;

export {
  floatToPx ,
  keyEventHandler ,
  make ,
  
}
/* react Not a pure module */
