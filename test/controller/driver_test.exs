defmodule Lambda.Controller.DriverTest do
  use Croma.TestCase
  alias Lambda.Model.Function, as: F
  alias Lambda.FunctionStore, as: FS

  setup do: on_exit(&Lambda.DataBase.drop_db/0)

  test "should remove function from DB if crashed" do
    code = "undefined_function(conn)"
    func = %{"path" => "path1", "code" => code}
    id = put_function_and_await(func)
    assert {_id, ^code} = FS.find("path1")

    res = Req.get("/path1")
    assert res.status == 500

    assert F.find(id) == {:error, :enoent}
    :timer.sleep(1_001)
    assert FS.find("path1") == nil
  end

  test "should execute lambda code as action" do
    code = "SolomonLib.Controller.Json.json(conn, 200, %{result: :ok})"
    func = %{"path" => "path1", "code" => code}
    put_function_and_await(func)
    assert {_id, ^code} = FS.find("path1")
    res = Req.get("/path1")
    assert res.status == 200
    res_body = res.body |> Poison.decode!
    assert res_body["result"] == "ok"
  end

  defp put_function_and_await(function) do
    {:ok, id} = F.create(function)
    :timer.sleep(1_001)
    id
  end
end
