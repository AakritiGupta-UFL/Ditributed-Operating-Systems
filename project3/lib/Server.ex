defmodule Server do
    use GenServer

    def start_link(val) do
      GenServer.start_link(__MODULE__,val)
    end

    def init(val) do
                {:ok,
                %{"routing_table" => %{"0" => %{"0" => "", "1" => "", "2" => "",  "3" => "",  "4" => "",  "5" => "",  "6" => "",  "7" => "",  "8" => "",  "9" => "",  "A" => "",  "B" => "",  "C" => "",  "D" => "",  "E" => "",  "F" => ""},
                        "1" => %{"0" => "", "1" => "", "2" => "",  "3" => "",  "4" => "",  "5" => "",  "6" => "",  "7" => "",  "8" => "",  "9" => "",  "A" => "",  "B" => "",  "C" => "",  "D" => "",  "E" => "",  "F" => ""},
                        "2" => %{"0" => "", "1" => "", "2" => "",  "3" => "",  "4" => "",  "5" => "",  "6" => "",  "7" => "",  "8" => "",  "9" => "",  "A" => "",  "B" => "",  "C" => "",  "D" => "",  "E" => "",  "F" => ""},
                        "3" => %{"0" => "", "1" => "", "2" => "",  "3" => "",  "4" => "",  "5" => "",  "6" => "",  "7" => "",  "8" => "",  "9" => "",  "A" => "",  "B" => "",  "C" => "",  "D" => "",  "E" => "",  "F" => ""},
                        "4" => %{"0" => "", "1" => "", "2" => "",  "3" => "",  "4" => "",  "5" => "",  "6" => "",  "7" => "",  "8" => "",  "9" => "",  "A" => "",  "B" => "",  "C" => "",  "D" => "",  "E" => "",  "F" => ""},
                        "5" => %{"0" => "", "1" => "", "2" => "",  "3" => "",  "4" => "",  "5" => "",  "6" => "",  "7" => "",  "8" => "",  "9" => "",  "A" => "",  "B" => "",  "C" => "",  "D" => "",  "E" => "",  "F" => ""},
                        "6" => %{"0" => "", "1" => "", "2" => "",  "3" => "",  "4" => "",  "5" => "",  "6" => "",  "7" => "",  "8" => "",  "9" => "",  "A" => "",  "B" => "",  "C" => "",  "D" => "",  "E" => "",  "F" => ""},
                        "7" => %{"0" => "", "1" => "", "2" => "",  "3" => "",  "4" => "",  "5" => "",  "6" => "",  "7" => "",  "8" => "",  "9" => "",  "A" => "",  "B" => "",  "C" => "",  "D" => "",  "E" => "",  "F" => ""}}
                      }}
      end

  def handle_call({:get_hash_identifier}, _from, state) do
           {:reply, Map.fetch(state,"hash_id"),state}
  end

  def handle_cast({:set_routing_table2,level,position,hash_val},state) do

     {:ok,full_routing_table} = Map.fetch(state,"routing_table")
     {:ok, update_level_table} = Map.fetch(full_routing_table,Integer.to_string(level))
      val= hash_val
     if(position>=0 and position<=9) do
          new_update_level_table = Map.put(update_level_table,Integer.to_string(position),val )
          new_full_routing_table = Map.put(full_routing_table,Integer.to_string(level), new_update_level_table )
          new_state = Map.put(state,"routing_table", new_full_routing_table)
          # IO.inspect(new_state)
          {:noreply,new_state}

     else
          cond do
              position == 10 ->
                  new_update_level_table = Map.put(update_level_table,"A",val )
                  new_full_routing_table = Map.put(full_routing_table,Integer.to_string(level), new_update_level_table )
                  new_state = Map.put(state,"routing_table", new_full_routing_table)
                  {:noreply,new_state}
              position == 11 ->
                  new_update_level_table = Map.put(update_level_table,"B",val )
                  new_full_routing_table = Map.put(full_routing_table,Integer.to_string(level), new_update_level_table )
                  new_state = Map.put(state,"routing_table", new_full_routing_table)
                  {:noreply,new_state}
              position == 12 ->
                  new_update_level_table = Map.put(update_level_table,"C",val )
                  new_full_routing_table = Map.put(full_routing_table,Integer.to_string(level), new_update_level_table )
                  new_state = Map.put(state,"routing_table", new_full_routing_table)
                  {:noreply,new_state}
              position == 13 ->
                  new_update_level_table = Map.put(update_level_table,"D",val )
                  new_full_routing_table = Map.put(full_routing_table,Integer.to_string(level), new_update_level_table )
                  new_state = Map.put(state,"routing_table", new_full_routing_table)
                  {:noreply,new_state}
              position == 14 ->
                  new_update_level_table = Map.put(update_level_table,"E",val )
                  new_full_routing_table = Map.put(full_routing_table,Integer.to_string(level), new_update_level_table )
                  new_state = Map.put(state,"routing_table", new_full_routing_table)
                  {:noreply,new_state}
              position == 15 ->
                  new_update_level_table = Map.put(update_level_table,"F",val )
                  new_full_routing_table = Map.put(full_routing_table,Integer.to_string(level), new_update_level_table )
                  new_state = Map.put(state,"routing_table", new_full_routing_table)
                  {:noreply,new_state}
          end
      end

  end


  def handle_cast({:set_routing_table_dynamic,level,position,hash_val},state) do

     {:ok,full_routing_table} = Map.fetch(state,"routing_table")
     {:ok, update_level_table} = Map.fetch(full_routing_table,Integer.to_string(level))
      val= hash_val
      {:ok,existing_val} = Map.fetch(update_level_table,position )
      if(String.length(existing_val) != 0) do
        new_update_level_table = Map.put(update_level_table,position,val )
        new_full_routing_table = Map.put(full_routing_table,Integer.to_string(level), new_update_level_table )
        new_state = Map.put(state,"routing_table", new_full_routing_table)
        {:noreply,new_state}
      else
        {:noreply,state}
      end

  end


  def handle_call({:get_routing_table}, _from, state) do

    {:reply, Map.fetch(state,"routing_table"), state}
  end


end
