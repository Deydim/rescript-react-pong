@scope("document") @val
external addEventListener: (string, ReactEvent.Keyboard.t => 'a) => unit = "addEventListener"
@scope("document") @val external removeEventListener: string => unit = "removeEventListener"

open Model

let intToPx = number => number->Belt.Int.toString ++ "px"

let preventDefault = evt =>
  switch ReactEvent.Keyboard.key(evt) {
    | "ArrowUp"
    | "ArrowDown" => ReactEvent.Keyboard.preventDefault(evt)
    | _ => ()
  }

@react.component
let make = (~config: Config.t) => {
  let {
    offsetLeft,
    offsetTop,
    fieldWidth,
    fieldHeight,
    playerSize,
    playerWidth,
    leftPlayerX,
    leftPlayerY,
    rightPlayerX,
    rightPlayerY,
    ballSize,
    ballX,
    ballY,
  } = Model.init(config)

  let (state, setState) = React.useReducer(Update.updateState, Model.make(~rightPlayerY))

  React.useEffect0(() => {
    addEventListener("keydown", evt => {
      preventDefault(evt)
      Update.handleUserInput(ReactEvent.Keyboard.key(evt), true)
    })
    Some(() => removeEventListener("keydown"))
  })
  React.useEffect0(() => {
    addEventListener("keyup", evt => {
      preventDefault(evt)
      Update.handleUserInput(ReactEvent.Keyboard.key(evt), false)
    })
    Some(() => removeEventListener("keyup"))
  })
  React.useEffect0(() => {
    Update.tick(~setState, ())
    None
  })
  <>
    <div
      className="field"
      style={ReactDOMStyle.make(
        ~left=offsetLeft->intToPx,
        ~top=offsetTop->intToPx,
        ~width=fieldWidth->intToPx,
        ~height=fieldHeight->intToPx,
        (),
      )}
    />
    <div
      className="player"
      style={ReactDOMStyle.make(
        ~left=(leftPlayerX + offsetLeft)->intToPx,
        ~top=(leftPlayerY + offsetTop)->intToPx,
        ~width=playerWidth->intToPx,
        ~height=playerSize->intToPx,
        (),
      )}
    />
    <div
      className="player"
      style={ReactDOMStyle.make(
        ~left=(rightPlayerX + offsetLeft)->intToPx,
        ~top=(state.rightPlayerY + offsetTop)->intToPx,
        ~width=playerWidth->intToPx,
        ~height=playerSize->intToPx,
        (),
      )}
    />
    <div
      className="ball"
      style={ReactDOMStyle.make(
        ~left=(ballX + offsetLeft)->intToPx,
        ~top=(ballY + offsetTop)->intToPx,
        ~width=ballSize->intToPx,
        ~height=ballSize->intToPx,
        ~borderRadius=(ballSize / 2)->intToPx,
        (),
      )}
    />
  </>
}
