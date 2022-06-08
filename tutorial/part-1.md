# Part 1 - Drawing The Background

## The Blank Playfield
Before anything else, we will make the background a solid color.  In this case: black.
* Make sure your DragonRuby project is loaded.
* Open your `main.rb` file.
* Delete the contents of the `tick` function
* Add a `solid` output to draw a black box filling the entire screen
  * A minimal Solid array defition: `[ X, Y, W, H, R, G, B ]`
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

** Drawing on our playfield
Before we move into all the layout, let's get some pixels on that playfield to make it look a little nicer.

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
![Dragon Ruby Playfield](../tutorial/DRGTK_Playfield_2.png?raw=true "Some dots")
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
  * `each` can also be represented in muiltiline form (and perform multiple actions) as:
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

## The Tile Map
Instead of working in 1 pixel increments, and having to keep track of nearly a million points, we'll create a play field of 128x72 tiles.

## Obstacles
Now that we have our play field, let's put some walls on it to give our player something to dodge.
