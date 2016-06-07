defmodule Lambda.Controller.FunctionTest do
  use Croma.TestCase
  alias Lambda.Model.Function, as: F

  @test_body %{
    "title" => "function1",
    "path"  => "/path",
    "function_body" => "body"
  }

  setup do: on_exit(&Lambda.DataBase.drop_db/0)

  test "GET /functions/:id should get a function" do
    {:ok, id} = F.create(@test_body)

    res = Req.get("/functions/#{id}")
    assert res.status == 200
    res_body = res.body |> Poison.decode!
    assert res_body["title"]         == "function1"
    assert res_body["path"]          == "/path"
    assert res_body["function_body"] == "body"
  end

  test "GET /functions/:id should return not found for nonexistent id" do
    res = Req.get("/functions/nonexistent")
    assert res.status == 404
  end

  test "POST /functions should create a new function" do
    res = Req.post_json("/functions", @test_body)
    assert res.status == 201
    res_body = res.body |> Poison.decode!
    assert String.length(res_body["id"]) == 13
    assert res_body["title"] == "function1"

    assert F.count |> Croma.Result.get! == 1
    {:ok, contents} = F.find(res_body["id"])
    assert contents["title"]         == "function1"
    assert contents["path"]          == "/path"
    assert contents["function_body"] == "body"
  end
end
