defmodule Lambda.Router do
  use SolomonLib.Router

  get "/hello", Hello, :hello

  post "/functions", Function, :create
end
