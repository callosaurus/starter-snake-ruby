class Snake
  attr_accessor :id, :name, :health, :body, :head, :length

  def initialize(snake_json)
    @id = snake_json[:id]
    @name = snake_json[:name]
    @health = snake_json[:health]
    @body = snake_json[:body]
    @head = snake_json[:head]
    @length = snake_json[:length]
  end
end
