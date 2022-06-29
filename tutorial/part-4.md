# Part 4 - Collisions

## Detecting collisions
In order to know if we've come into contact with something interesting, we need a way to check for that.
 
One approach might be to loop through all the things we might have touched, and see if our new location overlaps with that object's location, like so:
```ruby
  update_snake args
  args.state.walls.each do |w|
    if w.x/10 == args.state.snake.x &&
       w.y/10 == args.state.snake.y
      puts "Collided with wall!"
    end
  end
```

As you can see, this isn't exactly ideal for a few reasons:
* We are looping through all the possible walls to check for a collision
* We are performing math on the wall position before checking for the interaction. This may not be ideal if there's any chance of a rounding error

To improve our approach, maybe we could revisit how we store walls. Remember: we only draw them once, then basically remember that output, so maybe we could make searching for walls easier.  Additionally, we're going to want to check for more than just walls eventually, so we should make it as easy as possible to expand on our search routine.


## Responding to collisions 