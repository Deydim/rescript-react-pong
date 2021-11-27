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

module Narrow = {
  let make: (Model.horizontalDirection, Model.t) => option<Model.horizontalDirection> = (
    dir,
    {rightPlayerY, leftPlayerY, ball: {y: ballY, size: ballSize}, playerSize},
  ) => {
    switch dir {
    | Right =>
      ballY +. ballSize > rightPlayerY && ballY < rightPlayerY +. playerSize ? Some(Left) : None
    | Left =>
      ballY +. ballSize > leftPlayerY && ballY < leftPlayerY +. playerSize ? Some(Right) : None
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
  option<Model.horizontalDirection>,
  option<Model.verticalDirection>,
) = state => (
  Broad.make(state)->Belt.Option.flatMap(dir => Narrow.make(dir, state)),
  Vertical.make(state),
)
