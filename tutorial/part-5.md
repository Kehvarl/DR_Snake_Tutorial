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

### Smarter drawing
Since our Pickups array will change often, let's not store the renderable list in our state.  First we'll tweak the render function to always re-render our pickups:
```ruby
def render args
  args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]

  args.outputs.solids  << {x: args.state.snake.x*10, y:args.state.snake.y*10, w:10, h:10, r:0, g:128, b:0}

  args.outputs.solids << args.state.walls
  args.outputs.solids << args.state.obstacles
  args.outputs.solids << draw_array(args.state.pickup_coords, {r: 0, g: 0, b: 255})
end
```

Then we can modify our state to get rid of that extraneous `args.state.pickups` since we no longer use it.

```ruby
def initialize args
  args.state.update ||=1
  args.state.walls_coords ||= make_wall_coords
  args.state.obstacle_coords ||= make_obstacles
  args.state.pickup_coords ||= [make_pickup(args)]
  args.state.walls ||= draw_array(args.state.walls_coords, {r:255, g:0, b:0})
  args.state.obstacles ||= draw_array(args.state.obstacle_coords, {r: 128, g: 0, b: 128})
  args.state.snake.x ||= 64
  args.state.snake.y ||= 36
  args.state.snake.vx ||= 1
  args.state.snake.vy ||= 0
end
```

### Pick Up Lines
Now we have the ability to collide with pickups, and some better drawing routines, let's do something with that collision ability:

```ruby
  if hit
    if hit == :pickup
      args.state.pickup_coords = [make_pickup(args)]
    else
      args.state.snake.vx = -args.state.snake.vx
      args.state.snake.x += 2*args.state.snake.vx
      args.state.snake.vy = -args.state.snake.vy
      args.state.snake.y += 2*args.state.snake.vy
    end
  end
```

If we hit a pickup we just go ahead and make a new one, trusting our render routine to display it for us.

### Smarter pickup responses
What happens if we have 2 pickups on the screen and pick up one of them?   They both vanish!  Let's fix that...
We'll modify our pickup collision routine to delete just the pickup we collided with, and then add a new one, like so:
```ruby
    if hit == :pickup
      args.state.pickup_coords.delete([args.state.snake.x, args.state.snake.y])
      args.state.pickup_coords << make_pickup(args)
    else 
    ...
```

We can demonstrate how this works by initializing 2 pickups instead of one...
```ruby
args.state.pickup_coords ||= [make_pickup(args), make_pickup(args)]
```


# Previous
![Part 4 - Collisions](./tutorial/part-4.md)

# Next
![Part 6 - A Growing Snake](./tutorial/part-6.md)