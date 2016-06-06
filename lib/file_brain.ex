use Croma

defmodule Lambda.FileBrain do
  alias Croma.Result, as: R

  @random_bits_length 2
  @brain_path Path.expand(Path.join([".", "brain", Atom.to_string(Mix.env)]))

  @type find_t :: map | [String.t]

  defun find(db_name :: v[String.t], col_name :: v[String.t], id :: nil | String.t \\ nil) :: R.t(find_t) do
    case id do
      nil       ->
        col_path = Path.join([@brain_path, db_name, col_name])
        File.ls(col_path)
      file_name ->
        doc_path = Path.join([@brain_path, db_name, col_name, file_name])
        File.read(doc_path) |> R.map(&Poison.decode!/1)
    end
  end

  defun insert(db_name :: v[String.t], col_name :: v[String.t], id :: nil | String.t \\ nil, doc :: v[map]) :: R.t(String.t) do
    file_name = id || generate_id
    col_path = Path.join([@brain_path, db_name, col_name])
    File.mkdir_p!(col_path) # Idempotent. Rarely fails
    doc_path = Path.join(col_path, file_name)
    case File.write(doc_path, Poison.encode!(doc)) do
      :ok -> {:ok, file_name}
      e   -> e
    end
  end

  defun update(db_name :: v[String.t], col_name :: v[String.t], id :: v[String.t], doc :: v[map]) :: R.t(String.t) do
    case find(db_name, col_name, id) do
      {:ok, map} -> insert(db_name, col_name, id, Map.merge(map, doc))
      e          -> e
    end
  end

  defun remove(db_name :: v[String.t], col_name :: v[String.t], id :: v[String.t]) :: R.t(String.t) do
    remove_path(Path.expand(Path.join([@brain_path, db_name, col_name, id])))
  end

  defun drop_db(db_name :: v[String.t]) :: R.t(String.t) do
    remove_path(Path.expand(Path.join([@brain_path, db_name])))
  end

  defun drop_col(db_name :: v[String.t], col_name :: v[String.t]) :: R.t(String.t) do
    remove_path(Path.expand(Path.join([@brain_path, db_name, col_name])))
  end

  # Time-based sortable random ID
  defp generate_id do
    random_bits   = Base.encode16(:crypto.strong_rand_bytes(@random_bits_length))
    timestamp_str = SolomonLib.Time.now |> SolomonLib.Time.to_gregorian_milliseconds |> Integer.to_string(36)
    timestamp_str <> random_bits
  end

  defp remove_path(path) do
    case File.rm_rf(path) do
      {:ok, _}                -> {:ok, Path.basename(path)}
      {:error, reason, _file} -> {:error, reason}
    end
  end

  defpt location, do: @brain_path
end
