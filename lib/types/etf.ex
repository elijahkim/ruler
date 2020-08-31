defmodule Ruler.Types.ETF do
  use Ecto.Type

  def type, do: :binary

  # Provide custom casting rules.
  # Cast strings into the URI struct to be used at runtime
  def cast(data) do
    {:ok, data}
  end

  # When loading data from the database, as long as it's a map,
  # we just put the data back into an URI struct to be stored in
  # the loaded schema struct.
  def load(data) do
    {:ok, :erlang.binary_to_term(data)}
  end

  def dump(data), do: {:ok, :erlang.term_to_binary(data)}
end
