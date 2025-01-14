# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Lynx.Module.UserModule do
  @moduledoc """
  User Module
  """

  alias Lynx.Context.UserContext
  alias Lynx.Service.ValidatorService
  alias Lynx.Service.AuthService

  @doc """
  Get User By ID
  """
  def get_user_by_id(id) do
    case UserContext.get_user_by_id(id) do
      nil ->
        {:not_found, nil}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Get user by UUID
  """
  def get_user_by_uuid(uuid) do
    case UserContext.get_user_by_uuid(uuid) do
      nil ->
        {:not_found, "Team with UUID #{uuid} not found"}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Count Users
  """
  def count_users() do
    UserContext.count_users()
  end

  @doc """
  Get Users
  """
  def get_users(offset, limit) do
    UserContext.get_users(offset, limit)
  end

  @doc """
  Create User
  """
  def create_user(params \\ %{}) do
    hash =
      AuthService.hash_password(
        params[:password],
        params[:app_key]
      )

    user =
      UserContext.new_user(%{
        email: params[:email],
        name: params[:name],
        password_hash: hash,
        verified: false,
        api_key: params[:api_key],
        role: params[:role],
        last_seen: DateTime.utc_now()
      })

    case UserContext.create_user(user) do
      {:ok, user} ->
        {:ok, user}

      {:error, changeset} ->
        messages =
          changeset.errors()
          |> Enum.map(fn {field, {message, _options}} -> "#{field}: #{message}" end)

        {:error, Enum.at(messages, 0)}
    end
  end

  @doc """
  Update User
  """
  def update_user(params \\ %{}) do
    user =
      params[:id]
      |> ValidatorService.parse_int()
      |> UserContext.get_user_by_id()

    case user do
      nil ->
        {:not_found, "User with ID #{params[:id]} not found"}

      _ ->
        new_user = %{
          email: ValidatorService.get_str(params[:email], user.email),
          name: ValidatorService.get_str(params[:name], user.name)
        }

        case UserContext.update_user(user, new_user) do
          {:ok, user} ->
            {:ok, user}

          {:error, changeset} ->
            messages =
              changeset.errors()
              |> Enum.map(fn {field, {message, _options}} -> "#{field}: #{message}" end)

            {:error, Enum.at(messages, 0)}
        end
    end
  end

  @doc """
  Delete User by UUID
  """
  def delete_user_by_uuid(uuid) do
    case UserContext.get_user_by_uuid(uuid) do
      nil ->
        {:not_found, "User with ID #{uuid} not found"}

      user ->
        UserContext.delete_user(user)
        {:ok, "User with ID #{uuid} deleted successfully"}
    end
  end

  @doc """
  Validate User ID
  """
  def validate_user_id(user_id) do
    UserContext.validate_user_id(user_id)
  end

  @doc """
  Count Team Users
  """
  def count_team_users(team_id) do
    UserContext.count_team_users(team_id)
  end

  @doc """
  Verify if email is used
  """
  def is_email_used(email) do
    case UserContext.get_user_by_email(email) do
      nil ->
        false

      _ ->
        true
    end
  end
end
