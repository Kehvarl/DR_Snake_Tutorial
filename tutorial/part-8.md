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