defmodule Ruler.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Ruler.Repo
  alias Ruler.Rows.Schema.Row

  def row_factory do
    %Row{
      name: Faker.Person.En.name(),
      birthday: Faker.Date.between(~D[1920-01-01], ~D[2020-12-31]),
      income: Faker.random_between(10_000, 1_000_000),
      live_in: generate_boolean(),
      work_in: generate_boolean()
    }
  end

  defp generate_boolean() do
    Faker.random_between(0, 1)
    |> case do
      0 -> false
      1 -> true
    end
  end
end
