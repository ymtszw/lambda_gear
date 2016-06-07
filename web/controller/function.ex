defmodule Lambda.Controller.Function do
  use SolomonLib.Controller
  alias SolomonLib.Conn
  alias SolomonLib.Request, as: Req
  alias Lambda.Model.Function

  def get(%Conn{request: %Req{path_matches: pm}} = conn) do
    case Function.find(pm[:id]) do
      {:ok, func} -> json(conn, 200, func)
      _           -> json(conn, 404, %{error: "not_found"})
    end
  end

  def index(conn) do
    fetched_list =
      Function.all!
      |> Enum.into(%{}, fn id -> {id, Function.find!(id)} end)
    json(conn, 200, %{items: fetched_list})
  end

  def create(%Conn{request: %Req{body: body}} = conn) do
    contents = Map.take(body, ["title", "function_body", "path"])
    {:ok, id} = Function.create(contents)
    json(conn, 201, %{id: id, title: contents["title"]})
  end
end
