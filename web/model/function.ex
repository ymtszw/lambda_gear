defmodule Lambda.Model.Function do
  alias Lambda.DataBase, as: DB

  @col_name "functions"

  def find(  id),             do: DB.find(  @col_name, id)
  def all,                    do: DB.find(  @col_name)
  def create(id \\ nil, doc), do: DB.insert(@col_name, id, doc)
  def update(id, doc),        do: DB.update(@col_name, id, doc)
  def delete(id),             do: DB.remove(@col_name, id)
end
