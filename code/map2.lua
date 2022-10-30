--[[
math.randomseed(os.time())

local ent_list = {}
local sys_list = {}  ---@type core.sys[]



-- -- -- >>>

local tWidth, tHeight = 64, 48
local width, height

local tRate = { plain = 1, water = 1 }
local cGrid  ---@type table<number, map.cell[]>
local uList  ---@type table<string, map.unit>

local cSelected  ---@type map.cell?
local uSelected  ---@type map.unit?

local upmov_list = {}  ---@type map.unit[]
local dt_val = .07



-- -- -- >>>

local color_name = {
  white    = { 1, 1, 1 },
  pp_grid  = { 1, 1, 1, .15 },

  plain  = { .1, .25, .15 },
  water  = { .1, .15, .25 },

  [1]    = { .2, .8, .2 },
  [2]    = { .8, .2, .2 },
}

---@alias val.tile
---| "plain"
---| "water"




-- -- -- >>>

local function toKey(x,y)
  return ("x%sy%s"):format(x,y)
end
local function toGrid(sx,sy)
  return math.floor(sx / tWidth + 1), math.floor(sy / tHeight + 1)
end
local function toScreen(gx,gy)
  return (gx - 1) * tWidth, (gy - 1) * tHeight
end


local function addPosition(obj, x,y)
  obj.x, obj.y = obj.x + x, obj.y + y
end
local function setPosition(obj, x,y)
  obj.x, obj.y = x, y
end
local function getPosition(obj)
  return obj.x, obj.y
end
local function getPos(obj, x,y)
  return obj.x - (x or 0), obj.y - (y or 0)
end
local function getPosOff(obj, x,y)
  return obj.x - x, obj.y - y
end



-- -- -- >>> ent

---@class core.ent
local aEnt = {}
local mtEnt = {__index = aEnt}

local function Ent(t)
  t = setmetatable(t, mtEnt)
  ent_list[#ent_list+1] = t
  return t
end



-- -- -- >>> sys

---@class core.sys
local aSys = {}
local mtSys = {__index = aSys}

function aSys:getMatch(e)
  for i, key in ipairs(self) do
    if not e[key]
    then return nil end
    return e
  end
end
function aSys:getMatchList()
  local list = {}  ---@type core.ent[]
  for i, e in ipairs(ent_list) do
    if    e.removed
    then  table.remove(ent_list, i)
    else  list[#list+1] = self:getMatch(e) end
  end
  return list
end

local function exec(cmd, ...)
  for i, sys in ipairs(sys_list) do
    local fn = sys[cmd]
    if    fn
    then  fn(sys, ...) end
  end
end
local function Sys(t)
  t = setmetatable(t, mtSys)
  sys_list[#sys_list+1] = t
  return t
end


-- -- -- >>>




-- -- -- >>>




-- -- -- >>>


local sysMov = Sys { "mov_queue", "x", "y" }

function sysMov:update(ent, dt)  ---@param ent ent.unit
  local cpt = ent.mov_queue[#ent.mov_queue]
  if dt > cpt.dt then
    setPosition(ent, getPosition(cpt))
    table.remove(ent.mov_queue)
  else
    local k = dt / cpt.dt
    local dx,dy = getPosOff(ent, getPosition(cpt))
    addPosition(ent, dx * k, dy * k)
  end
  if #ent.mov_queue == 0 then
  end
end


-- -- -- >>>


local function newPathpoint(cell, value)
  ---@class cpt.pathpoint
  local c = {
    cell   = cell,
    value  = value,
    from   = nil,
    x      = cell.hx,
    y      = cell.hy,
    dt     = dt_val,
  }
  return c
end

local function newMapcell(gx,gy, tile)
  ---@class ent.cell
  local e = {
    key   = toKey(gx,gy),
    gx    = gx,
    gy    = gy,
    tile  = tile,  ---@type val.tile
    unit  = nil,   ---@type ent.unit?
  }
  e.x, e.y    = toScreen(gx, gy)
  e.hx, e.hy  = toScreen(gx + .5, gy + .5)
  return e
end

local function newUnit(team, mov, cell)
  ---@class ent.unit
  local e = {
    pp_grid    = {},  ---@type cpt.pathpoint
    mov_queue  = {},  ---@type cpt.pathpoint[]?
  }
  return e
end


-- -- -- >>>

local main = {}

function main.newGridRandom(w,h)
  
end
function main.draw()
  
end
function main.update(dt)
  
end

return main
]]