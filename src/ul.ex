defmodule Unlambda do
  @moduledoc """
    WIP: Unlambda interpreter and debugger
    http://www.madore.org/~david/programs/unlambda/
    Author: Rafael Friesen
  """

  def uli(code) do
    [ret] = ul(code++[0])
    ret
  end
  def ul(code) do
    IO.inspect code
    case code do
      [96|ctail] ->  # ` apply f to g
        [f,g|rest] = ul(ctail)
        [f.(g)|rest]
      [105|ctail] ->  # i identity (``skk->i)
        i = fn f -> f end
        [i|ul(ctail)]
      [107|ctail] ->  # k "constant function constructor": evaluate f and g and return f
        # k = fn (f,g) -> f end
        k = fn (f) ->
          fn (_) -> f end
        end
        [k|ul(ctail)]
      [115|ctail] -> # s "substituted application" executes ``fh`gh (```skss->s)
          #s=fn (f,g,h) -> (f.(h)).(g.(h)) end
        s = fn (f) ->
          fn (g) ->
            fn (h) ->
              (f.(h)).(g.(h))
            end
          end
        end
        [s|ul(ctail)]
      [0] -> []
    end
  end

  def ae(code) do
     abstraction_elimination(code)
  end
  def abstraction_elimination([c|code],var \\ '') do
    [h|t] = code
    if t==[] do
      ...
    end
    case [c] do
      '^' -> inner = abstraction_elimination(t, [h])
         abstraction_elimination(inner, var)
      '$' ->
        case [h] do
          '`'   -> '``s'          ++ abstraction_elimination(t, var)
          ^var  -> 'i'            ++ abstraction_elimination(t, var)
          other -> '`k$' ++ other ++ abstraction_elimination(t, var)
        end
      _ -> [c | abstraction_elimination(code, var)]
    end
  end


  def validate([], n) do
    case n do
      0 -> :ok
      _ -> {:invalid, "Too many `"}
    end
  end
  def validate([c|code], n \\ 1) do
    cond do
      n<1 -> {:invalid, "Too less/late `"}
      [c]=='`' -> validate(code,n+1)
      c in 'sk' -> validate(code,n-1)
    end
  end
end
