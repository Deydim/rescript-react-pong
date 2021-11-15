@scope("document") @val
external addEventListener: (string, ReactEvent.Keyboard.t => 'a) => unit = "addEventListener"
@scope("document") @val external removeEventListener: string => unit = "removeEventListener"

let intToPx = number => number->Belt.Int.toString ++ "px"

let keyEventHandler = (evt, ~dispatch: Model.action => unit) => {
  switch ReactEvent.Keyboard.key(evt) {
  | "ArrowUp" | "ArrowDown" => {
      ReactEvent.Keyboard.preventDefault(evt)
      dispatch(
        KeyEvent(ReactEvent.Keyboard.type_(evt), ReactEvent.Keyboard.key(evt))
      )
    }
  | " " => {
      ReactEvent.Keyboard.preventDefault(evt)
      if ReactEvent.Keyboard.type_(evt) == "keydown" {
        dispatch(
          KeyEvent(ReactEvent.Keyboard.type_(evt), ReactEvent.Keyboard.key(evt))
        )
      }
    }
  | _ => ()
  }
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

  let (state, dispatch) = React.useReducer(
    Update.updateState, 
    Model.make(
      ~rightPlayerY,
      ~ballSize,
      ~ballX,
      ~ballY,
    )
  )
  
  React.useEffect0(() => {
    addEventListener("keydown", evt => keyEventHandler(evt, ~dispatch))
    addEventListener("keyup", evt => keyEventHandler(evt, ~dispatch))
    Some(
      () => {
        removeEventListener("keyup")
        removeEventListener("keydown")
      },
    )
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
    <Update.Tick dispatch state />
  </>
}
