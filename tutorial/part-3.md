# Part 3 - Keyboard Input

## Cleanup
Before we dive into adding functionality, let's move some of our code out of `tick`

```ruby
def make_walls
  walls = []
  (0..127).each do |x|
    walls << {x: x*10, y:0, w:10, h:10, r:255, g:0, b:0}
    walls << {x: x*10, y:710, w:10, h:10, r:255, g:0, b:0}
  end

  (0..71).each do |y|
    walls << {x: 0, y:y*10, w:10, h:10, r:255, g:0, b:0}
    walls << {x: 1270, y:y*10, w:10, h:10, r:255, g:0, b:0}
  end

  return walls
end

def initialize args
  args.state.update ||=1
  args.state.walls ||= make_walls
  args.state.snake.x ||= 64
  args.state.snake.y ||= 36
  args.state.snake.vx ||= 1
  args.state.snake.vy ||= 0
end

def update_snake args
  args.state.update -= 1
  if args.state.update <= 0
    args.state.snake.x += args.state.snake.vx
    args.state.snake.y += args.state.snake.vy
    if args.state.snake.x > 128 || args.state.snake.x < 0
      args.state.snake.vx = -args.state.snake.vx
    end
    args.state.update = 3
  end
end

def render args
  args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]

  args.outputs.solids  << {x: args.state.snake.x*10, y:args.state.snake.y*10, w:10, h:10, r:0, g:128, b:0}

  args.outputs.solids << args.state.walls
end

def tick args
  if args.state.tick_count == 1 # We really only care about the ||= lines on the very first frame.
    initialize args
  end

  update_snake args
  render args
end
```

As you can see, we've just moved the various blocks of code out of `tick` into their own functions.  We haven't adjusted how they work in any way.

Now that we can think about our code in smaller pieces, let's make it complicated again!

## KeyDown

```ruby
def tick args
  if args.state.tick_count <= 1
    initialize args
  end

  if args.inputs.keyboard.up
    args.state.snake.vx = 0
    args.state.snake.vy = 1
  elsif args.inputs.keyboard.down
    args.state.snake.vx = 0
    args.state.snake.vy = -1
  elsif args.inputs.keyboard.left
    args.state.snake.vx = -1
    args.state.snake.vy = 0
  elsif args.inputs.keyboard.right
    args.state.snake.vx = 1
    args.state.snake.vy = 0
  end

  update_snake args
  render args
end
```

References
* [DragonRuby Docs: Inputs](http://docs.dragonruby.org/#---args-inputs-)

## KeyUp

## Modifiers

