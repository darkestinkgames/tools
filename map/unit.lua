local point2d = require 'code/point2d'
local pathpoint = require 'map/pathpoint'



local Unit = {} ---@class map.Unit
local mtUnit = {}



function Unit:draw()end
function Unit:getMoveCost()end
function Unit:update()end
function Unit:updMoveGrid()end
function Unit.new()end



mtUnit.__index = Unit

return setmetatable({}, mtUnit)