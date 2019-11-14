defmodule Chatplayer.UserManagerTest do
  use Chatplayer.DataCase
  import Chatplayer.Factory
  alias Chatplayer.UserManager

  describe "users" do
    alias Chatplayer.UserManager.User

    @valid_attrs %{email: "john@example.org", name: "some name", password: "some password", password_confirmation: "some password"}
    @update_attrs %{email: "paul@example.org", name: "some updated name", password: "some updated password", password_confirmation: "some updated password"}
    @invalid_attrs %{email: nil, name: nil, password: nil}

    def user_fixture() do
      insert(:user)
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert UserManager.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserManager.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = UserManager.create_user(@valid_attrs)
      assert user.email == "john@example.org"
      assert user.name == "some name"
      assert user.password == "some password"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserManager.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = UserManager.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "paul@example.org"
      assert user.name == "some updated name"
      assert user.password == "some updated password"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserManager.update_user(user, @invalid_attrs)
      assert user == UserManager.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserManager.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserManager.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserManager.change_user(user)
    end
  end
end
