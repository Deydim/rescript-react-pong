// let client = {
//   open ApolloClient
//   make(
//     ~cache=Cache.InMemoryCache.make(),
//     // I would turn this off in production
//     ~connectToDevTools=true,
//     ~uri=_ => "http://localhost:4000/graphql
//     ",
//     (),
//   )
// }
let httpLink = ApolloClient.Link.HttpLink.make(
  ~uri=_ => "https://localhost:4000",
  // Auth headers
  // ~headers=Obj.magic(headers),
  (),
)

let wsLink = {
  open ApolloClient.Link.WebSocketLink
  make(
    ~uri="ws://localhost:4000",
    ~options=ClientOptions.make(
      // Auth headers
      // ~connectionParams=ConnectionParams(Obj.magic({"headers": headers})),
      ~reconnect=true,
      (),
    ),
    (),
  )
}

// This is a splitter that intelligently routes requests through http or websocket depending on type
let terminatingLink = ApolloClient.Link.split(~test=({query}) => {
  let definition = ApolloClient.Utilities.getOperationDefinition(query)
  switch definition {
  | Some({kind, operation}) => kind === "OperationDefinition" && operation === "subscription"
  | None => false
  }
}, ~whenTrue=wsLink, ~whenFalse=httpLink)

let client = {
  open ApolloClient
  make(
    ~cache=Cache.InMemoryCache.make(),
    ~connectToDevTools=true,
    ~defaultOptions=DefaultOptions.make(
      ~mutate=DefaultMutateOptions.make(~awaitRefetchQueries=true, ~errorPolicy=All, ()),
      ~query=DefaultQueryOptions.make(~fetchPolicy=NetworkOnly, ~errorPolicy=All, ()),
      ~watchQuery=DefaultWatchQueryOptions.make(~fetchPolicy=NetworkOnly, ~errorPolicy=All, ()),
      (),
    ),
    ~link=terminatingLink,
    (),
  )
}