
local point2d = {}

local Point = { ---@class mod.Point
  x = 0,
  y = 0,
}

local mtPoint = {}


-- 

local function check(a, b) ---@return mod.Point, number, number
  if type(a) == "number" and type(b) == "table"
  then return b, a,a end
  if type(b) == "number" and type(a) == "table"
  then return a, b,b end
  return a, b.x,b.y
end


local function add(a, b) ---@return mod.Point
  local c, x,y = check(a,b)
  return point2d.new(c.x + x, c.y + y)
end

local function sub(a, b) ---@return mod.Point
  local c, x,y = check(a,b)
  return point2d.new(c.x - x, c.y - y)
end

local function mul(a, b) ---@return mod.Point
  local c, x,y = check(a,b)
  return point2d.new(c.x * x, c.y * y)
end

local function div(a, b) ---@return mod.Point
  local c, x,y = check(a,b)
  return point2d.new(c.x / x, c.y / y)
end

local function mod(a, b) ---@return mod.Point
  local c, x,y = check(a,b)
  return point2d.new(c.x % x, c.y % y)
end

local function pow(a, b) ---@return mod.Point
  local c, x,y = check(a,b)
  return point2d.new(c.x ^ x, c.y ^ y)
end


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
  local delta = (b - a) ^ 2
  return (delta.x + delta.y) ^ .5
end

function point2d.radian(a,b) ---@return number
end

function point2d.degree(a,b) ---@return number
end


-- 

mtPoint.__index = Point
mtPoint.__add = add
mtPoint.__sub = sub
mtPoint.__mul = mul
mtPoint.__div = div
mtPoint.__mod = mod
mtPoint.__pow = pow


return point2d

---@class mod.Point
---@operator add:mod.Point
---@operator sub:mod.Point
---@operator mul:mod.Point
---@operator div:mod.Point
---@operator mod:mod.Point
---@operator pow:mod.Point
