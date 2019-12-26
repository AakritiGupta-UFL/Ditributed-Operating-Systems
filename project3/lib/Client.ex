defmodule Client do
    use GenServer

    def start_link(val) do
        GenServer.start_link(Server,val)
    end

    def setRoutingTable(server,level,hash_val) do
        GenServer.cast(server, {:set_routing_table,level,hash_val})

    end

    def setRoutingTable2(server,level,position,hash_val) do
        GenServer.cast(server, {:set_routing_table2,level,position,hash_val})
    end

    def setRoutingTableDynamic(server,level,position,hash_val) do
        GenServer.cast(server, {:set_routing_table_dynamic,level,position,hash_val})
    end

    def getRoutingTable(server) do
      #  IO.puts("in get table")
        {:ok,routing_table} = GenServer.call(server,{:get_routing_table})
        routing_table
    end

end
