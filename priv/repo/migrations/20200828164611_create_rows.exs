defmodule Ruler.Repo.Migrations.CreateRows do
  use Ecto.Migration

  def change do
    create table(:rows) do
      add(:name, :string)
      add(:birthday, :date)
      add(:income, :integer)
      add(:live_in, :boolean)
      add(:work_in, :boolean)
      add(:weight, :integer)

      timestamps()
    end
  end
end
