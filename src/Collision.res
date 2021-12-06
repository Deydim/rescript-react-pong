module Broad = {
  let make: Model.t => option<Model.horizontalDirection> = ({
    ball: {x: ballx, horizontalDirection: dir, size: ballSize},
    playerWidth,
    fieldLimits,
  }) => {
    let ballCenterX = ballx +. ballSize /. 2.
    let leftPlayerCenterX = playerWidth /. 2.
    let rightPlayerCenterX = fieldLimits.right -. playerWidth /. 2.
    let limit = ballSize /. 2. +. playerWidth /. 2.
    switch dir {
    | Left => ballCenterX -. leftPlayerCenterX == limit ? Some(Left) : None
    | Right => rightPlayerCenterX -. ballCenterX == limit ? Some(Right) : None
    }
  }
}
module VectorChange = {
  let make = (~ballSize, ~ballY, ~playerY, ~playerSize, ~ballVertDir): (
    Model.ballVector,
    Model.verticalDirection,
  ) => {
    let ballCenter = ballY +. ballSize /. 2.
    let playerCenter = playerY +. playerSize /. 2.
    let hit = (ballCenter -. playerCenter) /. playerSize /. 3. *. 10.
    let dir: Model.verticalDirection = switch hit {
    | hit if hit < 0. => Up
    | hit if hit > 0. => Down
    | hit if hit == 0. => ballVertDir
    | _ => Js.Exn.raiseError("This state should be impossible!")
    }

    switch Js.Math.abs_float(hit)->Js.Math.round {
    | 2. => (Sharp, dir)
    | 1. => (Medium, dir)
    | 0. => (Slight, dir)
    | _ => Js.Exn.raiseError("Illegal player vs ball collision state!")
    }
  }
}

module Narrow = {
  let make: (
    Model.horizontalDirection,
    Model.t,
  ) => option<(Model.horizontalDirection, (Model.ballVector, Model.verticalDirection))> = (
    dir,
    state,
  ) => {
    let {rightPlayerY, leftPlayerY, ball: {y: ballY, size: ballSize}, playerSize} = state
    switch dir {
    | Right =>
      ballY +. ballSize > rightPlayerY && ballY < rightPlayerY +. playerSize
        ? Some(
            Left,
            VectorChange.make(
              ~ballSize,
              ~ballY,
              ~playerSize,
              ~playerY=rightPlayerY,
              ~ballVertDir=state.ball.verticalDirection,
            ),
          )
        : None
    | Left =>
      ballY +. ballSize > leftPlayerY && ballY < leftPlayerY +. playerSize
        ? Some(
            Right,
            VectorChange.make(
              ~ballSize,
              ~ballY,
              ~playerSize,
              ~playerY=leftPlayerY,
              ~ballVertDir=state.ball.verticalDirection,
            ),
          )
        : None
    }
  }
}
module Vertical = {
  let make: Model.t => option<Model.verticalDirection> = ({
    ball: {y: ballY, size: ballSize, verticalDirection: dir},
    fieldLimits: {bottom},
  }) => {
    if ballY == 10. || ballY == bottom -. ballSize +. 10. {
      dir == Down ? Some(Up) : Some(Down)
    } else {
      None
    }
  }
}

let make: Model.t => (
  option<(Model.horizontalDirection, (Model.ballVector, Model.verticalDirection))>,
  option<Model.verticalDirection>,
) = state => (
  Broad.make(state)->Belt.Option.flatMap(dir => Narrow.make(dir, state)),
  Vertical.make(state),
)
