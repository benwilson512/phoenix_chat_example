defmodule Chat.MessageQueryTest do

  use Chat.ChannelCase

  alias Chat.Message
  alias Chat.User

  @message_query """

  query ($id: ID!) {
    message(id: $id) {
      body
      author {
        name
      }
    }
  }

  """

  setup do
    {:ok, socket} = connect(Chat.UserSocket, %{})
    {:ok, _, socket} = subscribe_and_join(socket, Chat.GraphQLChannel, "graphql")

    %{socket: socket}
  end

  test "message query with 300ms timeout", %{socket: socket} do
    {:ok, author} = %User{name: "Dustin Farris"} |> Repo.insert()
    {:ok, message} = %Message{author_id: author.id, body: "Test message"} |> Repo.insert()

    ref = push socket, "query", %{query: @message_query, variables: %{id: message.id}}

    assert_reply ref, :ok, %{data: %{
      "message" => %{
        "body" => "Test message",
        "author" => %{
          "name" => "Dustin Farris"
        }
      }
    }}, 300
  end

  test "message query", %{socket: socket} do
    {:ok, author} = %User{name: "Dustin Farris"} |> Repo.insert()
    {:ok, message} = %Message{author_id: author.id, body: "Test message"} |> Repo.insert()

    ref = push socket, "query", %{query: @message_query, variables: %{id: message.id}}

    assert_reply ref, :ok, %{data: %{
      "message" => %{
        "body" => "Test message",
        "author" => %{
          "name" => "Dustin Farris"
        }
      }
    }}
  end
end
