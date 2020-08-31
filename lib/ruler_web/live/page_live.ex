defmodule RulerWeb.PageLive do
  use RulerWeb, :live_view
  alias Ruler.Rows

  @impl true
  def mount(_params, _session, socket) do
    rows = Rows.list_rows()

    {:ok, assign(socket, rows: rows)}
  end

  @impl true
  def handle_event("navigate_to_new_row", _params, socket) do
    {:noreply, push_redirect(socket, to: Routes.live_path(socket, RulerWeb.NewRowLive))}
  end

  @impl true
  def handle_event("navigate_to_rules", _params, socket) do
    {:noreply, push_redirect(socket, to: Routes.live_path(socket, RulerWeb.RulesLive))}
  end

  @impl true
  def handle_event("navigate_to_rule_create", _params, socket) do
    {:noreply, push_redirect(socket, to: Routes.live_path(socket, RulerWeb.CreateRuleLive))}
  end

  def format_date(date) do
    "#{date.month}/#{date.day}/#{date.year}"
  end

  def format_money(money) do
    Money.new(money * 100, :USD)
    |> Money.to_string()
  end
end
