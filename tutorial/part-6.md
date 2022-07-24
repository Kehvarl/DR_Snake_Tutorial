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
