
local point2d = {}
local Point = {} ---@class mod.Point2d
local mtPoint = {}


--------------------------------------------------

local function check(a, b) ---@return mod.Point2d, mod.Point2d
  if type(a) == "number" then a = point2d.new(a, a) end
  if type(b) == "number" then b = point2d.new(b, b) end
  assert(type(a) == "table" and type(b) == "table", "Only `table` or `number` to use!")
  return a, b
end

-- 

local function add(a, b)
  a, b = check(a,b)
  return point2d.new(a.x + b.x, a.y + b.y)
end

local function sub(a, b)
  a, b = check(a,b)
  return point2d.new(a.x - b.x, a.y - b.y)
end

local function mul(a, b)
  a, b = check(a,b)
  return point2d.new(a.x * b.x, a.y * b.y)
end

local function div(a, b)
  a, b = check(a,b)
  return point2d.new(a.x / b.x, a.y / b.y)
end

local function mod(a, b)
  a, b = check(a,b)
  return point2d.new(a.x % b.x, a.y % b.y)
end

local function pow(a, b)
  a, b = check(a,b)
  return point2d.new(a.x ^ b.x, a.y ^ b.y)
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

function Point:setP(pt)
  self.x,self.y = pt.x,pt.y
end

function Point:add(x,y)
  self.x,self.y = self.x + x,self.y + y
end

function Point:addP(pt)
  self.x,self.y = self.x + pt.x,self.y + pt.y
end


--------------------------------------------------

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

function point2d.perimeter(a,b) ---@return number
  assert(a and b, ("degree(%s,%s)"):format(a,b))
  return point2d.length(a,b) * 2 * math.pi
end

-- 

function point2d.new(x,y) ---@return mod.Point2d
  return setmetatable({
    x = x,
    y = y,
  }, mtPoint)
end

function point2d.byPoint(a,b, len) ---@return mod.Point2d
  assert(a and b and len, ("byPoint(%s,%s, %s)"):format(a,b, len))
  if len == 0 or a == b then return point2d.new(a:get()) end
  local delta = b - a
  local length = point2d.length(a,b)
  local k = len / length
  return delta * k + a
end

function point2d.byPointM(a,b, len) ---@return mod.Point2d
  assert(a and b and len, ("byPoint(%s,%s, %s)"):format(a,b, len))
  if len == 0 or a == b then return point2d.new(a:get()) end
  local delta = b - a
  local length = point2d.length(a,b)
  local k = math.max(0, math.min(1, len / length))
  return delta * k + a
end

function point2d.byRadian(a, rad, len) ---@return mod.Point2d
  assert(a and rad and len, ("byRadian(%s, %s, %s)"):format(a, rad, len))
  if len == 0 then return point2d.new(a:get()) end
  local b = point2d.new(math.cos(rad), math.sin(rad))
  return b * len + a
end

function point2d.byDegree(a, deg, len) ---@return mod.Point2d
  assert(a and deg and len, ("byRadian(%s, %s, %s)"):format(a, deg, len))
  if len == 0 then return point2d.new(a:get()) end
  local rad = deg * math.pi / 180
  return point2d.byRadian(a, rad, len)
end


--------------------------------------------------

Point.x = 0
Point.y = 0

---@class mod.Point2d
---@operator add:mod.Point2d
---@operator sub:mod.Point2d
---@operator mul:mod.Point2d
---@operator div:mod.Point2d
---@operator mod:mod.Point2d
---@operator pow:mod.Point2d
---@operator unm:mod.Point2d

mtPoint.__index = Point
mtPoint.__add   = add
mtPoint.__sub   = sub
mtPoint.__mul   = mul
mtPoint.__div   = div
mtPoint.__mod   = mod
mtPoint.__pow   = pow
mtPoint.__unm   = unm
mtPoint.__eq    = eq

return point2d
