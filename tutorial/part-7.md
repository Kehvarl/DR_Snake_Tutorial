# Part 7 - Keeping Score


If we're going to track score, we'll need a place to track it.  So we start by creating a variable in our game state in our setup routine; like so:
```ruby
def initialize args
  args.state.score ||= 0
  ...
```

Now we can update it!  For example, every time we grab a pickup let's add 10 points:
```ruby
    if hit == :pickup
      args.state.score += 10
      ...
```

We could even display our score.  Either in a score box at the top of our screen, or as a number that follow the head of our snake around, or a myriad other solutions depending on our whim.

This line added to our `render` method would work:
```ruby
args.outputs.labels << {x: 0, y: 720, text: args.state.score, r: 255, g: 255, b: 255}
```

Though to properly do things we should make sure our score doesn't impinge on the playfield.

One easy way to do that is to steal a few pixels from the height of things and use those to give us somewhere to draw:
```ruby
def draw_array(arr, color)
  out = []
  arr.each do |e|
    out << {x: e[0]*10, y: e[1]*9, w:10, h:9, **color}
  end
  out
end
```
Here we've modified the `draw_array` routine which calculates almost all of our screen drawing for us.  We're shrinking things vertically, stealing 1 pixel from each block (and adjusting the position of things to make sure we account for that stolen pixel).  This will give us a space 72 pixels tall at the top of the screen in which we can draw scores and a HUD.

Speaking of that "almost all", we do need one more change.  Over in our `render` block, we need to change the head of our snake to match the new coordinate system:
```ruby
args.outputs.solids  << {x: args.state.snake.x*10, y:args.state.snake.y*9, w:10, h:9, r:0, g:255, b:0}
```
Done.

Now let's jazz up that score.  We'll draw a box with the border color we want, and a second one in black.  This is one method to generate a thicker border than a single pixel.
```ruby
args.outputs.solids << {x: 0, y: 649, w: 1280, h: 71, r: 0, g: 255, b: 255}
args.outputs.solids << {x: 10, y: 659, w: 1260, h: 51, r: 0, g: 0, b: 0}
args.outputs.labels << {x: 40, y: 705, size_enum: 12, text: args.state.score, r: 0, g: 255, b: 255}
```


# Previous
* ![Part 6 - A Growing Snake](./tutorial/part-6.md)

# Next
* ![Part 8 - More Mechanics](./tutorial/part-8.md)