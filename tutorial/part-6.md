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
