defmodule Mix.Tasks.SpawnCalculator do

def start_link(a,b) do
  {:ok, pid} = Mix.Tasks.Vampirecalculator.start_link()
  q=div(b-a+1,50)
  count=50
  ranges1= for i<- 0..q-1, do: a+(i*count)+i
  if(rem((b-a),50)!==0) do
      to_add=[(q*50)+q+a]
      ranges = ranges1++to_add
      Enum.map(ranges, fn(range) -> spawn(__MODULE__, :work, [pid, range, count,b,self()])  end)
      check_response(length(ranges),0,pid)
  else
      Enum.map(ranges1, fn(range) -> spawn(__MODULE__, :work, [pid, range, count,b,self()]) end)
      check_response(length(ranges1),0,pid)
  end
end

def check_response(total_value,rcvd_value,pid) do
  if(total_value===rcvd_value) do
      final_ans=Mix.Tasks.Vampirecalculator.get_list(pid)
      final_ans |> Enum.each(fn x -> IO.puts(Enum.join(x," ")) end)
      System.halt(0)
  else
      receive do
        {:ok,"yes"} -> check_response(total_value,rcvd_value+1,pid)
      end
  end
end

def work(pid, start,count,b,id) do
  rend=start+count
  list=Enum.to_list(start..rend)
  Enum.map(list, fn(n) -> if(n <= b) do vampire_number(n,b,pid) end end)
  send(id,{:ok,"yes"})
end

def vampire_number(n,b,pid) do
vampire_list=[]
s=Integer.to_string(n)
if s |> String.length |>rem(2)!==1 do
	half_length= s |> String.length |>div(2)
    power= :math.pow(10,half_length) |>trunc
    small=div(n, power)
    big=trunc(:math.sqrt(n))
    allowed_number=Enum.sort(String.codepoints("#{n}"))
    factor_pair? =fn(n,i) -> rem(n,i)==0 && length(to_charlist(i))==half_length && length(to_charlist(div(n,i)))==half_length end
    list=for i<- small .. big, factor_pair? .(n,i), do: {i, div(n,i)}
    test2=Enum.filter(list, fn{x,y}-> rem(x,10)!=0 || rem(y,10)!=0 end)
    test=Enum.filter(list,fn{item1,item2}-> Enum.sort(String.codepoints("#{item1}#{item2}"))==allowed_number end)
    IO.puts("test is #{test}")
    if(test !=[]) do Enum.each(test,fn{item1,item2} -> l=[n,item1,item2]
                                                vampire_list=vampire_list++[l]
                                                GenServer.cast(pid, {:async_number,vampire_list})
                                                end)
   end


end
end
end
