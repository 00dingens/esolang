defmodule Brainfuck do
  @moduledoc """
    Brainfuck interpreter and debugger
    Author: Rafael Friesen
  """

  @doc """
  Run bfi/3 to interpret or debug Brainfuck programs.

  To just run call e.g. bfi(",[.,]", "Hello!")
  For debug call e.g. bfi(",[.,]", "Hello!", :true)

  In debug mode you will see
    - code, () brackets marking the actual instruction
    - memory, ][ brackets marking the current pointer position
    - the remaining input
  for each step and a detailed search for matching brackets.

  Memory is expanded as needed.
  """
  def bfi(code, input, debug \\ :false) do
    bf({'',code++' '}, {[0],[0,0]}, input, 1, debug)
  end

  # usage:
  # bf(
  #    {leftCode, [actualInstruction | rightCode]},
  #    {leftMemory, [actualMemory | rightMemory]},
  #    inputQueue,
  #    instructionCounter,
  #    debugFlag)
  defp bf({_,[]}, _, _, n, _) do
    {:ok, "#{n} steps"}
  end
  defp bf(code, mem, ip, n, d) do
    # separate and normalize
    {cl,[c|cr]}=code
    {ml,[m|mr]}=mem
    if mr==[] do; mr=[0]; end
    if ml==[] do; ml=[0]; end
    if ip==[] do; ip=[0]; end
    #if cr==[] do; cr=' '; end
    code={[c|cl],cr}
    mem={ml,[m|mr]}
    # debug output
    #IO.puts "Actual inst"[c]
    if d do
      IO.puts "\nstep #{n}"
      IO.puts " code: #{Enum.reverse(cl)}(#{[c]})#{cr}"
      IO.puts "  mem: #{inspect Enum.reverse(ml)}#{m}#{inspect mr}"
      IO.puts "input: #{ip}"
    end
    case [c] do
      '+' -> bf(code, {ml, [(m+1)|mr]}, ip, n+1, d)
      '-' -> bf(code, {ml, [(m-1)|mr]}, ip, n+1, d)
      '.' -> IO.write [m]
        bf(code, mem, ip, n+1, d)
      ',' -> [i|itail] = ip
        bf(code, {ml, [i|mr]}, itail, n+1, d)
      '<' -> [mlhead|mltail]=ml
        bf(code, {mltail, [mlhead,m|mr]}, ip, n+1, d)
      '>' -> bf(code, {[m|ml], mr}, ip, n+1, d)
      '[' ->
        code={[c|cl],cr}
        if m==0 do
          if d do
            IO.puts "search(n=1, ->): #{Enum.reverse(cl)}(#{[c]})#{cr}"
          end
          code=search(code,1, d)
        end
        bf(code, mem, ip, n+1, d)
      ']' ->
        if d do
          IO.puts "search(n=-1, <-): #{Enum.reverse(cl)}(#{[c]})#{cr}"
        end
        case search({[c|cr],cl},-1, d) do
          {:error,reason} -> {:error, reason}
          {cr,cl} ->
            code={cl,cr}
            bf(code, mem, ip, n+1, d)
        end
      _ -> bf(code, mem, ip, n, d)
    end
  end

  defp search(code, 0, _) do
    code
  end
  defp search({_,[]}, _, _) do
    {:error, "No matching brackets"}
  end
  defp search({cl,[c|cr]}, b, d) do
    if d do
      if b>0 do
        IO.puts "search(b=#{b}, ->): #{Enum.reverse(cl)}(#{[c]})#{cr}"
      else
        IO.puts "search(b=#{b}, <-): #{Enum.reverse(cr)}(#{[c]})#{cl}"
      end
    end
    code = {[c|cl],cr}
    case [c] do
      '[' -> search(code, b+1, d)
      ']' -> search(code, b-1, d)
      _ -> search(code, b, d)
    end
  end
end
