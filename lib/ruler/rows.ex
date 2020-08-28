defmodule Ruler.Rows do
  alias Ruler.Repo
  alias Ruler.Rows.Schema.Row

  def create_row(params) do
    params
    |> Ruler.Rows.Schema.Row.new_changeset()
    |> Repo.insert()
    |> notify(:create_rule)
  end

  defp set_weight(row) do
    weight = Ruler.apply(row, Ruler.rules())

    row
    |> Row.update_weight_changeset(%{weight: weight})
    |> Repo.update()
  end

  defp notify({:ok, row}, :create_rule) do
    set_weight(row)
  end

  defp notify({:error, reason}, :create_rule), do: {:ok, reason}
end
