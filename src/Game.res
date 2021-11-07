type t = NotStarted | Playing | Over

let intToPx = number => number->Belt.Int.toString ++ "px"

@react.component
let make = (~config: Config.t) => {
  let offsetLeft = 300
  let offsetTop = 50
  let fieldWidth = config.field_size * 22
  let fieldHeight = (config.field_size->Belt.Int.toFloat /. 30. *. 440.)->Belt.Float.toInt
  let playerWidth = 15
  let leftPlayerX = 0
  let rightPlayerX = fieldWidth - playerWidth
  let playerSize = config.player_size * 10
  let ballSize = config.ball_size
  let ballX = (fieldWidth -ballSize)/2

  <>
    <div
      className="field"
      style={ReactDOMStyle.make(
        ~left = offsetLeft->intToPx,
        ~top = offsetTop->intToPx,
        ~width = fieldWidth->intToPx,
        ~height = fieldHeight->intToPx,
        (),
      )}
    />
    <div className="player" style={ReactDOMStyle.make( 
      ~left = (leftPlayerX + offsetLeft)->intToPx,
      ~top = ((fieldHeight - playerSize)/2 + offsetTop)->intToPx,
      ~width = playerWidth->intToPx,
      ~height = playerSize->intToPx,
      ()
    )} />
    <div className="player" style={ReactDOMStyle.make( 
      ~left = (rightPlayerX + offsetLeft)->intToPx,
      ~top = ((fieldHeight - playerSize)/2 + offsetTop)->intToPx,
      ~width = playerWidth->intToPx,
      ~height = playerSize->intToPx,
      ()
    )} />
    <div className="ball" style={ReactDOMStyle.make( 
      ~left = (ballX + offsetLeft)->intToPx,
      ~top = ((fieldHeight - ballSize)/2 + offsetTop)->intToPx,
      ~width = ballSize->intToPx,
      ~height = ballSize->intToPx,
      ~borderRadius = (ballSize/2)->intToPx,
      ()
    )} />

  </>
}
