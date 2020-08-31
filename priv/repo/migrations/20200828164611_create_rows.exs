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

    create table(:commands) do
      add(:operation, :binary)
      add(:value, :integer)
      add(:rule_id, :uuid)

      timestamps()
    end

    create table(:rules) do
      add(:given, :binary)
      add(:property, :binary)
      add(:operator, :binary)
      add(:value, :binary)
      add(:command_id, references(:commands))

      timestamps()
    end

    create(index(:rules, [:command_id]))
    create(index(:commands, [:rule_id]))
  end
end
