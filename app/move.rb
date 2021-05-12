# This function is called on every turn of a game. It's how your Battlesnake decides where to move.
# Valid moves are "up", "down", "left", or "right".

# https://docs.battlesnake.com/references/api#example-move-request

def move(board)
  puts board
  puts board.class

  myHeadX = board.dig(:you, :head, :x)
  puts myHeadX
  myHeadY = board.dig(:you, :head, :y)
  puts myHeadY

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
  move = possible_moves.sample



  puts "MOVE: " + move
  { "move": move }
end
