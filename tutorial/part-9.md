# Part 9 - Publishing
Dragon Ruby makes it extremely easy to release your game for a variety of platforms.  The dragonruby-publish executable can build binaries for Web, Windows, Linux, and Raspberry Pi.  If you have a Pro license you can also package your game for Android, or even iOS if you also have a Mac.

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
gameid=dr-snake-tutorial
gametitle=Dragon Ruby Snake Tutorial
version=0.1
#icon=metadata/icon.png
```
You'll notice we've uncommented most of the lines and added values.  You'll want to use your own information instead of the example show above.


References:
[Deploying to Itch.io](http://docs.dragonruby.org/#--deploying-to-itch-io)

## Itch.io
Dragonruby-publish is designed to package up your project for a variety of platforms, then make those packages available through an itch.io project. In order to use this to it's full potential you will first need to create an itch.io account.

Next we will create a project page:
1) Log in to your itch.io account
2) If you're not already looking at your Creator Dashboard, click on the `Dashboard` icon at the top of your page
3) On the bottom of your list of projects click on the `Create new project` button.
4) Provide your project with:
   * `Title`: The title to display on the project page and links.  This is also your `gametitle` in the metadata file.
   * `Project URL`: The path to the project.  This is your `gameid` in your metadata file.
   * `Classification`: This needs to be set to "Game"
   * `Kind of Project`: Set this to "HTML".  That will allow the HTML version of your game to play in the browser, while also providing binary downloads for your other platforms.
5) You can skip the other information for now, but eventually may want to fill them in to improve your project's discoverability.
6) Scroll to the bottom and click "Save & view page". 

![New Project Settings](../tutorial/Itch_New_Project.png?raw=true "Itch New Project Settings")

## Dragon Ruby Publish
Now you'll need to do some work in a command prompt.
* If you're in windows, you browse to the `DR_Snake_Tutorial` folder we created at the beginning of this tutorial.  Then hold the `Shift` button on your keyboard and right-click on the `DR_Snake_Tutorial` folder.   From the menu that pops up select "Open PowerShell Window Here".  This will open a PowerShell command prompt in your game folder so we can run the needed tools. 
* In your powershell window run the command `./dragonruby-publish --only-package mygame`
  * This will tell DragonRuby-Publish to build all the packages for your game, but not try to push them to Itch.io yet.
* All the packages for your game will now be located in a folder named `build`.  You could manually upload these packages to your Itch.io project, however it's also possible to perform an automated upload.
* In your powershell window run the command `./dragonruby-publish mygame`

If you now return to your itch.io page and reload the project you'll see the files present and should even have the option to play your game in thr browser.
In order to make your game public so other people can find it you will want to click the `Edit Game` option at the top of your screen.  On the bottom of your project page, switch the project from "Draft" to "Published" status to make it public.  Then click the red `Save` button

## Moving On
If you've been following along then you have now built a simple snake game, thought about how to improve it, and published it so other people can play it!  The best way to cement this knowledge is to keep doing it:  Add on to your game and publish updates, build a new game and publish it, join a game jam or three.

## One Final Note
The Dragon Ruby Game Tool Kit (DRGTK) community on Discord would love to see your project and progress!  If you're already a member, post your game in the `show-and-tell` channel, and ask questions on how to improve things. 