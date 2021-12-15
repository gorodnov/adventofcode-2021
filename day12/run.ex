defmodule AdventOfCode do
  def solve1(input) do
    routes_map(input)
    |> tap(&IO.inspect/1)
    |> paths(:once)
    |> tap(&IO.inspect/1)
    |> Enum.count()
  end

  def solve2(input) do
    routes_map(input)
    |> tap(&IO.inspect/1)
    |> paths(:twice)
    |> tap(&IO.inspect/1)
    |> Enum.count()
  end

  defp paths(routes, navigation \\ :once) do
    path(routes, "start", [], [], navigation)
  end

  defp path(_, from, path_so_far, paths, _) when from === "end" do
    [Enum.reverse([from | path_so_far]) | paths]
  end

  defp path(routes, from, path_so_far, paths, navigation) do
    path_so_far = [from | path_so_far]
    tos = routes[from]
    |> Enum.filter(&can_visit_cave?(&1, path_so_far, navigation))
    |> Enum.reduce(paths, fn from, acc -> path(routes, from, path_so_far, acc, navigation) end)
  end

  defp can_visit_cave?(cave, path_so_far, navigation) do
    case navigation do
      :once -> big_cave?(cave) || !Enum.member?(path_so_far, cave)
      :twice -> can_visit_cave?(cave, path_so_far, :once) || !visited_twice?(path_so_far)
    end
  end

  defp visited_twice?(path_so_far) do
    path_so_far
    |> Enum.reject(&big_cave?/1)
    |> Enum.frequencies()
    |> Enum.find(fn {_, count} -> count === 2 end)
  end

  defp big_cave?(route) do
    String.match?(route, ~r{[A-Z]+})
  end

  defp routes_map(input) do
    input
    |> Enum.reduce(%{}, fn {from, to}, map ->
      route_map(map, {from, to})
      |> route_map({to, from})
    end)
  end

  defp route_map(map, {from, to}) when from !== "end" and to !== "start" do
    if map[from], do: Map.put(map, from, [to | map[from]]), else: Map.put(map, from, [to])
  end

  defp route_map(map, _) do
    map
  end
end

input =
  File.stream!("#{__DIR__}/in.txt")
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.split(&1, "-"))
  |> Enum.map(&List.to_tuple/1)

IO.inspect(AdventOfCode.solve1(input))
IO.inspect(AdventOfCode.solve2(input))
