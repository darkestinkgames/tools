-- 
local point2d    = require 'mod/point2d'
local pathpoint  = require 'map/pathpoint'



local main = {}

local Screen    = point2d.new()  ---@class map.UnitScreen : mod.Point2d
local mtScreen  = {}



function Screen:setPath(pp) ---@param pp map.PathPoint
  self.curve = pathpoint.curve(pp)
  self.render = self.curve:render()
end

function Screen:update(dt)
  if self.curve then
    local k
    self.timer = self.timer + dt
    if self:isLoop() then
      k = 1
      self.timer = 0
      self:set( self.curve:evaluate(k) )
      self.curve = nil
    else
      k = self.timer / self.duration
      self:set( self.curve:evaluate(k) )
    end
  end
end

function Screen:isLoop()
  return self.timer > self.duration or 0 > self.timer
end



function main.new(x,y)
  return setmetatable({
    x = x,
    y = y,
  }, mtScreen)
end



-- Screen.x         = nil  ---@type number
-- Screen.y         = nil  ---@type number
Screen.curve     = nil  ---@type love.BezierCurve?
Screen.render    = nil  ---@type number[]
Screen.k         = nil  ---@type number

Screen.timer     = 0    ---@type number
Screen.duration  = 1    ---@type number

mtScreen.__index = Screen

return main
