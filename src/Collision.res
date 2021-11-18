type t = Near(Model.horizontalDirection) | Hit(Model.horizontalDirection)

module Broad = {
  let make: (Model.t, Model.init) => option<Model.horizontalDirection> = (
    {ball: {x: ballx, horizontalDirection, size: ballSize}},
    {playerWidth, leftPlayerCenterX, rightPlayerCenterX},
  ) => {
    let ballCenterX = ballx +. ballSize /. 2.
    let limit = ballSize /. 2. +. playerWidth /. 2.
    switch horizontalDirection {
    | Left => ballCenterX -. leftPlayerCenterX == limit ? Some(Left) : None
    | Right => rightPlayerCenterX -. ballCenterX == limit ? Some(Right) : None
    }
  }
}

module Narrow = {
  let make: (Model.horizontalDirection, Model.t) => option<Model.horizontalDirection> = (
    dir,
    {rightPlayerY, leftPlayerY, ball: {y: ballY, size: ballSize}, playerSize},
  ) => {
    switch dir {
    | Right =>
      (ballY +. ballSize > rightPlayerY) && (ballY < rightPlayerY +. playerSize) 
        ? Some(Left)
        : None
    | Left =>
      ballY +. ballSize > leftPlayerY && ballY < leftPlayerY +. playerSize
        ? Some(Right)
        : None
    }
  }
}
module Vertical = {
  let make: Model.t => option<Model.verticalDirection> = ({ball:{y: ballY, size: ballSize, verticalDirection}, fieldLimits : {bottom}}) => {
    if ballY == 10. || ballY == bottom -. ballSize +. 10. {
      verticalDirection == Down ? Some(Up) : Some (Down)
    }
    else {
      None
    }
  }
}
let make = (state, init): (option<Model.horizontalDirection>, option<Model.verticalDirection>) => 
  (
    Broad.make(state, init)->Belt.Option.flatMap(dir => Narrow.make(dir, state)), 
    Vertical.make(state)
  )
