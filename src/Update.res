@val external requestAnimationFrame: ('a => unit) => int = "requestAnimationFrame"

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
      Js.log("start")
      {state}
    }
  | _ => state
  }
}

let handleUserInput: (string, bool) => unit = (key, isPressed) =>
  switch key {
  | "ArrowUp" => Model.keys.arrowUp = isPressed
  | "ArrowDown" => Model.keys.arrowDown = isPressed
  // | " " => setState(Start)
  | _ => ()
  }

let rec tick = (~setState, ~oldTime=?, ~time=?, ()) => {
  let oldTime = oldTime->Belt.Option.getWithDefault(0)
  let time = time->Belt.Option.getWithDefault(oldTime)
  //let progress = (oldTime - time) / 15 // to be used later with ball movement
  let timer = requestAnimationFrame(time => tick(~setState, ~oldTime=time, ~time=oldTime, ()))
  let {arrowUp, arrowDown} = Model.keys
  open Model
  switch (arrowUp, arrowDown) {
  | (true, true) => setState(Nothing)
  | (_, true) => setState(Down)
  | (true, _) => setState(Up)
  | _ => setState(Nothing)
  }
}