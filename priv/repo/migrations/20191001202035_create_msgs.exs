defmodule Chatplayer.Repo.Migrations.CreateMsgs do
  use Ecto.Migration

  def change do
    create table(:msgs) do
      add :content, :string
      add :user_id, references(:users)
      
      timestamps()
    end

  end
end
