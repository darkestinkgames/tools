local pathpoint = require 'map/pathpoint'



local pathfinder = {}



local check_list  ---@type map.Cell[]

local from_ce   ---@type map.Cell
local from_pp   ---@type map.PathPoint
local into_pp   ---@type map.PathPoint
local into_val  ---@type number
local max_val   ---@type number
local f         ---@type number



function pathfinder.grid(unit, _cell, _range)
  assert(unit)

  from_ce  = _cell   or unit.cell
  max_val  = _range  or math.huge

  local result = {} ---@type table<string, map.PathPoint>
  check_list  = {from_ce}
  result[from_ce.key] = _cell and unit.pp_grid[_cell.key] or pathpoint.new(from_ce, 0)
  f = 1

  repeat
    from_ce = check_list[f]
    from_pp = result[from_ce.key] or pathpoint.add(from_ce, result)
    for i, innto_ce in ipairs(from_ce.nearest) do
      into_val = from_pp.value + unit:getMoveCost(innto_ce)
      if max_val >= into_val then
        into_pp = result[innto_ce.key] or pathpoint.add(innto_ce, result)
        into_pp:initValueCheck(into_val, from_pp, check_list)
      end
    end
    f = f + 1
  until check_list[f]

  return result
end



return pathfinder
