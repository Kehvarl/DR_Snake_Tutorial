# Part 4 - Collisions

## Detecting collisions
```ruby
  update_snake args
  args.state.walls.each do |w|
    if w.x/10 == args.state.snake.x &&
       w.y/10 == args.state.snake.y
      puts "Collided with wall!"
    end
  end
```

## Responding to collisions 