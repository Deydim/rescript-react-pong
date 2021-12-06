module MyQuery = {let make = %graphql(`
  { hello (name: "ok")
}
`)}

@react.component
let make = () => {
//  Js.log(MyQuery.Inner.query)
  let todosResult = MyQuery.use()
  switch todosResult {
  | {data: Some({hello})} => Js.log(hello)
  | _ => Js.log("Loading...")
  }
React.null
}