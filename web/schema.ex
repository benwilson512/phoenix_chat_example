defmodule Chat.Schema do
  use Absinthe.Schema

  alias Chat.Repo
  alias Chat.Message

  def pubsub, do: Chat.Endpoint

  object :user do
    field :name, :string
  end

  object :message do
    field :body, :string
    field :author, :user
  end

  query do
    field :foo, :string

    field :message, type: :message do
      arg :id, non_null(:id)
      resolve fn(%{id: id}, _info) ->
        case Repo.get(Message, id) do
          nil -> {:error, "Message id #{id} not found"}
          message -> {:ok, Repo.preload(message, [:author])}
        end
      end
    end
  end

  subscription do
    field :message, :message do
      arg :room, non_null(:string)

      topic fn args ->
        args.room
      end

      trigger :send_message, topic: fn message ->
        message.room
      end

      resolve fn %{message: msg}, _, _ ->
        IO.puts "executing doc"
        {:ok, msg}
      end
    end
  end

  mutation do
    field :send_message, :message do
      arg :room, non_null(:string)
      arg :body, non_null(:string)
      arg :user, non_null(:string)

      resolve fn args, _ ->
        message = %{
          room: args.room,
          body: args.body,
          author: %{name: args.user}
        }
        {:ok, message}
      end
    end
  end


end
