defmodule Lambda.Controller.FunctionTest do
  use Croma.TestCase
  alias Lambda.Model.Function, as: F

  setup do: on_exit(&Lambda.DataBase.drop_db/0)

  test "POST /functions should create new function" do
    payload = %{
      "title" => "function1",
      "path"  => "/path",
      "function_body" => "body"
    }
    result = Req.post_json("/functions", payload)
    body = result.body |> Poison.decode!
    assert String.length(body["id"]) == 13
    assert body["title"] == "function1"

    assert F.count |> Croma.Result.get! == 1
    {:ok, contents} = F.find(body["id"])
    assert contents["title"]         == "function1"
    assert contents["path"]          == "/path"
    assert contents["function_body"] == "body"
  end
end
