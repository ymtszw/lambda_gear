defmodule Lambda.Controller.Error do
  use SolomonLib.Controller

  def error(conn, _reason) do
    json(conn, 500, %{from: "custom_error_handler"})
  end

  def no_route(conn) do
    json(conn, 400, %{error: "no_route"})
  end

  def bad_request(conn) do
    json(conn, 400, %{error: "bad_request"})
  end
end
