defmodule Mix.Tasks.Tapestry do
use Mix.Task

def main(numNodes,numReqs) do
    # IO.inspect("i am in Tapestry")
    node_pids= createNodes(numNodes-1)
    id_hash_list= mapHashIds(node_pids,[])
    id_hash_map=createIdHashMap(node_pids,id_hash_list)

    tapRouting(node_pids,id_hash_list,id_hash_map,numNodes,numReqs)

end

def tapRouting(node_pids,id_hash_list,id_hash_map,numNodes,numReqs)    do

    :ets.new(:nearestHash, [:set, :public, :named_table])
    :ets.new(:nearest_index, [:set, :public, :named_table])
     :ets.new(:hop, [:set, :public, :named_table])
     createRoutingTableAll(node_pids,id_hash_list)

     #adding last node dynamically to the network
     id_hash_list=addNodeHash(numNodes-1,id_hash_list)
     node_pids=addNodePid(node_pids)
     id_hash_map = Map.put(id_hash_map, Enum.at(id_hash_list,numNodes - 1), Enum.at(node_pids,numNodes - 1))
     add_index=length(id_hash_list)-1
     createRoutingTable2(Enum.at(node_pids,add_index),id_hash_list,length(node_pids)-1)
     addDynamicNodetoOtherRoutingTables(node_pids,id_hash_list,id_hash_map,add_index)
     :ets.insert(:hop, {"max",0})
    Enum.each(0..length(id_hash_list)-1, fn x ->
      list=[]
      list=list++id_hash_list
    #  IO.inspect list
      tempList=List.delete(list,Enum.at(id_hash_list,x))
    Enum.each(0..numReqs-1, fn i ->
      :ets.insert(:hop, {"hop_value",0})
      random_number =:rand.uniform(length(id_hash_list)-2)
    #  IO.inspect Enum.at(id_hash_list,x)
  #    IO.inspect Enum.at(tempList,random_number)
      findHops(Enum.at(id_hash_list,x),Enum.at(tempList,random_number),id_hash_map,0)
      [{"hop_value",hop}]=:ets.lookup(:hop, "hop_value")
      [{"max",max_value}]=:ets.lookup(:hop, "max")
      if(hop>max_value) do
       :ets.insert(:hop, {"max",hop})
      end
    end)
    end)
    [{"max",max_value}]=:ets.lookup(:hop, "max")
    IO.puts("Max hop is #{max_value}")
     #findHops(source,dest,id_hash_map,1)
end

  def createRoutingTableAll(node_pids,id_hash_list) do
    Enum.each(0..length(node_pids) - 1, fn i -> createRoutingTable2(Enum.at(node_pids,i),id_hash_list,i) end)
  end

  def createNodes(numNodes) do
     my_list=Enum.to_list 0..numNodes-1
     node_pids =  Enum.map(my_list, fn i -> {:ok, pid} =   Client.start_link("hi")
                                                pid
                                                end)
  end

  def createIdHashMap(node_pids,id_hash_list) do
    len=length(node_pids)
    Enum.reduce(0..len-1, %{}, fn (i, acc) ->
            Map.put(acc, Enum.at(id_hash_list,i), Enum.at(node_pids,i))
            end)
  end


  def mapHashIds(node_pids,list) do
    #IO.puts("hi")
    my_list=Enum.to_list 0..length(node_pids)-1
    list =  Enum.map(my_list, fn i -> :erlang.list_to_binary(Enum.map(:erlang.bitstring_to_list(:crypto.hash(:sha,"hellloo")),fn(x)-> :erlang.integer_to_binary(x,16)end))
                                t = :crypto.hash(:sha,Integer.to_string(i))
                                hash_val = :erlang.list_to_binary(Enum.map(:erlang.bitstring_to_list(t),fn(x)-> :erlang.integer_to_binary(x,16)end))
                                if(Enum.member?(list,hash_val)) do

                                end
                                list++String.slice(hash_val,0,8)
                                end)

  end

def createRoutingTable2(node_pid,id_hash_list,index) do
  my_hash = Enum.at(id_hash_list,index)

  :ets.insert(:nearestHash, {"dist",10000000})
  :ets.insert(:nearest_index, {"indexx",index+1})

  Enum.each(0..7, fn(level) ->
            Enum.each(0..15, fn pos ->
                      filtered_hashs =
                        Enum.filter(id_hash_list, fn hash_val ->

                                    cond do

                                    pos==10 ->
                                      String.at(hash_val,level) == "A" and if(level>0) do String.slice(my_hash,0..level-1) == String.slice(hash_val,0..level-1) else 1==1 end
                                    pos==11 ->
                                      String.at(hash_val,level) == "B" and if(level>0) do String.slice(my_hash,0..level-1) == String.slice(hash_val,0..level-1) else 1==1  end
                                    pos==12 ->
                                      String.at(hash_val,level) == "C" and if(level>0) do String.slice(my_hash,0..level-1) == String.slice(hash_val,0..level-1)  else 1==1 end
                                    pos==13 ->
                                      String.at(hash_val,level) == "D" and if(level>0) do String.slice(my_hash,0..level-1) == String.slice(hash_val,0..level-1) else 1==1 end
                                    pos==14 ->
                                      String.at(hash_val,level) == "E" and if(level>0) do String.slice(my_hash,0..level-1) == String.slice(hash_val,0..level-1) else 1==1 end
                                    pos==15 ->
                                      String.at(hash_val,level) == "F" and if(level>0) do String.slice(my_hash,0..level-1) == String.slice(hash_val,0..level-1) else 1==1 end
                                    pos>=0 and pos<=9 ->
                                      String.at(hash_val,level) == Integer.to_string(pos)  and if(level>0) do String.slice(my_hash,0..level-1) == String.slice(hash_val,0..level-1) else 1==1 end

                                    end
                                end)
                     if(length(filtered_hashs) !== 0) do
                          Enum.each(0..(length(filtered_hashs)-1), fn i -> [{_, minDiff}] = :ets.lookup(:nearestHash, "dist")
                                              #String.at(Enum.at(filtered_hashs,i),0) |> String.to_charlist |> val1
                                              #String.at(my_hash,0) |> String.to_charlist |> val2
                                              <<val1::utf8>> = String.at(Enum.at(filtered_hashs,i),0)
                                              <<val2::utf8>> = String.at(my_hash,0)
                                              diff = abs(val1 - val2)
                                              if( diff < minDiff) do
                                                :ets.insert(:nearestHash, {"dist",diff})
                                                :ets.insert(:nearest_index, {"indexx",i})
                                              end
                          end)
                          [{_, nearestIndex}] = :ets.lookup(:nearest_index, "indexx")
                          nearestVal = Enum.at(filtered_hashs,nearestIndex)
                          Client.setRoutingTable2(node_pid,level,pos,nearestVal)
                      end
                      end)
                      random_string="5"

                      end)


end


def findHops(my_hash_val,dest_hash_val,id_hash_map,hops) do

    {:ok, node_id} = Map.fetch(id_hash_map,my_hash_val)
    routing_table = Client.getRoutingTable(node_id)
    row = determine_level(my_hash_val,dest_hash_val,0)

    {:ok,m}=Map.fetch(routing_table,Integer.to_string(row))
    list= Map.values(m)

    col = String.at(dest_hash_val,row)

    if( col == "A" or col == "B" or col == "C" or col == "D" or col == "E" or col == "F" ) do
      col=
      cond do
        col == "A" ->   col =10
        col == "B" ->   col =11
        col == "C" ->   col=12
        col == "D" ->   col=13
        col == "E" ->   col=14
        col == "F" ->   col=15
      end
      col = neighbour(my_hash_val,dest_hash_val,col,list)
      if(Enum.at(list,col)==dest_hash_val) do
    #     IO.puts("DESTINATION FOUND")
      #   IO.puts("final hops: #{hops}")
         :ets.insert(:hop, {"hop_value",hops})
      else
          findHops(Enum.at(list,col),dest_hash_val,id_hash_map,hops+1)
      end

    else
      col = String.to_integer(col)
      col = neighbour(my_hash_val,dest_hash_val,col,list)
      if(Enum.at(list,col)==dest_hash_val) do
      #   IO.puts("DESTINATION FOUND")
      #   IO.puts("final hops: #{hops}")
         :ets.insert(:hop, {"hop_value",hops})
      else
          findHops(Enum.at(list,col),dest_hash_val,id_hash_map,hops+1)
      end
    end


end

def determine_level(my_hash_val,dest_hash_val,count) do

    if(String.at(my_hash_val,count)==String.at(dest_hash_val,count)) do
     count=determine_level(my_hash_val,dest_hash_val,count+1)
    else
      count
    end

end

def neighbour(my_hash_val,dest_hash_val,col,list) do
  #  IO.puts("in call with hash: #{my_hash_val} with col: #{col}")

    if(String.length(Enum.at(list,col))==0) do
        if(col>15) do
            neighbour(my_hash_val,dest_hash_val,0,list)
        else
            neighbour(my_hash_val,dest_hash_val,col+1,list)
        end
    else
      #  IO.puts("in returning with hash: #{my_hash_val} with col: #{col}")
        col
    end
end


def addNodeHash(i,id_hash_list) do
    :erlang.list_to_binary(Enum.map(:erlang.bitstring_to_list(:crypto.hash(:sha,"hellloo")),fn(x)-> :erlang.integer_to_binary(x,16)end))
    t = :crypto.hash(:sha,Integer.to_string(i))
    hash_val = :erlang.list_to_binary(Enum.map(:erlang.bitstring_to_list(t),fn(x)-> :erlang.integer_to_binary(x,16)end))
    val = String.slice(hash_val,0,8)
    id_hash_list ++ [val]
end

def addNodePid(node_pids) do
    {:ok, pid} =   Client.start_link("hi")
    node_pids ++ [pid]
end

def addDynamicNodetoOtherRoutingTables(node_pids,id_hash_list,id_hash_map,add_index) do
    my_hash =  Enum.at(id_hash_list, add_index)
    node_ids = List.delete(node_pids, add_index)
    id_hash_list = List.delete(id_hash_list, add_index)

    Enum.each(0..7, fn index ->
        filtered_hashs =
          Enum.filter(id_hash_list, fn hash_val ->
                      String.at(hash_val,index) != String.at(my_hash,index) and if(index>0) do String.slice(my_hash,0..index-1) == String.slice(hash_val,0..index-1) else 1==1 end
                      end)
        Enum.each(filtered_hashs, fn filtered_hash ->
                  {:ok, server} = Map.fetch(id_hash_map,filtered_hash)
                  if(index==0)  do
                    Client.setRoutingTableDynamic(server,0,String.at(my_hash,index),my_hash)
                  else
                    Client.setRoutingTableDynamic(server,index,String.at(my_hash,index),my_hash)
                  end

                  random_string="5"
        end)

                end)

end


end
