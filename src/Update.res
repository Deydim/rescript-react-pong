@val external requestAnimationFrame: ('a => unit) => int = "requestAnimationFrame"

open Model

let handleUserInput: (string, bool) => unit = (key, isPressed) =>
  switch key {
  | "ArrowUp" => keys.arrowUp = isPressed
  | "ArrowDown" => keys.arrowDown = isPressed
  | _ => ()
  }

let updateState = (state, action) => {
  switch (action, state.keys) {
  | (Up, keys) if keys.arrowUp => {
      ...state,
      rightPlayerY: state.rightPlayerY - 5,
    }
  | (Down, keys) if keys.arrowDown => {
      ...state,
      rightPlayerY: state.rightPlayerY + 5,
    }
  | _ => state
  }
}

let rec tick = (~setState, ~oldTime=?, ~time=?, ()) => {
  let oldTime = oldTime->Belt.Option.getWithDefault(0)
  let time = time->Belt.Option.getWithDefault(oldTime)
  //let progress = (oldTime - time) / 15 // to be used later with ball movement
  let timer = requestAnimationFrame(time => tick(~setState, ~oldTime=time, ~time=oldTime, ()))
  //ignore(requestAnimationFrame(time => tick(~setState, ~oldTime=time, ~time=oldTime, ())))
  let {arrowUp, arrowDown} = keys
  switch (arrowUp, arrowDown) {
  | (true, true) => setState(Nothing)
  | (_, true) => setState(Down)
  | (true, _) => setState(Up)
  | _ => setState(Nothing)
  }
}
