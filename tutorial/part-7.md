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