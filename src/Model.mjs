// Generated by ReScript, PLEASE EDIT WITH CARE


var keys = {
  arrowUp: false,
  arrowDown: false
};

var ballVectorTable = [
  [
    5,
    0.3
  ],
  [
    4,
    1.2
  ],
  [
    3,
    2
  ],
  [
    0,
    0
  ]
];

function init(config) {
  var fieldWidth = Math.imul(config.field_size, 22);
  var fieldHeight = config.field_size / 30 * 440 | 0;
  var playerSize = Math.imul(config.player_size, 10);
  var leftPlayerY = (fieldHeight - playerSize | 0) / 2 | 0;
  var rightPlayerY = (fieldHeight - playerSize | 0) / 2 | 0;
  var rightPlayerX = fieldWidth - 15 | 0;
  var ballSize = config.ball_size;
  var ballX = (fieldWidth - ballSize | 0) / 2 | 0;
  var ballY = (fieldHeight - ballSize | 0) / 2 | 0;
  return {
          offsetLeft: 300,
          offsetTop: 50,
          fieldWidth: fieldWidth,
          fieldHeight: fieldHeight,
          playerSize: playerSize,
          playerWidth: 15,
          leftPlayerX: 0,
          leftPlayerY: leftPlayerY,
          rightPlayerX: rightPlayerX,
          rightPlayerY: rightPlayerY,
          ballSize: ballSize,
          ballX: ballX,
          ballY: ballY
        };
}

function make(rightPlayerY, ballX, ballY, ballSize) {
  return {
          rightPlayerY: rightPlayerY,
          keys: keys,
          game: /* Paused */2,
          ball: {
            x: ballX,
            centerX: ballX + (ballSize / 2 | 0) | 0,
            y: ballY,
            centerY: ballY + (ballSize / 2 | 0) | 0,
            speed: 1.9,
            direction: /* UpRight */1,
            vectorIndex: 0
          }
        };
}

export {
  keys ,
  ballVectorTable ,
  init ,
  make ,
  
}
/* No side effect */
