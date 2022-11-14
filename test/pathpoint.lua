local main = {}

local PathPoint    = {}  ---@class map.PathPoint2
local mtPathPoint  = {}



---comment
---@param value number
---@param from map.PathPoint2
---@param check_list map.Cell[]
function PathPoint:initValueCheck(value, from, check_list)
  if self.value > value then
    self.value, self.from = value, from
    check_list[#check_list+1] = self.cell
  end
end



---comment
---@param cell map.Cell
---@param pp_grid table<string, map.PathPoint2>
---@return map.PathPoint2
function main.add(cell, pp_grid)
  local obj = main.new(cell)
  pp_grid[cell.key] = obj
  return obj
end

---comment
---@param cell map.Cell
---@param value number?
---@return map.PathPoint2
function main.new(cell, value)
  return setmetatable({
    cell   = cell,
    value  = value,
  }, mtPathPoint)
end



PathPoint.cell = nil  ---@type map.Cell
PathPoint.from = nil  ---@type map.PathPoint2?

PathPoint.value = math.huge

mtPathPoint.__index = PathPoint

return main