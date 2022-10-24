math.randomseed(os.time())

-- -- -- >>> ядро

local tWidth, tHeight = 64, 48
local width, height

local tRate = { plain = 1, water = 1 }
local cGrid  ---@type table<number, map.cell[]>
local uList  ---@type table<string, map.unit>

local cSelected  ---@type map.cell?
local uSelected  ---@type map.unit?

local updmov_list = {}  ---@type map.upd.mov[]
local dt_val = .2


-- -- -- >>> енумерашки

local color_name = {
  white  = { 1, 1, 1 },
  pp_grid  = { 1, 1, 1, .15 },
  pp_grid_hower  = { 1, 1, 0, .1 },

  plain  = { .1, .25, .15 },
  water  = { .1, .15, .25 },

  [1]    = { .2, .8, .2 },
  [2]    = { .8, .2, .2 },
}


-- -- -- >>> конвертація

local function toKey(x,y)
  return ("x%sy%s"):format(x,y)
end
local function toGrid(sx,sy)
  return math.floor(sx / tWidth + 1), math.floor(sy / tHeight + 1)
end
local function toScreen(gx,gy)
  return (gx - 1) * tWidth, (gy - 1) * tHeight
end


-- -- -- >>> нове

local function newCell(gx,gy, tile)
  local key = toKey(gx, gy)
  ---@class map.cell
  local obj = {
    key   = key,
    tile  = tile,  ---@type "plain"|"water"
    unit  = nil,   ---@type map.unit
    nlist = {},    ---@type map.cell[]
  }
  obj.gx, obj.gy = gx, gy
  obj.sx, obj.sy = toScreen(gx, gy)
  obj.hx, obj.hy = toScreen(gx + .5, gy + .5)
  obj.tile = obj.tile or "plain"
  return obj
end
---comment
---@param team number
---@param mov number
---@param cell map.cell
---@return map.unit
local function newUnit(team, mov, cell)
  assert( team,          ("Wrong argument `team` (%s)!"):format(team)    )
  assert( mov,           ("Wrong argument `mov` (%s)!"):format(mov)      )
  assert( cell,          ("Wrong argument `cell` (%s)!"):format(cell)    )
  assert( not cell.unit, ("The `cell` %s is occupied!"):format(cell.key) )
  ---@class map.unit
  local obj = {
    team       = team,  ---@type number
    mov        = mov,   ---@type number
    cell_pos   = cell,  ---@type map.cell
    pp_grid    = nil,   ---@type table<string, map.pathpoint>
    plist      = nil,   ---@type map.pathpoint[]
  }
  obj.x, obj.y = cell.hx, cell.hy
  return obj
end
local function newPathPt(cell, val)
  assert( cell, ("Wrong argument `cell` (%s)!"):format(cell) )
  local key = cell.key
  ---@class map.pathpoint
  local obj = {
    key   = key,   ---@type string
    cell  = cell,  ---@type map.cell
    val   = val,   ---@type number
    from  = nil,   ---@type map.pathpoint
  }
  return obj
end


-- -- -- >>> функціонал

local function setColor(name)
  assert( color_name[name], ("Color `%s` is missing!"):format(name) )
  love.graphics.setColor(color_name[name])
end

local function getRadius(k)
  assert( k, ("Wrong argument `k` (%s)!"):format(k) )
  local val = math.floor(math.min(tWidth, tHeight) * .5) * k
  return val, val * 4
end
local function getCell(gx,gy)
  if not cGrid[gy] then return nil end
  return cGrid[gy][gx]
end
local function getRandomCell()
  return cGrid[math.random(height)][math.random(width)]
end

local function initPoolTiles(max)
  local list = {}
  for key, value in pairs(tRate) do
    list[#list+1] = key
    list[#list+1] = value
  end
  local pool = {}
  assert( #list > 0, "No pattern has given!" )
  for i = 1, #list, 2 do
    local tile, count = list[i], list[i+1]
    assert( type(tile) == "string",  ("The `tile` (%s) should be a `string`"):format(tile)    )
    assert( type(count) == "number", ("The `count` (%s) should be a `number`!"):format(count) )
    for f = 1, count
    do pool[#pool+1] = tile end
  end
  local i = 1
  while max > i do
    pool[#pool+1] = pool[i]
    i = i + 1
  end
  return pool
end
local function initNearest()
  for y = 1, height do for x = 1, width do
    local cell = cGrid[y][x]
    cell.nlist[#cell.nlist+1] = getCell(x-1, y)
    cell.nlist[#cell.nlist+1] = getCell(x+1, y)
    cell.nlist[#cell.nlist+1] = getCell(x, y-1)
    cell.nlist[#cell.nlist+1] = getCell(x, y+1)
  end end
end

local function drawTile(cell) ---@param cell map.cell
  assert( cell, ("Wrong argument `cell` (%s)!"):format(cell) )
  setColor(cell.tile)
  love.graphics.rectangle("fill", cell.sx,cell.sy, tWidth-1, tHeight-1)
end
local function drawUnit(unit) ---@param unit map.unit
  setColor(unit.team)
  love.graphics.circle("fill", unit.x,unit.y, getRadius(.9))
end
local function drawUnitSelet(unit) ---@param unit map.unit
  setColor("white")
  love.graphics.circle("line", unit.cell_pos.hx,unit.cell_pos.hy, getRadius(.9))
end


-- >> пошук шляху

---unit > pathpoint
---@param unit map.unit
---@param cell map.cell
local function drawPathLine(unit, cell)
  local pp = unit.pp_grid[cell.key]
  if not cell.unit then
    setColor("white")
    love.graphics.print(tostring(pp.val), cell.hx-28,cell.hy+10)
  end
  setColor(unit.team)
  while pp do
    local x,y = pp.cell.hx, pp.cell.hy
    love.graphics.circle(unit.mov >= pp.val and "fill" or "line", x,y, getRadius(.25))
    pp = pp.from
  end
end
---unit > pathpoint
---@param unit map.unit
local function drawPathGrid(unit)
  setColor("pp_grid")
  for key, pp in pairs(unit.pp_grid) do if unit.mov >= pp.val then
    local x,y = pp.cell.sx, pp.cell.sy
    love.graphics.rectangle("fill", x,y, tWidth, tHeight)
  end end
end
---unit > pathpoint
---@param unit map.unit
---@param cell map.cell
local function getCost(unit, cell)
  assert( unit, ("getCost(unit|%s, cell|%s)"):format(unit, cell) )
  assert( cell, ("getCost(unit|%s, cell|%s)"):format(unit, cell) )
  local impass = unit.mov + 1
  if cell.unit then
    -- print( unit == cell.unit, cell.key )
    if cell.unit ~= unit
    then return impass end
  end
  if cell.tile == "water" then return 2 end
  return 1
end
---unit > pathpoint
---@param unit map.unit
---@param cell map.cell
---@return map.pathpoint
local function getUnitPathPt(unit, cell)
  assert(unit, ("getUnitPathPt(%s, %s)"):format(unit, cell))
  assert(cell, ("getUnitPathPt(%s, %s)"):format(unit, cell))
  return unit.pp_grid[cell.key]
end
---unit > pathpoint
---@param pp map.pathpoint
---@param val number
---@param from map.pathpoint
---@return map.cell|nil
local function setPtVal(pp, val, from)
  assert( pp,  ("Wrong argument `pp` (%s)!"):format(pp)   )
  assert( val, ("Wrong argument `val` (%s)!"):format(val) )
  if not pp.val then pp.val = val + 1 end
  if pp.val > val then
    pp.val = val
    pp.from = from
    return pp.cell
  end
  return nil
end
---грядка значень для пошуку шляху
---@param unit map.unit   # для кого грядка
---@param cell map.cell?  # не вказувати, якщо грядка з нуля
local function getUnitPathGrid(unit, cell)
  assert(unit, ("getUnitPathGrid(unit, cell)"):format(unit, cell))

  local cell_from = cell
  local pp_from
  if cell then
    pp_from = unit.pp_grid[cell.key]
  else
    cell_from = unit.cell_pos
    pp_from = newPathPt(cell_from, 0)
  end

  local check_list  = { cell_from }                  ---@type map.cell[]
  local pp_grid     = { [cell_from.key] = pp_from }  ---@type table<string, map.pathpoint>

  -- local cell_from
  local i = 1
  while check_list[i] do
    cell_from  = check_list[i]
    pp_from    = pp_grid[cell_from.key]
    for index, cell_into in ipairs(cell_from.nlist) do
      if not pp_grid[cell_into.key]
      then pp_grid[cell_into.key] = newPathPt(cell_into) end
      local pp_into = pp_grid[cell_into.key]
      local val_into = pp_from.val + getCost(unit, cell_into)
      check_list[#check_list+1] = setPtVal(pp_into, val_into, pp_from)
    end
    i = i + 1
  end

  latest_grid = check_list
  return pp_grid, cell
end
---оновлення шляху для усіх юнітів
local function initPathGridAll()
  for i, u in ipairs(uList)
  do u.pp_grid = getUnitPathGrid(u) end
end


-- >> переміщення

-- todo >>

local function newUnitUpdMov(unit, cell)
  assert(unit, ("newUpdMov(%s, %s)"):format(unit, cell))
  assert(cell, ("newUpdMov(%s, %s)"):format(unit, cell))

  ---@class map.upd.mov
  local obj = {
    unit = unit,   ---@type map.unit
    pp_list = {},  ---@type map.pathpoint[]
    dt_list = {},  ---@type number[]
    dt      = 0,
  }

  local pp_into = getUnitPathPt(unit, cell)
  while pp_into.from do
    obj.pp_list[#obj.pp_list+1] = pp_into
    pp_into = pp_into.from
  end

  for i, pp in ipairs(obj.pp_list)
  do obj.dt_list[i] = pp.val * dt_val end

  return obj
end
local function setUnitMovement(unit, cell) ---@param unit map.unit
  updmov_list[#updmov_list+1] = newUnitUpdMov(unit, cell)
  unit.cell_pos = cell
end
local function updMov(item, dt) ---@param item map.upd.mov
  item.dt = item.dt + dt
  -- todo
end
local function updItemsAll(dt) end

-- todo <<


-- >>

local function drawHover()
  local cell = getCell(toGrid(love.mouse.getPosition()))
  local unit
  if cell then
    unit = cell.unit
    love.graphics.setColor(1,1,1, .25)
    love.graphics.rectangle("fill", cell.sx,cell.sy, tWidth-1, tHeight-1)
  end
  if unit and not uSelected then
    drawPathGrid(unit)
  end
end


-- >> тест



-- -- -- >>> головняк

local main = {}

function main.tileRate(plain, water)
  assert(plain >= 0, "No negative numbers allowed!")
  assert(water >= 0, "No negative numbers allowed!")
  tRate.plain = plain or 0
  tRate.water = water or 0
  local check_sum = tRate.plain + tRate.water
  assert(check_sum ~= 0, "Pattern is empty!")
end
function main.newGrid(w,h)
  assert( w, ("Wrong argument `w` (%s)!"):format(w) )
  assert( h, ("Wrong argument `h` (%s)!"):format(w) )
  width, height = w, h
  cGrid = {}
  for gy = 1, h do
    cGrid[gy] = {}
    for gx = 1, w
    do cGrid[gy][gx] = newCell(gx,gy) end
  end
  initNearest()
  uList = {}
end
function main.newGridRandom(w,h)
  assert( w, ("Wrong argument `w` (%s)!"):format(w) )
  assert( h, ("Wrong argument `h` (%s)!"):format(w) )
  width, height = w, h
  local pool = initPoolTiles(w*h)
  cGrid = {}
  for gy = 1, h do
    cGrid[gy] = {}
    for gx = 1, w do
      local tile = table.remove(pool, math.random(#pool))
      cGrid[gy][gx] = newCell(gx,gy, tile)
    end
  end
  initNearest()
  uList = {}
end
function main.addUnit(team, mov, x,y)
  local cell
  if x and y then
    cell = getCell(x,y)
  else
    repeat cell = getRandomCell()
    until not cell.unit
  end
  assert(cell, "The `cell` is missing!")
  local unit = newUnit(team, mov, cell)
  cell.unit, unit.cell_pos = unit, cell
  uList[#uList+1] = unit
  initPathGridAll()
end
function main.draw()
  -- грядка
  for gy, list in ipairs(cGrid) do for gx, cell in ipairs(cGrid[gy]) do
    drawTile(cell)
  end end
  -- юніти
  for index, unit in ipairs(uList)
  do drawUnit(unit) end
  -- шляхогрядка юніта
  if uSelected then
    local mouse_cell = getCell(toGrid(love.mouse.getPosition()))
    if mouse_cell
    then drawPathLine(uSelected, mouse_cell) end
    drawPathGrid(uSelected)
    drawUnitSelet(uSelected)
  end
  -- підсвітка
  drawHover()
  -- 
end
function main.update(dt)
  updItemsAll(dt)
end
function main.select()
  local x, y = love.mouse.getPosition()
  cSelected = getCell(toGrid(x,y))

  if cSelected then if uSelected then
    -- uSelected.pp_grid, uSelected.cell_into = getUnitPathGrid(uSelected, cSelected)
    setUnitMovement(uSelected, cSelected)
  else
    uSelected = cSelected.unit
    if uSelected
    then uSelected.pp_grid, uSelected.cell_into = getUnitPathGrid(uSelected) end
  end end
end
function main.deselect()
  if uSelected then
    uSelected.pp_grid, uSelected.cell_into = getUnitPathGrid(uSelected)
    uSelected = nil
  end
end


-- -- -- >>>

return main