math.randomseed(os.time())


--!-- -------------------- навпростець

local setColor   = love.graphics.setColor
local rectangle  = love.graphics.rectangle
local circle     = love.graphics.circle
local gprint     = love.graphics.print


--!-- -------------------- про карту

local tWidth, tHeight = 64,48
local tRadius = math.min(tWidth,tHeight) * .5
local uRadius = math.floor(tRadius * .9)
local pRadius = 3

local mWidth, mHeight
local cellGrid = {}  ---@type table<string, cell_ent>

local unitList = {}  ---@type unit_ent[]

local selCell ---@type cell_ent?
local selUnit ---@type unit_ent?


--!-- -------------------- енумерашки

---@alias tile_name
---| "plain"
---| "water"

---@alias movement_name
---| "walk"

local tile_color = {
  plain = { .1, .25, .15 },
  water = { .1, .15, .25 },
}
local team_color = {
  { .2, .8, .2 },
  { .8, .2, .2 },
}
local white_color = {1, 1, 1}



--!-- -------------------- інструментарій

local function toKey(x,y)
  return ("x%sy%s"):format(x,y)
end
local function toGrid(x,y)
  return math.floor(x / tWidth + 1), math.floor(y / tHeight + 1)
end
local function toScreen(gx,gy)
  return (gx - 1) * tWidth, (gy - 1) * tHeight
end

local function addCoords(obj, x,y)
  obj.x, obj.y = obj.x + x, obj.y + y
end
local function setCoords(obj, x,y)
  obj.x, obj.y = x,y
end
local function getCoords(obj)
  return obj.x, obj.y
end
local function getCrds(obj, x,y)
  return obj.x - (x or 0), obj.y - (y or 0)
end
local function getCrdsOff(obj, x,y)
  return obj.x - x, obj.y - y
end

local function getCell(gx,gy)
  local key = toKey(gx,gy)
  return cellGrid[key]
end

local function clear(t)
  for k in pairs(t)
  do t[k] = nil end
end



--!-- -------------------- 

local core = {}

--!-- 

local function forPairs(t, fn, ...)
  for k, v in pairs(t)
  do fn(v, ...) end
end
local function forPairsK(t, fn, ...)
  for k in pairs(t)
  do fn(k, ...) end
end
local function forPairsKV(t, fn, ...)
  for k, v in pairs(t)
  do fn(k, v, ...) end
end

---comment
---@param cell cell_ent
---@param unit unit_ent
local function addUnitPathpoint(cell, unit)
  local key = cell.key
  local pp = core:newPathpoint(cell)
  unit.pp_grid[key] = pp
end

---comment
---@param cell cell_ent
local function drawCell(cell, w,h)
  assert(cell, ("drawCell(%s)"):format(cell))
  local x,y = cell.x, cell.y

  setColor(tile_color[cell.tile])
  rectangle("fill", x,y, w,h)
end
---comment
---@param unit unit_ent
local function drawUnit(unit)
  setColor(team_color[unit.team])
  local x,y = getCoords(unit.screen)
  circle("fill", x,y, uRadius)
end
---comment
---@param pathpoint pathpoint_cpt
local function drawUnitMovGrid(pathpoint)
  print("!")
  setColor(white_color)
  local x,y = pathpoint.cell.hx, pathpoint.cell.hy
  circle("fill", x,y, pRadius)
end
---comment
---@param key string
---@param pathpoint pathpoint_cpt
---@param unit unit_ent
local function setUnitMovetoGrid(key, pathpoint, unit)
  if unit.mov >= pathpoint.val
  then unit.mov_grid[key] = pathpoint end
end
---comment
---@param unit unit_ent
local function setUnitPathpoinGrid(unit)
  local pp_grid = unit.pp_grid
  local check_list = {unit.cell}
  local from_pp, from_cell, into_pp, into_val
  local i = 1

  while check_list[i] do
    from_cell = check_list[i]
    from_pp = core:getPathpoint(unit, from_cell)
    for index, into_cell in ipairs(from_cell.nlist) do
      into_pp = core:getPathpoint(unit, into_cell)
      into_val = core:getUnitMoveCost(unit, into_cell) + from_pp.val
      check_list[#check_list+1] = core:setPathpointValue(into_pp, into_val, from_pp)
    end
    i = i + 1
  end

  forPairsKV(pp_grid, addUnitPathpoint, unit)
end

--!-- 

---comment
---@param gx number
---@param gy number
---@param tile tile_name?
function core:addCell(gx,gy, tile)

  local cell = core:newCell(gx,gy)
  cell.tile = tile or "plain"

  cellGrid[cell.key] = cell
end
---comment
---@param unit unit_ent
function core:addMoveList(unit)
  assert(not unit.movto_cell)

  local cell = unit.movto_cell
  local pathpoint_into = unit.pp_grid[cell.key]
  local x,y

  while pathpoint_into.from do
    x,y = pathpoint_into.cell.hx, pathpoint_into.cell.hy
    unit.mov_grid[#unit.mov_grid+1] = core:newMovePoint(x,y)
    pathpoint_into = pathpoint_into.from
  end
end
---comment
---@param cell cell_ent
---@param team number?
---@param mov number?
---@param movement movement_name?
function core:addUnit(cell, team, mov, movement)
  assert(cell, ("addUnit(team, %s, mov, movement)"):format(cell))
  assert(not cell.unit, ("addUnit(team, cell.unit (%s), mov, movement)"):format(cell.unit))

  local unit = core:newUnit(team or 2, mov or 4, movement or "walk")
  cell.unit, unit.cell = unit, cell
  setCoords(unit.screen, cell.hx,cell.hy)

  unitList[#unitList+1] = unit
  forPairs(unitList, setUnitPathpoinGrid)
end
function core:addUnitRandom(team, mov, movement)
  local cell ---@type cell_ent
  repeat cell = getCell(math.random(mWidth), math.random(mHeight))
  until not cell.unit
  core:addUnit(cell, team, mov, movement)
end


function core:getMouse()
  local x,y = love.mouse.getPosition()
  return x,y
end
---comment
---@param unit unit_ent
---@param cell cell_ent
function core:getPathpoint(unit, cell)
  local grid = unit.pp_grid
  local key = cell.key
  if not grid[key]
  then grid[key] = self:newPathpoint(cell) end
  return grid[key]
end
---comment
---@param unit unit_ent
---@param cell cell_ent
function core:getUnitMoveCost(unit, cell)
  local impass = unit.mov + 1
  if cell.unit then if cell.unit ~= unit then
    return impass
  end end
  if cell.tile == "water" then return 2 end
  return 1
end

---comment
---@param gx number
---@param gy number
---@return cell_ent
function core:newCell(gx,gy)
  local key    = toKey(gx,gy)
  local x,y    = toScreen(gx,gy)
  local hx,hy  = toScreen(.5 + gx, .5 + gy)

  ---@class cell_ent
  local obj = {
    key    = toKey(gx,gy),
    gx     = gx,
    gy     = gy,
    tile   = nil,  ---@type tile_name
    unit   = nil,  ---@type unit_ent?
    x      = x,
    y      = y,
    hx     = hx,
    hy     = hy,
    nlist  = {},
  }

  return obj
end
---comment
---@param cell cell_ent
---@param val number?
---@return pathpoint_cpt
function core:newPathpoint(cell, val)
  ---@class pathpoint_cpt
  local obj = {
    cell  = cell,  ---@type cell_ent
    val   = val,   ---@type number?
    from  = nil,   ---@type pathpoint_cpt
  }
  return obj
end
---comment
---@param x number
---@param y number
---@param dt number?
function core:newMovePoint(x,y, dt)
  ---@class movepoint_cpt
  local obj = {
    x   = x,
    y   = y,
    dt  = dt or .2,
  }
  return obj
end
---comment
---@param team number
---@param mov number
---@param movement movement_name
---@return unit_ent
function core:newUnit(team, mov, movement)
  ---@class unit_ent
  local obj = {
    team        = team,      ---@type number
    mov         = mov,       ---@type number
    movement    = movement,  ---@type movement_name
    pp_grid     = {},        ---@type table<string, pathpoint_cpt>
    mov_grid    = {},        ---@type table<string, pathpoint_cpt>
    cell        = nil,       ---@type cell_ent
    movto_cell  = nil,       ---@type cell_ent?
    screen      = {
      x = nil,               ---@type number
      y = nil,               ---@type number
    }
  }
  return obj
end

---comment
---@param pp pathpoint_cpt
---@param value number
---@param from pathpoint_cpt
function core:setPathpointValue(pp, value, from)
  if not pp.val
  then pp.val = value + 1 end
  if pp.val > value then
    pp.val = value
    pp.from = from
    return pp.cell
  end
  return nil
end
---comment
---@param unit unit_ent
---@param cell cell_ent
function core:setUnitCell(unit, cell)
  assert(not cell.unit)

  unit.cell.unit = nil
  cell.unit, unit.cell = unit, cell
end

function core:drawCellHover()
  local x,y = self:getMouse()
  local cell = getCell(toGrid(x,y))

  if cell then
    x = x - x % tWidth
    y = y - y % tHeight
    setColor(1,1,1, .25)
    rectangle("fill", x,y, tWidth,tHeight)
  end
end
function core:drawUnitSel()
  if selUnit then
    local x,y = getCoords(selUnit.screen)
    setColor(white_color)
    circle("line", x,y, uRadius)
  end
end



--!-- --------------------

local main = {}

function main.new(w,h)
  clear(cellGrid)
  clear(unitList)

  mWidth,mHeight = w,h

  for gy = 1, h do for gx = 1, w do
    core:addCell(gx,gy)
  end end
end

function main.random(w,h)
  main.new(w,h)
  core:addUnitRandom(1, 4)
  core:addUnitRandom(1, 5)
  core:addUnitRandom(2, 4)
  core:addUnitRandom(2, 5)
end

function main.draw()
  forPairs(cellGrid, drawCell, tWidth-1,tHeight-1)
  core:drawCellHover()
  if selUnit
  then forPairs(selUnit.mov_grid, drawUnitMovGrid) end
  forPairs(unitList, drawUnit)
  core:drawUnitSel()
end

function main.update(dt)end

function main.select()
  local x,y = core:getMouse()
  selCell = getCell(toGrid(x,y))

  if selCell then
    local unit = selCell.unit
    if selUnit then
    else
      selUnit = unit
    end
  end
end

function main.deselect()
  selUnit = nil
end

return main

-- get — отримує існуюче
-- set — встановлює потрібне
-- add — додає щось кудись
-- new — створює та повертає