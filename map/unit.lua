local circle = love.graphics.circle
local setColor = love.graphics.setColor



local point2d     = require 'mod/point2d'
local pathpoint   = require 'map/pathpoint'
local unitscreen  = require 'test/unitscreen'



local main = {}

local Unit    = {}  ---@class map.Unit
local mtUnit  = {}



local radius = 20

local team_color = {
  { .2, .8, .2 },
  { .8, .2, .2 },
}



local function clear(t)
  for k in pairs(t) do t[k] = nil end
end



function Unit:draw()
  local x,y = self.screen:get()
  setColor(team_color[self.team])
  circle("fill", x,y, radius)
  setColor(1,1,1, .2)
  circle("line", x,y, radius)
end

function Unit:drawGrid()
  for k, pp in pairs(self.pp_grid) do
    local x,y = pp.cell.half:get()
    circle("fill", x,y, 4)
    love.graphics.print(pp.value, x,y)
  end
end

function Unit:setCell(cell) ---@param cell map.Cell
  assert(cell)
  assert(not cell.unit)
  self.cell.unit = nil
  cell.unit, self.cell = self, cell
end

function Unit:move(cell) ---@param cell map.Cell
  self.screen:setPath(self:getPathpoint(cell))
  self:setCell(cell)
end

function Unit:getPathpoint(cell) ---@param cell map.Cell
  assert(cell)
  assert(self.pp_grid[cell.key])
  return self.pp_grid[cell.key]
end

function Unit:getMoveCost(cell) ---@param cell map.Cell
  assert(cell)
  local u = cell.unit
  if u then if u == self then
    return 1
  else
    return self.impass
  end end

  return 1
end

function Unit:update(dt)
  self.screen:update(dt)
end

---comment
---@param cell map.Cell
---@param _mov number?
---@param _pass string?
---@param _team number?
---@return map.Unit
function Unit.new(cell, _mov, _pass, _team)
  return setmetatable({
    cell     = cell,
    screen   = unitscreen.new(cell.half:get()),
    mov      = _mov,
    pass     = _pass,
    team     = _team,
    pp_grid  = {},
  }, mtUnit)
end



Unit.cell     = nil  ---@type map.Cell
Unit.screen   = nil  ---@type map.UnitScreen
Unit.pp_grid  = nil  ---@type table<string, map.PathPoint>
Unit.impass   = nil

Unit.mov   = 3
Unit.pass  = "walk"
Unit.team  = 2

mtUnit.__index = Unit


return setmetatable({}, mtUnit)