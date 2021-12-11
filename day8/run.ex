defmodule AdventOfCode do
  def solve1(input) do
    input
    |> Stream.flat_map(fn [pattern, output] -> \
      pattern
      |> Stream.filter(fn x -> length(x) in [2, 4, 3, 7] end)
      |> then(fn filtered_pattern -> \
        Stream.filter(output, &(&1 in filtered_pattern))
      end)
    end)
    |> Enum.count()
  end
end

input = File.stream!("#{__DIR__}/in.txt")
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
