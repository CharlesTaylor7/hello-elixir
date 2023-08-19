defmodule Telephone do
  @moduledoc """
  Telephone sets up a distributed linked list of nodes.
  You can push a new node by calling, Telephone.push.
  Or you can message a node and all its decsendants by calling Telephone.message.
  """
  use GenServer

  # Client Code
  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  @doc """
  Replace the next node of the telephone chain with a telephone pid
  """
  def push(pid, next) do
    GenServer.cast(pid, {:push, next})
  end

  @doc """
  Count the length of the chain
  """
  def count(pid) do
    GenServer.call(pid, {:count})
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
  def handle_call(:count, _from, state) do
    IO.puts("receive :count")

    count =
      case state[:next] do
        nil -> 0
        next -> 1 + Telephone.count(next)
      end

    {:reply, count, state}
  end

  @impl true
  def handle_cast({:push, next}, state) do
    IO.puts("receive :push")
    {:noreply, Map.put(state, :next, next)}
  end

  @impl true
  def handle_cast({:message, count}, state) do
    IO.puts("receive :message")
    IO.puts("Hello #{count}")

    case state[:next] do
      nil -> nil
      next -> Telephone.message(next, count + 1)
    end

    {:noreply, state}
  end
end
