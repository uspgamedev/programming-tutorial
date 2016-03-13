
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

Stage 05
--------

Stage 06
--------

Extra Stage
-----------

