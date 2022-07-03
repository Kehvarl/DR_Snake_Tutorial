def make_wall_coords
  wall_coords = []
  (0..127).each do |x|
    wall_coords << [x,0]
    wall_coords << [x,71]
  end

  (0..71).each do |y|
    wall_coords << [0,y]
    wall_coords << [127,y]
  end

  wall_coords
end

def make_obstacles
  obstacles = []
  (32..96). each do |x|
    obstacles << [x,24]
  end
  obstacles
end

def draw_array (arr, color)
  out = []
  arr.each do |e|
    out << {x: e[0]*10, y: e[1]*10, w:10, h:10, **color}
  end
  out
end

def initialize args
  args.state.update ||=1
  args.state.walls_coords ||= make_wall_coords
  args.state.obstacle_coords ||= make_obstacles
  args.state.walls ||= draw_array(args.state.walls_coords, {r:255, g:0, b:0})
  args.state.obstacles ||= draw_array(args.state.obstacle_coords, {r: 128, g: 0, b: 128})
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

    args.state.update = 3
  end
end

def render args
  args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]

  args.outputs.solids  << {x: args.state.snake.x*10, y:args.state.snake.y*10, w:10, h:10, r:0, g:128, b:0}

  args.outputs.solids << args.state.walls
  args.outputs.solids << args.state.obstacles
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
  if args.state.wall_coords.include? [args.state.snake.x, args.state.snake.y]
    args.state.snake.vx = -args.state.snake.vx
    args.state.snake.x += 2*args.state.snake.vx
  end
  render args
end