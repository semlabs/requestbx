defmodule RequestbxWeb.StoreController do
  use RequestbxWeb, :controller

  def store(conn, params) do
    params = Map.delete(params, "path")
    :ets.insert(:request_store, {conn.request_path, params})

    conn
    |> put_resp_content_type("text/json")
    |> send_resp(200, "")
  end

  def get(conn, params) do
    expected_item_count = 
      (params["expected_items"] || "1")
      |> String.to_integer() 

    retry(fn -> 
      :ets.lookup(:request_store, conn.request_path) 
    end, expected_item_count)
    |> remove_key(conn)
  end

  defp retry(fun, item_count, times \\ 0)

  defp retry(fun, _, 100) do
    fun.()
  end

  defp retry(fun, item_count, times) do
    list = fun.()
    case length(list) do
      len when len >= item_count -> list
      len ->
        Process.sleep(10)
        retry(fun, item_count, times + 1)
    end
  end

  defp remove_key([], conn) do
    conn |> send_resp(200, "") 
  end

  defp remove_key(list, conn) do
    response = 
      list
      |> Enum.map(fn {_, value} -> 
        value 
      end)
    conn |> json(response)
  end

  def destroy(%{request_path: "/"} = conn, _params) do
    :ets.delete_all_objects(:request_store)
    conn |> send_resp(204, "") 
  end

  def destroy(conn, _params) do
    :ets.delete(:request_store, conn.request_path) 
    conn |> send_resp(204, "") 
  end
end
