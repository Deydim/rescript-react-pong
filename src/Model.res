
type eventType = string
type key = string
type game = Playing | Paused | NotStarted

type ballVector = Slight | Medium | Sharp
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
  keyA: bool,
  keyZ: bool
}
type limits = {
  bottom: float,
  right: float,
}
type ball = {
  isOut: bool,
  x: float,
  y: float,
  size: float,
  speed: float,
  horizontalDirection: horizontalDirection,
  verticalDirection: verticalDirection,
  vector: ballVector,
  predictedY: float,
}

type t = {
  rightPlayerY: float,
  leftPlayerY: float,
  rightPlayerControl: Config.control,
  leftPlayerControl: Config.control,
  playerWidth: float,
  keys: keys,
  game: game,
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
  leftPlayerControl: Config.control,
  rightPlayerControl: Config.control
}
type progress = float
type player = RightPlayer | LeftPlayer
type action =
  | UpdateConfig(init)
  | MovePlayer(verticalDirection, player)
  | KeyEvent(eventType, key)
  | BallMove(progress)
  | HandleCollisions
  | SetFrameTime(float)
  | None

let keys = {arrowUp: false, arrowDown: false, keyA: false, keyZ: false}

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
  let leftPlayerControl = config.left_player_control 
  let rightPlayerControl = config.right_player_control
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
    leftPlayerControl: leftPlayerControl,
    rightPlayerControl: rightPlayerControl
  }
}

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
  leftPlayerControl,
  rightPlayerControl,
}) => {
  rightPlayerY: rightPlayerY,
  leftPlayerY: leftPlayerY,
  rightPlayerControl: rightPlayerControl,
  leftPlayerControl: leftPlayerControl,
  playerSize: playerSize,
  playerWidth: playerWidth,
  keys: keys,
  game: NotStarted,
  ball: {
    isOut: false,
    x: ballX,
    y: ballY,
    speed: 4.,
    horizontalDirection: Left,
    verticalDirection: Down,
    vector: Slight,
    size: ballSize,
    predictedY: fieldHeight /. 2.,
  },
  fieldLimits: {
    bottom: fieldHeight,
    right: fieldWidth,
  },
  oldTime: 0.,
}

let getVector = (vec: ballVector) => {
  switch vec {
  | Slight => ballVectorTable[0]
  | Medium => ballVectorTable[1]
  | Sharp => ballVectorTable[2]
  }
}