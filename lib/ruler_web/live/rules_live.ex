defmodule RulerWeb.RulesLive do
  use RulerWeb, :live_view
  alias Ruler.Rules

  @impl true
  def render(assigns) do
    ~L"""
    <h1>Rules</h1>

    <%= for rule <- @rules do %>
      <div class="container">
        <blockquote class="container">
          <p>On <%= rule.given %></p>
          <p>When <%= rule.property %> <%= render_operator(rule.operator) %> <%= rule.value %></p>
          <p><%= rule.command.operation %> weight by <%= rule.command.value %></p>
        </blockquote>
      </div>
      </br>
    <% end %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    rules = Rules.list_rules()

    {:ok, assign(socket, rules: rules)}
  end

  defp render_operator(:greater_than), do: "is greater than"
  defp render_operator(:less_than), do: "is less than"
  defp render_operator(:equals), do: "is equal to"
end
