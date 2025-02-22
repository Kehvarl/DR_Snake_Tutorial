# Part 6 - A Growing Snake
Now we want to make our snake grow!  This will involve some changes to how we update things and how we render the snake.

First we'll add a variable to track our snake length:
```ruby
args.state.snake.length ||= 1
```

We can tweak our pickup code to play with that length, like so:
```ruby
if hit
    if hit == :pickup
      args.state.snake.length += 1
      args.state.pickup_coords.delete([args.state.snake.x, args.state.snake.y])
      args.state.pickup_coords << make_pickup(args)
```

Let's do something with that length.  First, we'll add an array to hold our snakey body...
```ruby
args.state.snake.body ||= [[64,64]]
```

Then a tweak to our rendering to draw that body:
```ruby
def render args
  args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]

  # args.outputs.solids  << {x: args.state.snake.x*10, y:args.state.snake.y*10, w:10, h:10, r:0, g:128, b:0}

  args.outputs.solids << args.state.walls
  args.outputs.solids << args.state.obstacles
  args.outputs.solids << draw_array(args.state.pickup_coords, {r: 0, g: 0, b: 255})
  args.outputs.solids << draw_array(args.state.snake.body, {r: 0, g: 128, b: 0})
end
```

And finally, we need to modify our snake_update routine so that we properly track that body through the screen.

```ruby
  if args.state.update <= 0
    args.state.snake.x += args.state.snake.vx
    args.state.snake.y += args.state.snake.vy
    args.state.snake.body << [args.state.snake.x, args.state.snake.y]
    if args.state.snake.body.length > args.state.snake.length
      args.state.snake.body = args.state.snake.body.drop((args.state.snake.body.length - args.state.snake.length))
    end
    args.state.update = 3
  end
```

Now we can watch our snake grow as we eat things.

### Snake body collision
The way things are currently, the head of the snake is the very last entry in our body array.  This means that our current collitsion-detection routine would think we're always colliding with the body.  We can fix that with a simple change:
```ruby
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
  end
end
```

By moving the head-position update to _after_ we add the previous head position to our body array, the head should never actually be in the body array.  So we can use our existing collision routine:
```ruby
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
```

and update our usage:
```ruby
  hit = check_collisions(args.state.snake.x, args.state.snake.y,
                         args.state.walls_coords,
                         args.state.obstacle_coords,
                         args.state.pickup_coords,
                         args.state.snake.body)
```

Remember to also update the call over in `make_pickup`.

And now we need to adjust our initialization code, since we're checking the snake.body in `make_pickup`, we need it to be initialized before then:

```ruby
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
  args.state.pickup_coords = []
  args.state.pickup_coords ||= [make_pickup(args), make_pickup(args)]
  args.state.walls ||= draw_array(args.state.walls_coords, {r:255, g:0, b:0})
  args.state.obstacles ||= draw_array(args.state.obstacle_coords, {r: 128, g: 0, b: 128})
end
```

Let's add something interesting to our map:  We'll give our snake the ability to move off the screen on one edge and return on the other.  We will first make an updage to our `update_snake` function by adding the following after we update x and y:
```ruby
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
```

A tiny change to our wall drawing and...
```ruby
  (0..127).each do |x|
    if x < 62 or x > 66
      wall_coords << [x,0]
      wall_coords << [x,71]
    end
  end
```

Now we can put gaps in our walls and our snake can pass through them.


# Previous
[Part 5 - Something To Eat](./tutorial/part-5.md)

# Next
![Part 7 - Keeping Score](./tutorial/part-7.md)