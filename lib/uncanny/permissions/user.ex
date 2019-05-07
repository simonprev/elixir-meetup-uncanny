defimpl Uncanny.Permissions, for: Uncanny.Identities.User do
  def can?(_, :list_posts, _), do: true
  def can?(_, :new_post, _), do: true
  def can?(_, :show_post, _), do: true
  def can?(_, :create_post, _), do: true

  def can?(user, :update_post, post) do
    user.id === post.user_id
  end

  def can?(user, :delete_post, post) do
    user.id === post.user_id
  end

  def can?(user, :increment_post_vote, {post, existing_votes}) do
    Map.get(existing_votes, post.id) !== 1
  end

  def can?(user, :decrement_post_vote, {post, existing_votes}) do
    Map.get(existing_votes, post.id) !== -1
  end
end
