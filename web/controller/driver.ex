use Croma

defmodule Lambda.Controller.Driver do
  use SolomonLib.Controller
  alias SolomonLib.Conn
  alias SolomonLib.Request, as: Req
  alias Lambda.FunctionStore, as: FS

  def execute(%Conn{request: %Req{path_matches: pm}} = conn) do
    case FS.find(pm[:path]) do
      nil        -> json(conn, 404, %{error: "not_found"})
      {id, code} -> do_execute(conn, id, code)
    end
  end

  def do_execute(conn, id, code) do
    try do
      {res, _binding} = Code.eval_string(code, [conn: conn])
      res
    rescue
      e ->
        Lambda.Model.Function.delete!(id) # Delete un-compilable function
        json(conn, 500, %{message: "lambda function: #{id} crashed and deleted!", error: inspect(e)})
    end
  end
end
