math.randomseed(os.time())

-- -- -- >>> ядро

local tWidth, tHeight = 64, 48
local width, height

local cGrid  ---@type table<string, map.cell>
-- local uGrid  ---@type table<string, map.unit>

local cSelected
local uSelected


-- -- -- >>> енумерашки

local color_name = {
  white = { 1, 1, 1 },

  plain = { .1, .25, .15 },
  water = { .1, .15, .25 },
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
  local key = toKey(gx, gy)
  -- print(key)
  ---@class map.cell
  local obj = {
    key   = key,
    tile  = name,  ---@type "plain"|"water"
    unit  = nil,   ---@type map.unit
  }
  obj.gx, obj.gy = gx, gy
  obj.sx, obj.sy = toScreen(gx, gy)
  obj.hx, obj.hy = toScreen(gx + .5, gy + .5)
  obj.tile = obj.tile or "plain"
  return obj
end
local function newUnit(team, mov, cell)
  assert( team,      ("Wrong argument `team` (%s)!"):format(team)    )
  assert( mov,       ("Wrong argument `mov` (%s)!"):format(mov)      )
  assert( cell,      ("Wrong argument `cell` (%s)!"):format(cell)    )
  assert( cell.unit, ("The `cell` %s is occupied!"):format(cell.key) )
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
  assert( cell, ("Wrong argument `cell` (%s)!"):format(cell) )
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

local function setColor(name)
  assert( color_name[name], ("Color `%s` is missing!"):format(name) )
  love.graphics.setColor(color_name[name])
end
local function setPtVal(pp,val,from) ---@param pp map.pathpoint
  assert( pp,  ("Wrong argument `pp` (%s)!"):format(pp)   )
  assert( val, ("Wrong argument `val` (%s)!"):format(val) )
  if not pp.val then pp.val = val + 1 end
  if pp.val > val then
    pp.val = val
    pp.from = from
    return pp.cell
  end
  return nil
end

local function getRadius(k)
  assert( k, ("Wrong argument `k` (%s)!"):format(k) )
  local val = math.floor(math.min(tWidth, tHeight) * .5) * k
  return val, val * 4
end
local function getCell(gx,gy)
  return cGrid[toKey(gx,gy)]
end
local function getCost(cell) ---@param cell map.cell
  assert( cell, ("Wrong argument `cell` (%s)!"):format(cell) )
  if cell.unit then return nil end
  if cell.tile == "water" then return 2 end
  return 1
end
local function getPt(ppGrid,cell) ---@param cell map.cell
  assert( ppGrid, ("Wrong argument `ppGrid` (%s)!"):format(ppGrid) )
  assert( cell,   ("Wrong argument `cell` (%s)!"):format(cell)     )
  return ppGrid[cell.key]
end

local function initPathGrid(pp,mov)end

local function drawTile(cell) ---@param cell map.cell
  assert( cell,   ("Wrong argument `cell` (%s)!"):format(cell)     )
  setColor(cell.tile)
  love.graphics.rectangle("fill", cell.sx,cell.sy, tWidth-1, tHeight-1)
end
local function drawHover()
  local cell = getCell(toGrid(love.mouse.getPosition()))
  if cell then
    love.graphics.setColor(1,1,1, .5)
    love.graphics.rectangle("fill", cell.sx,cell.sy, tWidth-1, tHeight-1)
  end
end
local function drawUnit()end
local function drawPathGrid(unit)end
local function drawPathLine(pp)end
local function drawPathQueue(unit)end

local function addQueue(unit,tile)end


-- -- -- >>> головняк

local main = {}

function main.new(w,h)
  assert( w, ("Wrong argument `w` (%s)!"):format(w) )
  assert( h, ("Wrong argument `h` (%s)!"):format(w) )
  cGrid = {}
  for gy = 1, h do for gx = 1, w do
    local cell = newCell(gx,gy)
    cGrid[cell.key] = cell
  end end
  -- uGrid = {}
end
function main.addUnit(team, mov, x,y)end
function main.draw()end
function main.update(dt)end
function main.select()end
function main.deselect()end


-- -- -- >>>

return main