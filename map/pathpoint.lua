
local PathPoint = {} ---@class map.PathPoint
local mtPathPoint = {}



function PathPoint:setValueCheck(value, from, check_list)
  if self.value > value then
    self.value, self.from = value, from
    check_list[#check_list+1] = self.cell
  end
end

function PathPoint.new(cell, grid, value)
  local key = cell.key

  ---@type map.PathPoint
  local obj = {
    cell = cell,
    value = value,
  }

  grid[key] = obj
  return setmetatable(obj, mtPathPoint)
end



PathPoint.cell = nil  ---@type map.Cell
PathPoint.from = nil  ---@type map.PathPoint?

PathPoint.value = math.huge

mtPathPoint.__index = PathPoint

return setmetatable({}, mtPathPoint)