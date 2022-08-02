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