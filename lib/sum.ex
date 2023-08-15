defmodule Sum do
  @moduledoc """
  Documentation for `ParallelSum`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ParallelSum.hello()
      :world

  """
  def hello do
    :world
  end
end

defmodule Stack do
  use GenServer

  # Client Code

  def start_link(default) when is_binary(default) do
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
  def init(elements) do
    initial_state = String.split(elements, ",", trim: true)
    {:ok, initial_state}
  end

  @impl true
  def handle_call(:pop, _from, state) do
    case state do
      [to_caller | new_state] ->
        {:reply, to_caller, new_state}
      _ ->
        {:reply, :nil, []}
    end
  end

  @impl true
  def handle_cast({:push, element}, state) do
    new_state = [element | state]
    {:noreply, new_state}
  end
end