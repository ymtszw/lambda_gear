defmodule Lambda.Controller.Hello do
  use SolomonLib.Controller

  def hello(conn) do
    render(conn, 200, "hello", [message: "Hello!"])
  end
end
