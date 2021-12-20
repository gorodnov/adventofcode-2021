defmodule AdventOfCode do
  def solve(insertion_rules, pair_frequencies, steps) do
    Enum.reduce(1..steps, pair_frequencies, &(insert(&1, &2, insertion_rules)))
    |> Enum.reduce(%{}, fn {[elem | _], num}, acc -> merge_sum(acc, %{elem => num}) end)
    |> Map.values()
    |> then(&(Enum.max(&1) - Enum.min(&1)))
  end

  defp insert(step, pair_frequencies, insertion_rules) do
    IO.puts(step)
    # IO.inspect(insertion_rules)
    pair_frequencies
    # |> tap(&IO.inspect(&1))
    |> Enum.reduce(%{}, fn {pair, num}, acc -> \
      if elem = Map.get(insertion_rules, pair) do
        Map.delete(acc, %{pair => num})
        |> merge_sum(%{[hd(pair), elem] => num})
        |> merge_sum(%{[elem | tl(pair)] => num})
      else
        merge_sum(acc, %{pair => num})
      end
    end)
    # |> tap(&IO.inspect(&1))
  end

  defp merge_sum(map1, map2) do
    Map.merge(map1, map2, fn _, v1, v2 -> v1 + v2 end)
  end
end

insertion_rules =
  File.stream!("#{__DIR__}/in.txt")
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.split(&1, ~r{\s->\s}))
  |> Stream.map(fn [h | t] -> [String.graphemes(h) | t] end)
  |> Enum.map(&List.to_tuple/1)
  |> Map.new()

pair_frequencies =
  File.stream!("#{__DIR__}/template.txt")
  |> Enum.map(&String.trim/1)
  |> then(fn [h | _] -> String.graphemes(h) end)
  |> Enum.chunk_every(2, 1)
  |> Enum.frequencies()

IO.inspect(AdventOfCode.solve(insertion_rules, pair_frequencies, 10))
IO.inspect(AdventOfCode.solve(insertion_rules, pair_frequencies, 40))
