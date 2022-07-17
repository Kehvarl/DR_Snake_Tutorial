# Part 5 - Something To Eat

### Adding collectable items
Let's just create a pickup array, and put one item into it:
First, a function to create an item:
```ruby
def make_pickup
  x = rand(126) + 1
  y = rand(70) + 1
  return {x:x, y:y, w:10, h:10, r:0, g:0, b:255}
end
```
Then we call it and store that item in our various arrays:
```ruby
def initialize args   
  ...
  args.state.pickups ||= make_pickup
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

