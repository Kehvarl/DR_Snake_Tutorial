def make_wall_coords
  wall_coords = []
  (0..127).each do |x|
    if x < 62 or x > 66
      wall_coords << [x,0]
      wall_coords << [x,71]
    end
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

def make_pickup(args)
  x = 0
  y = 0
  hit = true
  while hit
    x = rand(126) + 1
    y = rand(70) + 1
    hit = check_collisions(x, y,
                           args.state.walls_coords,
                           args.state.obstacle_coords,
                           args.state.pickup_coords,
                           args.state.snake.body)
  end
  return [x,y]
end

def draw_array(arr, color)
  out = []
  arr.each do |e|
    out << {x: e[0]*10, y: e[1]*10, w:10, h:10, **color}
  end
  out
end

def initialize args
  args.state.update ||=1
  args.state.snake.length ||= 1
  args.state.snake.body ||= [[64,64]]
  args.state.snake.x ||= 64
  args.state.snake.y ||= 64
  args.state.snake.vx ||= 1
  args.state.snake.vy ||= 0
  args.state.walls_coords ||= make_wall_coords
  args.state.obstacle_coords ||= make_obstacles
  args.state.pickup_coords ||= [make_pickup(args), make_pickup(args)]
  args.state.walls ||= draw_array(args.state.walls_coords, {r:255, g:0, b:0})
  args.state.obstacles ||= draw_array(args.state.obstacle_coords, {r: 128, g: 0, b: 128})
end

def update_snake args
  args.state.update -= 1
  if args.state.update <= 0
    args.state.snake.body << [args.state.snake.x, args.state.snake.y]
    if args.state.snake.body.length > args.state.snake.length
      args.state.snake.body = args.state.snake.body.drop((args.state.snake.body.length - args.state.snake.length))
    end
    args.state.update = 3
    args.state.snake.x += args.state.snake.vx
    args.state.snake.y += args.state.snake.vy
    if args.state.snake.x > 127
      args.state.snake.x = 0
    elsif args.state.snake.x < 0
      args.state.snake.x = 127
    end
    if args.state.snake.y > 71
      args.state.snake.y = 0
    elsif args.state.snake.y < 0
      args.state.snake.y = 71
    end
  end
end

def check_collisions(x,y,walls,obstacles,pickups,body)
  if walls.include? [x,y]
    :wall
  elsif obstacles.include? [x,y]
    :obstacle
  elsif pickups.include? [x,y]
    :pickup
  elsif body.include? [x,y]
    :body
  else
    false
  end
end

def render args
  args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]
  args.outputs.solids << args.state.walls
  args.outputs.solids << args.state.obstacles
  args.outputs.solids << draw_array(args.state.pickup_coords, {r: 0, g: 0, b: 255})
  args.outputs.solids << draw_array(args.state.snake.body, {r: 0, g: 128, b: 0})
  args.outputs.solids  << {x: args.state.snake.x*10, y:args.state.snake.y*10, w:10, h:10, r:0, g:255, b:0}
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
  hit = check_collisions(args.state.snake.x, args.state.snake.y,
                         args.state.walls_coords,
                         args.state.obstacle_coords,
                         args.state.pickup_coords,
                         args.state.snake.body)
  if hit
    if hit == :pickup
      args.state.snake.length += 1
      args.state.pickup_coords.delete([args.state.snake.x, args.state.snake.y])
      args.state.pickup_coords << make_pickup(args)
    elsif hit == :body
      # game over
    else
      # maybe game over?
      args.state.snake.vx = -args.state.snake.vx
      args.state.snake.vy = -args.state.snake.vy
      args.state.snake.x += args.state.snake.vx
      args.state.snake.y += args.state.snake.vy
    end
  end
  render args
end
