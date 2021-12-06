%%raw(`import './App.css'`)


@react.component
let make = () => {
  let (config, setConfig) = React.useReducer(Config.reducer, Config.make())
  <ApolloClient.React.ApolloProvider client={Apollo.client}>
    <> <TestQuery/><ViewConfig config setConfig /> <ViewGame config /> </>
  </ApolloClient.React.ApolloProvider>
}


