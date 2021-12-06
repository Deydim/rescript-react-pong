module MyQuery = {
  let make = %graphql(`{ hello (name: "OK")}`)
}

module MySub = %graphql(`subscription {sub_incremented}`)


  @react.component
  let make = () => {
    let (execute, result) = MyQuery.useLazy()
    let onClick = _ => {
      execute()
    }
    switch result {
    | Executed ({loading, data: Some({hello})}) => Js.log("some data")
    | _ =>()
    }
     <button onClick> {"Query me"->React.string} </button>
  }

