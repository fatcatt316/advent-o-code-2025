defmodule SafeCracker do

  # @numbers Enum.to_list(0..99)
  @max_number 100
  @initial_number 50
  @initial_password 0

  def crack(file \\ "test_input.txt") do
    {part1_password, part2_password, _current_number} = File.stream!(file)
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
    |> Enum.reduce({@initial_password, @initial_password, @initial_number}, fn line, {current_part1_password, current_part2_password, current_number} ->
      number_of_clicks = String.slice(line, 1, 3) |> String.to_integer()
      direction = String.at(line, 0)

      # passes in R or L, then the number of clicks, along with current index
      new_number = twist_dial(direction, number_of_clicks, current_number)
      current_part2_password = passed_zero_count(direction, number_of_clicks, current_number) + current_part2_password

      case new_number do
        0 -> {current_part1_password + 1, current_part2_password + 1, new_number}
        _ -> {current_part1_password, current_part2_password, new_number}
      end
    end)

    IO.puts("Part 1 Password: #{part1_password} | Part 2 Password: #{part2_password}")
  end

  # returns the new number after moving the number of clicks
  defp twist_dial("R", number_of_clicks, current_number) do
    current_number + number_of_clicks
    |> Integer.mod(@max_number)
  end
  defp twist_dial("L", number_of_clicks, current_number) do
    current_number - number_of_clicks
    |> Integer.mod(@max_number)
  end

  # checks if zero was passed while rotating the dial
  def passed_zero_count(direction, number_of_clicks, current_number) do
    full_rotation_count = div(number_of_clicks, @max_number)

    remaining_clicks = Integer.mod(number_of_clicks, @max_number)
    case direction do
      "R" ->
        case current_number + remaining_clicks do
          n when n > @max_number -> full_rotation_count + 1
          _ -> full_rotation_count
        end
      "L" ->
        case current_number - remaining_clicks do
          n when n < 0 and current_number != 0 -> full_rotation_count + 1
          _ -> full_rotation_count
        end
    end
  end
end

# SafeCracker.crack("test_input.txt") # should be 3 and 6
SafeCracker.crack("input.txt")
