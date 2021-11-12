//    TYPES

type game = NotStarted | Playing | Over
type ballHorizontalDirection = Left | Right
type ballVerticalDirection = Up | Down
type ballAngle = Diagonal | Slight | Level
type keys = {
  mutable arrowUp: bool,
  mutable arrowDown: bool,
}
type t = {
  rightPlayerY: int,
  keys: keys,
  // rightPlayerY,
  // ballX,
  // ballY,
  // speed,
  // direction
}

type keyEvent = Up | Down | StartGame | Nothing
type init = {
  offsetLeft: int,
  offsetTop: int,
  fieldWidth: int,
  fieldHeight: int,
  playerSize: int,
  playerWidth: int,
  leftPlayerX: int,
  leftPlayerY: int,
  rightPlayerX: int,
  rightPlayerY: int,
  ballSize: int,
  ballX: int,
  ballY: int,
}

//    DATA

let keys = {arrowUp: false, arrowDown: false}

let init = (config: Config.t) => {
  let offsetLeft = 300
  let offsetTop = 50
  let fieldWidth = config.field_size * 22
  let fieldHeight = (config.field_size->Belt.Int.toFloat /. 30. *. 440.)->Belt.Float.toInt
  let playerSize = config.player_size * 10
  let playerWidth = 15
  let leftPlayerX = 0
  let leftPlayerY = (fieldHeight - playerSize) / 2
  let rightPlayerY = (fieldHeight - playerSize) / 2
  let rightPlayerX = fieldWidth - playerWidth
  let ballSize = config.ball_size
  let ballX = (fieldWidth - ballSize) / 2
  let ballY = (fieldHeight - ballSize) / 2
  {
    offsetLeft: offsetLeft,
    offsetTop: offsetTop,
    fieldWidth: fieldWidth,
    fieldHeight: fieldHeight,
    playerSize: playerSize,
    playerWidth: playerWidth,
    leftPlayerX: leftPlayerX,
    leftPlayerY: leftPlayerY,
    rightPlayerX: rightPlayerX,
    rightPlayerY: rightPlayerY,
    ballSize: ballSize,
    ballX: ballX,
    ballY: ballY,
  }
}

let make = (~rightPlayerY) => {
  rightPlayerY,
  keys: keys,
  // ballX, ballY, speed, direction
}
