# Level 02: turn-based combat!

In this level you'll learn:

* A simple turn-based game structure
* How to manage a tile-based game structure
* How to load images
* How to create a simple animation
* How to implement an artificial intelligence (AI)
* How to manage game states

This time we have an actual game! It is a tile-based, turn-based strategy game, much like Fire Emblem and Advance Wars. The tasks will be much harder!

Instructions to play:

Use arrow keys to select a blue unit (these are your units). Press 'enter' to move the selected unit, move it using arrow keys. You should choose it wisely because you can only move one unit per turn. Press 'enter' again to confirm your movement. Now four neighbor tiles will be highlighted in green, if any enemy is located in one of them, you can select it and attack pressing 'enter'. Now, the enemy makes their movement, keep an eye on it.

## Stage 00
Start by trying to get a grip on the code. It is quite bigger than the Level 01's, but still manageable. Try to answer these questions:

* How did we set up the background tiles?
* Which mathematical structure does the map look like?


## Stage 01

Let's code! This first stage will be easy as pie since you already have done something similar in the previous level. The game does not play any sound yet, what about making it feel alive adding sounds to it?

Add sounds for:
* Moving the arrow keys
* Pressing the enter button to select a unit to move
* Pressing the enter button to attack a unit (you should add different attacking sounds to the two different kinds of unit)

## Stage 02

Now we are going to add our customized tiles in order to make our game more “good-looking”. You may notice we are using lists with RGB colors to set up our tiles right now. The way you are going to set up the tiles now is a little bit different, you will have to load an image for each type of tile. Fortunately, LÖVE wiki provides a [good tutorial about tile-based game backgrounds](https://love2d.org/wiki/Tutorial:Tile-based_Scrolling) (always check the documentation).

## Stage 03
What happens if we try to move our unit to a location where there is already another unit occupying it? Well, we know that two units can not be in the same place, so we probably got a problem here. You must do something to avoid the existence of that case.

Let's go further, you might have noticed that every unit can move wherever the player or the Enemy AI wants, that makes the game less tactical and hence less “interesting”. You should set and implement a limit for the number of movements a single unit can do per turn. You should decide this value for the limit taking into consideration this question: “Which value makes the game fun to play?”.

## Stage 04

~~Now that you have implemented a way where the units can not be moved to certain places (everywhere there is another unit) and set a limit for the number of movements one unit can do. Why not adding some obstacles in the game to make it even more tactical? The players will have to think more about the moves and that is something interesting for a strategy game like ours.~~

Our game is not very smooth when it comes to animation. When we move a unit it simply teleports to the position we selected. Your job is implementing a movement animation for the units.

## Stage 05
You probably noticed the AI we created is ~~way too~~ simple. You already know what to do. So, be creative, think about strategies for the AI and think about how you can implement them. You must pay attention to the corner cases where your AI might not work as you expected!

## Stage 06
Create new state buff/heal

## Extra Stage
