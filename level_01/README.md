
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
changing features in it. For that you'll have to look through the code and guess
what each of its parts do, then play along. This actually reflects a very real
world situation, since most often than not you'll have to deal with other
people's code. We did try to make these ones well organized and clear for
didatic purposes though. Don't always expect that =).

You should keep the changes you make in the code from one stage to another!

Stage 00
--------

Read chapter *9. Game Loop* from Bob Nystrom's
[Game Programming Patterns](http://gameprogrammingpatterns.com/contents.html)
(its web version is free). This is very important, do not skip! You may notice
that our game loop here is actually not the best approach, but we'll deal with
that soon enough.

The LÖVE framework works by providing two separate tools: a set of callback
routines and a vast set of specialized tools. The callbacks are routines **you**
must define **with a specific name convention**. The framework will locate this
routines and execute then when the time is right. For instance, the
`love.load()` callback is executed only once, when the game is started. The
`love.update(dt)` is executed every game frame, and characterizes the Game Loop
in this framework. And `love.draw()` is called when it is time to render the
game's view onto a system window or directly to the screen (in case the game is
fullscreen). There are many others which you'll learn soon enough.

The specialized tools are just a bunch of routines and classes you can use most
of the time to build the behaviours of your game. You'll learn them as we go,
but you shouldn't memorize then. Learn to consult the [LÖVE
wiki](https://love2d.org/wiki/Main_Page) instead!

Stage 01
--------
Now open `main.lua` and give it a superficial look. Try and guess what each part
does. When you are somewhat convinced you know what is going on, or are just
tired of trying, continue from here.

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

Stage 02
--------

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

But let's make this in two steps.

1. Make it so that they just cannot go beyond the borders, by not moving then
   when they would do so. This can be done by rewinding the last movement when
   you hit the border.
2. Then, you also make then change their move direction whenever they seem to
   have "collided" with the screen borders. You can just reflect the x-axis or
   y-axis speed, depending on whether the ball collides with a horizontal or a
   vertical wall.

Go!

Stage 03
--------

All this about moving objects on the screen is to eerie! We need some sound.
Go to [Open Game Art](http://opengameart.org/) and find some nice bouncing or
hitting sound effects in OGG or WAV format. Download them into this lesson's
folder, and rename it to "bounce.ogg" or "bounce.wav", respectively.

Then check out [how to load and play a sound
effect](https://love2d.org/wiki/love.audio.newSource) and make it so that the
sound plays whenever an object hits a wall. You may have to [adjust its
volume](https://love2d.org/wiki/Source:setVolume).

**Hint:** use the `bounce_sfx` variable we provided in the code! Load the source
in `love.load` then call `play` in the rights part of the code. Why do it this
way? To save memory! Think about it as homework, or ask someone =).

You will notice that the sound does not play all the times it should. Some balls
hit the borders but there is no sound playback! This happens because so far we
have only monophonic sound. The simple way to solve this is to [stop the
sound](https://love2d.org/wiki/Source:stop) before playing it every time. This
is not the best approach, but anything better is too complicated for a first
tutorial. You can try it though =).

Stage 04
--------

The next step is to make each bouncing ball have an individual color. It is very
important that each one of them *keeps the same color from the moment it is
created until the end of the game's execution*. Consequently, you will probably
have to change how the balls are created in `newObject()`! Also, check out [how
to draw things with a different
color](https://love2d.org/wiki/love.graphics.setColor).

In case you are wondering about how the circles are drawn, see
[love.graphics.circle](https://love2d.org/wiki/love.graphics.circle).

Stage 05
--------

The last one was rather easy because this one is the hardest challenge in this
tutorial!

Time to make the balls bounce off each other. We will be simulating perfect
elastic collisions with no friction, where all bodies have the exact same mass.
In other words, when two ball collide, their velocity vectors are swapped!

The idea is to check, pair by pair, which balls are colliding and then applying
the collision effects. Do not worry about the amount of computational effort
needed: even without any optimization, it will still be a piece of cake for any
modern computer! As Donald Knuth said, **"premature optimization is the root of
all evil!"**.

Our recommendations for this stage is to check for collisions from within a
separate function, `handleCollisions()`, that should be called every game
update. You should be able to guess how to properly iterate the object list by
looking over the rest of the sample code.

How do you know when two circles are colliding?

There are a few gotchas here:

1. You will soon realize you should not *really* check everything pair by pair.
2. Just swapping the velocity vectors is not always enough! Not if the balls
   are too deep into each other.

Stage 06
--------

But this is not a game yet! And it will not be! We will finish this level by
successfully making a toy, but not a game (challenge: what is the difference?).
However, even a toy needs some form of *interaction*. It's time to grab some
user input!

There are two ways of reading the user input. The easier way is to just ask a
device's state whenever you want. For instance, if you want to know if the
player is holding the left mouse button down, you can do

```lua
if love.mouse.isDown(1)
  -- do stuff
end
```

The task this time is to make all balls attracted to the player's cursor while
the left button is down. You can get its position on screen with
[love.mouse.getPosition()](https://love2d.org/wiki/love.mouse.getPosition).
The atraction force should be inversely proportional to the distance from the
ball to the cursor. Something like:

```lua
local force_dir_x, force_dir_y = mouse_x - object.x, mouse_y - object.y
local distance = math.sqrt(force_dir_x^2 + force_dir_y^2)
local force = 1.0 / distance
object.dir_x = object.dir_x + force*force_dir_x/distance*dt
object.dir_y = object.dir_y + force*force_dir_y/distance*dt
```

Notice that this makes objects' speed vary, which means that the OBJECT_SPEED
variable we defined in Stage 01 is no longer needed. The full velocity vector
of each object will be represented by the (dir_x, dir_y) fields. You may also
need to greatly increase the "force" constant.

Things might get a little crazy, but that is ok. If you want, you can try to
stabilize the game as an extra exercise.

Extra Stage
-----------

For those that like a challenge. Add another input where the player can create
balls and also define a move direction. Start with fewer balls and also make
then vanish after 10 seconds. You can even add a visual feedback to show how
much time they have left!

Fell free to add anything else you want. Experiment away!

