defmodule Chat.ChannelCase do

  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.ChannelTest

      alias Chat.Repo

      @endpoint Chat.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Chat.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Chat.Repo, {:shared, self()})
    end

    :ok
  end
end
