%%raw(`import './App.css'`)

@react.component
let make = () => {
  let initialConfig: Config.t = {field_size: 25, player_size: 8, ball_size: 16}
  let (config, setConfig) = React.useReducer(Config.reducer, initialConfig)
  <>
    <div className="configContainer"> <ViewConfigUI config setConfig /> </div>
    <div> <div className="field"> <Game config/> </div> </div>
  </>
}
