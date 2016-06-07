defmodule Lambda.Model.FunctionTest do
  use Croma.TestCase

  @test_d %{"body" => "contents"}

  setup do: on_exit(&Lambda.DataBase.drop_db/0)

  test "model functions should properly handle CRUD operation" do
    {:ok, id1}  = Function.create(@test_d)
    {:ok, doc1} = Function.find(id1)
    assert doc1 == @test_d

    new_doc = %{"body" => "updated"}
    {:ok, id2}  = Function.update(id1, new_doc)
    assert id1 == id2
    {:ok, doc2} = Function.find(id2)
    assert doc2 == new_doc

    {:ok, id3}   = Function.create(@test_d)
    {:ok, list1} = Function.all
    {:ok, c1}    = Function.count
    assert list1 == [id1, id3]
    assert c1    == 2

    {:ok, _}     = Function.delete(id1)
    {:ok, list2} = Function.all
    assert list2 == [id3]
  end
end
