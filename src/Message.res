let floatToPx = number => number->Belt.Float.toString ++ "px"

@react.component
let make = (~children, ~offsetLeft, ~offsetTop, ~limits: Model.limits) => {
  
  <div style = {
    ReactDOMStyle.make(
      ~position = "absolute",
      ~top = (offsetTop +. limits.bottom /. 2. +. 50.)->floatToPx,
      ~left = (offsetLeft +.  limits.right /. 2. -. 100.)->floatToPx,
      ~width = "200px",
      ~textAlign = "center",
      ~textDecoration= "overline",
      ()
    )
  }>
  children
  </div>
}