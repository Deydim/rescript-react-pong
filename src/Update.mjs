// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Model from "./Model.mjs";
import * as React from "react";
import * as Collision from "./Collision.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";

function updateState(state, action) {
  if (typeof action === "number") {
    var collision = Collision.make(state);
    var dir = collision.wallsVertical;
    if (dir !== undefined) {
      var init = state.ball;
      return {
              rightPlayerY: state.rightPlayerY,
              leftPlayerY: state.leftPlayerY,
              playerWidth: state.playerWidth,
              keys: state.keys,
              game: state.game,
              ball: {
                x: init.x,
                y: init.y,
                size: init.size,
                speed: init.speed,
                horizontalDirection: init.horizontalDirection,
                verticalDirection: dir,
                vector: init.vector,
                predictedY: init.predictedY
              },
              fieldLimits: state.fieldLimits,
              playerSize: state.playerSize,
              oldTime: state.oldTime
            };
    }
    var init$1 = state.ball;
    return {
            rightPlayerY: state.rightPlayerY,
            leftPlayerY: state.leftPlayerY,
            playerWidth: state.playerWidth,
            keys: state.keys,
            game: state.game,
            ball: {
              x: init$1.x,
              y: init$1.y,
              size: init$1.size,
              speed: init$1.speed,
              horizontalDirection: Belt_Option.getWithDefault(collision.horizontalDirection, state.ball.horizontalDirection),
              verticalDirection: Belt_Option.getWithDefault(collision.playerVertical, state.ball.verticalDirection),
              vector: Belt_Option.getWithDefault(collision.playerVector, state.ball.vector),
              predictedY: Belt_Option.getWithDefault(collision.predictedY, state.ball.predictedY)
            },
            fieldLimits: state.fieldLimits,
            playerSize: state.playerSize,
            oldTime: state.oldTime
          };
  }
  switch (action.TAG | 0) {
    case /* UpdateConfig */0 :
        var init$2 = action._0;
        var init$3 = state.ball;
        return {
                rightPlayerY: state.rightPlayerY,
                leftPlayerY: state.leftPlayerY,
                playerWidth: state.playerWidth,
                keys: state.keys,
                game: state.game,
                ball: {
                  x: init$3.x,
                  y: init$3.y,
                  size: init$2.ballSize,
                  speed: init$3.speed,
                  horizontalDirection: init$3.horizontalDirection,
                  verticalDirection: init$3.verticalDirection,
                  vector: init$3.vector,
                  predictedY: init$3.predictedY
                },
                fieldLimits: {
                  bottom: init$2.fieldHeight,
                  right: init$2.fieldWidth
                },
                playerSize: init$2.playerSize,
                oldTime: state.oldTime
              };
    case /* MovePlayer */1 :
        var player = action._1;
        if (action._0) {
          if (player) {
            return {
                    rightPlayerY: state.rightPlayerY,
                    leftPlayerY: Math.max(state.leftPlayerY - 5, 10),
                    playerWidth: state.playerWidth,
                    keys: state.keys,
                    game: state.game,
                    ball: state.ball,
                    fieldLimits: state.fieldLimits,
                    playerSize: state.playerSize,
                    oldTime: state.oldTime
                  };
          } else {
            return {
                    rightPlayerY: Math.max(state.rightPlayerY - 3, 10),
                    leftPlayerY: state.leftPlayerY,
                    playerWidth: state.playerWidth,
                    keys: state.keys,
                    game: state.game,
                    ball: state.ball,
                    fieldLimits: state.fieldLimits,
                    playerSize: state.playerSize,
                    oldTime: state.oldTime
                  };
          }
        } else if (player) {
          return {
                  rightPlayerY: state.rightPlayerY,
                  leftPlayerY: Math.min(state.leftPlayerY + 5, state.fieldLimits.bottom - state.playerSize + 10),
                  playerWidth: state.playerWidth,
                  keys: state.keys,
                  game: state.game,
                  ball: state.ball,
                  fieldLimits: state.fieldLimits,
                  playerSize: state.playerSize,
                  oldTime: state.oldTime
                };
        } else {
          return {
                  rightPlayerY: Math.min(state.rightPlayerY + 3, state.fieldLimits.bottom - state.playerSize + 10),
                  leftPlayerY: state.leftPlayerY,
                  playerWidth: state.playerWidth,
                  keys: state.keys,
                  game: state.game,
                  ball: state.ball,
                  fieldLimits: state.fieldLimits,
                  playerSize: state.playerSize,
                  oldTime: state.oldTime
                };
        }
    case /* KeyEvent */2 :
        var type_ = action._0;
        switch (action._1) {
          case " " :
              var match = state.game;
              return {
                      rightPlayerY: state.rightPlayerY,
                      leftPlayerY: state.leftPlayerY,
                      playerWidth: state.playerWidth,
                      keys: state.keys,
                      game: match !== 0 ? /* Playing */0 : /* Paused */1,
                      ball: state.ball,
                      fieldLimits: state.fieldLimits,
                      playerSize: state.playerSize,
                      oldTime: state.oldTime
                    };
          case "ArrowDown" :
              var init$4 = state.keys;
              return {
                      rightPlayerY: state.rightPlayerY,
                      leftPlayerY: state.leftPlayerY,
                      playerWidth: state.playerWidth,
                      keys: {
                        arrowUp: init$4.arrowUp,
                        arrowDown: type_ === "keydown"
                      },
                      game: state.game,
                      ball: state.ball,
                      fieldLimits: state.fieldLimits,
                      playerSize: state.playerSize,
                      oldTime: state.oldTime
                    };
          case "ArrowUp" :
              var init$5 = state.keys;
              return {
                      rightPlayerY: state.rightPlayerY,
                      leftPlayerY: state.leftPlayerY,
                      playerWidth: state.playerWidth,
                      keys: {
                        arrowUp: type_ === "keydown",
                        arrowDown: init$5.arrowDown
                      },
                      game: state.game,
                      ball: state.ball,
                      fieldLimits: state.fieldLimits,
                      playerSize: state.playerSize,
                      oldTime: state.oldTime
                    };
          default:
            return state;
        }
    case /* BallMove */3 :
        var progress = action._0;
        var param = Model.getVector(state.ball.vector);
        var vy = param[1];
        var vx = param[0];
        var match$1 = state.ball.verticalDirection;
        var match$2 = state.ball.horizontalDirection;
        var match$3 = match$1 ? (
            match$2 ? [
                vx,
                -vy
              ] : [
                -vx | 0,
                -vy
              ]
          ) : (
            match$2 ? [
                vx,
                vy
              ] : [
                -vx | 0,
                vy
              ]
          );
        var init$6 = state.ball;
        return {
                rightPlayerY: state.rightPlayerY,
                leftPlayerY: state.leftPlayerY,
                playerWidth: state.playerWidth,
                keys: state.keys,
                game: state.game,
                ball: {
                  x: Math.max(state.playerWidth, Math.min(state.ball.x + match$3[0] * state.ball.speed * progress, state.fieldLimits.right - state.ball.size - state.playerWidth)),
                  y: Math.max(10, Math.min(state.ball.y + match$3[1] * state.ball.speed * progress, state.fieldLimits.bottom - state.ball.size + 10)),
                  size: init$6.size,
                  speed: init$6.speed,
                  horizontalDirection: init$6.horizontalDirection,
                  verticalDirection: init$6.verticalDirection,
                  vector: init$6.vector,
                  predictedY: init$6.predictedY
                },
                fieldLimits: state.fieldLimits,
                playerSize: state.playerSize,
                oldTime: state.oldTime
              };
    case /* SetFrameTime */4 :
        return {
                rightPlayerY: state.rightPlayerY,
                leftPlayerY: state.leftPlayerY,
                playerWidth: state.playerWidth,
                keys: state.keys,
                game: state.game,
                ball: state.ball,
                fieldLimits: state.fieldLimits,
                playerSize: state.playerSize,
                oldTime: action._0
              };
    
  }
}

function Update$Tick(Props) {
  var state = Props.state;
  var send = Props.send;
  var tick = function (time) {
    Curry._1(send, {
          TAG: /* SetFrameTime */4,
          _0: time
        });
    var ai = function (dir) {
      var playerType = state.ball.horizontalDirection === /* Left */0 ? /* LeftPlayer */1 : /* RightPlayer */0;
      var playerY = playerType === /* RightPlayer */0 ? state.rightPlayerY : state.leftPlayerY;
      if (state.ball.horizontalDirection === dir && Math.abs(state.ball.predictedY - (playerY + state.playerSize / 2)) > 4) {
        if (state.ball.predictedY > playerY + state.playerSize / 2) {
          return Curry._1(send, {
                      TAG: /* MovePlayer */1,
                      _0: /* Down */0,
                      _1: playerType
                    });
        } else {
          return Curry._1(send, {
                      TAG: /* MovePlayer */1,
                      _0: /* Up */1,
                      _1: playerType
                    });
        }
      } else if (state.ball.horizontalDirection !== dir && Math.abs(state.fieldLimits.bottom / 2 - (state.leftPlayerY + state.playerSize / 2)) > 4) {
        if (state.fieldLimits.bottom / 2 > state.rightPlayerY + state.playerSize / 2) {
          return Curry._1(send, {
                      TAG: /* MovePlayer */1,
                      _0: /* Down */0,
                      _1: playerType
                    });
        } else {
          return Curry._1(send, {
                      TAG: /* MovePlayer */1,
                      _0: /* Up */1,
                      _1: playerType
                    });
        }
      } else {
        return ;
      }
    };
    ai(state.ball.horizontalDirection);
    Curry._1(send, /* HandleCollisions */0);
    var progress = (time - state.oldTime) / 15;
    if (progress < 2) {
      return Curry._1(send, {
                  TAG: /* BallMove */3,
                  _0: progress
                });
    }
    
  };
  React.useEffect((function () {
          var match = state.game;
          return Belt_Option.map(match !== 0 ? (console.log(state), undefined) : requestAnimationFrame(tick), (function (timer, param) {
                        cancelAnimationFrame(timer);
                        
                      }));
        }), [
        state.game,
        state,
        tick
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
