defmodule AdventOfCode do
  def solve1(input) do
    input
    |> Enum.filter(&considered_coords_1?/1)
    |> calc()
  end

  def solve2(input) do
    input
    |> Enum.filter(&considered_coords_2?/1)
    |> calc()
  end

  defp calc(lines) do
    lines
    |> Enum.reduce(Enum.map(0..999, fn _ -> List.duplicate(0, 1000) end), &draw_line/2)
    |> Enum.map_reduce(0, fn line, acc -> {line, acc + Enum.count(line, &(&1 > 1))} end)
  end

  defp draw_line({x1, y1, x2, y2}, field) do
    cond do
      x1 === x2 && y1 !== y2 -> Enum.reduce(y1..y2, field, fn y, acc -> update_field(acc, x1, y) end)
      y1 === y2 && x1 !== x2 -> Enum.reduce(x1..x2, field, fn x, acc -> update_field(acc, x, y1) end)
      true -> \
        Enum.zip(x1..x2, y1..y2)
        |> Enum.reduce(field, fn {x, y}, acc -> update_field(acc, x, y) end)
    end
  end

  defp update_field(field, x, y) do
    List.update_at(field, y, fn line -> List.update_at(line, x, &(&1 + 1)) end)
  end

  defp considered_coords_1?({x1, y1, x2, y2}) do
    x1 === x2 || y1 === y2
  end

  defp considered_coords_2?({x1, y1, x2, y2}) do
    x1 === x2 || y1 === y2 || (Range.size(x1..x2) === Range.size(y1..y2))
  end
end

input =
  File.stream!("#{__DIR__}/in.txt")
  |> Stream.map(&String.split(&1, ~r{,|->|\s}))
  |> Stream.map(&Enum.reject(&1, fn x -> x === "" end))
  |> Stream.map(&Enum.map(&1, fn x -> String.to_integer(x) end))
  |> Enum.map(&List.to_tuple/1)

IO.inspect(AdventOfCode.solve1(input))
IO.inspect(AdventOfCode.solve2(input))
