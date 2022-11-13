local PathPoint = {} ---@class map.PathPoint
local mtPathPoint = {}



function PathPoint:initValueCheck(value, from, check_list)
  if self.value > value then
    self.value, self.from = value, from
    check_list[#check_list+1] = self.cell
  end
end

function PathPoint.add(cell, pp_grid, _value)
  local key = cell.key

  ---@type map.PathPoint
  local obj = {
    cell = cell,
    value = _value,
  }

  pp_grid[key] = obj
  return setmetatable(obj, mtPathPoint)
end



PathPoint.cell = nil  ---@type map.Cell
PathPoint.from = nil  ---@type map.PathPoint?

PathPoint.value = math.huge

mtPathPoint.__index = PathPoint

return setmetatable({}, mtPathPoint)