defmodule Sum do
  use GenServer

  # Client Code
  def start_link(default) do
    GenServer.start_link(__MODULE__, default)
  end

  def tally(pid) do
    GenServer.call(pid, :tally)
  end

  # Server Code
  @impl true
  def init(elements) do
    state = List.foldl(elements, 0, fn (elem, acc) -> elem + acc end)
    {:ok, state}
  end

  @impl true
  def handle_call(:tally, _from, state) do
    {:noreply, state}
  end
end
