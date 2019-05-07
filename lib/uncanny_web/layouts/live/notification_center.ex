defmodule UncannyWeb.Layouts.Live.NotificationCenter do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <ul class="mb-0">
    <%= for notification <- @notifications do %>
      <li class="alert alert-secondary">
        <%= notification.text %>

        <button class="btn btn-outline-danger btn-sm border-0" phx-click="close" phx-value="<%= notification.id %>">×</button>
      </li>
    <% end %>
    </ul>
    """
  end

  def mount(_, socket) do
    Phoenix.PubSub.subscribe(Uncanny.PubSub, "notifications")
    {:ok, assign(socket, :notifications, [])}
  end

  def handle_info(%UncannyWeb.Notification{} = notification, socket) do
    if socket.assigns[:current_user_id] !== notification.author_id do
      notifications = [notification | socket.assigns[:notifications]]
      {:noreply, assign(socket, :notifications, notifications)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("close", id, socket) do
    notifications = Enum.reject(socket.assigns[:notifications], &(&1.id === id))
    {:noreply, assign(socket, :notifications, notifications)}
  end
end
