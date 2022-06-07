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
* 
* [DragonRuby Docs: Rendering Outputs](http://docs.dragonruby.org/#---args-outputs-)
* [DragonRuby Docs: Rendering a solid using an Array](http://docs.dragonruby.org/#---rendering-a-solid-using-an-array)

## The Tile Map
Instead of working in 1 pixel increments, and having to keep track of nearly a million points, we'll create a play field of 128x72 tiles.

## Obstacles
Now that we have our play field, let's put some walls on it to give our player something to dodge.
