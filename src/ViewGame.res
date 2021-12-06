@scope("document") @val
external addEventListener: (string, ReactEvent.Keyboard.t => 'a) => unit = "addEventListener"
@scope("document") @val external removeEventListener: string => unit = "removeEventListener"

let floatToPx = number => number->Belt.Float.toString ++ "px"

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
  let init = Model.init(config)
  let {
    offsetLeft,
    offsetTop,
    fieldWidth,
    fieldHeight,
    playerSize,
    playerWidth,
    leftPlayerX,
    rightPlayerX,
    ballSize
  } = init

  let (state, dispatch) = React.useReducer(
    Update.updateState, 
    Model.make(init)
  )
  
  React.useEffect1(() => {
    addEventListener("keydown", evt => keyEventHandler(evt, ~dispatch))
    addEventListener("keyup", evt => keyEventHandler(evt, ~dispatch))
    Some(
      () => {
        removeEventListener("keyup")
        removeEventListener("keydown")
      },
    )
  },[dispatch])

  React.useEffect3( () => {
    dispatch(UpdateConfig(init))
    dispatch(MovePlayer(Up))
    dispatch(MovePlayer(Down))
    dispatch(BallMove(0.))
    // moves players and ball to force update of their position within field limits
    None
  }, (config, init, dispatch))

  <>
    <div
      className="field"
      style={ReactDOMStyle.make(
        ~left=offsetLeft->floatToPx,
        ~top=offsetTop->floatToPx,
        ~width=fieldWidth->floatToPx,
        ~height=fieldHeight->floatToPx,
        (),
      )}
    />
    <div
      className="player"
      style={ReactDOMStyle.make(
        ~left=(leftPlayerX +. offsetLeft)->floatToPx,
        ~top=(state.leftPlayerY +. offsetTop)->floatToPx,
        ~width=playerWidth->floatToPx,
        ~height=playerSize->floatToPx,
        (),
      )}
    />
    <div
      className="player"
      style={ReactDOMStyle.make(
        ~left=(rightPlayerX +. offsetLeft)->floatToPx,
        ~top=(state.rightPlayerY +. offsetTop)->floatToPx,
        ~width=playerWidth->floatToPx,
        ~height=playerSize->floatToPx,
        (),
      )}
    />
    <div
      className="ball"
      style={ReactDOMStyle.make(
        ~left=(state.ball.x +. offsetLeft)->floatToPx,
        ~top=(state.ball.y +. offsetTop)->floatToPx,
        ~width=ballSize->floatToPx,
        ~height=ballSize->floatToPx,
        ~borderRadius=(ballSize /. 2.)->floatToPx,
        (),
      )}

    />
    <Update.Tick dispatch state />
  </>
}
