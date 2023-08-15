# Telephone sets up a circular linked list of messages to pass around


defmodule Telephone do
  use GenServer

  # Client Code
  def start_link(default) do
    GenServer.start_link(__MODULE__, default)
  end

  def push(pid, element) do
    GenServer.cast(pid, {:push, element})
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  # Server Code
  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_call(:pop, _from, state) do
    case state do
      [to_caller | new_state] ->
        {:reply, to_caller, new_state}

      _ ->
        {:reply, nil, []}
    end
  end

  @impl true
  def handle_cast({:push, element}, state) do
    new_state = [element | state]
    {:noreply, new_state}
  end
end
