math.randomseed(os.time())



--!-- --------------------

local tWidth, tHeight = 64,48

local mWidth, mHeight
local cellGrid = {}  ---@type table<string, cell_ent>

local unitList = {}  ---@type unit_ent[]



--!-- --------------------

---@alias tile_name
---| "plain"
---| "water"

---@alias movement_name
---| "walk"



--!-- --------------------

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

local function forP(t, fn, ...)
  for k, v in pairs(t)
  do fn(v, ...) end
end
local function forPK(t, fn, ...)
  for k, v in pairs(t)
  do fn(k, v, ...) end
end

local function clear(t)
  for k in pairs(t)
  do t[k] = nil end
end



--!-- -------------------- 



--!-- -------------------- new

---comment
---@param gx number
---@param gy number
---@return cell_ent
local function newCell(gx,gy)
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
local function newPathPoint(cell, val)
  ---@class pathpoint_cpt
  local obj = {
    cell  = cell,  ---@type cell_ent
    val   = val,   ---@type number?
    from  = nil,   ---@type pathpoint_cpt?
  }
  return obj
end
---comment
---@param team number
---@param mov number
---@param movement movement_name
---@return unit_ent
local function newUnit(team, mov, movement)
  ---@class unit_ent
  local obj = {
    team        = team,      ---@type number
    mov         = mov,       ---@type number
    movement    = movement,  ---@type movement_name
    pp_grid     = {},        ---@type table<string, pathpoint_cpt>
    mov_grid    = {},        ---@type table<string, pathpoint_cpt>
    cell        = nil,       ---@type cell_ent
    movto_cell  = nil,       ---@type cell_ent?
  }
  return obj
end



--!-- -------------------- 

--?-- мультишот

---comment
---@param cell cell_ent
---@param unit unit_ent
local function addUnitPathpoint(cell, unit)
  local key = cell.key
  local pp = newPathPoint(cell)
  unit.pp_grid[key] = pp
end

--?-- ваншот

---comment
---@param gx number
---@param gy number
---@param tile tile_name?
local function addCell(gx,gy, tile)

  local cell = newCell(gx,gy)
  cell.tile = tile or "plain"

  cellGrid[cell.key] = cell
end
---comment
---@param cell cell_ent
---@param team number?
---@param mov number?
---@param movement movement_name?
local function addUnit(cell, team, mov, movement)
  assert(cell, ("addUnit(team, %s, mov, movement)"):format(cell))
  assert(not cell.unit, ("addUnit(team, cell.unit (%s), mov, movement)"):format(cell.unit))

  local unit = newUnit(team or 2, mov or 4, movement or "walk")

  unitList[#unitList+1] = unit
end



--!-- --------------------




--!-- --------------------



--!-- --------------------

local main = {}

function main.new(w,h)
  clear(cellGrid)
  clear(unitList)

  mWidth,mHeight = w,h

  for gy = 1, h do for gx = 1, w do
    addCell(gx,gy)
  end end
end
function main.draw()end
function main.update(dt)end
function main.select(x,y)end
function main.deselect()end

return main

-- new
-- get
-- set
-- add