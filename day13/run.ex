defmodule AdventOfCode do
  def solve1(coordinates, instructions) do
    Enum.reduce(instructions, coordinates, &fold/2)
    |> Enum.count()
  end

  def solve2(coordinates, instructions) do
    Enum.reduce(instructions, coordinates, &fold/2)
    |> render()
  end

  defp render(coordinates) do
    coordinates
    |> Enum.reduce((for _ <- 0..6, do: List.duplicate(' ', 50)), fn {x, y}, paper -> \
      List.update_at(paper, y, fn list -> List.update_at(list, x, fn _ -> '#' end) end)
    end)
  end

  defp fold({dir, val}, coordinates) do
    coordinates
    # |> tap(&IO.inspect(&1))
    |> Enum.map(fn {x, y} -> \
      case dir do
        :x -> {fold({x, val}), y}
        :y -> {x, fold({y, val})}
      end
    end)
    |> Enum.uniq()
    # |> tap(&IO.inspect(&1))
  end

  defp fold({coord, fold_value}) when coord > fold_value do
    2 * fold_value - coord
  end

  defp fold({coord, _}) do
    coord
  end
end

coordinates =
  File.stream!("#{__DIR__}/in.txt")
  |> Stream.map(&String.trim/1)
  |> Stream.map(fn line -> String.split(line, ",") |> Enum.map(&String.to_integer/1) end)
  |> Enum.map(&List.to_tuple/1)

instructions =
  File.stream!("#{__DIR__}/instructions.txt")
  |> Stream.map(fn line -> \
    Regex.scan(~r{(x|y)=(\d+)}, line)
    |> then(fn [[_ | tail] | _] -> List.to_tuple(tail) end)
  end)
  |> Enum.map(fn {coord, val} -> {String.to_atom(coord), String.to_integer(val)} end)

IO.inspect(AdventOfCode.solve1(coordinates, [hd(instructions)]))
IO.inspect(AdventOfCode.solve2(coordinates, instructions), limit: :infinity, pretty: true, width: 260)
# Answer: cejklugj
