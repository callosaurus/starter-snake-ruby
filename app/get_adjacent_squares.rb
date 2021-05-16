
def get_adjacent_squares(coord, board_width, board_height)

  up_square = {:x => coord[:x], :y => coord[:y]+1}
  # puts "up_square is: #{up_square}"
  down_square = {:x => coord[:x], :y => coord[:y]-1}
  # puts "down_square is: #{down_square}"
  left_square = {:x => coord[:x]-1, :y => coord[:y]}
  # puts "left_square is: #{left_square}"
  right_square = {:x => coord[:x]+1, :y => coord[:y]}
  # puts "right_square is: #{right_square}"

  adjacent_squares = {
    :up_square => up_square,
    :down_square => down_square,
    :left_square => left_square,
    :right_square => right_square
  }

  return adjacent_squares
end
