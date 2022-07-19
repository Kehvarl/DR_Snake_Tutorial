# Part 5 - Something To Eat

### Adding collectable items
Let's just create a pickup array, and put one item into it:
First, a function to create an item:
```ruby
def make_pickup
  x = rand(126) + 1
  y = rand(70) + 1
  return [x,y]
end
```
Then we call it and store that item in our various arrays:
```ruby
def initialize args   
  ...
  args.state.pickup_coords ||= [make_pickup]
  ...
  args.state.pickups ||= draw_array(args.state.pickup_coords, {r: 0, g: 0, b: 255})
  ...
end
```

And finally we add that pickup to our rendering:
```ruby
def render args
  args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]

  args.outputs.solids  << {x: args.state.snake.x*10, y:args.state.snake.y*10, w:10, h:10, r:0, g:128, b:0}

  args.outputs.solids << args.state.walls
  args.outputs.solids << args.state.obstacles
  args.outputs.solids << args.state.pickups
end
```

While we're here, let's tweak our collision test slightly:
```ruby
def check_collisions(x,y,walls,obstacles,pickups)
  if walls.include? [x,y]
    :wall
  elsif obstacles.include? [x,y]
    :obstacle
  elsif pickups.include? [x,y]
    :pickup
  else
    false
  end
end
```

And update the place we call it:
```ruby
  hit = check_collisions(args.state.snake.x, args.state.snake.y,
                         args.state.walls_coords,
                         args.state.obstacle_coords,
                         args.state.pickup_coords)
```

Now our snake bounces off pickups as well, but we can also use this to improve our pickup placement:

```ruby
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
                           args.state.pickup_coords)
  end
  return [x,y]
end
```

Now we know that any pickup we generate will be on a nice open space.
