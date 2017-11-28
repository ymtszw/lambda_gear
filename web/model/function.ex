use Croma

defmodule Lambda.Model.Function do
  alias Lambda.DataBase, as: DB

  @col_name "functions"

  def find(  id),             do: DB.find(  @col_name, id)
  def all(),                  do: DB.find(  @col_name)
  def count(),                do: all() |> Croma.Result.map(&Enum.count/1)
  def create(id \\ nil, doc), do: DB.insert(@col_name, id, doc)
  def update(id, doc),        do: DB.update(@col_name, id, doc)
  def delete(id),             do: DB.remove(@col_name, id)

  Croma.Result.define_bang_version_of(find: 1, all: 0, count: 0, create: 2, update: 2, delete: 1)
end
