defmodule Main do
  use Application

  def start(_type, _args) do
    IO.puts("hello, world!")
    dyn_supervisor = DynamicSupervisor.start_link(
      strategy: :one_for_one,
      name: Main
    )

    pids = [A, B, C, D]
    for index <- 0..4 do
      pid = pids |> Enum.at(index)
      next_pid = pids |> Enum.at(index + 1)

      child_spec = %{
        id: pid,
        start: {Telephone, :start_link, [[]]}
      }
      DynamicSupervisor.start_child(Main, child_spec)
      Telephone.push(pid, next_pid)
    end

    Telephone.message(A)

    dyn_supervisor
  end
end
