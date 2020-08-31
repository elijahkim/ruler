defmodule Ruler.Rules.Schema.Command do
  use Ruler.Schema
  alias Ruler.Types.ETF
  alias Ruler.Rules.Schema.Rule

  schema "commands" do
    field(:operation, ETF)
    field(:value, :integer)

    belongs_to(:rule, Rule)

    timestamps()
  end

  def new_changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, [:value, :operation])
  end
end
