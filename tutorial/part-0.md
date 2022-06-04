# Part 0 - Setting Up

## Prior Knowledge
This tutorial will attempt to be beginner friendly, but some experience with programming will help.  For the sake of simplicity, I will be using DragonRuby on Windows 10, but DragonRuby Game Toolkit is highly portable and the same instructions should run on multiple operating systems. 

## Project Setup
### Download DragonRuby
You will need a copy of DragonRuby Game Toolkit for th is tutorial.
You can acquire it from either of these sites.  You may even already own a copy if you back lots of bundles on Itch.io. 

* http://dragonruby.org/toolkit/game
* https://dragonruby.itch.io/

### Creating the game
Unzip your new copy of DragonRuby, and name the folder something like `DR_Snake_Tutorial`

### Using DragonRuby Game Toolkit
Open your game folder, and double-click on `dragonruby.exe` to run the game engine.

You will probably receive a Windows Protection popup like this one:
![Windows Protection Dialog](../tutorial/Windows_Protect_1.png?raw=true "Windows Protection Dialog")

Click on the `More Info` link to expand to the following
![Windows Protection More Info](../tutorial/Windows_Protect_2.png?raw=true "Windows Protection More Info")

Verify the app is "dragonruby.exe" and click `Run Anyway` to actually run DR.

You should now have the DragonRuby Hello World Application on your screen
![Dragon Ruby Hello World](../tutorial/DRGTK_Default.png?raw=true "Hello World from DragonRuby Game Toolkit")

Open `DR_Snake_Tutorial/mygame/app/main.rb` in your favorite editor (VSCode, Atom, RubyMine, Notepad), and you will be met with:
```ruby
def tick args
  args.outputs.labels  << [640, 500, 'Hello World!', 5, 1]
  args.outputs.labels  << [640, 460, 'Go to docs/docs.html and read it!', 5, 1]
  args.outputs.labels  << [640, 420, 'Join the Discord! http://discord.dragonruby.org', 5, 1]
  args.outputs.sprites << [576, 280, 128, 101, 'dragonruby.png']
end
```

A quick breakdown:
* `def tick args`  -  Create a function named `tick` that accepts a parameter named `args`
  * `tick` is a special function.  DragonRuby will call it 60 times per second, and expects it to perform any needed calculations and draw the screen.
  * `args` is DragonRuby's special power, it holds information about inputs, and is where you set up your actual screen draws
* `args.outputs.labels  << [640, 500, 'Hello World!', 5, 1]`
  * The `args` variable has an `outputs` collection which accepts a number of different types of thing to draw.
  * In this case we're drawing a `label`, which we can create with an array
    * Label array definition `[ X, Y, Text, Size, Alignment ]`
      * `X`  X position of the bottom-left corner of the label
      * `Y`  Y position of the bottom-left corner of the label
      * `Text` The text to display
      * `Size` The size of the text.  A 0 represents the "default size".  Negative values lead to smaller text, while positive values lead to larger text
      * `Alignment`  0: Left, 1: Center, 2: Right
* `args.outputs.labels  << [640, 460, 'Go to docs/docs.html and read it!', 5, 1]`
* `args.outputs.labels  << [640, 420, 'Join the Discord! http://discord.dragonruby.org', 5, 1]`
* `args.outputs.sprites << [576, 280, 128, 101, 'dragonruby.png']`
  * This example shows a `sprite` output.   Sprites are powerful and let you place images anywhere in your window that you like.
    * A minimal Sprite array defition: `[ X, Y, W, H, Path ]`
      * `X`  X position of the bottom-left corner of the sprite
      * `Y`  Y position of the bottom-left corner of the sprite
      * `W`  The sprite's width
      * `H`  The desired height for the sprite
      * `Path`  The path to the image to display on the sprite.
* `end` - end the function block.
  * If you're used to other languages, you may be looking for a `return`.  In Ruby, a function returns the result of the last statement in the function.

A note on position in DragonRuby.  Unlike some other engines, DragonRuby coordinates start at the bottom left of the screen and proceed to 1280 pixels wide and 720 pixels tall.

References:
* [DragonRuby Docs: How to Render a Label](http://docs.dragonruby.org/#---how-to-render-a-label)
* [DragonRuby Docs: How to Render a Sprite Using an Array](http://docs.dragonruby.org/#---how-to-render-a-sprite-using-an-array)
* [DragonRuby Docs: Coordinate System and Virtual Canvas](http://docs.dragonruby.org/#---coordinate-system-and-virtual-canvas)

### Edit-Test-Loop

