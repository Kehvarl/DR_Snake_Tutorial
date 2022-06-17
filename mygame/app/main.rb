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
  args.state.walls ||= make_walls

  args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]

  args.outputs.solids  << {x: 640, y:360, w:10, h:10, r:0, g:128, b:0}

  args.outputs.solids << args.state.walls
end