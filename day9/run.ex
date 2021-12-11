defmodule AdventOfCode do
  defguardp in_range(x, y, input) when x >= 0 and x < length(hd(input)) and y >= 0 and y < length(input)

  defp low_points(input) do
    xmax = length(hd(input)) - 1
    ymax = length(input) - 1
    Enum.reduce(0..ymax, [], fn y, acc -> \
      Enum.reduce(0..xmax, acc, fn x, map -> [{{x, y}, point({x, y}, input)} | map] end)
    end)
    |> Enum.reverse()
    |> Enum.map(fn {{x, y}, point} -> {{x, y}, point, neibours({x, y}, input)} end)
    |> Enum.filter(fn x -> elem(x, 1) < Enum.min(elem(x, 2)) end)
  end

  def solve1(input) do
    low_points(input)
    |> Enum.map(fn x -> elem(x, 1) + 1 end)
    |> Enum.sum()
  end

  def solve2(input) do
    low_points(input)
    |> Enum.map(fn {{x, y}, point, _} -> {{x, y}, point, basin({x, y}, input)} end)
    |> Enum.map(fn {_, _, basin} -> Enum.uniq(basin) end)
    |> Enum.sort(&(length(&1) > length(&2)))
    |> Enum.slice(0, 3)
    |> Enum.reduce(1, &(length(&1) * &2))
  end

  defp basin({x, y}, input) do
    basin({x, y}, input, [])
  end

  defp basin({x, y}, input, acc) do
    self = point({x, y}, input)
    if self === 9 do
      acc
    else
      acc = [{x, y} | acc]
      Enum.reject([{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}], &(&1 in acc))
      |> Enum.reduce(acc, &(basin(&1, input, &2)))
    end
  end

  defp neibours({x, y}, input) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.map(&point(&1, input))
  end

  defp point({x, y}, input) when in_range(x, y, input) do
    Enum.at(input, y)
    |> Enum.at(x)
  end

  defp point(_, _) do
    9
  end
end

input =
  File.stream!("#{__DIR__}/in.txt")
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.codepoints/1)
  |> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)

IO.inspect(AdventOfCode.solve1(input))
IO.inspect(AdventOfCode.solve2(input))
