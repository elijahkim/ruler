defmodule Ruler.Repo do
  use Ecto.Repo,
    otp_app: :ruler,
    adapter: Ecto.Adapters.Postgres
end
