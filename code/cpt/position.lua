
---@class cpt.position
local position = {
  x = 0,  ---@type number
  y = 0,  ---@type number
}

function position:addPos(x, y)
  self.x, self.y = self.x + x, self.y + y
end
function position:setPosition(x, y)
  self.x, self.y = x, y
  return self
end
function position:getPos(ox, oy)
  return self.x - (ox or 0), self.y - (oy or 0)
end
function position:getPosOff(ox, oy)
  return self.x - ox, self.y - oy
end
function position:getPoitions()
  return self.x, self.y
end

local mtPosition = {__index = position}


local main = {}

function main.new(x, y)
  local obj = main.init()
  return obj:setPosition(x, y)
end
function main.init(obj)
  obj = obj or {}
  return setmetatable(obj, mtPosition)
end

return main