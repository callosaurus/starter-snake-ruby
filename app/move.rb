# This function is called on every turn of a game. It's how your Battlesnake decides where to move.
# Valid moves are "up", "down", "left", or "right".

# https://docs.battlesnake.com/references/api#example-move-request

def move(request)
  snakes = request.dig(:board, :snakes)
  my_snake = request[:you]

  board_width = request.dig(:board, :width)
  board_height = request.dig(:board, :height)

  my_snake_x = my_snake.dig(:head, :x)
  my_snake_y = my_snake.dig(:head, :y)
  excluded_moves = []
  case my_snake_x
  when 0
    excluded_moves.push("left")
  when board_width - 1
    excluded_moves.push("right")
  end

  case my_snake_y
  when 0
    excluded_moves.push("down")
  when board_height - 1
    excluded_moves.push("up")
  end

  # look at state of board
  # see where "you" is
  # avoid walls
  # avoid other snakes
  # avoid rest of your body

  # see where food is
  # see if health is low
  # plan path to nearest food
  # TODO: anticipate other snakes moving to food

  # try and 'trap' other snakes?

  # Choose a random direction to move in
  possible_moves = ["up", "down", "left", "right"]
  possible_moves = possible_moves - excluded_moves
  move = possible_moves.sample

  puts "MOVE: " + move
  { "move": move }
end
