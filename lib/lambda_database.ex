use Croma

defmodule Lambda.DataBase do
  alias Lambda.FileBrain, as: FB

  @db_name "lambda"

  def find(  col, id \\ nil),      do: FB.find(  @db_name, col, id)
  def insert(col, id \\ nil, doc), do: FB.insert(@db_name, col, id, doc)
  def update(col, id, doc),        do: FB.update(@db_name, col, id, doc)
  def remove(col, id),             do: FB.remove(@db_name, col, id)

  def drop_col(col), do: FB.drop_col(@db_name, col)
  def drop_db,       do: FB.drop_db( @db_name)
end
