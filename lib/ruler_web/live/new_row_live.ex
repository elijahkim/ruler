defmodule RulerWeb.NewRowLive do
  use RulerWeb, :live_view
  alias Ruler.Rows.Schema.Row
  alias Ruler.Rows

  @impl true
  def render(assigns) do
    ~L"""
    <h1>Insert a new row</h1>
    <%= f = form_for @changeset, "#", [phx_change: :validate, phx_submit: :save] %>
      <%= label f, :name %>
      <%= text_input f, :name %>
      <%= error_tag f, :name %>

      <%= label f, :birthday %>
      <%= date_input f, :birthday %>
      <%= error_tag f, :birthday %>

      <%= label f, :income %>
      <%= number_input f, :income %>
      <%= error_tag f, :income %>

      <%= label f, :live_in %>
      <%= checkbox f, :live_in %>

      <%= label f, :work_in %>
      <%= checkbox f, :work_in %>

      <div>
        <%= submit "Save" %>
      </div>
    </form>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    changeset = Row.new_changeset(%{})

    {:ok, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("validate", %{"row" => row}, socket) do
    changeset = Row.new_changeset(row)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"row" => row}, socket) do
    case Rows.create_row(row) do
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
end
