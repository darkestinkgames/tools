local point2d = require 'code/point2d'
local pathfinder = require 'test/unitpathfinder'
-- local pathpoint = require 'map/pathpoint'




local Unit    = {}  ---@class map.Unit
local mtUnit  = {}



function Unit:draw()end
function Unit:setCell()end
function Unit:update()end
function Unit:updMoveGrid()end

function Unit.new(cell, mov, pass, team)
  ---@type map.Unit
  local obj = {
    cell  = cell,
    mov   = mov   or 3,
    pass  = pass  or "walk",
    team  = team  or 2,
  }
  pathfinder.add(obj)
  return setmetatable(obj, mtUnit)
end



Unit.cell        = nil  ---@type map.Cell
Unit.mov         = nil  ---@type map.Cell
Unit.pass        = nil  ---@type string
Unit.pathfinder  = nil  ---@type map.PathFinder

mtUnit.__index = Unit

return setmetatable({}, mtUnit)