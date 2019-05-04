defmodule UncannyWeb.Pow.EctoCache do
  @behaviour Pow.Store.Base
  @app_name :uncanny

  import Ecto.Query

  alias Pow.Config

  defmodule Credential do
    use Ecto.Schema

    schema "user_credentials" do
      field(:namespace, :string)
      field(:key, :string)
      field(:user_id, :integer)

      timestamps()
    end
  end

  defmodule Attributes do
    @enforce_keys ~w(namespace key)a
    defstruct ~w(namespace key)a
  end

  @impl true
  def put(config, key, {user, _}) do
    attributes = attributes_from_key(config, key)

    repo().insert(%Credential{
      namespace: attributes.namespace,
      key: attributes.key,
      user_id: user.id
    })
  end

  @impl true
  def delete(config, key) do
    attributes = attributes_from_key(config, key)

    if attributes.key !== nil do
      attributes
      |> query()
      |> repo().delete_all()
    end
  end

  @impl true
  def get(config, key) do
    config
    |> attributes_from_key(key)
    |> query()
    |> first()
    |> repo().one()
    |> case do
      nil ->
        :not_found

      credential ->
        user = repo().get(user_module(), credential.user_id)

        timestamp =
          credential.inserted_at
          |> DateTime.from_naive!("Etc/UTC")
          |> DateTime.to_unix(:millisecond)

        {user, timestamp}
    end
  end

  @impl true
  def keys(config) do
    config
    |> attributes_from_key("")
    |> query()
    |> select([:key])
    |> repo().all()
  end

  defp attributes_from_key(config, key) do
    namespace = Config.get(config, :namespace, "cache")

    %Attributes{namespace: namespace, key: key}
  end

  defp query(%{namespace: namespace, key: ""}) do
    from(
      credentials in Credential,
      where: credentials.namespace == ^namespace
    )
  end

  defp query(attributes) do
    %{attributes | key: ""}
    |> query()
    |> where(key: ^attributes.key)
  end

  defp repo, do: Application.get_env(@app_name, :pow)[:repo]
  defp user_module, do: Application.get_env(@app_name, :pow)[:user]
end
