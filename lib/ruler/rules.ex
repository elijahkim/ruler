defmodule Ruler.Rules do
  alias Ruler.Rules.Schema.Rule
  alias Ruler.{Repo, Rows}
  import Ecto.Query

  def list_rules() do
    from(
      r in Rule,
      preload: :command
    )
    |> Repo.all()
  end

  def create_rule(params) do
    params
    |> Rule.new_changeset()
    |> Repo.insert()
    |> notify(:rule_created)
  end

  defp notify({:ok, rule}, :rule_created) do
    rules = list_rules()

    Rows.list_rows()
    |> Task.async_stream(fn row -> Rows.set_weight(row, rules) end)
    |> Stream.run()

    {:ok, rule}
  end

  defp notify({:error, changeset}, :rule_created), do: {:error, changeset}
end
