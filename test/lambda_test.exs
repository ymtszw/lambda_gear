defmodule LambdaTest do
  use ExUnit.Case

  test "hello should render HAML template as HTML" do
    response = Req.get("/hello")
    assert response.status == 200
    assert response.headers["content-type"] == "text/html"
    body = response.body
    assert String.starts_with?(body, "<!DOCTYPE html>")
    assert String.contains?(body, "Message from lambda: Hello!")
  end
end
