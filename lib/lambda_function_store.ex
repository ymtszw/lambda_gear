use Croma

defmodule Lambda.FunctionStore do
  @moduledoc """
  Poll the DB, periodically reloading persisted functions into ETS.
  Use `find/1` to lookup per ID.
  """

  use GenServer
  alias Lambda.Model.Function, as: Func

  @table_name :lambda_code_store
  @interval if(Mix.env == :test, do: 1_000, else: 3_000)

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    _table_id = :ets.new(@table_name, [:public, :named_table, {:read_concurrency, true}])
    :ets.insert(@table_name, load_codes)
    {:ok, :polling, @interval}
  end

  def handle_info(:timeout, _old_funcs) do
    :ets.insert(@table_name, load_codes)
    {:noreply, :polling, @interval}
  end

  defp load_codes do
    Func.all!
    |> Enum.map(fn id -> {id, Func.find!(id)} end)
    |> Enum.reject(fn
      {_, %{"path" => _, "code" => _}} -> false
      _                                -> true
    end)
    |> Enum.into(%{}, fn {id, %{"path" => path, "code" => code}} -> {path, {id, code}} end)
    |> Map.to_list
  end

  # APIs

  @doc """
  Finds and returns a function of the given path from currently stored functions
  """
  defun find(path :: String.t) :: nil | map do
    case :ets.lookup(@table_name, path) do
      []             -> nil
      [{_, id_code}] -> id_code
    end
  end
end
