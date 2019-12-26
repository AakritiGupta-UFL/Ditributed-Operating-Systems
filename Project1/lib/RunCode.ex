defmodule Mix.Tasks.RunCode do
  use Mix.Task

  def run(args) do
  #  {start,end}= OptionParser.parse(args, strict: [debug: :boolean])
        start = String.to_integer(Enum.at(args, 0))
        end1 = String.to_integer(Enum.at(args, 1))
            Mix.Tasks.SpawnCalculator.start_link(start, end1)
  end

end
