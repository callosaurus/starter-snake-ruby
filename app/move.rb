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
  valid_adjacent_squares = adjacent_squares
  puts "first snake body: #{snakes_from_request[0][:body]}"
  snake_bodies = []
  # snakes_from_request.each { |snake| snake_bodies += snake[:body] }
  request.dig(:board, :snakes).each { |snake|
    #if snake_bodies[:id] != request.dig(:you, :id) {
      snake_bodies += snake[:body]
    #}
  }


  # puts "all the snake bodies put together are: #{snake_bodies}"
  # puts "the adjacent squares are #{adjacent_squares}"
  # puts "the up square is #{adjacent_squares[:up_square]}"

  if adjacent_squares.dig(:up_square, :y) > board_height-1 || snake_bodies.include?(adjacent_squares[:up_square])
    possible_moves.delete("up")
    valid_adjacent_squares.delete(:up_square)
    puts "removed possible move UP"
  end

  if adjacent_squares.dig(:down_square, :y) < 0 || snake_bodies.include?(adjacent_squares[:down_square])
    possible_moves.delete("down")
    valid_adjacent_squares.delete(:down_square)
    puts "removed possible move DOWN"
  end

  if adjacent_squares.dig(:left_square, :x) < 0 || snake_bodies.include?(adjacent_squares[:left_square])
    possible_moves.delete("left")
    valid_adjacent_squares.delete(:left_square)
    puts "removed possible move LEFT"
  end

  if adjacent_squares.dig(:right_square, :x) > board_width-1 || snake_bodies.include?(adjacent_squares[:right_square])
    possible_moves.delete("right")
    valid_adjacent_squares.delete(:right_square)
    puts "removed possible move RIGHT"
  end

  # TODO: avoid head-to-head-collisions
  # avoid head-to-head-collisions IF SMALLER, else try eat other snake (but not constrict self)
  # unless possible_moves.count == 1
  #   valid_adjacent_squares.each {
  #     |square, coord|
  #     if is_square_threatened?(coord)
  #         valid_adjacent_squares.delete
  #   }

  puts "THE REMAINING POSSIBLE MOVES ARE #{possible_moves}"
  move = possible_moves.sample
  puts "Randomly chose MOVE: " + move

  # look for nearest food
  food_coords = request.dig(:board, :food)

  food_coords_moves_has = {
    # {{"x": 6, "y": 7}: 3}
  }

  closest_food_coord = {}
  closest_food_total_moves = 20

  food_coords.each { |food|
    x_diff = food[:x] - my_snake.dig(:head, :x)
    y_diff = food[:y] - my_snake.dig(:head, :y) # 0
    food_total_moves = x_diff.abs + y_diff.abs
    food_coords_moves_has[food] = food_total_moves

    # TODO: case of tie?
    if closest_food_coord == {}
         closest_food_coord = food
         closest_food_total_moves = food_total_moves
    elsif food_total_moves < closest_food_total_moves
         closest_food_coord = food
         closest_food_total_moves = food_total_moves
    end
  }


  puts "closest_food_coord:" + closest_food_coord.to_s
  puts "closest_food_total_moves:" + closest_food_total_moves.to_s

  x_diff = closest_food_coord[:x] - my_snake.dig(:head, :x)
  y_diff = closest_food_coord[:y] - my_snake.dig(:head, :y)
  puts "x_diff to closest_food_coord:" + x_diff.to_s
  puts "y_diff to closest_food_coord:" + y_diff.to_s

  food_direction_moves = []

  if x_diff > 0
    puts "x_diff > 0, so go RIGHT to nearest food"
    food_direction_moves.push("right")
  elsif x_diff < 0
    puts "x_diff < 0, so go LEFT to nearest food"
    food_direction_moves.push("left")
  end

  if y_diff > 0
    puts "y_diff > 0, so go UP to nearest food"
    food_direction_moves.push("up")
  elsif y_diff < 0
    puts "y_diff < 0, so go DOWN to nearest food"
    food_direction_moves.push("down")
  end
  puts "food_direction_moves: #{food_direction_moves}"

  possible_moves = food_direction_moves & possible_moves
  puts "after intersection, possible_moves: #{possible_moves}"

  if possible_moves.count > 0
    move = possible_moves.sample
  # else
  #   move = possible_moves[0]
  end

  puts "Randomly chose MOVE: " + move

  # TODO: anticipate other snakes moving to food, try and 'cut off access'

  # TODO: don't box self in

  # TODO: try and 'trap' other snakes?
  
  # TODO: more cautious play if more snakes? i.e. 1v1 easier than 1v1v1, easier than 1v1v1v1

  { "move": move }
end

def is_square_threatened?(square)
  snake_heads = []
  # snakes_from_request.each { |snake| snake_bodies += snake[:body] }
  request.dig(:board, :snakes).each { |snake|
      snake_heads += snake[:head]
  }

  adjacent_squares = get_adjacent_squares(square)
  adjacent_squares.each {
    |square, coord|
    if snake_heads.include?(coord)
      return true
    end
  }
  return false
end
