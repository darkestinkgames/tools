local point2d = require 'mod/point2d'

local cell = require 'map/cell'
local unit = require 'map/unit'



local main = {}

local Map = { ---@class game.Map
  state      = nil,  ---@type string
  cell_grid  = nil,  ---@type table<string, map.Cell>
  unit_list  = nil,  ---@type map.Unit[]
}
local mtMap  = {}



function main.new(w,h)
  local size = point2d.new(w,h)
  local grid = {} ---@type table<string, map.Cell>

  for y = 1, size.y do for x = 1, size.x do
    cell.add(x,y, grid)
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


function Map:onMouse(x, y, button)
  if button == 2 then
    self:addUnit( self:getCell(x,y) )
  end
end

function Map:update(dt)end

function Map:getCell(x,y)
  x,y = cell:getGrid(x,y)
  return self.cell_grid[cell:toKey(x,y)]
end

function Map:addUnit(c) ---@param c map.Cell
  local u = unit.new(c)
  c.unit = u
  self.unit_list[#self.unit_list+1] = u
end

function Map:draw()
  for  k, c in pairs(self.cell_grid)
  do   c:draw() end
  for  i, u in ipairs(self.unit_list)
  do   u:draw() end
end



mtMap.__index = Map

return main
