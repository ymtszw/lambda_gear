defmodule Lambda.FileBrainTest do
  use Croma.TestCase, alias_as: FB

  @db "test_db"
  @col "test_col"
  @d %{"data" => "value"}

  setup do: on_exit(&remove_brain/0)

  defp remove_brain, do: File.rm_rf(FB.location)

  test "insert/4 should insert data as file" do
    {:ok, file_name} = FB.insert(@db, @col, @d)
    doc_path = Path.join([FB.location, @db, @col, file_name])
    assert File.read!(doc_path) == "{\"data\":\"value\"}"
  end

  test "insert/4 should insert data as file with given id" do
    id = "doc01"
    {:ok, file_name} = FB.insert(@db, @col, id, @d)
    assert file_name == id
  end

  test "find/3 should get data as map" do
    {:ok, id} = FB.insert(@db, @col, @d)
    {:ok, doc} = FB.find(@db, @col, id)
    assert doc == @d
  end

  test "find/3 should get doc list within a col" do
    {:ok, id1} = FB.insert(@db, @col, @d)
    :timer.sleep(1) # wait 1 millisec to ensure timestamp ordering
    {:ok, id2} = FB.insert(@db, @col, @d)
    {:ok, list} = FB.find(@db, @col)
    assert list == [id1, id2] # IDs sorted by time
  end

  test "update/4 should update a doc" do
    {:ok, id1} = FB.insert(@db, @col, @d)
    new_doc = %{"data" => "updated", "add" => "field"}
    {:ok, id2} = FB.update(@db, @col, id1, new_doc)
    assert id1 == id2
    {:ok, doc} = FB.find(@db, @col, id2)
    assert doc == new_doc
  end

  test "remove/3 should remove a doc" do
    {:ok, id1} = FB.insert(@db, @col, @d)
    :timer.sleep(1) # wait 1 millisec to ensure timestamp ordering
    {:ok, id2} = FB.insert(@db, @col, @d)
    {:ok, list1} = FB.find(@db, @col)
    assert list1 == [id1, id2]
    {:ok, id3} = FB.remove(@db, @col, id1)
    assert id3 == id1
    {:ok, list2} = FB.find(@db, @col)
    assert list2 == [id2]
  end

  test "drop_db/1 should delete db" do
    {:ok, id} = FB.insert(@db, @col, @d)
    {:ok, db} = FB.drop_db(@db)
    assert db == @db
    assert {:error, :enoent} == FB.find(@db, @col, id)
    db_path = Path.join([FB.location, @db])
    refute File.exists?(db_path)
  end

  test "drop_col/2 should delete col" do
    {:ok, id} = FB.insert(@db, @col, @d)
    {:ok, col} = FB.drop_col(@db, @col)
    assert col == @col
    assert {:error, :enoent} == FB.find(@db, @col, id)
    db_path = Path.join([FB.location, @db])
    assert File.exists?(db_path)
    col_path = Path.join(db_path, @col)
    refute File.exists?(col_path)
  end
end
