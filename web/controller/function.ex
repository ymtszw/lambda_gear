defmodule Lambda.Controller.Function do
  use SolomonLib.Controller
  alias SolomonLib.Conn
  alias SolomonLib.Request, as: Req
  alias Lambda.Model.Function

  def create(%Conn{request: %Req{body: body}} = conn) do
    contents = Map.take(body, ["title", "function_body", "path"])
    {:ok, id} = Function.create(contents)
    json(conn, 200, %{"id" => id, "title" => contents["title"]})
  end
end
