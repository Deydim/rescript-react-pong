module Slider = {
  @react.component
  let make = (~value, ~label, ~max, ~min, ~onChange) => <>
    <tr> <td style={ReactDOMStyle.make(~paddingTop="20px", ())}> {label->React.string} </td> </tr>
    <tr>
      <td> <input onChange type_="range" min max value /> </td> <td> {value->React.string} </td>
    </tr>
  </>
}

@react.component
let make = (~config: Config.t, ~setConfig: Config.action => unit) => {
  <div className="configContainer">
    <fieldset>
      <legend> {"Config"->React.string} </legend>
      <table>
        <tbody>
          <Slider
            label="Field size"
            value={config.field_size->Belt.Int.toString}
            max="40"
            min="10"
            onChange={evt => setConfig(SetFieldSize(ReactEvent.Form.target(evt)["value"]))}
          />
          <Slider
            label="Player size"
            value={config.player_size->Belt.Int.toString}
            max="20"
            min="6"
            onChange={evt => setConfig(SetPlayerSize(ReactEvent.Form.target(evt)["value"]))}
          />
          <Slider
            label="Ball size"
            value={config.ball_size->Belt.Int.toString}
            max="30"
            min="6"
            onChange={evt => setConfig(SetBallSize(ReactEvent.Form.target(evt)["value"]))}
          />
        </tbody>
      </table>
    </fieldset>
  </div>
}
