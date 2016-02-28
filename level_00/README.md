
Level 00: setting up the programming environment
================================================

For the lessons in this tutorial, we'll be using the
[LÖVE framework](https://love2d.org/). Go ahead and download version 0.10.1 for
your operational system of choice. On Unix systems (Linux and Mac OS X),
installing the framework will make the command

```bash
$ love <path>
```

Available in the terminal. On Windows systems, you will get an executable
`love.exe`. You can also make it available through the command line if you add
it to the system's PATH. If you don't know what that means, then nevermind =).

This framework works by interpreting a directory as a game project. As long as
there is a `main.lua` in a given directory, say `/home/user/mygame`, running

```bash
$ love /home/user/mygame
```

Will open a new black window where the game will be when we actually add some
code to it. In Windows, you can simply drag and drop the game folder onto the
LÖVE executable, or use the command line too if you altered the PATH.

Here in this lesson's directory we have a minimal `main.lua` and a `conf.lua`
in order for you to test whether you managed to set up LÖVE or not. When you
think it is so, just use the command to run this directory as a LÖVE project
and see what you get. If it works, that's it for Level 00.

o/

