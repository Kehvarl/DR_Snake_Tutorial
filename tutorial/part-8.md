# [Part 8 - More Mechanics]

## Preliminaries
Before we move on, let's do some code cleanup.   We have a lot going on in our `tick` event, so let's pull some of that out into functions:

We can literally just move the key handling stuff into a function we can call. It won't need any changes
```ruby
def handle_keys(args)
  if args.inputs.keyboard.up
    args.state.snake.vx = 0
    args.state.snake.vy = 1
  elsif args.inputs.keyboard.down
    args.state.snake.vx = 0
    args.state.snake.vy = -1
  elsif args.inputs.keyboard.left
    args.state.snake.vx = -1
    args.state.snake.vy = 0
  elsif args.inputs.keyboard.right
    args.state.snake.vx = 1
    args.state.snake.vy = 0
  end
end
```

And we can do basically the same for the Collision Handling (Pay attention to what we will need to pass in though)
```ruby
def handle_collision (hit, args)
  if hit == :pickup
    args.state.score += 10
    args.state.snake.length += 1
    args.state.pickup_coords.delete([args.state.snake.x, args.state.snake.y])
    args.state.pickup_coords << make_pickup(args)
  elsif hit == :body
    # game over
  else
    # maybe game over?
    args.state.snake.vx = -args.state.snake.vx
    args.state.snake.vy = -args.state.snake.vy
    args.state.snake.x += args.state.snake.vx
    args.state.snake.y += args.state.snake.vy
  end
end
```

With those done, our Tick is much simpler.  An argument could be made that we should move the collision check into our Update function, but for now this flows well enough.
```ruby
def tick args
  if args.state.tick_count <= 1
    initialize args
  end

  handle_keys(args)
  update_snake args
  hit = check_collisions(args.state.snake.x, args.state.snake.y,
                         args.state.walls_coords,
                         args.state.obstacle_coords,
                         args.state.pickup_coords,
                         args.state.snake.body)
  if hit
    handle_collision(hit, args)
  end
  render args
end
```

## Game Mechanics
Now that we have so many pieces, we need to turn it into a proper game.  This requires a bit of definition: What is a game?
Per Merriam-Webster, one definition of Game is: "a physical or mental competition conducted according to rules with the participants in direct opposition to each other".
Whereas Wikipedia gives us something more helpful with "Key components of games are goals, rules, challenge, and interaction. "

Let's review those:
* Goals - Our game doesn't yet have any goals.  We just grow bigger without end.
* Rule - We have some rules already (how the snake moves, what happens when our snake encounters something), but we may be able to expand here.
* Challenge - How can we control and scale the difficulty of our game?
* Interaction - Our snake already responds to our input, and the game world responds to the snake in various ways.  Can we play with that?

Clearly we need to focus on `Challenge`, and `Goals`.

### Challenge
There are many ways we could adjust the difficulty of our little snake game:
* Make more things dangerous
  * Instead of bouncing off walls, they injure our snake or end the game
  * Obstacles injure our snake, end the game, or reduce score
  * Our snake striking itself causes injury or ends the game
* Our snake speeds up over time
* More obstacles appear over time
* We add an enemy
And with some work we could come up with many more.
  

### Goals
Goals are possibly one of the most critical things.  They take our project from being "play" and into being a "game".  Some quick brainstorming on goals could give us this list
* Increase level after a certain number of pickups gathered
* Introduce some combat system
  * Add enemies to be defeated
  * Add boss battles to win levels or the game
* Set a goal for snake length
* Create mazes and make solving them the goal
* Spawn a number of special pickups, collecting them all leads to victory
* Add a timer with the goal of getting as many points as possible before time runs out

Some of these ideas can be mixed together, others change the nature of our game in one way or another.  Our task is to pick one or more goals that will leave us with something that's fun to play.  For the purposes of this tutorial , we'll go with a timer.

#### Game Timer
We'll start by implementing a simple 20 second countdown which we reset every time the snake eats something...

Or rather, we'll start by getting the current time in ms so we can work with that:
```ruby
def time_ms
  (Time.now().to_f * 1000.0).to_i
end
```
Any time we call this function it will grab the current time in milliseconds, allowing us to do some comparisons.

If we add a line to our initialization routine like so:
```ruby
  args.state.countdown = time_ms() + 20000
```
We can store a time 20 seconds in the future in our game state.

To show that time drawing nearer, a quick change to our draw routine:
```ruby
args.outputs.labels << {x: 640, y: 705, size_enum: 12, text: (args.state.countdown - time_ms())/1000, r: 0, g: 255, b: 255}
```

One more quick tweak so we show a somewhat less frantic countdown, we'll format our timer with 1 decimal place.
```ruby
  args.outputs.labels << {x: 640, y: 705, size_enum: 12, text: '%.1f' % ((args.state.countdown - time_ms())/1000), r: 0, g: 255, b: 255}
```

Now that we have our countdown displaying, let's reset it to 20 seconds every time the snake eats something.   We just modify our collision handler, like so:
```ruby
def handle_collision (hit, args)
  if hit == :pickup
    args.state.score += 10
    args.state.snake.length += 1
    args.state.pickup_coords.delete([args.state.snake.x, args.state.snake.y])
    args.state.pickup_coords << make_pickup(args)
    args.state.countdown = time_ms() + 20000
...
```

We also need to check if the value has reached 0.  However, if we do that in our update, then display the timer after the update, we might end up in a case where we show that the player is out of time even though they weren't when we checked.  The smart way to avoid that is to check once, and cache that check.  We'll do that in our tick:
```ruby
def tick args
  if args.state.tick_count <= 1
    initialize args
  end

  args.state.current_timer = (args.state.countdown - time_ms())/1000
...
```

We're storing our value in the game state since we already pass that state around to all the places we need to check it.  Like our draw routine:
```ruby
  args.outputs.labels << {x: 640, y: 705, size_enum: 12, text: '%.1f' % args.state.current_timer, r: 0, g: 255, b: 255}
```

#### Game Over
We have our countdown timer, we have walls, and we have obstacles.  Let's handle what we do if any of these potentially game-ending things come into effect.

We'll start by tracking which state our game is in, from a short list:
* running
  * The game is running and we need to update the screen every frame
* game_over
  * The game is ended and we only need to make sure the game_over message is displayed
* restart
  * We want to start a new game, which means resetting all the variables and entering "running" state

We'll set this up in our `initialize` method:
```ruby
def initialize args
  args.state.state ||= :running
```

Our `tick` method can use the current state to decide what to do.  This means we probably want to move our current `tick` to something like `running_tick`  Like so:
```ruby
def running_tick args
  if args.state.tick_count <= 1
    initialize args
  end

  args.state.current_timer = (args.state.countdown - time_ms())/1000

  handle_keys(args)
  update_snake args
  hit = check_collisions(args.state.snake.x, args.state.snake.y,
                         args.state.walls_coords,
                         args.state.obstacle_coords,
                         args.state.pickup_coords,
                         args.state.snake.body)
  if hit
    handle_collision(hit, args)
  end
  render args
end
```

Then we create a new `tick` that calls out to what it needs to:
```ruby
def tick args
  if args.state.state == :running
    running_tick args
  end
end
```

This would work, but if we ever change our game state, the game will hang and won't respond to any inputs.  Let's add in a `game_over` state handler:

```ruby
def tick args
  if args.state.state == :running
    running_tick args
  elsif args.state.state == :game_over
    game_over_tick args
  end
end
```
Of course, we need that `game_over_tick` as well, so we'll create it:
```ruby

def game_over_tick args
  render args
  args.outputs.solids << {x: 360, y: 310, w: 560, h: 80, r: 255, g: 255, b: 255}
  args.outputs.solids << {x: 370, y: 320, w: 540, h: 60, r: 0, g: 0, b: 0}
  args.outputs.labels << {x: 490, y: 370, size_enum: 12, text: "G A M E  O V E R", r: 255, g: 255, b: 255}
end
```
As you can see, we simply show the game itself and then draw a message over top of it.   Since this method never calls any of our updates, we don't have to worry about stuff moving or our counter appearing to continue. 

#### A Brand New Game
We aren't using our game-over state yet, but before we do let's do something about starting over.  We can make a couple of tweaks to our `game_over_tick` to display another message and watch for a keypress:
```ruby
def game_over_tick args
  render args
  args.outputs.solids << {x: 360, y: 310, w: 560, h: 80, r: 255, g: 255, b: 255}
  args.outputs.solids << {x: 370, y: 320, w: 540, h: 60, r: 0, g: 0, b: 0}
  args.outputs.labels << {x: 490, y: 370, size_enum: 12, text: "G A M E  O V E R", r: 255, g: 255, b: 255}
  args.outputs.labels << {x: 455, y: 300, size_enum: 3, text: "Press Space To Start New Game", r: 255, g: 255, b: 255}
  if args.inputs.keyboard.space
    args.state.state = :restart
  end
end
```

And now a change to our `tick` to handle the :restart state:
```ruby
def tick args
  if args.state.state == :running or args.state.tick_count <= 1
    running_tick args
  elsif args.state.state == :game_over
    game_over_tick args
  elsif args.state.state == :restart
    initialize args
    args.state.state = :running
  end
end
```

#### Ending The Game