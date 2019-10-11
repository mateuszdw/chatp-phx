defmodule Chatplayer.Repo.Migrations.CreateMsgs do
  use Ecto.Migration

  def change do
    create table(:msgs) do
      add :content, :string

      timestamps()
    end

  end
end
