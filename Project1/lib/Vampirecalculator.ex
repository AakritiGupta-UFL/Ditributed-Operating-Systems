defmodule Mix.Tasks.Vampirecalculator do
  use GenServer

 def start_link() do
  GenServer.start_link(__MODULE__, [])
 end

 def init(state) do
    {:ok, state}
  end


def get_list(pid) do
  GenServer.call(pid, :get_list)
end

def handle_call(:get_list,_from,state) do
{:reply,state,state}
end

def handle_cast({:async_number, vampire_list}, state) do
  new_state=state++vampire_list
#  new_state |> IO.inspect()
  {:noreply, new_state}
 end

end
