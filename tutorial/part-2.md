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
Instead of moving our snake to the right and only to the right, let's make that controllable:

```ruby
def tick args
  args.state.walls ||= make_walls
  args.state.snake.x ||= 64
  args.state.snake.y ||= 36
  args.state.snake.vx ||= 1
  args.state.snake.vy ||= 0

  args.state.snake.x += args.state.snake.vx
  if args.state.snake.x > 128
    args.state.snake.x = 0
  end
```

As you can see, we're using `vx` and `vy` to store movement in the X and Y axises.   We need to update our X position as well, so let's make that change now:

```ruby
  args.state.snake.x += args.state.snake.vx
  args.state.snake.y += args.state.snake.vy
  if args.state.snake.x > 128
    args.state.snake.x = 0
  end
```
Just to prove that it works, let's change that wrap-around screen code to make the snake bounce off walls...

```ruby
  if args.state.snake.x > 128 || args.state.snake.x < 0
    args.state.snake.vx = -args.state.snake.vx
  end
```
Now our poor snake is bouncing frantically from side to side...

## Movement Speed

Our snake moves really fast.  It would be nice if we could maybe only move it every few ticks.
To do that, let's introduce a delay and we can play with that delay to adjust the snake speed

```ruby
def tick args
  args.state.update ||=1
  args.state.walls ||= make_walls
  args.state.snake.x ||= 64
  args.state.snake.y ||= 36
  args.state.snake.vx ||= 1
  args.state.snake.vy ||= 0

  args.state.update -= 1
  if args.state.update <= 0
    args.state.snake.x += args.state.snake.vx
    args.state.snake.y += args.state.snake.vy
    if args.state.snake.x > 128 || args.state.snake.x < 0
      args.state.snake.vx = -args.state.snake.vx
    end
    args.state.update = 10
  end

  args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]

  args.outputs.solids  << {x: args.state.snake.x*10, y:args.state.snake.y*10, w:10, h:10, r:0, g:128, b:0}

  args.outputs.solids << args.state.walls
end
```

Now we only move and draw the snake once every 10 frames.  This is clearly too slow, so we can tweak that:
```ruby
args.state.update = 3 # 20 FPS
```

Now we're updatign the snake 20 times per second, and it's much easier to keep track of.  As we move up in level, we could even adjust that by storing our max count in the game state and reducing it as we progress.


# Previous
![Part 2 - Drawing The Snake](./tutorial/part-2.md)

# Next
![Part 3 - Keyboard Input](./tutorial/part-3.md)