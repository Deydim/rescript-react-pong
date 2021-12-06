let client = {
  open ApolloClient
  make(
    ~cache=Cache.InMemoryCache.make(),
    // I would turn this off in production
    ~connectToDevTools=true,
    ~uri=_ => "http://localhost:4000/graphql
    ",
    (),
  )
}