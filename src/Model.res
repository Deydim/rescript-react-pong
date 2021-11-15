//    TYPES

type eventType = string
type key = string
type action = Up | Down | Nothing | Start | Pause | KeyEvent(eventType, key)
type game = Playing | Over | Paused

type ballVectorTableIndex = [#0 | #1 | #2 | #3]
type ballDirection =
  | UpLeft
  | UpRight
  | DownLeft
  | DownRight

type keys = {
  arrowUp: bool,
  arrowDown: bool,
}

type ball = {
  x: int,
  centerX: int,
  y: int,
  centerY: int,
  speed: float,
  direction: ballDirection,
  vectorIndex: ballVectorTableIndex
}

type t = {
  rightPlayerY: int,
  keys: keys,
  game: game,
  ball: ball,
}

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

//    INIT

let keys = {arrowUp: false, arrowDown: false}
let ballVectorTable = [(5, 0.3), (4, 1.2), (3, 2.), (0, 0.)]

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

// STATE

let make = (~rightPlayerY, ~ballX, ~ballY, ~ballSize) => {
  rightPlayerY: rightPlayerY,
  keys: keys,
  game: Paused,
  ball: {
    x: ballX,
    centerX: ballX + ballSize / 2,
    y: ballY,
    centerY: ballY + ballSize / 2,
    speed: 1.9,
    direction: UpRight,
    vectorIndex: #0
  },
}
