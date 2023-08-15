defmodule ParallelSum do
  use Application

  def start(_type, _args) do
    IO.puts("hello, world!")

    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
