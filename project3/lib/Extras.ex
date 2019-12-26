defmodule Mix.Tasks.Extras do
use Mix.Task


def createETS() do
    :ets.new(:hashIds, [:set, :public, :named_table])
    :ets.insert(:hashIds, {"0",[]})
    :ets.insert(:hashIds, {"1",[]})
    :ets.insert(:hashIds, {"2",[]})
    :ets.insert(:hashIds, {"3",[]})
    :ets.insert(:hashIds, {"4",[]})
    :ets.insert(:hashIds, {"5",[]})
    :ets.insert(:hashIds, {"6",[]})
    :ets.insert(:hashIds, {"7",[]})
    :ets.insert(:hashIds, {"8",[]})
    :ets.insert(:hashIds, {"9",[]})
    :ets.insert(:hashIds, {"A",[]})
    :ets.insert(:hashIds, {"B",[]})
    :ets.insert(:hashIds, {"C",[]})
    :ets.insert(:hashIds, {"D",[]})
    :ets.insert(:hashIds, {"E",[]})
    :ets.insert(:hashIds, {"F",[]})
  end

# def segregateNodes(id_hash_map) do
#
#  Enum.each(id_hash_map,fn({key,value}) ->
#                          [{_, count}] = :ets.lookup(:hashIds,String.at(value,0))
#                          count=count++[value]
#                          :ets.insert(:hashIds, {String.at(value,0), count})
#                          end)
#
# end

def createRoutingTable(node_pids,id_hash_map) do
  Enum.each(0..length(id_hash_map)-1, fn(i) ->

                      temp_node_ids = List.delete(node_pids, Enum.at(node_pids,i))
                      Enum.each(0..15, fn(j) ->
                          index = :rand.uniform(length(temp_node_ids))
                          index = index - 1
                          pid = Enum.at(temp_node_ids,index)
                          cond do

                          j==10 ->
                            Client.setRoutingTable(pid,"A",Enum.at(id_hash_map,i))
                          j==11 ->
                              Client.setRoutingTable(pid,"B",Enum.at(id_hash_map,i))
                          j==12 ->
                              Client.setRoutingTable(pid,"C",Enum.at(id_hash_map,i))
                          j==13 ->
                              Client.setRoutingTable(pid,"D",Enum.at(id_hash_map,i))
                          j==14 ->
                              Client.setRoutingTable(pid,"E",Enum.at(id_hash_map,i))
                          j==15 ->
                              Client.setRoutingTable(pid,"F",Enum.at(id_hash_map,i))
                          j>=0 and j<=9 ->
                                Client.setRoutingTable(pid,j,Enum.at(id_hash_map,i))
                          end
                      end)
                        IO.puts("state updated")
                      end)

end

def printRoutingTablePerNode(node_pids) do
    my_list=Enum.to_list 0..length(node_pids)-1
    Enum.map(my_list, fn i -> table = Client.getRoutingTable(Enum.at(node_pids,i))
                                               IO.inspect(table)
                                               table
                                               end)
end

def handle_cast({:set_routing_table,level,hash_val},state) do

   {:ok,full_routing_table} = Map.fetch(state,"routing_table")
   if(is_integer(level)) do
       {:ok, update_level_table} = Map.fetch(full_routing_table,Integer.to_string(level))
        val=Enum.at(hash_val,0)
        new_update_level_table = Map.put(update_level_table,String.at(val,level),val )
        new_full_routing_table = Map.put(full_routing_table,Integer.to_string(level), new_update_level_table )
        new_state = Map.put(state,"routing_table", new_full_routing_table)
        # IO.inspect(new_state)
        {:noreply,new_state}

   else
       {:ok, update_level_table} = Map.fetch(full_routing_table,level)
        val=Enum.at(hash_val,0)
        cond do
            level=="A" ->
                new_update_level_table = Map.put(update_level_table,String.at(val,10),val )
                new_full_routing_table = Map.put(full_routing_table,level, new_update_level_table )
                new_state = Map.put(state,"routing_table", new_full_routing_table)
                {:noreply,new_state}
            level=="B" ->
                new_update_level_table = Map.put(update_level_table,String.at(val,11),val )
                new_full_routing_table = Map.put(full_routing_table,level, new_update_level_table )
                new_state = Map.put(state,"routing_table", new_full_routing_table)
                {:noreply,new_state}
            level=="C" ->
                new_update_level_table = Map.put(update_level_table,String.at(val,12),val )
                new_full_routing_table = Map.put(full_routing_table,level, new_update_level_table )
                new_state = Map.put(state,"routing_table", new_full_routing_table)
                {:noreply,new_state}
            level=="D" ->
                new_update_level_table = Map.put(update_level_table,String.at(val,13),val )
                new_full_routing_table = Map.put(full_routing_table,level, new_update_level_table )
                new_state = Map.put(state,"routing_table", new_full_routing_table)
                {:noreply,new_state}
            level=="E" ->
                new_update_level_table = Map.put(update_level_table,String.at(val,14),val )
                new_full_routing_table = Map.put(full_routing_table,level, new_update_level_table )
                new_state = Map.put(state,"routing_table", new_full_routing_table)
                {:noreply,new_state}
            level=="F" ->
                new_update_level_table = Map.put(update_level_table,String.at(val,15),val )
                new_full_routing_table = Map.put(full_routing_table,level, new_update_level_table )
                new_state = Map.put(state,"routing_table", new_full_routing_table)
                {:noreply,new_state}
        end
    end

end

end
