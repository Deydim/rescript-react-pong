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
      (collision: Collision.t) => {
        switch collision.wallsVertical {
        | Some(dir) => {...state, ball: {...state.ball, verticalDirection: dir}}
        | None => {
            ...state,
            ball: {
              ...state.ball,
              horizontalDirection: collision.horizontalDirection->Belt.Option.getWithDefault(
                state.ball.horizontalDirection,
              ),
              vector: collision.playerVector->Belt.Option.getWithDefault(state.ball.vector),
              verticalDirection: collision.playerVertical->Belt.Option.getWithDefault(
                state.ball.verticalDirection,
              ),
              predictedY: collision.predictedY->Belt.Option.getWithDefault(state.ball.predictedY),
            },
          }
        }
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
  | MovePlayer(dir: Model.verticalDirection, player) =>
    switch (dir, player) {
    | (Up, LeftPlayer) => {
        ...state,
        leftPlayerY: Js.Math.max_float(state.leftPlayerY -. 5., 10.),
      }
    | (Up, RightPlayer) => {
        ...state,
        rightPlayerY: Js.Math.max_float(state.rightPlayerY -. 3., 10.),
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
          state.rightPlayerY +. 3.,
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
      let (deltaX, deltaY) = Model.getVector(state.ball.vector)->(
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
      
      let ai = (dir: Model.horizontalDirection) => {
        let playerType: Model.player =
          state.ball.horizontalDirection == Left ? LeftPlayer : RightPlayer
        let playerTypeOpp: Model.player =
          state.ball.horizontalDirection == Right ? LeftPlayer : RightPlayer
        let playerY = playerType == RightPlayer ? state.rightPlayerY : state.leftPlayerY
        let playerYOpp = playerType == LeftPlayer ? state.rightPlayerY : state.leftPlayerY
        
        if (
          state.ball.horizontalDirection == dir &&
            Js.Math.abs_float(state.ball.predictedY -. (playerY +. state.playerSize /. 2.)) > 4.
        ) {
          switch state.ball.predictedY > playerY +. state.playerSize /. 2. {
          | true => send(MovePlayer(Down, playerType))
          | false => send(MovePlayer(Up, playerType))
          }
        } 
        
        if (
            Js.Math.abs_float(
              state.fieldLimits.bottom /. 2. -. (playerYOpp +. state.playerSize /. 2.),
            ) > 4.
        ) {
          switch state.fieldLimits.bottom /. 2. > playerYOpp +. state.playerSize /. 2. {
          | true => send(MovePlayer(Down, playerTypeOpp))
          | false => send(MovePlayer(Up, playerTypeOpp))
          }
        }
      }

      // switch (state.keys.arrowUp, state.keys.arrowDown) {
      // | (false, true) => send(MovePlayer(Down, LeftPlayer))
      // | (true, false) => send(MovePlayer(Up, LeftPlayer))
      // | _ => ()
      // }

      ai(state.ball.horizontalDirection)
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
