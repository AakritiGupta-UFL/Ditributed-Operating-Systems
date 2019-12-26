defmodule Mysupervisor do
  use Supervisor

  def start_link(args) do
      IO.inspect args
      args1=String.to_integer(Enum.at(args, 0))
      args2=String.to_integer(Enum.at(args, 1))
      Supervisor.start_link(__MODULE__,[args1,args2])
  end

  def init([args1,args2]) do
    #  IO.inspect("here now")
      supervise([worker(Child,[args1,args2])], strategy: :one_for_one)
  end
end
