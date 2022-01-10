module Slider = {
  @react.component
  let make = (~value, ~label, ~max, ~min, ~onChange) => <>
    <tr>
      <td style={ReactDOMStyle.make(~paddingTop="20px", ~width="100%", ())}>
        {label->React.string}
      </td>
    </tr>
    <tr>
      <td> <input onChange type_="range" min max value /> </td> <td> {value->React.string} </td>
    </tr>
  </>
}
2
module Switch = {
  @react.component
  let make = (~defaultChecked, ~label, ~onChange) => {
    <>
      <tr>
        <td span=2 style={ReactDOMStyle.make(~textAlign="center", ~paddingTop="20px", ())}>
          {React.string(label)}
        </td>
      </tr>
      <tr>
        <td span=2>
          {React.string("Human")}
          <label className="switch">
            <input type_="checkbox" defaultChecked onChange />
            <span className="slider round" />
          </label>
          {React.string("NPC")}
        </td>
      </tr>
    </>
  }
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
            onChange={evt =>
              setConfig(SetFieldSize(ReactEvent.Form.target(evt)["value"]->Belt.Float.toInt))}
          />
          <Slider
            label="Player size"
            value={config.player_size->Belt.Int.toString}
            max="20"
            min="6"
            onChange={evt =>
              setConfig(SetPlayerSize(ReactEvent.Form.target(evt)["value"]->Belt.Float.toInt))}
          />
          <Slider
            label="Ball size"
            value={config.ball_size->Belt.Int.toString}
            max="30"
            min="6"
            onChange={evt =>
              setConfig(SetBallSize(ReactEvent.Form.target(evt)["value"]->Belt.Float.toInt))}
          />
          <Switch
            defaultChecked={true}
            label={"Left"}
            onChange={evt => setConfig(ToggleLeftPlayerControl)}
          />
          <Switch
            defaultChecked={false}
            label={"Right"}
            onChange={evt => setConfig(ToggleRightPlayerControl)}
          />
        </tbody>
      </table>
    </fieldset>
  </div>
}
