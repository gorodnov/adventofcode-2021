defmodule AdventOfCode do
  def solve1({crab_positions, max_pos}) do
    Enum.reduce(0..max_pos, %{}, fn pos, acc -> Map.put(acc, pos, calc_fuel_diff(pos, crab_positions)) end)
    |> Map.values()
    |> Enum.min()
  end

  def solve2({crab_positions, max_pos}) do
    Enum.reduce(0..max_pos, %{}, fn pos, acc -> Map.put(acc, pos, calc_fuel_foo(pos, crab_positions)) end)
    |> Map.values()
    |> Enum.min()
  end

  defp calc_fuel_diff(pos, crab_positions) do
    Enum.reduce(crab_positions, 0, fn {k, v}, acc -> acc + abs(pos - k) * v  end)
  end

  defp calc_fuel_foo(pos, crab_positions) do
    Enum.reduce(crab_positions, 0, fn {k, v}, acc -> acc + foo(abs(pos - k)) * v  end)
  end

  defp foo(n) when n > 0 do
    n + foo(n - 1)
  end

  defp foo(_), do: 0
end

File.cd("day7")

input =
  File.read!("in.txt")
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
    |> then(fn crab_positions -> \
      {crab_positions, Map.keys(crab_positions) |> Enum.max()}
    end)

IO.inspect(AdventOfCode.solve1(input))
IO.inspect(AdventOfCode.solve2(input))
