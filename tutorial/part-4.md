# Part 4 - Collisions

In a game of snake, collisions are one of the main gameplay elements:  You can collide with a wall and die, or with the body of your own snake, or even an obstacle scattered around the play field.  You could also collide with an objective and eat it to grow ever longer.

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
For example:
```ruby
def make_wall_coords
  wall_coords = []
  (0..127).each do |x|
    wall_coords << [x,0]
    wall_coords << [x,71]
  end

  (0..71).each do |y|
    wall_coords << [0,y]
    wall_coords << [127,y]
  end

  return wall_coords
end

#  ...
def tick args
  args.state.wall_coords ||= make_wall_coords
#         ...  
    args.state.walls.each do |w|
      if args.state.walls_coords.include? [args.state.snake.x, args.state.snake.y]
        puts "Collided with wall!"
      end
    end
end
```

This way we can just use the `Array.include?` method to check for coordinate overlap.

While we're improving things, instead of making an array of wall locations AND generating the walls themselves, let's use that array of coordinates to do our rendering:

```ruby
def draw_array (arr, color)
  out = []
  arr.each do |e|
    out << {x: e[0]*10, y: e[1]*10, w:10, h:10, **color}
  end
  out
end

def initialize args
  args.state.update ||=1
  args.state.walls_coords = make_wall_coords
  args.state.walls = draw_array(args.state.walls_coords, {r:255, g:0, b:0})
  args.state.snake.x ||= 64
  args.state.snake.y ||= 36
  args.state.snake.vx ||= 1
  args.state.snake.vy ||= 0
end
```


This new draw method isn't the most efficient, but it lets us take any array of coordinates and spit out an array of drawable hashes.
There is a new concept here: `**`
* The Splat (`*`) can be used to put the contents of one array into another.  The double-splat, or "splat-splat" (`**`) can be used to insert the contents of a hash into another hash.
* We're using it to pass in the 3-argument hash for color (R, G, and B).  This will let us make items of several colors with just one function.

## Responding to collisions 

```ruby
  if args.state.walls_coords.include? [args.state.snake.x, args.state.snake.y] or
    args.state.obstacle_coords.include? [args.state.snake.x, args.state.snake.y]
    args.state.snake.vx = -args.state.snake.vx
    args.state.snake.x += 2*args.state.snake.vx
    args.state.snake.vy = -args.state.snake.vy
    args.state.snake.y += 2*args.state.snake.vy
  end
```