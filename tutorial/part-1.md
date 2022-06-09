# Part 1 - Drawing The Background

## The Blank Play Field
Before anything else, we will make the background a solid color.  In this case: black.
* Make sure your DragonRuby project is loaded.
* Open your `main.rb` file.
* Delete the contents of the `tick` function
* Add a `solid` output to draw a black box filling the entire screen
  * A minimal Solid array definition: `[ X, Y, W, H, R, G, B ]`
      * `X`  X position of the bottom-left corner of the box
      * `Y`  Y position of the bottom-left corner of the box
      * `W`  Width of the box
      * `H`  Height of the box
      * `R`  Red component of the color to fill the box with (0-255)
      * `G`  Green component of the fill color (0-255)
      * `B`  Blue component of the fill color (0-255)

main.rb
```ruby
def tick args
  args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]
end
```

When you save your file, the DragonRuby project should reload and present you with a black screen.
![Dragon Ruby Black Background](../tutorial/DRGTK_BG_Black.png?raw=true "Black Background")

Experiment with different values for `R`, `G`, and `B` to see how they work

References
* [DragonRuby Docs: Rendering Outputs](http://docs.dragonruby.org/#---args-outputs-)
* [DragonRuby Docs: Rendering a solid using an Array](http://docs.dragonruby.org/#---rendering-a-solid-using-an-array)

** Drawing on our play field
Before we move into all the layout, let's get some pixels on that play field to make it look a little nicer.

main.rb
```ruby
def tick args
  args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]
  args.outputs.solids  << [640, 360, 10, 10, 255, 255, 255]
end
```

Just to prove we can draw on the screen, we've placed a white square in the approximate middle  We could draw lots of those if we wanted, like so:

```ruby
def tick args
  args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]
  args.outputs.solids  << [640, 360, 10, 10, 255, 255, 255]
  args.outputs.solids  << [650, 360, 10, 10, 255, 0, 255]
  args.outputs.solids  << [660, 360, 10, 10, 255, 255, 0]
  args.outputs.solids  << [670, 360, 10, 10, 0, 255, 255]
end
```
![Dragon Ruby Play Field](../tutorial/DRGTK_Playfield_2.png?raw=true "Some dots")
Here we have a series of blocks of slightly different colors.

Drawing all these squares one by one is a bit of a pain, and won't help us animate them.  So let's store what we want to draw in an array, and draw everything in that array

```ruby
def tick args
  walls = [
    {x: 640, y:360, w:10, h:10, r:255, g:255, b:255},
    {x: 650, y:360, w:10, h:10, r:255, g:0, b:255},
    {x: 660, y:360, w:10, h:10, r:255, g:255, b:0},
    {x: 670, y:360, w:10, h:10, r:0, g:255, b:255}
  ]

  args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]
  walls.each do |w|
    args.outputs.solids << w
  end
end
```

We're introducing 2 new concepts here:
* First, we've turned all our Solid arrays into Solid hashes.
  * A hash in Ruby starts with `{` and ends with `}`
  * Between the curly braces are a series of key-value pairs.  Each pair has a key, a colon (`:`), and the value for that key
  * This means each item in the hash can be referenced by it's key, and not just location.
    * eg: `{x:10, y:20}.x` will give you `10`. 
  * A Solid's hash can contain a number of properties, we're providing just the ones we need which are the ones we used for our previous arrays
    * X, Y, W, H, R, G, B
  * An additional advantage to hashes in DragonRuby is that they can be rendered faster than the arrays, which means there's less impact to having lots of them.
* Secondly we're rendering all our Solids using the `each` function.  In Ruby, `each` runs a given function on all the items in an array.  
  * The `each` function syntax is: `<array>.each {|<iterator>| <expression>}` where:
    * `<array>` is the Array containing the items to use
    * `<iterator>` is the variable that will hold each item being passed to the expression
    * `<expression>` is the code to run on each item.
  * `each` can also be represented in multiline form (and perform multiple actions) as:
```ruby
<array>.each do |<iterator>|
  <expression 1>
  <expression 2>
  ...
end
```

In our example, you can see that we loop over our collection of walls, and send each one to `args.outputs.solids`

Try experimenting with adding new tiles to the wall collection.    

References
* [Ruby-Doc: Hash](https://ruby-doc.org/core-3.1.2/Hash.html)
* [DragonRuby Docs: Rendering a solid using a Hash](http://docs.dragonruby.org/#---rendering-a-solid-using-a-hash)
* [Ruby-Doc: Array.each](https://ruby-doc.org/core-2.4.1/Array.html#method-i-each)

## Game State
An array of walls is fine, but the previous example actually recreates the array from scratch every frame.  That's not too helpful, especially if we ever want to make changes to it.

In DragonRuby, we can use the `args.state` collection to hold information we'll need again in another frame, like so:
```ruby
def tick args
  args.state.player.x ||= 0
  args.state.player.y ||= 0
end
```

Here we introduce a new concept: `||=`.   This operator sets a value if and only if that value is not already set.  In our example we created a player.x and player.y and set them both.  However, the next frame those values will already be set, so the commands to set the will be skipped.  This means that if we change `args.state.player.x` or `args.state.player.y` to new values, those new values will be retained for us.


References
* [DragonRuby Docs: Using args.state To Store Your Game State](http://docs.dragonruby.org/#---using--args-state--to-store-your-game-state)

## The Tile Map
Instead of working in 1 pixel increments, and having to keep track of nearly a million points, we'll be treating the screen as a field of 128x72 tiles with each tile being 10x10

There are a number of ways to store our tiles:
### The Grid
* We could use a 2 dimensional array which tracks every possible position on the screen:
```ruby
def tick args
  walls ||= Array.new(72){Array.new(128, [0,0,0])} # default each tile to black
  walls[36][64] = [0,255,0]
  (0..71).each { |y|
    (0..127).each { |x|
      args.outputs.solids << [x * 10, y * 10, 10, 10] + walls[y][x]
    }
  }
end
```

Here we've introduced a lot of new thoughts:
1) `Array.new` This is one way to create an Array in Ruby.  This specific technique allows you to set the size and initial value
   * `Array.new(72)` creates a new array with 72 items (0 to 71) each set to `nil`
   * `Array.new(72, 0)` creates a new array with 72 items each set to 0.
   * `Array.new(72){...}` creates a new array with 72 items each set by the contents of the code between curly brackets `{...}`
2) Multidimensional Arrays, that is: Arrays of Arrays.
   * `Array.new(72){Array.new(128)}` creates an array of arrays, in this case 72 Arrays that can each hold 128 items
   * This format is usually called RC or Row-Column format as you'll access the arrays using the index of the first array (which we've set to the Height of our playfield) then the index of the second array (which is sized to match the width of our playfield)
     * eg: `walls[y][x]` the Xth cell of the Yth array in our main array; or `walls[36][64]` the 64th item in the 36th array in Walls.
3) Ranges:  In Ruby we can represent a range of values with `<start>..<end>`. For example: `0..71` is the range of integers from 0 to 71
4) Adding Arrays:  If you take two arrays in Ruby and use the `+` operator on them, you get an array with all the items from both arrays.
  * `[1,2] + [3,4] -> [1,2,3,4]`

References:
*[Ruby-Doc: Array](https://ruby-doc.org/core-3.1.0/Array.html)
*[Ruby-Doc: Array + Array](https://ruby-doc.org/core-3.1.0/Array.html#method-i-2B)

### A Hash

## Obstacles
Now that we have our play field, let's put some walls on it to give our player something to dodge.
