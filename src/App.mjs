// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Apollo from "./Apollo.mjs";
import * as Config from "./Config.mjs";
import * as ViewGame from "./ViewGame.mjs";
import * as TestQuery from "./TestQuery.mjs";
import * as ViewConfig from "./ViewConfig.mjs";
import * as Client from "@apollo/client";

import './App.css'
;

function App(Props) {
  var match = React.useReducer(Config.reducer, Config.make(undefined));
  var config = match[0];
  return React.createElement(Client.ApolloProvider, {
              client: Apollo.client,
              children: React.createElement(React.Fragment, undefined, React.createElement(TestQuery.make, {}), React.createElement(ViewConfig.make, {
                        config: config,
                        setConfig: match[1]
                      }), React.createElement(ViewGame.make, {
                        config: config
                      }))
            });
}

var make = App;

export {
  make ,
  
}
/*  Not a pure module */
