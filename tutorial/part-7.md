# Part 7 - Keeping Score

```ruby
def initialize args
  args.state.score ||= 0
  ...
```

```ruby
    if hit == :pickup
      args.state.score += 10
      ...
```