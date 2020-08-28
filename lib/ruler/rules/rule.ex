defmodule Ruler.Rules.Rule do
  defstruct [
    :given,
    :property,
    :value,
    :operator,
    :command
  ]

  def new(args) do
    struct(__MODULE__, args)
  end
end
