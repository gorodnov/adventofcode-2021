defmodule AdventOfCode do
  def solve1(input) do
    input
    |> Enum.reduce([], fn line, acc -> if c = corrupted?(line), do: [c | acc], else: acc end)
    |> Enum.map(&corrupted_points/1)
    |> Enum.sum()
  end

  def solve2(input) do
    input
    |> Enum.reject(&corrupted?/1)
    |> Enum.map(&autocomplete/1)
    |> Enum.sort()
    |> then(&(Enum.at(&1, div(length(&1), 2))))
  end

  defp autocomplete(line) do
    line
    |> Enum.reduce([], fn x, acc -> if opening?(x), do: [x | acc], else: tl(acc) end)
    |> Enum.reduce(0, fn chr, score -> 5 * score + autocomplete_points(get_closing(chr))  end)
  end

  defp corrupted?(line) do
    try do
      Enum.reduce(line, [], fn x, acc -> \
        cond do
          opening?(x) -> [x | acc]
          Enum.join([hd(acc), x], "") in ["()", "[]", "{}", "<>"] -> tl(acc)
          true -> throw(x)
        end
      end)
      false
    catch
      x -> x
    end
  end

  defp opening?(chr) do
    chr in ["(", "[", "{", "<"]
  end

  defp get_closing(chr) do
    case chr do
      "(" -> ")"
      "[" -> "]"
      "{" -> "}"
      "<" -> ">"
    end
  end

  defp corrupted_points(chr) do
    case chr do
      ")" -> 3
      "]" -> 57
      "}" -> 1197
      ">" -> 25137
    end
  end

  defp autocomplete_points(chr) do
    case chr do
      ")" -> 1
      "]" -> 2
      "}" -> 3
      ">" -> 4
    end
  end
end

input =
  File.stream!("#{__DIR__}/in.txt")
  |> Stream.map(&String.trim/1)
  |> Enum.map(&String.graphemes/1)

IO.inspect(AdventOfCode.solve1(input))
IO.inspect(AdventOfCode.solve2(input))
