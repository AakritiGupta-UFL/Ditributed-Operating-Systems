defmodule Mix.Tasks.RunCode do
  use Mix.Task

  def run(args) do

          numNodes = String.to_integer(Enum.at(args, 0))
          numReqs = String.to_integer(Enum.at(args, 1))
          Mix.Tasks.Tapestry.main(numNodes, numReqs)
  end

end
