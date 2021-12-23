@scope("document") @val
external addEventListener: (string, ReactEvent.Keyboard.t => 'a) => unit = "addEventListener"
@scope("document") @val external removeEventListener: string => unit = "removeEventListener"

let floatToPx = number => number->Belt.Float.toString ++ "px"

let keyEventHandler = (evt, ~send: Model.action => unit) => {
  switch ReactEvent.Keyboard.key(evt) {
  | "ArrowUp" | "ArrowDown" => {
      ReactEvent.Keyboard.preventDefault(evt)
      send(
        KeyEvent(ReactEvent.Keyboard.type_(evt), ReactEvent.Keyboard.key(evt))
      )
    }
  | " " => {
      ReactEvent.Keyboard.preventDefault(evt)
      if ReactEvent.Keyboard.type_(evt) == "keydown" {
        send(
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

  let (state, send) = React.useReducer(
    Update.updateState, 
    Model.make(init)
  )
  
  React.useEffect1(() => {
    addEventListener("keydown", evt => keyEventHandler(evt, ~send))
    addEventListener("keyup", evt => keyEventHandler(evt, ~send))
    Some(
      () => {
        removeEventListener("keyup")
        removeEventListener("keydown")
      },
    )
  },[send])

  React.useEffect1( () => {
    send(UpdateConfig(init))
    send(MovePlayer(Up, LeftPlayer(NPC)))
    send(MovePlayer(Down, LeftPlayer(NPC)))
    send(MovePlayer(Up, RightPlayer(NPC)))
    send(MovePlayer(Down, RightPlayer(NPC)))
    send(BallMove(0.))
    // moves players and ball to force update of their position within field limits
    None
  }, [config])

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
    <div style = {
    ReactDOMStyle.make(
      ~position = "absolute",
      ~top = (offsetTop +. init.fieldHeight +. 50.)->floatToPx,
      ~left = (offsetLeft +.  init.fieldWidth /. 2. -. 100.)->floatToPx,
      ~width = "200px",
      ~textAlign = "center",
      ()
    )
  }>
    {switch state.game {
      | Playing => {React.null} 
      | Paused => {React.string("Paused")} 
      | NotStarted => {React.string("Press space to play")}
    }}
    </div>
    <Update.Tick send state />
  </>
}
