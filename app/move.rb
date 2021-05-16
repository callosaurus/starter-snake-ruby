# This function is called on every turn of a game. It's how your Battlesnake decides where to move.
# Valid moves are "up", "down", "left", or "right".

# https://docs.battlesnake.com/references/api#example-move-request

require './app/snake.rb'
require './app/get_adjacent_squares.rb'

def move(request)
  possible_moves = ["up", "down", "left", "right"]
  board_width = request.dig(:board, :width)
  board_height = request.dig(:board, :height)

  snakes_from_request = []
  snakes_from_request = request.dig(:board, :snakes).each {
     |snake_json| snakes_from_request.push(Snake.new(snake_json))
   }

  my_snake = request[:you]
  # my_snake = Snake.new(request[:you])

  # avoid walls, self, and other snake body collisions
  adjacent_squares = get_adjacent_squares(request.dig(:you, :head), board_width, board_height)

  puts "first snake body: #{snakes_from_request[0][:body]}"
  snake_bodies = []
  # snakes_from_request.each { |snake| snake_bodies += snake[:body] }
  request.dig(:board, :snakes).each { |snake| snake_bodies += snake[:body] }

  # puts "all the snake bodies put together are: #{snake_bodies}"
  # puts "the adjacent squares are #{adjacent_squares}"
  # puts "the up square is #{adjacent_squares[:up_square]}"

  if adjacent_squares.dig(:up_square, :y) > board_height-1 || snake_bodies.include?(adjacent_squares[:up_square])
    possible_moves.delete("up")
    puts "removed possible move UP"
  end

  if adjacent_squares.dig(:down_square, :y) < 0 || snake_bodies.include?(adjacent_squares[:down_square])
    possible_moves.delete("down")
    puts "removed possible move DOWN"
  end

  if adjacent_squares.dig(:left_square, :x) < 0 || snake_bodies.include?(adjacent_squares[:left_square])
    possible_moves.delete("left")
    puts "removed possible move LEFT"
  end

  if adjacent_squares.dig(:right_square, :x) > board_width-1 || snake_bodies.include?(adjacent_squares[:right_square])
    possible_moves.delete("right")
    puts "removed possible move RIGHT"
  end


  # TODO: avoid head-to-head-collisions
  # TODO: see where food is
  # TODO: plan path to nearest food
  # TODO: anticipate other snakes moving to food
  # TODO: don't box self in
  # TODO: try and 'trap' other snakes?

  puts "THE REMAINING POSSIBLE MOVES ARE #{possible_moves}"
  move = possible_moves.sample

  puts "Randomly chose MOVE: " + move
  { "move": move }
end
