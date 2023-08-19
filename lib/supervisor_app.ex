defmodule SupervisorApp do
  use Application

  def start(_type, _args) do
    IO.puts("hello, world!")

    {:ok, parent_pid} = DynamicSupervisor.start_link(strategy: :one_for_one)

    {:ok, child_pid} = DynamicSupervisor.start_child(parent_pid, IOPutServer)

    IOPutServer.message(child_pid, "hello")

    IO.puts(Process.info(child_pid))
    {:ok, parent_pid}
  end
end

defmodule IOPutServer do
  use GenServer

  def init(_init) do
    {:ok, nil}
  end

  def message(pid, msg) do
    GenServer.cast(pid, {:message, msg})
  end

  def handle_cast({:message, msg}, _state) do
    IO.puts("received #{msg}")
    {:noreply, nil}
  end
end
