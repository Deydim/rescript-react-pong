type control = Human | NPC
type t = {
  field_size: int,
  player_size: int,
  ball_size: int,
  right_player_control: control,
  left_player_control: control,
}

type action =
  | SetFieldSize(int)
  | SetPlayerSize(int)
  | SetBallSize(int)
  | ToggleRightPlayerControl 
  | ToggleLeftPlayerControl

let toggleControl = value => value == NPC ? Human : NPC

let reducer = (state, action) =>
  switch action {
  | SetFieldSize(value) => {...state, field_size: value}
  | SetPlayerSize(value) => {...state, player_size: value}
  | SetBallSize(value) => {...state, ball_size: value}
  | ToggleRightPlayerControl => {
      ...state,
      right_player_control: toggleControl(state.right_player_control),
    }
  | ToggleLeftPlayerControl => {
      ...state,
      left_player_control: toggleControl(state.left_player_control),
    }
  }

let make = () => {
  field_size: 25,
  player_size: 8,
  ball_size: 16,
  left_player_control: NPC,
  right_player_control: Human,
}
