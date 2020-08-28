defmodule Ruler do
  @moduledoc """
  Ruler keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Ruler.Rules.{Rule, Command}

  def apply(item, rules) do
    Enum.reduce(rules, 0, fn rule, weight ->
      if apply(__MODULE__, rule.operator, [Map.get(item, rule.property), rule.value]) do
        apply(__MODULE__, rule.command.operator, [weight, rule.command.value])
      else
        weight + 0
      end
    end)
  end

  def equals(a, b), do: a === b

  def greater_than(nil, _), do: false

  def greater_than(a, b), do: a > b

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
