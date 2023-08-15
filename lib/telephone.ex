# Telephone sets up a linked list of messages to pass around
defmodule Telephone do
  use GenServer

  # Client Code
  def start_link(default) do
    GenServer.start_link(__MODULE__, default)
  end

  def push(pid, next) do
    GenServer.cast(pid, {:push, next})
  end

  def message(pid, count \\ 0) do
    GenServer.cast(pid, {:message, count})
  end

  # Server Code
  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:push, next}, state) do
    {:noreply, Map.put(state, :next, next)}
  end

  @impl true
  def handle_cast({:message, count}, state) do
    IO.puts("Hello #{count}")
    case state.next do
      :nil -> :nil
      next -> Telephone.message(next, count + 1)
    end

    {:noreply, state}
  end
end
