defmodule AdventOfCode do
  def solve(pairs, template, steps) do
    Enum.reduce(1..steps, template, &(insert(&1, &2, pairs)))
    |> Enum.frequencies()
    |> Map.values()
    |> then(&(Enum.max(&1) - Enum.min(&1)))
  end

  defp insert(step, polymer, pairs) do
    IO.puts(step)
    polymer
    |> Enum.chunk_every(2, 1)
    # |> tap(&IO.inspect(&1))
    |> Enum.flat_map(fn pair -> \
      if elem = Map.get(pairs, pair) do
        [hd(pair), elem]
      else
        pair
      end
    end)
    # |> tap(&IO.inspect(&1))
  end
end

pairs =
  File.stream!("#{__DIR__}/in.txt")
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.split(&1, ~r{\s->\s}))
  |> Stream.map(fn [h | t] -> [String.graphemes(h) | t] end)
  |> Enum.map(&List.to_tuple/1)
  |> Map.new()

template =
  File.stream!("#{__DIR__}/template.txt")
  |> Enum.map(&String.trim/1)
  |> then(fn [h | _] -> String.graphemes(h) end)

IO.inspect(AdventOfCode.solve(pairs, template, 10))
# IO.inspect(AdventOfCode.solve(pairs, template, 40))
