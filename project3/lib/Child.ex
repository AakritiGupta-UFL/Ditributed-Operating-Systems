defmodule Child do
use GenServer

  def start_link(arg1,arg2) do

    list=[]
    list=list++[arg1]
    IO.inspect list
    list=list++[arg2]

    GenServer.start_link(__MODULE__,list,name: __MODULE__)
  end

  def init(args) do
    loop(args)
  end

  def loop(args) do

    numNodes = Enum.at(args, 0)
    numReqs = Enum.at(args, 1)
    Mix.Tasks.Tapestry.main(numNodes, numReqs)
  end

end
