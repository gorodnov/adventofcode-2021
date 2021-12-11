defmodule AdventOfCode do
  def prepare_board(board) do
    Enum.reduce(0..4, [], fn pos, acc -> \
      Stream.concat(acc, [Enum.map(board, &(Enum.at(&1, pos)))])
    end)
    |> Stream.concat(board)
    |> Enum.map(&({&1, 0}))
  end

  def solve1(numbers, boards) do
    Enum.reduce_while(numbers, boards, fn number, state -> \
      state = draw(state, number)
      bingo = Enum.filter(state, &(!Enum.empty?(Enum.filter(&1, fn {_, cnt} -> cnt === 5 end))))
      if Enum.empty?(bingo), do: {:cont, state}, else: {:halt, {hd(bingo), number}}
    end)
    |> calc()
  end

  def solve2(numbers, boards) do
    Enum.reduce(numbers, {boards, nil}, fn number, {state, winner} -> \
      state = draw(state, number)
      bingo = Enum.filter(state, &(!Enum.empty?(Enum.filter(&1, fn {_, cnt} -> cnt === 5 end))))
      if Enum.empty?(bingo) do
        {state, winner}
      else
        {Enum.reject(state, &(Enum.member?(bingo, &1))), {List.last(bingo), number}}
      end
    end)
    |> then(&(calc(elem(&1, 1))))
  end

  defp draw(boards, number) do
    Enum.map(boards, &draw_board(&1, number))
  end

  defp draw_board(board, number) do
    Enum.map(board, &(mark_line(&1, number)))
  end

  defp mark_line({numbers, cnt}, number) do
    Enum.map_reduce(numbers, cnt, fn x, acc -> \
      if(x === number, do: {0, acc + 1}, else: {x, acc})
    end)
  end

  defp calc({board, number}) do
    div(sum(board), 2) * String.to_integer(number)
  end

  defp sum(board) do
    board
    |> Stream.map(&elem(&1, 0))
    |> Stream.concat()
    |> Stream.map(&(if is_binary(&1), do: String.to_integer(&1), else: &1))
    |> Enum.sum()
  end
end

numbers =
  File.read!("#{__DIR__}/in.txt")
  |> String.split(~r{[,\n]}, trim: true)

boards =
  File.stream!("#{__DIR__}/boards.txt")
  |> Stream.map(&String.split/1)
  |> Stream.reject(&Enum.empty?/1)
  |> Stream.chunk_every(5, 5, :discard)
  |> Enum.map(&AdventOfCode.prepare_board/1)

IO.inspect(AdventOfCode.solve1(numbers, boards))
IO.inspect(AdventOfCode.solve2(numbers, boards))
