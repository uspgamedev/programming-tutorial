
-- GAME CONSTANTS

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
  -- Each cell has the tile type id, which are indexes on the TILES table
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
  -- Format: {row, column}
  {3, 7},
  {11, 8},
  {5, 14}
}

local CPU_UNIT_POSITIONS = {
  -- Format: {row, column}
  {9, 11},
  {12, 3},
  {2, 17}
}

-- GLOBAL VARIABLES

-- The battlefield map
local map
-- Array of player units
local player_units
-- Array of CPU units
local cpu_units
-- Current state of the game
local state
-- Control cursor
local cursor
-- Currently selected unit
local selected_unit

-- HELPER FUNCTIONS

local function makeUnit (side, pos, num)
  return {
    hp = 100,
    atk = 20,
    side = side,
    pos = pos,
    num = num,
    alive = true
  }
end

-- GAME LOGIC

function love.load ()
  -- Load map
  map = {}
  for i=1,HEIGHT do
    map[i] = {}
    for j=1,WIDTH do
      map[i][j] = { bg = MAP_BASE[i][j], fg = false }
    end
  end
  -- Load units
  player_units = {}
  cpu_units = {}
  for i,pos in ipairs(PLAYER_UNIT_POSITIONS) do
    player_units[i] = makeUnit('player', pos, i)
    map[pos[1]][pos[2]].fg = player_units[i]
  end
  for i,pos in ipairs(CPU_UNIT_POSITIONS) do
    cpu_units[i] = makeUnit('cpu', pos, i)
    map[pos[1]][pos[2]].fg = cpu_units[i]
  end
  -- Set game state
  state = STATES.PICK_UNIT
  cursor = {10, 8}
  selected_unit = 0
end

local function attack (attacker, defender)

end

local function enemyTurn ()
  -- Do nothing if there is no unit alive
  if not (cpu_units[1].alive or cpu_units[2].alive or cpu_units[3].alive) then
    return
  end
  -- Pick a random unit
  local enemy
  repeat
    enemy = cpu_units[love.math.random(0, 3)]
  until enemy and enemy.alive
  -- Choose a random target tile to move to
  local new_pos = {}
  repeat
    new_pos[1] = love.math.random(HEIGHT)
    new_pos[2] = love.math.random(WIDTH)
  until not map[new_pos[1]][new_pos[2]].fg
  map[enemy.pos[1]][enemy.pos[2]].fg = false
  map[new_pos[1]][new_pos[2]].fg = enemy
  enemy.pos[1] = new_pos[1]
  enemy.pos[2] = new_pos[2]
  --
  local att_pos = {}
  for name,dir in pairs(DIRS) do
    att_pos[1] = enemy.pos[1] + dir[1]
    att_pos[2] = enemy.pos[2] + dir[2]
    if att_pos[1] <= HEIGHT and att_pos[1] >= 1 then
      if att_pos[2] <= WIDTH and att_pos[2] >= 1 then
        local other = map[att_pos[1]][att_pos[2]].fg
        if other and other.side == 'player' then
          other.hp = other.hp - enemy.atk
          print('Enemy unit ' .. enemy.num .. ' done ' .. enemy.atk ..
                ' damage at ally unit ' .. other.num .. '!')
          if other.hp == 0 then
            print('Ally unit ' .. other.num .. ' died!')
            other.alive = false
            map[att_pos[1]][att_pos[2]].fg = false
          end
          break
        end
      end
    end
  end
  if not att then
    print('Enemy unit ' .. enemy.num .. ' done ' .. 0 ..
          ' damage to the air!')
  end
end

function love.keypressed (key)
  -- Store whether the key pressed was a directional key
  local dir = DIRS[key]
  -- Store the unit under the cursor, if any
  local target_unit = map[cursor[1]][cursor[2]].fg
  if state == STATES.PICK_UNIT then
    -- Player moved cursor
    if dir then
      cursor[1] = math.max(1, math.min(cursor[1] + dir[1], HEIGHT))
      cursor[2] = math.max(1, math.min(cursor[2] + dir[2], WIDTH))
    -- Player picked a unit
    elseif key == 'return' and target_unit then
      if target_unit.side == 'player' then
        selected_unit = target_unit
        print('Picked unit ' .. selected_unit.num)
        state = STATES.MOVE_UNIT
      end
    end
  elseif state == STATES.MOVE_UNIT then
    -- Player moved cursor
    if dir then
      cursor[1] = math.max(1, math.min(cursor[1] + dir[1], HEIGHT))
      cursor[2] = math.max(1, math.min(cursor[2] + dir[2], WIDTH))
    -- Player selected a tile to move to
    elseif key == 'return' then
      -- Target tile has a unit on it
      if target_unit then
        error('Oh-oh, try another tile...')
      -- Move unit
      else
        map[selected_unit.pos[1]][selected_unit.pos[2]].fg = false
        map[cursor[1]][cursor[2]].fg = selected_unit
        selected_unit.pos[1] = cursor[1]
        selected_unit.pos[2] = cursor[2]
        state = STATES.ATTACK_TARGET
      end
    end
  elseif state == STATES.ATTACK_TARGET then
    -- Player changed attack direction
    if dir then
      cursor[1] = math.max(1, math.min(selected_unit.pos[1] + dir[1], HEIGHT))
      cursor[2] = math.max(1, math.min(selected_unit.pos[2] + dir[2], WIDTH))
    -- Attack target chosen
    elseif key == 'return' then
      if target_unit then
        if target_unit.side == 'cpu' then
          target_unit.hp = target_unit.hp - selected_unit.atk
          print('Ally unit ' .. selected_unit.num .. ' done ' .. selected_unit.atk ..
                ' damage at enemy unit ' .. target_unit.num .. '!')
          if target_unit.hp <= 0 then
            print('Enemy unit ' .. target_unit.num .. ' died!')
            target_unit.alive = false
            map[cursor[1]][cursor[2]].fg = false
          end
          state = STATES.PICK_UNIT
          enemyTurn()
        else
          print('You can\'t attack your own unit!')
        end
      else
        print('Ally unit ' .. selected_unit.num .. ' done ' .. 0 ..
              ' damage to the air!')
        state = STATES.PICK_UNIT
        enemyTurn()
      end
    end
  end
end

-- GAME RENDERING

function love.draw ()
  local g = love.graphics
  -- Draw map
  for i=1,HEIGHT do
    for j=1,WIDTH do
      local target = map[i][j].fg
      g.push()
      g.translate((j-1)*TILE_SIZE, (i-1)*TILE_SIZE)
      g.setColor(TILES[map[i][j].bg])
      g.rectangle('fill', 0, 0, TILE_SIZE, TILE_SIZE)
      -- Draw units
      if target then
        if target.side == 'player' then
          g.setColor(0, 0, 255)
        else
          g.setColor(255, 0, 0)
        end
        g.polygon('fill', TILE_SIZE/2, 0, TILE_SIZE, TILE_SIZE, 0, TILE_SIZE)
        g.print(target.num, 0, 0)
      end
      g.pop()
    end
  end
  -- Highlight currently selected unit
  if state == STATES.MOVE_UNIT then
    g.push()
    local pos = selected_unit.pos
    g.translate(TILE_SIZE*(pos[2] - 1), TILE_SIZE*(pos[1] - 1))
    g.setColor(0, 255, 0, 255)
    g.rectangle('line', 0, 0, TILE_SIZE, TILE_SIZE)
    g.pop()
  end
  -- Highlight available attack targets
  if state == STATES.ATTACK_TARGET then
    g.push()
    local pos = selected_unit.pos
    g.translate(TILE_SIZE*(pos[2] - 1), TILE_SIZE*(pos[1] - 1))
    g.setColor(0, 255, 0, 255)
    for name,dir in pairs(DIRS) do
      g.rectangle('line', TILE_SIZE*dir[2], TILE_SIZE*dir[1], TILE_SIZE,
                  TILE_SIZE)
    end
    g.pop()
  end
  -- Draw cursor
  if cursor then
    g.push()
    g.translate(TILE_SIZE*(cursor[2] - 1), TILE_SIZE*(cursor[1] - 1))
    g.setColor(255, 255, 255, 255)
    g.rectangle('line', -1, -1, TILE_SIZE+2, TILE_SIZE+2)
    g.pop()
  end
end
