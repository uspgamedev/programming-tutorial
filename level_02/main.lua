
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
local sel_unit

local function makeUnit (side, pos, num)
  return { hp = 100, atk = 20, side = side, pos = pos, num = num, alive = true }
end

local function enemy_turn ()
  local enemy = cpu_units[math.random(0, 3)]
  local new_pos = {}
  if not (cpu_units[1].alive or cpu_units[2].alive or cpu_units[3].alive) then
    return 0
  end
  while not enemy or not enemy.alive do
    enemy = cpu_units[math.random(0, 3)]
  end
  map[enemy.pos[1]][enemy.pos[2]].fg = false
  new_pos[1] = math.random(HEIGHT)
  new_pos[2] = math.random(WIDTH)
  local not_new = map[new_pos[1]][new_pos[2]].fg
  while not_new do
    new_pos[1] = math.random(HEIGHT)
    new_pos[2] = math.random(WIDTH)
    not_new = map[new_pos[1]][new_pos[2]].fg
  end
  map[new_pos[1]][new_pos[2]].fg = enemy
  enemy.pos[1] = new_pos[1]
  enemy.pos[2] = new_pos[2]
  local att = false
  local att_pos = {}
  for name,dir in pairs(DIRS) do
    att_pos[1] = enemy.pos[1] + dir[1]
    att_pos[2] = enemy.pos[2] + dir[2]
    if att_pos[1] <= HEIGHT and att_pos[1] >= 1 then
      if att_pos[2] <= WIDTH and att_pos[2] >= 1 then
        local other = map[att_pos[1]][att_pos[2]].fg
        if not att then
          if other and other.side == 'player' then
            other.hp = other.hp - enemy.atk
            print('Enemy unit ' .. enemy.num .. ' done ' .. enemy.atk ..
                  ' damage at ally unit ' .. other.num .. '!')
            att = true
            if other.hp == 0 then
              print('Ally unit ' .. other.num .. ' died!')
              other.alive = false
              map[att_pos[1]][att_pos[2]].fg = false
            end
          end
        end
      end
    end
  end
  if not att then
    print('Enemy unit ' .. enemy.num .. ' done ' .. 0 ..
          ' damage to the air!')
  end
end

function love.load ()
  map = {}
  sel_unit = 0
  for i=1,HEIGHT do
    map[i] = {}
    for j=1,WIDTH do
      map[i][j] = { bg = MAP_BASE[i][j], fg = false }
    end
  end
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
  state = STATES.PICK_UNIT
  cursor = {10, 8}
end

function love.keypressed (key)
  local dir = DIRS[key]
  local other = map[cursor[1]][cursor[2]].fg
  if state == STATES.PICK_UNIT then
    if dir then
      cursor[1] = cursor[1] + dir[1]
      cursor[2] = cursor[2] + dir[2]
    elseif key == 'return' and other then
      if other.side == 'player' then
        sel_unit = other
        print('Picked unit: ' .. sel_unit.num)
        state = STATES.MOVE_UNIT
      end
    end
  elseif state == STATES.MOVE_UNIT then
    if dir then
      cursor[1] = cursor[1] + dir[1]
      cursor[2] = cursor[2] + dir[2]
    elseif key == 'return' then
      if other then
        print('Oh-oh, try another tile...')
      else
        map[sel_unit.pos[1]][sel_unit.pos[2]].fg = false
        map[cursor[1]][cursor[2]].fg = sel_unit
        sel_unit.pos[1] = cursor[1]
        sel_unit.pos[2] = cursor[2]
        state = STATES.ATTACK_TARGET
      end
    end
  elseif state == STATES.ATTACK_TARGET then
    if dir then
      local next_cur = { sel_unit.pos[1] + dir[1], sel_unit.pos[2] + dir[2] }
      if next_cur[1] <= HEIGHT and next_cur[1] >= 1 then
        if next_cur[2] <= WIDTH and next_cur[2] >= 1 then
          cursor[1] = next_cur[1]
          cursor[2] = next_cur[2]
        end
      end
    elseif key == 'return' then
      if other then
        if other.side == 'cpu' then
          other.hp = other.hp - sel_unit.atk
          print('Ally unit ' .. sel_unit.num .. ' done ' .. sel_unit.atk ..
                ' damage at enemy unit ' .. other.num .. '!')
          if other.hp == 0 then
            print('Enemy unit ' .. other.num .. ' died!')
            other.alive = false
            map[cursor[1]][cursor[2]].fg = false
          end
          state = STATES.PICK_UNIT
          enemy_turn()
        else
          print('You can\'t attack your own unit!')
        end
      else
        print('Ally unit ' .. sel_unit.num .. ' done ' .. 0 ..
              ' damage to the air!')
        state = STATES.PICK_UNIT
        enemy_turn()
      end
    end
  end
end

function love.draw ()
  local g = love.graphics
  for i=1,HEIGHT do
    for j=1,WIDTH do
      local other = map[i][j].fg
      g.push()
      g.translate((j-1)*TILE_SIZE, (i-1)*TILE_SIZE)
      g.setColor(TILES[map[i][j].bg])
      g.rectangle('fill', 0, 0, TILE_SIZE, TILE_SIZE)
      if other then
        if other.side == 'player' then
          g.setColor(0, 0, 255)
        else
          g.setColor(255, 0, 0)
        end
        g.polygon('fill', TILE_SIZE/2, 0, TILE_SIZE, TILE_SIZE, 0, TILE_SIZE)
        g.print(other.num, 0, 0)
      end
      g.pop()
    end
  end
  if state == STATES.MOVE_UNIT then
    g.push()
    local pos = sel_unit.pos
    g.translate(TILE_SIZE*(pos[2] - 1), TILE_SIZE*(pos[1] - 1))
    g.setColor(0, 255, 0, 255)
    g.rectangle('line', 0, 0, TILE_SIZE, TILE_SIZE)
    g.pop()
  end
  if state == STATES.ATTACK_TARGET then
    g.push()
    local pos = sel_unit.pos
    g.translate(TILE_SIZE*(pos[2] - 1), TILE_SIZE*(pos[1] - 1))
    g.setColor(0, 255, 0, 255)
    for name,dir in pairs(DIRS) do
      g.rectangle('line', TILE_SIZE*dir[2], TILE_SIZE*dir[1], TILE_SIZE,
                  TILE_SIZE)
    end
    g.pop()
  end
  if cursor then
    g.push()
    g.translate(TILE_SIZE*(cursor[2] - 1), TILE_SIZE*(cursor[1] - 1))
    g.setColor(255, 255, 255, 255)
    g.rectangle('line', -1, -1, TILE_SIZE+2, TILE_SIZE+2)
    g.pop()
  end
end
