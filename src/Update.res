@val external requestAnimationFrame: ('a => unit) => int = "requestAnimationFrame"
@val external cancelAnimationFrame: int => unit = "cancelAnimationFrame"

let updateState = (state: Model.t, action: Model.action) => {
  switch action {
  | Up => {
      ...state,
      rightPlayerY: state.rightPlayerY - 5,
    }
  | Down => {
      ...state,
      rightPlayerY: state.rightPlayerY + 5,
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
  | _ => state
  }
}

module Tick = {
  @react.component
  let make = (~state: Model.t, ~dispatch: Model.action => unit) => {
    let (timer, setTimer) = React.useState(() => 0)
    let (frameCount, setFrameCount) = React.useState(() => 0)

    let tick = () => {
      setFrameCount(prev => prev + 1)
      let {arrowUp, arrowDown} = state.keys
      switch (arrowUp, arrowDown) {
      | (true, true) => dispatch(Nothing)
      | (_, true) => dispatch(Down)
      | (true, _) => dispatch(Up)
      | _ => ()
      }
      switch state.game {
      | Paused => ()
      | Playing => ()
      | _ => ()
      }
    }

    React.useEffect2(() => {
      if state.game == Playing {
        setTimer(_ => requestAnimationFrame(tick))
      }
      Some(() => cancelAnimationFrame(timer))
    }, (frameCount, state.game))
    React.null
  }
}
