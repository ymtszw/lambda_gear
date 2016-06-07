defmodule Lambda.Controller.HelloTest do
  use ExUnit.Case

  test "GET / should render root page" do
    response = Req.get("/")
    assert response.status == 200
    assert response.headers["content-type"] == "text/html"
    body = response.body
    assert String.starts_with?(body, "<!DOCTYPE html>")
    assert String.contains?(body, "<div id=\"main\"></div>")
  end
end
