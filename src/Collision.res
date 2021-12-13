type t = {
  horizontalDirection: option<Model.horizontalDirection>,
  wallsVertical: option<Model.verticalDirection>,
  playerVector: option<Model.ballVector>,
  playerVertical: option<Model.verticalDirection>,
  predictedY: option<float>,
}

module PredictBallHit = {
  let make: (t, Model.t) => option<float> = (
    collision,
    {
      ball: {x, y, size, vector},
      fieldLimits: {bottom: fieldHeight, right: fieldWidth},
      playerWidth,
      playerSize,
    },
  ) => {
    let (vx, vy) = Model.getVector(Belt.Option.getWithDefault(collision.playerVector, vector))
    let x = ref(x)
    let y = ref(y)
    let left = ref(collision.horizontalDirection == Some(Left) ? -1. : 1.)
    let up = ref(collision.playerVertical == Some(Up) ? -1. : 1.)
    while x.contents >= playerWidth && x.contents < fieldWidth -. playerWidth {
      x.contents = x.contents +. vx->Belt.Int.toFloat *. left.contents
      y.contents = y.contents +. vy *. up.contents

      if y.contents < 10. {
        y.contents = 10.
        up.contents = -.up.contents
      }
      if y.contents > fieldHeight -. size +. 10. {
        y.contents = fieldHeight -. size +. 10.
        up.contents = -.up.contents
      }
    }
    Some(
      y.contents +.
      Js.Math.round(playerSize /. 2. *. Js.Math.random() -. 4.) *. (Js.Math.random() < 0.5 ? -1. : 1.),
    )
  }
}

module Broad = {
  let make: (t, Model.t) => t = (
    collision,
    {ball: {x: ballx, horizontalDirection: dir, size: ballSize}, playerWidth, fieldLimits},
  ) => {
    let ballCenterX = ballx +. ballSize /. 2.
    let leftPlayerCenterX = playerWidth /. 2.
    let rightPlayerCenterX = fieldLimits.right -. playerWidth /. 2.
    let limit = ballSize /. 2. +. playerWidth /. 2.
    switch dir {
    | Left => {
        ...collision,
        horizontalDirection: ballCenterX -. leftPlayerCenterX == limit ? Some(Left) : None,
      }
    | Right => {
        ...collision,
        horizontalDirection: rightPlayerCenterX -. ballCenterX == limit ? Some(Right) : None,
      }
    }
  }
}
module VectorChange = {
  let make: (t, Model.t) => t = (collision, state) => {
    let ballCenter = state.ball.y +. state.ball.size /. 2.
    let playerY = state.ball.horizontalDirection == Left ? state.leftPlayerY : state.rightPlayerY
    let playerCenter = playerY +. state.playerSize /. 2.
    let hit = (ballCenter -. playerCenter) /. state.playerSize /. 3. *. 10.

    {
      ...collision,
      playerVector: switch Js.Math.abs_float(hit)->Js.Math.round {
      | 2. => Some(Sharp)
      | 1. => Some(Medium)
      | 0. => Some(Slight)
      | _ => None
      },
      playerVertical: switch hit {
      | hit if hit < 0. => Some(Up)
      | hit if hit > 0. => Some(Down)
      | hit if hit == 0. => Some(state.ball.verticalDirection)
      | _ => None
      },
    }
  }
}

module Narrow = {
  let make: (t, Model.t) => t = (collision, state) => {
    let {rightPlayerY, leftPlayerY, ball: {y: ballY, size: ballSize}, playerSize} = state
    {
      ...collision,
      horizontalDirection: switch collision.horizontalDirection {
      | Some(Right) =>
        ballY +. ballSize > rightPlayerY && ballY < rightPlayerY +. playerSize ? Some(Left) : None
      | Some(Left) =>
        ballY +. ballSize > leftPlayerY && ballY < leftPlayerY +. playerSize ? Some(Right) : None
      | None => None
      },
    }
  }
}

module Walls = {
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

let make: Model.t => t = state => {
  {
    horizontalDirection: None,
    wallsVertical: None,
    playerVector: None,
    playerVertical: None,
    predictedY: None,
  }->(
    collision =>
      {
        ...collision,
        wallsVertical: Walls.make(state),
      }->(
        collision =>
          switch collision.wallsVertical {
          | Some(_) => collision
          | None =>
            collision
            ->Broad.make(state)
            ->(
              collision =>
                switch collision.horizontalDirection {
                | Some(_) =>
                  collision
                  ->Narrow.make(state)
                  ->(
                    collision =>
                      switch collision.horizontalDirection {
                      | Some(_) =>
                        collision
                        ->VectorChange.make(state)
                        ->(
                          collision => {
                            ...collision,
                            predictedY: PredictBallHit.make(collision, state),
                          }
                        )

                      | None => collision
                      }
                  )
                | None => collision
                }
            )
          }
      )
  )
}
