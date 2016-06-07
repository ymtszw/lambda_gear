defmodule Lambda.Router do
  use SolomonLib.Router

  get "/", Hello, :root

  get  "/functions",     Function, :index
  get  "/functions/:id", Function, :get
  post "/functions",     Function, :create
end
