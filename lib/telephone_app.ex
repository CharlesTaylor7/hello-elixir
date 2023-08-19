defmodule TelephoneApp do
  use Application

  def start(_type, _args) do
    IO.puts("hello, world!")

    {:ok, parent_pid} = DynamicSupervisor.start_link(strategy: :one_for_one)

    pids = [A, B, C, D]

    for index <- 0..3 do
      pid = pids |> Enum.at(index)
      next_pid = pids |> Enum.at(index + 1)
      new_node(parent_pid, pid, next_pid)
    end

    :ok = Telephone.message(A, 1)
    IO.puts("Count: #{Telephone.count(A)}")

    {:ok, parent_pid}
  end

  def new_node(pid, name, next) do
    child_spec = %{
      id: name,
      start: {Telephone, :start_link, [[]]}
    }

    {:ok, child_pid} = DynamicSupervisor.start_child(pid, child_spec)

    Telephone.push(child_pid, next)
    IO.puts("Count: #{Telephone.count(A)}")
  end
end
