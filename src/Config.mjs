// Generated by ReScript, PLEASE EDIT WITH CARE


function reducer(state, action) {
  switch (action.TAG | 0) {
    case /* SetFieldSize */0 :
        return {
                field_size: action._0,
                player_size: state.player_size,
                ball_size: state.ball_size
              };
    case /* SetPlayerSize */1 :
        return {
                field_size: state.field_size,
                player_size: action._0,
                ball_size: state.ball_size
              };
    case /* SetBallSize */2 :
        return {
                field_size: state.field_size,
                player_size: state.player_size,
                ball_size: action._0
              };
    
  }
}

function make(param) {
  return {
          field_size: 25,
          player_size: 8,
          ball_size: 16
        };
}

export {
  reducer ,
  make ,
  
}
/* No side effect */
