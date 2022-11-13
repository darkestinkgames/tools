local point2d = require 'code/point2d'
local pathpoint = require 'map/pathpoint'




local Unit    = {}  ---@class map.Unit
local mtUnit  = {}



local check_list  ---@type map.Cell[]

local grid      ---@type table<string, map.PathPoint>
local from_ce   ---@type map.Cell
local from_pp   ---@type map.PathPoint
local into_pp   ---@type map.PathPoint
local from_val  ---@type number
local into_val  ---@type number

local f



local function clear(t)
  for k in pairs(t) do t[k] = nil end
end



function Unit:draw()end
function Unit:setCell()end
function Unit:getMoveCost(cell)end
function Unit:update(dt)end

function Unit:getPathpointGrid(cell, range)
  grid     = {}
  from_ce  = self.cell
  range    = range or math.huge
  f        = 1

  if cell then
    from_ce = cell
    pathpoint.add(cell, grid, 0)
  end

  check_list = {from_ce}

  repeat
    from_ce = check_list[f]
    from_pp = grid[from_ce.key] or pathpoint.add(from_ce, grid)
    for i, into_ce in ipairs(from_ce.nearest) do
      into_val  = from_pp.value + self:getMoveCost(into_ce)
      into_pp   = grid[into_ce.key] or pathpoint.add(into_ce, grid)
      if    range >= into_val
      then  into_pp:initValueCheck(into_val, from_pp, check_list) end
    end
    f = f + 1
  until check_list[f]
end

---comment
---@param cell map.Cell
---@param mov number?
---@param pass string?
---@param team number?
---@return map.Unit
function Unit.new(cell, mov, pass, team)
  ---@class map.Unit
  local obj = {
    cell     = cell,
    mov      = mov,
    pass     = pass,
    team     = team,
    pp_grid  = {},
  }
  return setmetatable(obj, mtUnit)
end



Unit.cell        = nil  ---@type map.Cell
Unit.pathfinder  = nil  ---@type map.PathFinder
Unit.pp_grid     = nil  ---@type table<string, map.PathPoint>

Unit.team        = 2
Unit.pass        = "walk"
Unit.mov         = 3

mtUnit.__index = Unit

return setmetatable({}, mtUnit)