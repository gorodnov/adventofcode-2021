defmodule AdventOfCode do
  def solve(input, days) do
    Enum.reduce(1..days, input, &day/2)
    |> Enum.sum()
  end

  defp day(_, [a0, a1, a2, a3, a4, a5, a6, a7, a8]) do
    [a1, a2, a3, a4, a5, a6, a7 + a0, a8, a0]
  end
end

File.cd("day6")

input =
  File.read!("in.txt")
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
    |> then(&(Map.merge(%{0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0}, &1)))
    |> Map.values()

IO.inspect(AdventOfCode.solve(input, 80))
IO.inspect(AdventOfCode.solve(input, 256))
