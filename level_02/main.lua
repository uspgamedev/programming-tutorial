
local WIDTH, HEIGHT = 20, 15

local TILE_SIZE = 32

local TILES = {
  {115, 170, 114}, --grass
  {114, 85, 49}, --dirt
  {107, 110, 124} --cobblestone
}

local STATES = {
  PICK_UNIT = 1,
  MOVE_UNIT = 2,
  ATTACK_TARGET = 3
}

local DIRS = {
  right = {0, 1},
  left = {0, -1},
  up = {-1, 0},
  down = {1, 0},
}

local MAP_BASE = {
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 1, 1, 1, 2, 2, 1, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
}

local PLAYER_UNIT_POSITIONS = {
  {3, 7},
  {11, 8},
  {5, 14}
}

local CPU_UNIT_POSITIONS = {
  {9, 11},
  {12, 3},
  {2, 17}
}

local map
local player_units
local cpu_units
local state
local cursor

local function makeUnit (side)
  return { hp = 100, atk = 20, side = side }
end

function love.load ()
  map = {}
  for i=1,HEIGHT do
    map[i] = {}
    for j=1,WIDTH do
      map[i][j] = { bg = MAP_BASE[i][j], fg = false }
    end
  end
  player_units = {}
  cpu_units = {}
  for i,pos in ipairs(PLAYER_UNIT_POSITIONS) do
    player_units[i] = makeUnit('player')
    map[pos[1]][pos[2]].fg = player_units[i]
  end
  for i,pos in ipairs(CPU_UNIT_POSITIONS) do
    cpu_units[i] = makeUnit('cpu')
    map[pos[1]][pos[2]].fg = cpu_units[i]
  end
  state = STATES.PICK_UNIT
  cursor = {10, 8}
end

function love.keypressed (key)
  if state == STATES.PICK_UNIT then
    local dir = DIRS[key] if dir then
      cursor[1] = cursor[1] + dir[1]
      cursor[2] = cursor[2] + dir[2]
    elseif key == 'return' then
      print('pick unit')
    end
  elseif state == STATE.MOVE_UNIT then
    --
  elseif state == STATE.ATTACK_TARGET then
    --
  end
end

function love.draw ()
  local g = love.graphics
  for i=1,HEIGHT do
    for j=1,WIDTH do
      local tile = map[i][j]
      g.push()
      g.translate((j-1)*TILE_SIZE, (i-1)*TILE_SIZE)
      g.setColor(TILES[tile.bg])
      g.rectangle('fill', 0, 0, TILE_SIZE, TILE_SIZE)
      if tile.fg then
        if tile.fg.side == 'player' then
          g.setColor(0, 0, 255)
        else
          g.setColor(255, 0, 0)
        end
        g.polygon('fill', TILE_SIZE/2, 0, TILE_SIZE, TILE_SIZE, 0, TILE_SIZE)
      end
      g.pop()
    end
  end
  if cursor then
    g.push()
    g.translate(TILE_SIZE*(cursor[2] - 1), TILE_SIZE*(cursor[1] - 1))
    g.setColor(255, 255, 255, 255)
    g.rectangle('line', -1, -1, TILE_SIZE+2, TILE_SIZE+2)
    g.pop()
  end
end
