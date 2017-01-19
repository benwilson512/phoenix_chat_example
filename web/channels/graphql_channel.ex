defmodule Chat.GraphQLChannel do
  use Phoenix.Channel

  def join("graphql", _message, socket) do
    {:ok, socket}
  end

  def handle_in("query", %{"query" => query, "variables" => variables}, socket) do
    result = query |> Absinthe.run(Chat.Schema, variables: variables)

    {:reply, result, socket}
  end
end
