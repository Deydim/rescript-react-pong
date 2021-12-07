@val external requestAnimationFrame: ('a => unit) => int = "requestAnimationFrame"
@val external cancelAnimationFrame: int => unit = "cancelAnimationFrame"

let updateState = (state: Model.t, action: Model.action) => {
  switch action {
  | SetFrameTime(time) => {
      ...state,
      oldTime: time,
    }
  | HandleCollisions =>
    Collision.make(state)->(
      ((hor, vert)) => {
        ...state,
        ball: {
          ...state.ball,
          horizontalDirection: hor->Belt.Option.mapWithDefault(state.ball.horizontalDirection, ((
            newHor,
            _,
            _,
          )) => newHor),
          vector: hor->Belt.Option.mapWithDefault(state.ball.vector, ((_, newVec, _)) => newVec),
          verticalDirection: switch vert {
          | None =>
            hor->Belt.Option.mapWithDefault(state.ball.verticalDirection, ((_, _, newVert)) =>
              newVert
            )
          | Some(vert) => vert
          },
        },
      }
    )

  | UpdateConfig(init: Model.init) => {
      ...state,
      fieldLimits: {
        bottom: init.fieldHeight,
        right: init.fieldWidth,
      },
      ball: {
        ...state.ball,
        size: init.ballSize,
      },
      playerSize: init.playerSize,
    }
  | MovePlayer(dir: Model.verticalDirection, player) => switch (dir, player) {
    | (Up, LeftPlayer) => {
        ...state,
        leftPlayerY: Js.Math.max_float(state.leftPlayerY -. 5., 10.),
      }
    | (Up, RightPlayer) => {
        ...state,
        rightPlayerY: Js.Math.max_float(state.leftPlayerY -. 5., 10.),
      }

    | (Down, LeftPlayer) => {
        ...state,
        leftPlayerY: Js.Math.min_float(
          state.leftPlayerY +. 5.,
          state.fieldLimits.bottom -. state.playerSize +. 10.,
        ),
      }
    | (Down, RightPlayer) => {
        ...state,
        rightPlayerY: Js.Math.min_float(
          state.rightPlayerY +. 5.,
          state.fieldLimits.bottom -. state.playerSize +. 10.,
        ),
      }
    }
  | KeyEvent(type_, key) =>
    switch key {
    | "ArrowUp" => {...state, keys: {...state.keys, arrowUp: type_ == "keydown"}}
    | "ArrowDown" => {...state, keys: {...state.keys, arrowDown: type_ == "keydown"}}
    | " " => {
        ...state,
        game: switch state.game {
        | NotStarted
        | Paused =>
          Playing
        | Playing => Paused
        },
      }
    | _ => state
    }
  | BallMove(progress) => {
      let (deltaX, deltaY) = switch state.ball.vector {
      | Slight => Model.ballVectorTable[0]
      | Medium => Model.ballVectorTable[1]
      | Sharp => Model.ballVectorTable[2]
      }->(
        ((vx, vy)) =>
          switch (state.ball.verticalDirection, state.ball.horizontalDirection) {
          | (Down, Right) => (vx, vy)
          | (Up, Right) => (vx, -.vy)
          | (Up, Left) => (-vx, -.vy)
          | (Down, Left) => (-vx, vy)
          }
      )
      {
        ...state,
        ball: {
          ...state.ball,
          x: Js.Math.max_float(
            state.playerWidth,
            Js.Math.min_float(
              state.ball.x +. Belt.Int.toFloat(deltaX) *. state.ball.speed *. progress,
              state.fieldLimits.right -. state.ball.size -. state.playerWidth,
            ),
          ),
          y: Js.Math.max_float(
            10.,
            Js.Math.min_float(
              state.ball.y +. deltaY *. state.ball.speed *. progress,
              state.fieldLimits.bottom -. state.ball.size +. 10.,
            ),
          ),
        },
      }
    }
  }
}

module Tick = {
  @react.component
  let make = (~state: Model.t, ~send: Model.action => unit) => {
    let tick = time => {
      send(SetFrameTime(time))
      switch (state.keys.arrowUp, state.keys.arrowDown) {
      | (false, true) => send(MovePlayer(Down, LeftPlayer))
      | (true, false) => send(MovePlayer(Up, LeftPlayer))
      | _ => ()
      }
      send(HandleCollisions)

      let progress = (time -. state.oldTime) /. 15.
      if progress < 2. {
        send(BallMove(progress))
      }
    }
    React.useEffect3(() => {
      switch state.game {
      | Playing => Some(requestAnimationFrame(tick))
      | _ => {
          Js.log(state)
          None
        }
      }->Belt.Option.map((timer, ()) => cancelAnimationFrame(timer))
    }, (state.game, state, tick))
    React.null
  }
}
