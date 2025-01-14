# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule LynxWeb.EnvironmentView do
  use LynxWeb, :view

  alias Lynx.Module.EnvironmentModule
  alias Lynx.Module.StateModule

  # Render environments list
  def render("list.json", %{environments: environments, metadata: metadata}) do
    %{
      environments: Enum.map(environments, &render_environment/1),
      _metadata: %{
        limit: metadata.limit,
        offset: metadata.offset,
        totalCount: metadata.totalCount
      }
    }
  end

  # Render environment
  def render("index.json", %{environment: environment}) do
    render_environment(environment)
  end

  # Render errors
  def render("error.json", %{message: message}) do
    %{errorMessage: message}
  end

  # Format environment
  defp render_environment(environment) do
    count = StateModule.count_states(environment.id)

    %{
      id: environment.uuid,
      name: environment.name,
      slug: environment.slug,
      username: environment.username,
      isLocked: EnvironmentModule.is_environment_locked(environment.id),
      stateVersion: "v#{count}",
      secret: environment.secret,
      createdAt: environment.inserted_at,
      updatedAt: environment.updated_at
    }
  end
end
