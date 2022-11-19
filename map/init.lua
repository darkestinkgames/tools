local point2d = require 'mod/point2d'
local pathpoint = require 'map/pathpoint'

local cell = require 'map/cell'
local unit = require 'map/unit'



local main = {}

local Map = { ---@class game.Map
  state      = nil,  ---@type string
  cell_grid  = nil,  ---@type table<string, map.Cell>
  unit_list  = nil,  ---@type map.Unit[]
  cell       = nil,  ---@type map.Cell?
  unit       = nil,  ---@type map.Unit?
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
  local obj = setmetatable({
    size       = size,
    cell_grid  = grid,
    unit_list  = {},    ---@type map.Unit[]
    impass     = size.x * size.y
  }, mtMap)

  -- obj:addUnit()
  print(obj.impass)

  return obj
end



function Map:onMouse(x, y, button)
  local c = self:getCell(x,y)
  if button == 1 and c then
    self.cell = c
    local u = c.unit
    if u then
      self.unit = u
      u.pp_grid = pathpoint.grid(u)
    end
  end
  if button == 2 then
    self:addUnit(c)
  end
end

function Map:getCell(x,y)
  x,y = cell:getGrid(x,y)
  return self.cell_grid[cell:toKey(x,y)]
end

function Map:addUnit(c) ---@param c map.Cell
  local u = unit.new(c)
  u.impass = self.impass
  c.unit = u
  self.unit_list[#self.unit_list+1] = u
end

function Map:draw()
  for  k, c in pairs(self.cell_grid)
  do   c:draw() end
  for  i, u in ipairs(self.unit_list)
  do   u:draw() end
  if self.unit then
    love.graphics.setColor(1,1,1)
    local x,y = self.unit.screen:get()
    self.unit:drawGrid()
    love.graphics.circle("line", x,y, 20)
  end
end

function Map:update(dt)end



mtMap.__index = Map

return main
