local Point2d = require 'mod/point2d'

local Cell = require 'map/cell'



local Map = {} ---@class game.Map
local mtMap = {}



function Map:onMouse(x, y, button, istouch, presses)end
function Map:update(dt)end
function Map:add(x,y)end

function Map:draw()
  for  k, c in pairs(self.cell_grid)
  do   c:draw() end
end

function Map.new(w,h)
  local size = Point2d.new(w,h)
  local grid = {} ---@type table<string, map.Cell>

  for y = 1, size.y do for x = 1, size.x do
    Cell.add(x,y, grid)
  end end
  for k, c in pairs(grid) do
    c:setNearest(grid)
  end

  ---@class game.Map
  local obj = {
    size       = size,
    cell_grid  = grid,
    unit_list  = {},    ---@type map.Unit[]
  }
  return setmetatable(obj, mtMap)
end



Map.state  = nil  ---@type string
Map.cell   = nil  ---@type map.Cell?
Map.unit   = nil  ---@type map.Unit?

mtMap.__index = Map

return setmetatable({}, mtMap)
