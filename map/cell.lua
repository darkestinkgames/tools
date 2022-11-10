local point2d = require 'code/point2d'



local Cell = {} ---@class map.Cell
local mtCell = {}



local tile_color = {
  plain = {.1, .25, .15},
  water = {.1, .15, .25},
}



function Cell:draw()end
function Cell:setNearest()end
function Cell:getUnit()end
function Cell.new()end



Cell.key        = nil  ---@type string
Cell.nearest    = nil  ---@type map.Cell[]
Cell.grid_pt    = nil  ---@type mod.Point2d
Cell.screen_pt  = nil  ---@type mod.Point2d
Cell.half_pt    = nil  ---@type mod.Point2d
Cell.unit       = nil  ---@type map.Unit?

Cell.tile  = "plain"
Cell.size  = point2d.new(48,48)

mtCell.__index = Cell

return setmetatable({}, mtCell)