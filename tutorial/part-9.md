# Part 9 - Publishing
Dragon Ruby makes it extremely easy to release your game for a variety of platforms.  The dragonruby-publish executable can build binaries for Web, Windows, Linux, Raspberry Pi, Android, and Ios if everything is set up properly.

## Your Game's Metadata
Up to now we've done all our work in the `mygame/app/main.rb` file.  Now we'll work with one of the other files that DragonRuby uses, it can be found in `mygame\metadata\game_metadata.txt`

The default metadata file looks like
```
#devid=myname
#devtitle=My Name
#gameid=mygame
#gametitle=My Game
#version=0.1
#icon=metadata/icon.png

# Uncomment the entry below to bytecode compile your Ruby code (Pro License Only)
#compile_ruby=false

# Uncomment the entry below to specify the package name for your APK (Pro License Only)
#packageid=org.dev.gamename
```

The key components are:
* `devid`  This is your username on itch.io.  If you don't yet have an itch.io account, we'll set one up in the next section.
* `devtitle` The name or company to list as your game's author.  This can contain spaces if needed.
* `gameid`  This needs to match the ProjectURL for the itch.io page where you'll host the game
* `gametitle` The title of your game.  This will also change what appears in the titlebar of the window when your game is running.
* `version` The current version of your game.
* `icon` The path to the image to use for the game's icon.

An example metadata file:
```ruby
devid=kehvarl
devtitle=Kehvarl
gameid=DRSnakeTutorial
gametitle=Dragon Ruby Snake Tutorial
version=0.1
#icon=metadata/icon.png
```



References:
[Deploying to Itch.io](http://docs.dragonruby.org/#--deploying-to-itch-io)