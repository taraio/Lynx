# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule LynxWeb.StateController do
  @moduledoc """
  State Controller
  """

  use LynxWeb, :controller

  require Logger

  alias Lynx.Module.StateModule
  alias Lynx.Module.EnvironmentModule
  alias Lynx.Service.ValidatorService

  plug :auth when action in [:create, :index]

  defp auth(conn, _opts) do
    with {user, secret} <- Plug.BasicAuth.parse_basic_auth(conn) do
      result =
        EnvironmentModule.is_access_allowed(%{
          team_slug: conn.params["t_slug"],
          project_slug: conn.params["p_slug"],
          env_slug: conn.params["e_slug"],
          username: user,
          secret: secret
        })

      case result do
        {:error, msg} ->
          Logger.info(msg)

          conn
          |> put_status(:forbidden)
          |> render("error.json", %{
            message: "Access is forbidden"
          })
          |> halt

        {:ok, _, _, _} ->
          conn
      end
    else
      _ -> conn |> Plug.BasicAuth.request_basic_auth() |> halt()
    end
  end

  @doc """
  Create State Endpoint
  """
  def create(conn, params) do
    body = Map.drop(params, ["t_slug", "p_slug", "e_slug"]) |> Jason.encode!()

    result =
      StateModule.add_state(%{
        t_slug: ValidatorService.get_str(params["t_slug"], ""),
        p_slug: ValidatorService.get_str(params["p_slug"], ""),
        e_slug: ValidatorService.get_str(params["e_slug"], ""),
        name: "_tf_state_",
        value: body
      })

    case result do
      {:not_found, _} ->
        conn
        |> put_status(:not_found)
        |> render("error.json", %{
          message: "Project not found"
        })

      {:success, _} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, body)

      {:error, msg} ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", %{
          message: msg
        })
    end
  end

  @doc """
  View State Endpoint
  """
  def index(conn, params) do
    result =
      StateModule.get_latest_state(%{
        t_slug: ValidatorService.get_str(params["t_slug"], ""),
        p_slug: ValidatorService.get_str(params["p_slug"], ""),
        e_slug: ValidatorService.get_str(params["e_slug"], "")
      })

    case result do
      {:not_found, _} ->
        conn
        |> put_status(:not_found)
        |> render("error.json", %{
          message: "Project not found"
        })

      {:no_state, _} ->
        conn
        |> put_status(:not_found)
        |> render("error.json", %{
          message: "State not found"
        })

      {:state_found, state} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, state.value)
    end
  end
end
