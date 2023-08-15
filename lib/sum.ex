defmodule Sum do
  use GenServer

  # Client Code
  def start_link(default) do
    GenServer.start_link(__MODULE__, default)
  end

  @spec tally(atom | pid | {atom, any} | {:via, atom, any}) :: any
  def tally(pid) do
    GenServer.call(pid, :tally)
  end

  # Server Code
  @impl true
  def init(_) do
    {:ok, 0}
  end

  @impl true
  def handle_call(:tally, _from, state) do
    {:reply, state, state}
  end
end
