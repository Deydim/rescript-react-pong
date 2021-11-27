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
          horizontalDirection: hor->Belt.Option.getWithDefault(state.ball.horizontalDirection),
          verticalDirection: vert->Belt.Option.getWithDefault(state.ball.verticalDirection),
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
  | PlayerUp => {
      ...state,
      rightPlayerY: Js.Math.max_float(state.rightPlayerY -. 5., 10.),
      leftPlayerY: Js.Math.max_float(state.leftPlayerY -. 5., 10.),
    }
  | PlayerDown => {
      ...state,
      rightPlayerY: Js.Math.min_float(
        state.rightPlayerY +. 5.,
        state.fieldLimits.bottom -. state.playerSize +. 10.,
      ),
      leftPlayerY: Js.Math.min_float(
        state.leftPlayerY +. 5.,
        state.fieldLimits.bottom -. state.playerSize +. 10.,
      ),
    }
  | Start => {
      ...state,
      game: Playing,
    }
  | Pause => {
      ...state,
      game: Paused,
    }
  | KeyEvent(type_, key) =>
    switch key {
    | "ArrowUp" => {...state, keys: {...state.keys, arrowUp: type_ == "keydown"}}
    | "ArrowDown" => {...state, keys: {...state.keys, arrowDown: type_ == "keydown"}}
    | " " => {...state, game: state.game == Paused ? Playing : Paused}
    | _ => state
    }
  | BallMove(progress) => {
      let (deltaX, deltaY) = Model.ballVectorTable[(state.ball.vectorIndex :> int)]->(
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
  let make = (~state: Model.t, ~dispatch: Model.action => unit) => {
    let tick = time => {
      dispatch(SetFrameTime(time))
      switch (state.keys.arrowUp, state.keys.arrowDown) {
      | (false, true) => dispatch(PlayerDown)
      | (true, false) => dispatch(PlayerUp)
      | _ => ()
      }
      dispatch(HandleCollisions)

      let progress = (time -. state.oldTime) /. 15.
      if progress < 2. {
        dispatch(BallMove(progress))
      }
    }
    React.useEffect2(() => {
      switch state.game {
      | Playing => Some(requestAnimationFrame(tick))
      | _ => {
          Js.log(state)
          None
        }
      }->Belt.Option.map((timer, ()) => cancelAnimationFrame(timer))
    }, (state.oldTime, state.game))
    React.null
  }
}
