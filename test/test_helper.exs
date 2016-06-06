SolomonLib.Test.Config.init

defmodule Req do
  @base_url SolomonLib.Test.Config.base_url

  alias SolomonLib.Httpc

  def get(path, headers \\ %{}) do
    Httpc.get!(@base_url <> path, headers)
  end

  def post(path, headers, body) do
    Httpc.post!(@base_url <> path, body, headers)
  end

  def post_json(path, json) do
    body = Poison.encode!(json)
    post(path, [{"content-type", "application/json"}], body)
  end

  def post_form(path, query) do
    body = URI.encode_query(query)
    post(path, [{"content-type", "application/x-www-form-urlencoded"}], body)
  end
end
