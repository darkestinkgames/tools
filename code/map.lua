math.randomseed(os.time())

-- -- -- >>> ядро

local tWidth, tHeight = 64, 48
local width, height

local cGrid
local uGrid

local cSelected
local uSelected


-- -- -- >>> енумерашки

local color_name = {
  white = { 1, 1, 1 },
}


-- -- -- >>> функціонал

local function toKey(x,y)
  return ("x%sy%s"):format(x,y)
end
local function toGrid(sx,sy)
  return math.floor(sx / tWidth + 1), math.floor(sy / tHeight + 1)
end
local function toScreen(gx,gy)
  return (gx - 1) * tWidth, (gy - 1) * tHeight
end


-- -- -- >>> нове

local function newCell(gx,gy, name)
  ---@class map.cell
  local obj = {
    key   = toKey(gx, gy),
    tile  = name,  ---@type "plain"|"water"
    unit  = nil,   ---@type map.unit
  }
  obj.gx, obj.gy = gx, gy
  obj.sx, obj.sy = toScreen(gx, gy)
  obj.hx, obj.hy = toScreen(gx + .5, gy + .5)
  return obj
end
local function newUnit(team, mov, cell)
  assert(team,         ("Wrong argument %s!"):format(team))
  assert(mov,          ("Wrong argument %s!"):format(mov))
  assert(cell,         ("Wrong argument %s!"):format(cell))
  assert(cGrid[cell],  ("The `cell` %s is missing!"):format(cell.key))
  ---@class map.unit
  local obj = {
    team   = team,  ---@type number
    mov    = mov,   ---@type number
    cell   = cell,  ---@type map.cell
    pgrid  = nil,   ---@type table<string, map.pathpoint>
    plist  = nil,   ---@type map.pathpoint[]
  }
  return obj
end
local function newPathPt(cell, val)
  local key = cell.key
  ---@class map.pathpoint
  local obj = {
    key   = key,   ---@type string
    cell  = cell,  ---@type map.cell
    val   = val,   ---@type number
    from  = nil,   ---@type map.pathpoint
  }
  return obj
end


-- -- -- >>> функціонал

local function setColor(name)end
local function setPathPtVal(pp,val,from)end

local function getRadius(val)end
local function getCell(gx,gy)end
local function getCost(tile)end
local function getPt(grid,tile)end

local function initPathGrid(pp,mov)end

local function drawTile()end
local function drawHover()end
local function drawUnit()end
local function drawPathGrid(unit)end
local function drawPathLine(pp)end
local function drawPathQueue(unit)end

local function addQueue(unit,tile)end


-- -- -- >>> головняк

local main = {}

function main.new(w,h)end
function main.draw()end
function main.update(dt)end
function main.select()end
function main.deselect()end


-- -- -- >>>

return main