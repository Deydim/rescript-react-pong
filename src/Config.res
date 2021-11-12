type t = {
  field_size: int,
  player_size: int,
  ball_size: int,
}

type action =
  | SetFieldSize(int)
  | SetPlayerSize(int)
  | SetBallSize(int)

let reducer = (state, action) =>
  switch action {
  | SetFieldSize(value) => {...state, field_size: value}
  | SetPlayerSize(value) => {...state, player_size: value}
  | SetBallSize(value) => {...state, ball_size: value}
  }

let make = () => {field_size: 25, player_size: 8, ball_size: 16}