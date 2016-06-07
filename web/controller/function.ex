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
    case Map.take(body, ["title", "code", "path"]) do
      %{"code" => _, "path" => _} = func ->
         {:ok, id} = Function.create(func)
         json(conn, 201, %{id: id, title: func["title"]})
      _ -> json(conn, 400, %{error: "`code` and `path` keys required!"})
    end
  end
end
