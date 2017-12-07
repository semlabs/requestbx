defmodule RequestbxWeb.StoreController do
  use RequestbxWeb, :controller

  def store(conn, params) do
    params = Map.delete(params, "path")
    :ets.insert(:request_store, {conn.request_path, params})

    conn
    |> put_resp_content_type("text/json")
    |> send_resp(200, "")
  end

  def get(conn, _params) do
    retry(fn -> 
      :ets.lookup(:request_store, conn.request_path) 
    end, 0)
    |> remove_key(conn)
  end

  defp retry(fun, 100) do
    []
  end

  defp retry(fun, times) do
   case fun.() do
     [] -> 
       Process.sleep(10)
       retry(fun, times + 1)
     list -> list 
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
end
