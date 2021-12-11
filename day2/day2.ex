defmodule AdventOfCode do
  # {hpos, dpos, aim}
  def solve1(course) do
    course
    |> Enum.reduce({0, 0}, &drive/2)
    |> calc()
  end

  def solve2(course) do
    course
    |> Enum.reduce({0, 0, 0}, &drive_aim/2)
    |> calc()
  end

  defp drive(course, state) do
    case course do
      ["up", x] -> put_elem(state, 1, elem(state, 1) - x)
      ["down", x] -> put_elem(state, 1, elem(state, 1) + x)
      ["forward", x] -> put_elem(state, 0, elem(state, 0) + x)
    end
  end

  defp drive_aim(course, state) do
    case course do
      ["up", x] -> put_elem(state, 2, elem(state, 2) - x)
      ["down", x] -> put_elem(state, 2, elem(state, 2) + x)
      ["forward", x] -> put_elem(state, 0, elem(state, 0) + x) |> put_elem(1, elem(state, 1) + elem(state, 2) * x)
    end
  end

  defp calc(state) do
    case state do
      {h, d} -> h * d
      {h, d, _} -> h * d
    end
  end
end

source =
  String.split(File.read!("#{__DIR__}/in.txt"), ~r{\n})
  |> Enum.filter(fn x -> x != "" end)
  |> Enum.map(&String.split/1)
  |> Enum.map(&List.update_at(&1, 1, fn x -> String.to_integer(x) end))

IO.inspect(AdventOfCode.solve1(source))
IO.inspect(AdventOfCode.solve2(source))
