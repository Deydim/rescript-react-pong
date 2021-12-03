//    TYPES

type eventType = string
type key = string
type game = Playing | Over | Paused

type ballVectorTableIndex = [#0 | #1 | #2 ]
type horizontalDirection =
  | Left
  | Right
type verticalDirection =
  | Down
  | Up
type ballDirection = (verticalDirection, horizontalDirection)

type keys = {
  arrowUp: bool,
  arrowDown: bool,
}
type limits = {
  bottom: float,
  right: float,
}
type ball = {
  x: float,
  y: float,
  size: float,
  speed: float,
  horizontalDirection: horizontalDirection,
  verticalDirection: verticalDirection,
  vectorIndex: ballVectorTableIndex,
}

type t = {
  rightPlayerY: float,
  leftPlayerY: float,
  playerWidth: float,
  keys: keys,
  game: game,
  horizontalCollision: option<horizontalDirection>,
  ball: ball,
  fieldLimits: limits,
  playerSize: float,
  oldTime: float,
}

type init = {
  offsetLeft: float,
  offsetTop: float,
  fieldWidth: float,
  fieldHeight: float,
  playerSize: float,
  playerWidth: float,
  leftPlayerX: float,
  leftPlayerY: float,
  rightPlayerX: float,
  rightPlayerY: float,
  leftPlayerCenterX: float,
  rightPlayerCenterX: float,
  ballSize: float,
  ballX: float,
  ballY: float,
}
type progress = float

type action =
  | UpdateConfig(init)
  | PlayerUp
  | PlayerDown
  | Start
  | Pause
  | KeyEvent(eventType, key)
  | BallMove(progress)
  | HandleCollisions
  | SetFrameTime(float)

let keys = {arrowUp: false, arrowDown: false}

let ballVectorTable = [(5, 0.3), (4, 1.2), (3, 2.)]

let init = (config: Config.t) => {
  let offsetLeft = 300.
  let offsetTop = 50.
  let fieldWidth = (config.field_size * 22)->Belt.Int.toFloat
  let fieldHeight = config.field_size->Belt.Int.toFloat /. 30. *. 440.
  let playerSize = (config.player_size * 10)->Belt.Int.toFloat
  let playerWidth = 14.
  let leftPlayerX = 0.
  let leftPlayerY = (fieldHeight -. playerSize) /. 2.
  let rightPlayerY = (fieldHeight -. playerSize) /. 2.
  let rightPlayerX = fieldWidth -. playerWidth
  let ballSize = config.ball_size->Belt.Int.toFloat
  let ballX = (fieldWidth -. ballSize) /. 2.
  let ballY = (fieldHeight -. ballSize) /. 2.
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
    leftPlayerCenterX: leftPlayerX +. playerWidth /. 2.,
    rightPlayerCenterX: rightPlayerX +. playerWidth /. 2.,
  }
}

// STATE

let make = ({
  rightPlayerY,
  leftPlayerY,
  playerWidth,
  ballX,
  ballY,
  ballSize,
  fieldHeight,
  fieldWidth,
  playerSize,
}) => {
  rightPlayerY: rightPlayerY,
  leftPlayerY: leftPlayerY,
  playerSize: playerSize,
  playerWidth: playerWidth,
  keys: keys,
  game: Paused,
  horizontalCollision: None,
  ball: {
    x: ballX,
    y: ballY,
    speed: 0.8,
    horizontalDirection: Left,
    verticalDirection: Down,
    vectorIndex: #1,
    size: ballSize,
  },
  fieldLimits: {
    bottom: fieldHeight,
    right: fieldWidth,
  },
  oldTime: 0.,
}
