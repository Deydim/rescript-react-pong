%%raw(`import './App.css'`)

@react.component
let make = () => {
  let (config, setConfig) = React.useReducer(Config.reducer, Config.make())
  <> <ViewConfig config setConfig /> <Game config /> </>
}
