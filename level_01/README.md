
Level 01: game code overview
============================

In this lesson, you'll learn:

* The main structure of a game code, the *Game Loop*
* How to draw things
* How to play sounds
* How to make stuff actually do something
* How to grab the player's input
* How to represent game objects
* How to make game objects interact

Much of this you'll figure out by trying to understand the initial code that
comes with this lesson. All lessons will use the same format: an unifinished
mini-game will be provided, and you'll be tasked with adding, removing or
changing feature in it. For that you'll have to look through the code and guess
what each of its parts do, then play along. This actually reflects a very real
world situation, since most often than not you'll have to deal with other
people's code. We did try to make these ones well organized and clear for
didatic purposes though. Don't always expect that =).

You should keep the changes you make in the code from one task to another!

Task 00
-------

Read chapter *9. Game Loop* from Bob Nystrom's
[Game Programming Patterns](http://gameprogrammingpatterns.com/contents.html)
(its web version is free). This is very important, do not skip! You may notice
that our game loop here is actually not the best approach, but we'll deal with
that soon enough.

Task 01
-------

See how we used a variable `MAX_OBJECTS` in order to keep an information? That
is the smart way of doing things, because if we need to change this value at
some point in the game development, we only need to modify one line of code -
the one where the value is set. Otherwise, we'd have to go through the code
changing every line that had the magic number `32`, and most likely we'd miss a
few or change the wrong ones.

So now we want you to do the same with the speed value of the objects. There are
two `64` in the `moveObject()` function. Make it so it goes into a varible
`OBJECT_SPEED` that is loaded in `love.load()` and then used by `moveObject()`.
You may also experiment with different speed values and see what happens =).

What would you say the objects' speed units are?

Task 02
-------

Now let's do something interesting! You probably have noticed that the objects
quickly march out of the screen and are missing forever. Change it so that they
actually bounce off the screen walls.

In order to do that, you should add a few code lines at the end of the
`moveObject()` function. You will have to use if-statements, something like:

```lua
if object.x < 0 or object.x > W then
  -- do something about it!
end
```

But let's make this in two steps. First, make it so that they just cannot go
beyond the borders, by not moving then when they would do so. Then, you also
make then change their move direction whenever they seem to have "collided"
with the screen borders. Go!

Task 03
-------

All this about moving objects on the screen is to eerie! We need some sound.
Go to [Open Game Art](http://opengameart.org/) and find some nice bouncing or
hitting sound effects in OGG or WAV format. Download then into this lesson's
folder, and rename it to "bounce.ogg" or "bounce.wav", respectively.

Then check out [how to load and play a sound
effect](https://love2d.org/wiki/love.audio.newSource) and make it so that the
sound plays whenever an object hits a wall. You may have to [adjust its
volume](https://love2d.org/wiki/Source:setVolume) or [stop
it](https://love2d.org/wiki/Source:stop) before playing again so that all
bouncings are heard.

Task 04
-------

The next step is to make each bouncing ball have an individual color. It is very
important that each one *keeps the same color from its crreation to the end of
the game's execution*. Consequently, you will probably have to change how the
ball are created in `newObject()`! Also, check out [how to draw things with a
different color](https://love2d.org/wiki/love.graphics.setColor).

In case you are wondering about how the circles are drawn, see
[love.graphics.circle](https://love2d.org/wiki/love.graphics.circle).

Task 05
-------

The last one was rather easy because this one is the first real challenge in
this tutorial!

Time to make the balls bounc off each other. We will be simulating perfect
elastic collisions with no friction, where all bodies have the exact same mass.
In other words, when two ball collide, they velocity vectors are swapped!

The idea is to check, pair by pair, which balls are colliding and then applying
the collision effects. Do not worry about the amount of computational effort
needed: even without any optimization, it will still be a piece of cake for any
modern computer! As Donald Knuth said, **"premature optimization is the root of
all evil!"**.

Ouw recommendations for this task is to check for collisions from within a
separate function, `handleCollisions()`, that should be called every game
update. You should be able to guess how to properly iterate the object list by
looking over the rest of the sample code. There is on gotcha though, but we hope
you will see it coming =).


