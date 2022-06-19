# Part 2 - Drawing The Snake

## A Single Box
Let's start by just drawing a single box to represent our snake.  We can figure out how to deal with a long snake later.

We already know how to display a box on the screen, so leveraging that knowledge, we get:
```ruby
def tick args
  args.state.walls ||= make_walls

  args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]
  
  args.outputs.solids  << {x: 640, y:360, w:10, h:10, r:0, g:128, b:0}
  
  args.outputs.solids << args.state.walls
end
```
Now we have our 1-block snake on the screen!
![That first bit of snake](../tutorial/DRGTK_snake_1.png?raw=true "Snake Head")

Of course, this is silly...  Let's get some coordinates for that snake and do things properly:

```ruby
def tick args
  args.state.walls ||= make_walls
  args.state.snake.x ||= 64
  args.state.snake.y ||= 36

  args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]

  args.outputs.solids  << {x: args.state.snake.x*10, y:args.state.snake.y*10, w:10, h:10, r:0, g:128, b:0}

  args.outputs.solids << args.state.walls
end
```

There, now we can do some interesting things with our snake

## Moving in a Straight Line
Let's make our snake move!  We can just update the X coordinate every frame, like so:
```ruby
def tick args
  args.state.walls ||= make_walls
  args.state.snake.x ||= 64
  args.state.snake.y ||= 36

  args.state.snake.x += 1

  args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]

  args.outputs.solids  << {x: args.state.snake.x*10, y:args.state.snake.y*10, w:10, h:10, r:0, g:128, b:0}

  args.outputs.solids << args.state.walls
end
```

Of course, now our snake runs off screen and vanishes.  Let's fix that by making the screen wrap around (and pretend we can walk through walls at the moment)
```ruby
args.state.snake.x += 1
if args.state.snake.x > 128
args.state.snake.x = 0
end
```

## Velocity


## Movement Speed