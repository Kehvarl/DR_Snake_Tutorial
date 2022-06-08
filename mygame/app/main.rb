def tick args
  walls = [
    {x: 640, y:360, w:10, h:10, r:255, g:255, b:255},
    {x: 650, y:360, w:10, h:10, r:255, g:0, b:255},
    {x: 660, y:360, w:10, h:10, r:255, g:255, b:0},
    {x: 670, y:360, w:10, h:10, r:0, g:255, b:255}
  ]

  args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]
  walls.each do |w|
    args.outputs.solids << w
  end
end
