local circle = love.graphics.circle
local setColor = love.graphics.setColor



local point2d     = require 'code/point2d'
local pathpoint   = require 'map/pathpoint'



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

function Unit:setCell(cell) ---@param cell map.Cell
  assert(cell)
  assert(not cell.unit)
  self.cell.unit = nil
  cell.unit, self.cell = self, cell
end

function Unit:setPath(cell) ---@param cell map.Cell
  
end

function Unit:getPathpoint(cell) ---@param cell map.Cell
  assert(cell)
  assert(self.pp_grid[cell.key])
  return self.pp_grid[cell.key]
end

function Unit:getMoveCost(cell) ---@param cell map.Cell
  assert(cell)
  local impass = self.mov + 1

  local u = cell.unit
  if u then if u == self then
    return 1
  else
    return impass
  end end

  return 1
end

function Unit:update(dt)end

---comment
---@param cell map.Cell
---@param _mov number?
---@param _pass string?
---@param _team number?
---@return map.Unit
function Unit.new(cell, _mov, _pass, _team)
  ---@class map.Unit
  local obj = {
    cell     = cell,
    screen   = cell.half:clone(),
    mov      = _mov,
    pass     = _pass,
    team     = _team,
    pp_grid  = {},
  }
  return setmetatable(obj, mtUnit)
end



Unit.cell        = nil  ---@type map.Cell
Unit.pp_grid     = nil  ---@type table<string, map.PathPoint>

Unit.team        = 2
Unit.pass        = "walk"
Unit.mov         = 3

mtUnit.__index = Unit

return setmetatable({}, mtUnit)