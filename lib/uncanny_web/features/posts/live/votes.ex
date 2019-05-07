defmodule UncannyWeb.Features.Posts.Live.Votes do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <button phx-click="increment">+</button>
    <%= @score %>
    <button phx-click="decrement">-</button>
    """
  end

  def mount(%{score: score}, socket) do
    {:ok, assign(socket, :score, score || 0)}
  end

  def handle_event("increment", _, socket) do
    {:noreply, assign(socket, :score, socket.assigns[:score] + 1)}
  end

  def handle_event("decrement", _, socket) do
    {:noreply, assign(socket, :score, socket.assigns[:score] - 1)}
  end
end
