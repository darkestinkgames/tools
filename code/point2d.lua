
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


local function add(a, b)
  local c, x,y = check(a,b)
  return point2d.new(c.x + x, c.y + y)
end

local function sub(a, b)
  local c, x,y = check(a,b)
  return point2d.new(c.x - x, c.y - y)
end

local function mul(a, b)
  local c, x,y = check(a,b)
  return point2d.new(c.x * x, c.y * y)
end

local function div(a, b)
  local c, x,y = check(a,b)
  return point2d.new(c.x / x, c.y / y)
end

local function mod(a, b)
  local c, x,y = check(a,b)
  return point2d.new(c.x % x, c.y % y)
end

local function pow(a, b)
  local c, x,y = check(a,b)
  return point2d.new(c.x ^ x, c.y ^ y)
end

local function unm(a) -- норм чи посиплеться? 
  return point2d.new(-a.x, -a.y)
end

local function eq(a,b)
  assert(type(a) == "table" and type(b) == "table")
  return a.x == b.x and a.y == b.y
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
  assert(a and b, ("length(%s,%s)"):format(a,b))
  if a == b then return 0 end
  local delta = (b - a) ^ 2
  return (delta.x + delta.y) ^ .5
end

function point2d.radian(a,b) ---@return number
  assert(a and b, ("radian(%s,%s)"):format(a,b))
  if a == b then return 0 end
  local delta = b - a
  return math.atan2(delta.y, delta.x)
end

function point2d.degree(a,b) ---@return number
  assert(a and b, ("degree(%s,%s)"):format(a,b))
  if a == b then return 0 end
  return point2d.radian(a,b) * 180 / math.pi
end

function point2d.byPoint(a,b, len) ---@return mod.Point
  assert(a and b and len, ("byPoint(%s,%s, %s)"):format(a,b, len))
  if len == 0 or a == b then return point2d.new(a:get()) end
  local delta = b - a
  local length = point2d.length(a,b)
  local k = len / length
  return a + delta * k
end

function point2d.byPointM(a,b, len) ---@return mod.Point
  assert(a and b and len, ("byPoint(%s,%s, %s)"):format(a,b, len))
  if len == 0 or a == b then return point2d.new(a:get()) end
  local delta = b - a
  local length = point2d.length(a,b)
  local k = math.max(0, math.min(1, len / length))
  return a + delta * k
end

function point2d.byRadian(a, rad, len) ---@return mod.Point
  assert(a and rad and len, ("byRadian(%s, %s, %s)"):format(a, rad, len))
  if len == 0 then return point2d.new(a:get()) end
  local b = point2d.new(math.cos(rad), math.sin(rad))
  return b * len + a
end

function point2d.byDegree(a, deg, len) ---@return mod.Point
  assert(a and deg and len, ("byRadian(%s, %s, %s)"):format(a, deg, len))
  if len == 0 then return point2d.new(a:get()) end
  local rad = deg * math.pi / 180
  return point2d.byRadian(a, rad, len)
end


-- 

mtPoint.__index = Point
mtPoint.__add = add
mtPoint.__sub = sub
mtPoint.__mul = mul
mtPoint.__div = div
mtPoint.__mod = mod
mtPoint.__pow = pow
mtPoint.__unm = unm
mtPoint.__eq = eq


return point2d


---@class mod.Point
---@operator add:mod.Point
---@operator sub:mod.Point
---@operator mul:mod.Point
---@operator div:mod.Point
---@operator mod:mod.Point
---@operator pow:mod.Point
---@operator unm:mod.Point
