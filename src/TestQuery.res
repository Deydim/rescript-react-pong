module MyQuery = {let make = %graphql(`
  { hello (name: "test")
}
`)}

@react.component
let make = () => {
//  Js.log(MyQuery.Inner.query)
  let todosResult = MyQuery.use()
  Js.log2("result:",todosResult)
  // switch todosResult {
  // | {data: Some({hello})} => Js.log("Success")
  // | _ => ()a
  // }
React.null
}