defmodule AdventOfCode do
  def solve1(depth_list) do
    depth_list
    |> Enum.reduce([Enum.max(depth_list), 0], &test_depth/2)
    |> List.last()
  end

# TODO use tuple
  def solve2(depth_list) do
    depth_list
    |> Enum.chunk_every(3,1,:discard)
    |> Enum.map(&Enum.sum/1)
    |> AdventOfCode.solve1()
  end

  defp test_depth(depth, acc) do
    if depth > List.first(acc) do
      [depth, List.last(acc) + 1]
    else
      [depth, List.last(acc)]
    end
  end
end

File.cd("day1")
depth_list =
  String.split(File.read!("in.txt"), ~r{\n})
  |> Enum.filter(fn x -> x != "" end)
  |> Enum.map(&String.to_integer/1)

IO.inspect(AdventOfCode.solve1(depth_list))
IO.inspect(AdventOfCode.solve2(depth_list))
