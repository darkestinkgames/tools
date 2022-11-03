
local point2d = {}

local Point = { ---@class mod.Point
  x = 0,
  y = 0,
}

local mtPoint = {}


-- 

local function check(a, b)end

local function add(a, b)end
local function sub(a, b)end
local function mul(a, b)end
local function div(a, b)end
local function mod(a, b)end
local function pow(a, b)end

-- 

function Point:get() ---@return number, number
  return self.x, self.y
end

function Point:getF() ---@return number, number
  return math.floor(self.x), math.floor(self.y)
end

function Point:set(x,y)
  self.x,self.y = x,y
end


-- 

function point2d.new(x,y) ---@return mod.Point
  return setmetatable({
    x = x,
    y = y,
  }, mtPoint)
end

function point2d.length(a,b) ---@return number
end

function point2d.radian(a,b) ---@return number
end

function point2d.degree(a,b) ---@return number
end


-- 

return point2d

---@class mod.Point
---@operator add:mod.Point
---@operator sub:mod.Point
---@operator mul:mod.Point
---@operator div:mod.Point
---@operator mod:mod.Point
---@operator pow:mod.Point
