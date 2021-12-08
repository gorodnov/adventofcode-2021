defmodule AdventOfCode do
  def solve1(input) do
    input
    |> Stream.flat_map(fn [pattern, output] -> \
      pattern
      |> Stream.filter(fn x -> Enum.member?([2, 4, 3, 7], length(x)) end)
      |> then(fn filtered_pattern -> \
        Stream.filter(output, &(Enum.member?(filtered_pattern, &1)))
      end)
    end)
    |> Enum.count()
  end
end

File.cd("day8")

input = File.stream!("in.txt")
  |> Stream.map(fn line -> \
    String.trim(line)
    |> String.split(~r{\s*\|\s*})
    |> Enum.map(fn x -> \
      String.split(x)
      |> Enum.map(&String.to_charlist/1)
      |> Enum.map(&Enum.sort/1)
    end)
  end)

IO.inspect(AdventOfCode.solve1(input))
