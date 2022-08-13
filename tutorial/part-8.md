# [Part 8 - More Mechanics]

Now that we have so many pieces, we need to turn it into a proper game.  This requires a bit of definition: What is a game?
Per Merriam-Webster, one definition of Game is: "a physical or mental competition conducted according to rules with the participants in direct opposition to each other".
Whereas Wikipedia gives us something more helpful with "Key components of games are goals, rules, challenge, and interaction. "

Let's review those:
* Goals - Our game doesn't yet have any goals.  We just grow bigger without end.
* Rule - We have some rules already (how the snake moves, what happens when our snake encounters something), but we may be able to expand here.
* Challenge - How can we control and scale the difficulty of our game?
* Interaction - Our snake already responds to our input, and the game world responds to the snake in various ways.  Can we play with that?

Clearly we need to focus on `Challenge`, and `Goals`.

## Challenge
There are many ways we could adjust the difficulty of our little snake game:
* Make more things dangerous
  * Instead of bouncing off walls, they injure our snake or end the game
  * Obstacles injure our snake, end the game, or reduce score
  * Our snake striking itself causes injury or ends the game
  * Our snake speeds up over time
  * More obstacles appear over time
  * We add an enemy
And with some work we could come up with many more.