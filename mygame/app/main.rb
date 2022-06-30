def make_walls
  walls = []
  wall_coords = []
  (0..127).each do |x|
    walls << {x: x*10, y:0, w:10, h:10, r:255, g:0, b:0}
    walls << {x: x*10, y:710, w:10, h:10, r:255, g:0, b:0}
    wall_coords << [x,0]
    wall_coords << [x,71]
  end

  (0..71).each do |y|
    walls << {x: 0, y:y*10, w:10, h:10, r:255, g:0, b:0}
    walls << {x: 1270, y:y*10, w:10, h:10, r:255, g:0, b:0}
    wall_coords << [0,y]
    wall_coords << [127,y]
  end

  return [walls, wall_coords]
end

def initialize args
  args.state.update ||=1
  walls ||= make_walls
  args.state.walls = walls[0]
  args.state.walls_coords = walls[1]
  args.state.snake.x ||= 64
  args.state.snake.y ||= 36
  args.state.snake.vx ||= 1
  args.state.snake.vy ||= 0
end

def update_snake args
  args.state.update -= 1
  if args.state.update <= 0
    args.state.snake.x += args.state.snake.vx
    args.state.snake.y += args.state.snake.vy
    if args.state.snake.x > 128 || args.state.snake.x < 0
      args.state.snake.vx = -args.state.snake.vx
    end
    args.state.update = 3
  end
end

def render args
  args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]

  args.outputs.solids  << {x: args.state.snake.x*10, y:args.state.snake.y*10, w:10, h:10, r:0, g:128, b:0}

  args.outputs.solids << args.state.walls
end

def tick args
  if args.state.tick_count <= 1
    initialize args
  end

  if args.inputs.keyboard.up
    args.state.snake.vx = 0
    args.state.snake.vy = 1
  elsif args.inputs.keyboard.down
    args.state.snake.vx = 0
    args.state.snake.vy = -1
  elsif args.inputs.keyboard.left
    args.state.snake.vx = -1
    args.state.snake.vy = 0
  elsif args.inputs.keyboard.right
    args.state.snake.vx = 1
    args.state.snake.vy = 0
  end

  update_snake args
  args.state.walls.each do |w|
    if args.state.wall_coords.include? [args.state.snake.x, args.state.snake.y]
      puts "Collided with wall!"
    end
  end
  render args
end