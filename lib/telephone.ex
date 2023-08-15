
defmodule Telephone do
  @moduledoc """
  Telephone sets up a distributed linked list of nodes.
  You can push a new node by calling, Telephone.push.
  Or you can message a node and all its decsendants by calling Telephone.message.
  """
  use GenServer

  # Client Code
  def start_link(default) do
    GenServer.start_link(__MODULE__, default)
  end

  @doc """
  Replace the next node of the telephone chain with a telephone pid
  """
  def push(pid, next) do
    GenServer.cast(pid, {:push, next})
  end

  @doc """
  Print hello from each node in the chain.
  """
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
    case state[:next] do
      :nil -> :nil
      next -> Telephone.message(next, count + 1)
    end

    {:noreply, state}
  end
end
