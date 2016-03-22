
-- This is how you use multiple source files. Here we include the module
-- 'button', which provides some simple User Interface button features.
local button = require 'button'
-- And here we include the module 'dialog' for showing the battle log.
local dialog = require 'dialog'

-- Color pallete:
-- https://coolors.co/app/28536b-bfc3ba-1c0f13-6e7e85-b7cece
-- Notice that this is actually a global variable!
COLORS = {
  BACKGROUND = {28, 15, 19},
  HUD = {40, 83, 107},
  TEXT = {191, 195, 186},
  HIGHLIGHT = {110, 126, 133},
  SMILE = {132, 0, 50}
}

-- Screen resolution
local W, H
-- Heads-up Display (HUD) position
local hud_x, hud_y
-- Fighters!
local player, enemy
-- Text font
local font

-- Creates a standard fighter
local function makeFighter (name)
  return {
    name = name,
    -- attributes
    hp = 100,
    power = 10,
    armor = 10,
    -- state
    damage = 0,
    action = 'None',
    -- bonuses
    power_bonus = 0,
    armor_bonus = 0,
    -- reloading
    reloading = false
  }
end

-- Ignore for now
local function wait (time)
  return function (dt)
    time = time - dt
    return time > 0
  end
end

-- IDIOT STALL
function stall (time)
    stall = true
    Time = time
     
end

--[[ Combat functions ]]--

-- How the enemy AI chooses an action.
-- 75% Melee
-- 15% Shield
-- 10% Shoot
local function enemyAI ()
  local rng = love.math.random()
  if rng < 0.75 then
    return 'Melee'
  elseif rng < 0.9 then
    return 'Shield'
  else
    return 'Shoot'
  end
end

-- Combat damage computation
-- Basically, one fighter causes damage proportional to his power minus the
-- target's armor, adding some bonuses. The log show the player what happened.
local function damage (self, other)
  local log = self.name .. " used " .. self.action .. "!\n"
  -- Damage cannot be less than zero
  local damage = math.max(0, (self.power + self.power_bonus) -
                             (other.armor + other.armor_bonus))
  if damage > 0 then
    -- Damage cannot surpass target's total hp
    other.damage = math.min(other.hp, other.damage + damage)
    log = log .. "Caused " .. damage .. " damage\n"
  else
    log = log .. "No damage caused\n"
  end
  return log
end

-- This table contains the routines for each kind of action
local actions = {}

-- 'Melee' action
-- Strong vs. 'Shield'
function actions.Melee (self, other)
  local bonus = 0
  if other.action == 'Shield' then
    bonus = 30
  end
  self.power_bonus, self.armor_bonus = bonus, -10
end

-- 'Shield' action
-- Strong vs. 'Shoot'
function actions.Shield (self, other)
  self.power_bonus, self.armor_bonus = -self.power, 10
end

-- 'Shoot' action
-- Strong vs. 'Melee'
function actions.Shoot (self, other)
  local atk_bonus = 0
  if other.action == 'Melee' then
    atk_bonus = 20
  end
  self.power_bonus, self.armor_bonus = atk_bonus, 0

end

function actions.Reload(self)
  --Do nothing
end

-- Combat routine! Here the blood is shed.
local function combat ()
  if player.reloading == true then
    player.action = "Reload"
    actions[player.action] (player)
  else
    -- Player gets its action from the selected button
    player.action = button.getSelected() 
    -- Compute combat bonuses
    actions[player.action] (player, enemy)
  end

  if enemy.reloading == true then
    enemy.action = "Reload"
    actions[enemy.action] (enemy)
  else
    -- Enemy gets its action from the AI
    enemy.action = enemyAI()
    -- Compute combat bonuses
    actions[enemy.action] (enemy, player)
  end


  -- Compute damage and generate text log
  local text = ""
  
  if player.reloading == true then
    text = text .. player.name .. " is reloading\n"
    player.reloading = false
  else
    text = text .. damage(player, enemy, text)
  end

  if enemy.reloading == true then
    text = text .. enemy.name .. " is reloading\n"
    enemy.reloading = false
  else
    text = text .. damage(enemy, player, text)
  end


  if enemy.action == "Shoot" then
    enemy.reloading = true
  end

  if player.action == "Shoot" then
    player.reloading = true
  end

  -- Update the battle dialog
  dialog.setText(text)

  if player.reloading == true then

    stall(40)

  end

end

--[[ Main game functions ]]--

function love.load ()
  W, H = love.graphics.getDimensions()
  hud_x, hud_y = 0, 3*H/4
  -- This loads a custom font!
  font = love.graphics.newFont('fonts/SourceCodePro-Regular.ttf', 16)
  -- Change backgound color
  love.graphics.setBackgroundColor(COLORS.BACKGROUND)
  -- Create fighters
  player = makeFighter 'Player'
  enemy = makeFighter 'EvilSmile'
  -- Create buttons
  button.new('Melee')
  button.new('Shield')
  button.new('Shoot')
  -- Set initial dialog text
  dialog.setText("Choose action")

  stall = false
  Time = 0
end

-- Handle keyboard input
function love.keypressed (key)
  -- ESC exits the game
  if key == 'escape' then
    love.event.push 'quit'
  end
  if not task and player.reloading == false then
    -- Move cursors and select action
    if key == 'up' then
      button.cursorUp()
    elseif key == 'down' then
      button.cursorDown()
    elseif key == 'z' then
      combat()
    end
  end
end

-- For displaying the player's stats
local PLAYER_STATS = [[
LIFE: %d/%d

POWER: %d

ARMOR: %d
]]

-- Quite complex now!
function love.draw ()
  local g = love.graphics
  g.setFont(font)
  do -- Draw HUD
    g.push()
    g.translate(hud_x, hud_y)
    g.setColor(COLORS.HUD)
    g.rectangle('fill', 0, 0, W, H-hud_y)
    do -- Draw player stats
      g.setColor(COLORS.TEXT)
      g.rectangle('line', 10, 10, W/4-20, H-hud_y-20)
      g.printf(PLAYER_STATS:format(player.hp - player.damage,
                                   player.hp,
                                   player.power,
                                   player.armor),
               20, 20, W/4-40, 'left')
    end
    do -- Draw buttons
      g.push()
      g.translate(W/4, 0)
      button.draw(g)
      g.pop()
    end
    do -- Draw dialog
      g.push()
      g.translate(W/2, 0)
      dialog.draw(g)
      g.pop()
    end
    g.pop()
  end
  if enemy.damage < enemy.hp then -- Draw enemy
    g.push()
    g.translate(W/2, H/3)
    g.setColor(COLORS.SMILE)
    g.circle('fill', 0, 0, 50, 24)
    g.setColor(COLORS.BACKGROUND)
    g.polygon('fill', 40, 15, 0, 30, -40, 15)
    g.circle('fill', 25, -20, 10, 8)
    g.circle('fill', -25, -20, 10, 8)
    g.pop()
  end
end

function love.update(dt)
    Time = Time - dt
  if Time < 0 then
    Time = 0
    if stall == true then
      combat()
    end
    stall = false
  end
end

