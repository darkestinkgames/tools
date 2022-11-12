local circle    = love.graphics.circle
local setColor  = love.graphics.setColor



local main = {}



local posX, posY = 0, 0

local dur, cd = 1, 0
local vertices = { posX, posY }

local curve, render, k



local function reset()
  for  i in ipairs(vertices)
  do   vertices[i] = nil end
end

local function isLoop()
  return cd > dur or 0 > cd
end

local function clamp()
  return math.max(0, math.min(dur, cd))
end

local function cdReset()
  cd = cd % dur
end

local function drawGrid(tileW,tileH)
  for y = 0, love.graphics.getHeight(), tileH do for x = 0, love.graphics.getWidth(), tileW do
    circle("fill", x,y, 2)
  end end
end



function main.update(dt)
  if curve then
    cd = cd + dt
    if isLoop() then
      k = 1
      posX,posY = curve:evaluate(k)
      cdReset()
      reset()
      main.add(posX,posY)
      curve = nil
    else
      k = (cd / dur)
      posX,posY = curve:evaluate(k)
    end
  end
end

function main.draw()
  -- грядка
  drawGrid(48,48)
  -- лінія
  if #vertices > 3 then
    love.graphics.line(vertices)
  end
  -- 
  setColor(1,1,1)
  -- 
  if curve then
    love.graphics.line(render)
  end
  circle("fill", posX,posY, 16)
  setColor(1, 1, 1, .35)
  for i = 1, #vertices, 2 do
    local x,y = vertices[i], vertices[i+1]
    circle("fill", x,y, 4)
  end
end

function main.add(x,y)
  local a = vertices[#vertices-1]
  if a then
    local b = vertices[#vertices]
    vertices[#vertices+1] = (a + x) / 2
    vertices[#vertices+1] = (b + y) / 2
  end
  vertices[#vertices+1] = x
  vertices[#vertices+1] = y
end

function main.set(x,y)
  main.add(x,y)
  curve = love.math.newBezierCurve(vertices)
  render = curve:render()
end




------------------- { - } --------------------

function love.draw()
  main.draw()
end


function love.update(dt)
  main.update(dt)
end

function love.mousepressed(x, y, button, istouch, presses)
  if button == 1
  then
    main.set(x,y)
  end
  if button == 2
  then
    main.add(x,y)
  end
end



-- return main
