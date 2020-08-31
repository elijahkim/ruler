defmodule Ruler do
  @moduledoc """
  Ruler keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Ruler.Rules.{Rule, Command}
  alias Ruler.{Rules, Rows}

  def reindex() do
    rules = Rules.list_rules()

    Rows.list_rows()
    |> Task.async_stream(fn row -> Rows.set_weight(row, rules) end)
    |> Stream.run()
  end

  def apply(item, rules) do
    Enum.reduce(rules, 0, fn rule, weight ->
      operator = rule.operator
      property = rule.property

      if apply(__MODULE__, operator, [Map.get(item, property), rule.value]) do
        operation = rule.command.operation

        apply(__MODULE__, operation, [weight, rule.command.value])
      else
        weight + 0
      end
    end)
  end

  def equals(%type{} = date1, date2) when type in [Date, NaiveDateTime, DateTime] do
    type.compare(date1, date2) == :eq
  end

  def equals(a, b), do: a === b

  def greater_than(%type{} = date1, date2) when type in [Date, NaiveDateTime, DateTime] do
    type.compare(date1, date2) == :gt
  end

  def greater_than(a, b), do: a > b

  def less_than(%type{} = date1, date2) when type in [Date, NaiveDateTime, DateTime] do
    type.compare(date1, date2) == :lt
  end

  def less_than(nil, _), do: false

  def less_than(a, b), do: a < b

  def increment(a, b), do: a + b

  def decrement(a, b), do: a - b

  def rules do
    [
      %Rule{
        given: Ruler.Rows.Schema.Row,
        property: :name,
        value: "Eli",
        operator: :equals,
        command: %Command{
          operator: :increment,
          value: 10
        }
      },
      %Rule{
        given: Ruler.Rows.Schema.Row,
        property: :birthday,
        value: Date.new(1990, 11, 21) |> elem(1),
        operator: :less_than,
        command: %Command{
          operator: :increment,
          value: 10
        }
      },
      %Rule{
        given: Ruler.Rows.Schema.Row,
        property: :income,
        value: 100_000,
        operator: :less_than,
        command: %Command{
          operator: :increment,
          value: 1
        }
      },
      %Rule{
        given: Ruler.Rows.Schema.Row,
        property: :income,
        value: 100_000,
        operator: :greater_than,
        command: %Command{
          operator: :decrement,
          value: 3
        }
      },
      %Rule{
        given: Ruler.Rows.Schema.Row,
        property: :work_in,
        value: true,
        operator: :equals,
        command: %Command{
          operator: :increment,
          value: 1
        }
      },
      %Rule{
        given: Ruler.Rows.Schema.Row,
        property: :live_in,
        value: true,
        operator: :equals,
        command: %Command{
          operator: :increment,
          value: 2
        }
      }
    ]
  end
end
