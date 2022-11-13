local PathPoint = require 'map/pathpoint'



local PathFinder = {} ---@class map.PathFinder
local mtPathFinder = {}



local check_list  ---@type map.Cell[]

local grid      ---@type table<string, map.PathPoint>
local from_ce   ---@type map.Cell
local from_pp   ---@type map.PathPoint
local into_pp   ---@type map.PathPoint
local from_val  ---@type number
local into_val  ---@type number



local function clear(t)
  for k in pairs(t) do t[k] = nil end
end

function PathFinder:getGrid(cell, range) ---@param cell map.Cell
  grid     = self.grid
  from_ce  = cell or self.unit.cell
  from_pp  = grid[from_ce.key]
  range    = range or math.huge

  clear(check_list)
  clear(grid)

  local f = 1

  repeat
    from_ce = check_list[f]
    from_pp = grid[from_ce.key] or PathPoint.add(from_ce, grid, 0)
    for i, into_ce in ipairs(from_ce.nearest) do
      into_val  = from_pp.value + self:getCost(into_ce)
      into_pp   = grid[into_ce.key] or PathPoint.add(into_ce, grid)
      if   range >= into_val
      then into_pp:initValueCheck(into_val, from_pp, check_list) end
    end
    f = f + 1
  until check_list[f]
end

---comment
---@param unit map.Unit
---@param cell map.Cell?
---@param range number?
function PathFinder.update(unit, cell, range)
  grid     = unit.pp_grid
  from_ce  = cell or unit.cell
  from_pp  = grid[from_ce.key]
  range    = range or math.huge

  clear(grid)
  check_list = {from_ce}
  grid[from_ce.key] = from_pp -- може бути `nil`

  local f = 1

  repeat
    from_ce = check_list[f]
    from_pp = grid[from_ce.key] or PathPoint.add(from_ce, grid, 0)
    for i, into_ce in ipairs(from_ce.nearest) do
      into_val  = from_pp.value + unit:getMoveCost(into_ce)
      into_pp   = grid[into_ce.key] or PathPoint.add(into_ce, grid)
      if   range >= into_val
      then into_pp:initValueCheck(into_val, from_pp, check_list) end
    end
    f = f + 1
  until check_list[f]
end

function PathFinder:getCost(into_ce) ---@param into_ce map.Cell
  local impass = self.unit.mov + 1
  -- todo
  return 1
end

function PathFinder.add(unit) ---@param unit map.Unit
  ---@type map.PathFinder
  unit.pathfinder = {
    unit = unit,
    grid = {},
  }
  return setmetatable(unit.pathfinder, mtPathFinder)
end



PathFinder.unit = nil  ---@type map.Unit
PathFinder.grid = nil  ---@type table<string, map.PathPoint>

mtPathFinder.__index = PathFinder

return setmetatable({}, mtPathFinder)
