// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Client from "@apollo/client";
import * as ApolloClient__React_Hooks_UseQuery from "rescript-apollo-client/src/@apollo/client/react/hooks/ApolloClient__React_Hooks_UseQuery.mjs";

var Raw = {};

var query = Client.gql(["query   {\nhello(name: \"ok\")  \n}\n"]);

function parse(value) {
  var value$1 = value.hello;
  return {
          hello: !(value$1 == null) ? value$1 : undefined
        };
}

function serialize(value) {
  var value$1 = value.hello;
  var hello = value$1 !== undefined ? value$1 : null;
  return {
          hello: hello
        };
}

function serializeVariables(param) {
  
}

function makeVariables(param) {
  
}

function makeDefaultVariables(param) {
  
}

var Inner = {
  Raw: Raw,
  query: query,
  parse: parse,
  serialize: serialize,
  serializeVariables: serializeVariables,
  makeVariables: makeVariables,
  makeDefaultVariables: makeDefaultVariables
};

var include = ApolloClient__React_Hooks_UseQuery.Extend({
      query: query,
      Raw: Raw,
      parse: parse,
      serialize: serialize,
      serializeVariables: serializeVariables
    });

var use = include.use;

var MyQuery_refetchQueryDescription = include.refetchQueryDescription;

var MyQuery_useLazy = include.useLazy;

var MyQuery_useLazyWithVariables = include.useLazyWithVariables;

var MyQuery = {
  Inner: Inner,
  Raw: Raw,
  query: query,
  parse: parse,
  serialize: serialize,
  serializeVariables: serializeVariables,
  makeVariables: makeVariables,
  makeDefaultVariables: makeDefaultVariables,
  refetchQueryDescription: MyQuery_refetchQueryDescription,
  use: use,
  useLazy: MyQuery_useLazy,
  useLazyWithVariables: MyQuery_useLazyWithVariables
};

function TestQuery(Props) {
  var todosResult = Curry.app(use, [
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined
      ]);
  var match = todosResult.data;
  if (match !== undefined) {
    console.log(match.hello);
  } else {
    console.log("Loading...");
  }
  return null;
}

var make = TestQuery;

export {
  MyQuery ,
  make ,
  
}
/* query Not a pure module */
