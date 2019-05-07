defprotocol Uncanny.Permissions do
  @fallback_to_any true

  @spec can?(any(), any(), any()) :: boolean() | {:ok, any} | {:error, any()}
  def can?(resource, action, target)
end

defimpl Uncanny.Permissions, for: Any do
  def can?(_, :list_posts, _), do: true
  def can?(_, :show_post, _), do: true
  def can?(_, _, _), do: false
end
