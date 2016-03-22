
Level 02: turn-based combat!
============================

In this level you'll learn:
* A simple turn-based game structure
* User Interface buttons
* Multiple source files
* Combat mechanics
* Game balance design
* More advanced rendering

This time we have an actual game! It's a turn-based combat game, much like
Final Fantasy or Dragon Quest. The tasks will be much harder!

Use the up and down keys to select an action, and the 'z' key to choose!

Stage 00
--------

Start by trying to get a grip on the code. It is quite bigger than the Level
01's, but still manageable. Try to answer these questions:

* How is everything rendered?
* Where are the combat computations?
* When is the combat triggered?
* What is the best strategy against the Evil Smile?
* How come there is no `love.update(dt)` function!?

Stage 01
--------

Let's code! See how the buttons and the dialog each have a separate source file
to handle their stuff? This is called **encapsulation**. You separate your
programs in modules, and each is responsible for its own things. It makes it
easier to reuse code and to locate errors. For instance, if the buttons are not
being properly drawn, then the error must be in button.lua!

Now encapsulate the combat code into a combat.lua file. Pay attention to which
variables are global (every file can access them) and which are local. You may
need to make a few changes in order to make combat.lua get access to all the
information it needs. However, always avoid making more global variables, since
it reduces encapsulation! Prefer passing parameters for now.

Stage 02
--------

You may have noticed that it is impossible to know how much life the Evil Smile
has left. Make a lifebar.lua module that knows how to draw a fighter's life
bar. Then draw the Evil Smile's life bar above or below it. Also draw one
for the player in addition to the numeric display. Choose wherever you think is
best to place it.

Stage 03
--------

Add sounds for:

* Moving the button cursor
* Selecting an action and fighting

Stage 04
--------

You can notice that the game never ends. Even after the Evil Smile has died
(disappeared), the game still goes on forever! Let's change this.

Create an ending for the program, that happens if the player has reached
0 hp, or if the Evil Smile has been defeated. Make something appear in the dialog
box and stop the player from making any more actions. If you would like, you can
draw something on screen to better illustrate that the battle is over

Stage 05
--------

How about we balance the game? If you haven't noticed by now, the actions aren't
really all that balanced...Make yourself a diagram for every possible combination
of actions and try to figure witch one is the most powerful.

Now, make that, after using this most powerful action, the player that used it
can't use any actions next turn. If you think is necessary, change each action's
power and/or bonus so that the game feels "fair".

Stage 06
--------

ANIMATION TIME!!

The game is too static, lets make things more ~juicy~. In this stage, create an animation
for every action that the Evil Smile receives and does. You can do this hard-coded, or
learn how to use > quads < on love:

https://love2d.org/wiki/Quad

Don't forget to "stop" players actions until all animations have ended (or are skipped if
 you implement that).

Extra Stage
-----------



