local rectangle  = love.graphics.rectangle
local setColor   = love.graphics.setColor



local point2d = require 'code/point2d'



local Cell = {} ---@class map.Cell
local mtCell = {}



local default_size = point2d.new(48,48)

local tile_color = {
  plain = {.1, .25, .15},
  water = {.1, .15, .25},
}



local function clear(t)
  for k in pairs(t) do t[k] = nil end
end

local function toKey(x,y)
  return ("x%sy%s"):format(x,y)
end



function Cell:draw()
  local x,y = self.screen:get()
  local w,h = self.size:get()
  setColor(tile_color[self.tile])
  rectangle("fill", x,y, w,h)
end

function Cell:setNearest(grid)
  local list = self.nearest
  local x,y = self.grid:get()
  clear(list)
  list[#list+1] = grid[toKey(x, y - 1)]
  list[#list+1] = grid[toKey(x, y + 1)]
  list[#list+1] = grid[toKey(x - 1, y)]
  list[#list+1] = grid[toKey(x + 1, y)]
end

function Cell:getUnit()
  return self.unit
end

function Cell:toGrid(screen)
  return (screen - screen % self.size) / self.size + 1
end

function Cell:toScreen(grid)
  return (grid - 1) * self.size
end

function Cell:new(x,y, grid, tile)
  local key = toKey(x,y)
  local pos = point2d.new(x,y)
  ---@type map.Cell
  local obj = {
    key      = key,
    tile     = tile,
    grid     = pos,
    screen   = self:toScreen(pos),
    half     = self:toScreen(.5 + pos),
    nearest  = {},
  }
  grid[key] = obj
  return setmetatable(obj, mtCell)
end



Cell.key      = nil  ---@type string
Cell.nearest  = nil  ---@type map.Cell[]
Cell.grid     = nil  ---@type mod.Point2d
Cell.screen   = nil  ---@type mod.Point2d
Cell.half     = nil  ---@type mod.Point2d
Cell.unit     = nil  ---@type map.Unit?

Cell.tile  = "plain"
Cell.size  = default_size

mtCell.__index = Cell

return setmetatable({}, mtCell)
