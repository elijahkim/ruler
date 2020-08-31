defmodule RulerWeb.CreateRuleLive do
  use RulerWeb, :live_view
  alias Ruler.Rules.Schema.Rule
  alias Ruler.Rules

  @impl true
  def mount(_params, _session, socket) do
    changeset = Rule.new_changeset(%{})

    given = [
      Select: "Select",
      Row: "Ruler.Rows.Schema.Row"
    ]

    operator_options = [
      :greater_than,
      :less_than,
      :equals
    ]

    operation_options = [
      :increment,
      :decrement
    ]

    {:ok,
     assign(socket,
       changeset: changeset,
       given_options: given,
       property_options: [],
       operator_options: operator_options,
       operation_options: operation_options,
       selected_type: :string
     )}
  end

  @impl true
  def handle_event("validate", %{"rule" => rule}, socket) do
    changeset = Rule.new_changeset(rule)

    property_options =
      try do
        given = ("Elixir." <> Map.get(rule, "given")) |> String.to_existing_atom()
        given.__struct__() |> Map.keys()
      rescue
        _ ->
          []
      end

    selected_type =
      try do
        given = ("Elixir." <> Map.get(rule, "given")) |> String.to_existing_atom()
        field = Map.get(rule, "property") |> String.to_existing_atom()
        given.__schema__(:type, field)
      rescue
        _ ->
          :string
      end

    {:noreply,
     assign(socket,
       changeset: changeset,
       property_options: property_options,
       selected_type: selected_type
     )}
  end

  @impl true
  def handle_event("save", %{"rule" => rule}, socket) do
    given = ("Elixir." <> Map.get(rule, "given")) |> String.to_existing_atom()
    field = Map.get(rule, "property") |> String.to_existing_atom()
    type = given.__schema__(:type, field)
    command = Map.get(rule, "command")

    params = %{
      "given" => given,
      "property" => field,
      "operator" => Map.get(rule, "operator") |> String.to_existing_atom(),
      "value" => Map.get(rule, "value") |> cast(type),
      "command" => %{
        "operation" => Map.get(command, "operation") |> String.to_existing_atom(),
        "value" => Map.get(command, "value") |> String.to_integer()
      }
    }

    case Rules.create_rule(params) do
      {:ok, _row} ->
        socket =
          socket
          |> put_flash(:info, "Row saved successfully")
          |> push_redirect(to: Routes.page_path(socket, :index))

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp cast(value, :string), do: value
  defp cast(value, :integer), do: String.to_integer(value)
  defp cast(value, :date), do: Date.from_iso8601!(value)
  defp cast(value, :naive_datetime), do: NaiveDateTime.from_iso8601!(value)
  defp cast("true", :boolean), do: true
  defp cast("false", :boolean), do: false
end
