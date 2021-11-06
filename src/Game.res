  type t = NotStarted | Playing | Over
@react.component
let make = (~config: Config.t)=> 
  <>
  {config.field_size->Belt.Int.toString->React.string}
  {config.player_size->Belt.Int.toString->React.string}
  {config.ball_size->Belt.Int.toString->React.string}
  </>
