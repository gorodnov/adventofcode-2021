defmodule AdventOfCode do
  def solve(pairs, template, steps) do
    Enum.reduce(1..steps, template, &(insert(&1, &2, pairs)))
    |> String.graphemes()
    |> Enum.frequencies()
    |> Map.values()
    |> then(&(Enum.max(&1) - Enum.min(&1)))
  end

  defp insert(step, polymer, pairs) do
    IO.puts(step)
    polymer
    |> String.graphemes()
    |> Enum.chunk_every(2, 1)
    |> Enum.map(&Enum.join/1)
    |> Enum.map_join(fn pair -> \
      if elem = Map.get(pairs, pair) do
        "#{String.first(pair)}#{elem}"
      else
        pair
      end
    end)
  end
end

pairs =
  File.stream!("#{__DIR__}/in.txt")
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.split(&1, ~r{\s->\s}))
  |> Enum.map(&List.to_tuple/1)
  |> Map.new()

template =
  File.stream!("#{__DIR__}/template.txt")
  |> Enum.map(&String.trim/1)
  |> hd()

IO.inspect(AdventOfCode.solve(pairs, template, 10))
# IO.inspect(AdventOfCode.solve(pairs, template, 40))
