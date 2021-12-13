defmodule AdventOfCode do
  defguardp in_range(x, y, input) when x >= 0 and x < length(hd(input)) and y >= 0 and y < length(input)

  defp coords(input) do
    for x <- 1..length(hd(input)), y <- 1..length(input) do
      {x - 1, y - 1}
    end
  end

  def solve1(input) do
    Enum.reduce(1..100, {input, 0}, &step/2)
  end

  def solve2(input) do
    synchronizing(input, 1)
  end

  defp synchronizing(input, step) do
    coords = coords(input)
    input = Enum.reduce(coords, input, &increase/2)
    input = Enum.reduce(coords, input, &flash/2)
    flashed_octopuses = Enum.filter(coords, fn {x,y} -> level(input, {x, y}) === 0 end)
    if length(flashed_octopuses) < length(input) * length(hd(input)) do
      synchronizing(input, step + 1)
    else
      step
    end
  end

  defp step(_, {input, count}) do
    coords = coords(input)
    input = Enum.reduce(coords, input, &increase/2)
    input = Enum.reduce(coords, input, &flash/2)
    Enum.reduce(coords, {input, count}, fn {x,y}, {input, count} -> \
      if level(input, {x, y}) === 0, do: {input, count + 1}, else: {input, count}
    end)
  end

  defp increase({x, y}, input) do
    update_level(input, {x, y}, :increase)
  end

  defp flash_increase({x, y}, input) do
    update_level(input, {x, y}, :flash_increase)
  end

  defp flash({x, y}, input) do
    level = level(input, {x, y})
    if level > 9 do
      input = update_level(input, {x, y}, :flash)
      adjacent = adjacent(input, {x, y})
      input = Enum.reduce(adjacent, input, &flash_increase/2)
      Enum.reduce(adjacent, input, &flash/2)
    else
      input
    end
  end

  defp adjacent(input, {x, y}) do
    [{x, y - 1}, {x + 1, y - 1}, {x + 1, y}, {x + 1, y + 1}, {x, y + 1}, {x - 1, y + 1}, {x - 1, y}, {x - 1, y - 1}]
    |> Enum.filter(&(level(input, &1)))
  end

  defp update_level(input, {x, y}, type) do
    List.update_at(input, y, fn line -> \
      List.update_at(line, x, fn level -> \
        cond do
          type === :increase -> level + 1
          type === :flash_increase -> if level === 0, do: 0, else: level + 1
          type === :flash -> if level > 9, do: 0, else: level
        end
      end)
    end)
    |> then(&(&1))
  end

  defp level(input, {x, y}) when in_range(x, y, input) do
    Enum.at(input, y)
    |> Enum.at(x)
  end

  defp level(_, _) do
    nil
  end
end

input =
  File.stream!("#{__DIR__}/in.txt")
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.codepoints/1)
  |> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)

IO.inspect(AdventOfCode.solve1(input))
IO.inspect(AdventOfCode.solve2(input))
