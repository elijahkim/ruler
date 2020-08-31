defmodule Ruler.Rules.Schema.Rule do
  use Ruler.Schema
  alias Ruler.Types.ETF
  alias Ruler.Rules.Schema.Command

  schema "rules" do
    field(:given, ETF)
    field(:property, ETF)
    field(:operator, ETF)
    field(:value, ETF)

    has_one(:command, Command)

    timestamps()
  end

  def new_changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, [:given, :property, :operator, :value])
    |> cast_assoc(:command, with: &Command.new_changeset/2)
  end
end
