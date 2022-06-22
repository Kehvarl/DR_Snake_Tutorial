def make_walls
  walls = []
  (0..127).each do |x|
    walls << {x: x*10, y:0, w:10, h:10, r:255, g:0, b:0}
    walls << {x: x*10, y:710, w:10, h:10, r:255, g:0, b:0}
  end

  (0..71).each do |y|
    walls << {x: 0, y:y*10, w:10, h:10, r:255, g:0, b:0}
    walls << {x: 1270, y:y*10, w:10, h:10, r:255, g:0, b:0}
  end

  return walls
end

def tick args
  args.state.update ||=1
  args.state.walls ||= make_walls
  args.state.snake.x ||= 64
  args.state.snake.y ||= 36
  args.state.snake.vx ||= 1
  args.state.snake.vy ||= 0

  args.state.update -= 1
  if args.state.update <= 0
    args.state.snake.x += args.state.snake.vx
    args.state.snake.y += args.state.snake.vy
    if args.state.snake.x > 128 || args.state.snake.x < 0
      args.state.snake.vx = -args.state.snake.vx
    end
    args.state.update = 3
  end

  args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]

  args.outputs.solids  << {x: args.state.snake.x*10, y:args.state.snake.y*10, w:10, h:10, r:0, g:128, b:0}

  args.outputs.solids << args.state.walls
end