defmodule AdventOfCode do
  # TODO re-do with recursion 
  def solve1(numbers, base) do
    gamma =
      Enum.map(0..(base - 1), &common_kind(numbers, &1, :most))
      |> Enum.join()
      |> String.to_integer(2)
    epsilon = Integer.pow(2, base) - gamma - 1
    gamma * epsilon
  end

  def solve2(numbers) do
    oxigen = test(numbers, 0, :most)
    co2 = test(numbers, 0, :less)
    oxigen * co2
  end

  defp test(numbers, bit, kind) when length(numbers) > 1 do
    values = Enum.filter(numbers, fn x -> String.at(x, bit) === common_kind(numbers, bit, kind) end)
    test(values, bit + 1, kind)
  end

  defp test(numbers, _, _) do
    String.to_integer(hd(numbers), 2)
  end

  defp common_kind(numbers, possition, kind) do
    freq = numbers |> Enum.frequencies_by(&String.at(&1, possition))
    case kind do
      :most -> if freq["1"] >= freq["0"], do: "1", else: "0"
      :less -> if freq["0"] <= freq["1"], do: "0", else: "1"
    end
  end
end

File.cd("day3")
source =
  String.split(File.read!("in.txt"), ~r{\n})
  |> Enum.filter(fn x -> x != "" end)

IO.inspect(AdventOfCode.solve1(source, 12))
IO.inspect(AdventOfCode.solve2(source))
