defmodule Ruler.Rows.Schema.Row do
  use Ruler.Schema

  schema "rows" do
    field :name, :string
    field :birthday, :date
    field :income, :integer
    field :live_in, :boolean
    field :work_in, :boolean
    field :weight, :integer

    timestamps()
  end

  def new_changeset(params) do
    %__MODULE__{}
    |> cast(params, [:name, :birthday, :income, :live_in, :work_in])
  end

  def update_weight_changeset(row, params) do
    row
    |> cast(params, [:weight])
  end
end
