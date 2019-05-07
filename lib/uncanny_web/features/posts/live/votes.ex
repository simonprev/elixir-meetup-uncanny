defmodule UncannyWeb.Features.Posts.Live.Votes do
  use Phoenix.LiveView

  alias Uncanny.Features

  import Uncanny.Permissions, only: [can?: 3]

  def render(assigns) do
    ~L"""
    <div class="d-flex flex-column justify-content-center align-items-center">
      <div>
        <%= cond do %>
          <% can?(@user, :increment_post_vote, {@post, @user_votes}) -> %>
            <button class="btn btn-sm btn-outline-secondary border-0" phx-click="increment">▲</button>
          <% is_map(@user) -> %>
            <button class="btn btn-sm btn-outline-success border-0" disabled>▲</button>
          <% true -> %>
        <% end %>
      </div>

      <%= @score %>

      <div style="transform: rotate(180deg)">
        <%= cond do %>
          <% can?(@user, :decrement_post_vote, {@post, @user_votes}) -> %>
            <button class="btn btn-sm btn-outline-secondary border-0" phx-click="decrement">▲</button>
          <% is_map(@user) -> %>
            <button class="btn btn-sm btn-outline-danger border-0" disabled>▲</button>
          <% true -> %>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(%{post: post, user: user, user_votes: user_votes}, socket) do
    socket =
      socket
      |> assign(:score, post.votes_score || 0)
      |> assign(:post, post)
      |> assign(:user_votes, user_votes)
      |> assign(:user, user)

    {:ok, socket}
  end

  def handle_event("increment", _, socket) do
    Features.increment_post_vote(socket.assigns[:post], socket.assigns[:user])
    [post] = Features.merge_votes([socket.assigns[:post]])

    socket =
      socket
      |> assign(:score, post.votes_score)
      |> assign(:user_votes, Map.put(socket.assigns[:user_votes], post.id, 1))

    {:noreply, socket}
  end

  def handle_event("decrement", _, socket) do
    Features.decrement_post_vote(socket.assigns[:post], socket.assigns[:user])
    [post] = Features.merge_votes([socket.assigns[:post]])

    socket =
      socket
      |> assign(:score, post.votes_score)
      |> assign(:user_votes, Map.put(socket.assigns[:user_votes], post.id, -1))

    {:noreply, socket}
  end
end
