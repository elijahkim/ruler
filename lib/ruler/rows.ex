defmodule Ruler.Rows do
  alias Ruler.{Repo, Rules}
  alias Ruler.Rows.Schema.Row
  import Ecto.Query

  def list_rows() do
    from(
      r in Row,
      order_by: [desc_nulls_last: :weight, asc: :inserted_at]
    )
    |> Repo.all()
  end

  def create_row(params) do
    params
    |> Ruler.Rows.Schema.Row.new_changeset()
    |> Repo.insert()
    |> notify(:create_rule)
  end

  def set_weight(row, rules) do
    weight = Ruler.apply(row, rules)

    row
    |> Row.update_weight_changeset(%{weight: weight})
    |> Repo.update()
  end

  defp notify({:ok, row}, :create_rule) do
    rules = Rules.list_rules()

    set_weight(row, rules)
  end

  defp notify({:error, reason}, :create_rule), do: {:ok, reason}
end
