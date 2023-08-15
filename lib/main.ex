defmodule Main do
  use Application

  def start(_type, _args) do
    IO.puts("hello, world!")

    dyn_supervisor = DynamicSupervisor.start_link(
      strategy: :one_for_one,
      name: Mine
    )

    pids = [A, B, C, D]
    for index <- 0..3 do
      pid = pids |> Enum.at(index)
      next_pid = pids |> Enum.at(index + 1)
      Main.new_node(pid, next_pid)
    end

    Telephone.message(A, 1)

    dyn_supervisor
  end

  def new_node(name, next) do
    child_spec = %{
      id: name,
      start: {Telephone, :start_link, [[]]}
    }
    DynamicSupervisor.start_child(Mine, child_spec)
    Telephone.push(name, next)
  end
end
