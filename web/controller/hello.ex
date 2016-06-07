defmodule Lambda.Controller.Hello do
  use SolomonLib.Controller

  def root(conn) do
    render(conn, 200, "root", [])
  end
end
