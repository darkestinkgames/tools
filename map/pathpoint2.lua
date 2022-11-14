local pathpoint = {}



local check_list  ---@type map.Cell[]

local from_ce   ---@type map.Cell
local from_pp   ---@type map.PathPoint
local into_pp   ---@type map.PathPoint
local into_val  ---@type number
local max_val   ---@type number
local f         ---@type number



---нова точка шляху
---@param cell map.Cell
---@param _value number?
---@return map.PathPoint
function pathpoint.new(cell, _value)
  ---@class map.PathPoint
  local obj = {
    cell   = cell,  ---@type map.Cell
    from   = nil,   ---@type map.PathPoint?
    value  = _value or math.huge,
  }
  return obj
end


---створити нову точку шляху й додати до грядки
---@param cell map.Cell
---@param pp_grid table<string, map.PathPoint>
---@return map.PathPoint
function pathpoint.add(cell, pp_grid)
  local obj = pathpoint.new(cell)
  pp_grid[cell.key] = obj
  return obj
end


---перевірка нового значення точки хляху
---@param pp map.PathPoint
---@param val number
---@param from map.PathPoint
function pathpoint.check(pp, val, from)
  if pp.value > val then
    pp.value, pp.from = val, from
    check_list[#check_list+1] = pp.cell
  end
end


---нова грядка для пошуку шляху
---@param unit map.Unit
---@param _cell map.Cell?
---@param _range number?
---@return table<string, map.PathPoint>
function pathpoint.grid(unit, _cell, _range)
  assert(unit)

  from_ce  = _cell   or unit.cell
  max_val  = _range  or math.huge

  local result = {} ---@type table<string, map.PathPoint>

  check_list  = {from_ce}
  result[from_ce.key] = _cell and unit.pp_grid[_cell.key] or pathpoint.new(from_ce, 0)
  f = 1

  repeat
    from_ce = check_list[f]
    from_pp = result[from_ce.key] or pathpoint.add(from_ce, result)
    for i, into_ce in ipairs(from_ce.nearest) do
      into_val = from_pp.value + unit:getMoveCost(into_ce)
      if max_val >= into_val then
        into_pp = result[into_ce.key] or pathpoint.add(into_ce, result)
        pathpoint.check(into_pp, into_val, from_pp)
      end
    end
    f = f + 1
  until check_list[f]

  return result
end



return pathpoint
