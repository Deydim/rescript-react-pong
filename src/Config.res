type t = {
  field_size: int,
  player_size: int,
  ball_size: int,
}

type action =
  | FieldSize(int)
  | PlayerSize(int)
  | BallSize(int)

let reducer = (state, action) =>
  switch action {
  | FieldSize(value) => {...state, field_size: value}
  | PlayerSize(value) => {...state, player_size: value}
  | BallSize(value) => {...state, ball_size: value}
  }
