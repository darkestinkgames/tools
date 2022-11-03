love.graphics.setBackgroundColor( .08, .08, .08 )

local circle = love.graphics.circle

local point2d = require 'code/point2d'

local a = point2d.new(5,5)
local b = point2d.new(7,7)
local c = a + b - 2 * 2 / 2 ^ 2
local degree = 45


-- -- -- >>>

function love.load(...)
end
function love.draw()
  circle("fill", a.x,a.y, 16)
  circle("line", b.x,b.y, 8)
  circle("line", c.x,c.y, 4)

  love.graphics.push()
  love.graphics.translate(a:get())
  love.graphics.rotate(degree * math.pi / 180)
  circle("line", 30,0, 4)
  love.graphics.pop()
end
function love.update(dt)
end
function love.keypressed(key)
  if key == 'escape' then love.event.push('quit') end
end
function love.mousepressed(x, y, button, istouch, presses)
  if button == 1 then
    b:set(x,y)
  end
  if button == 2 then
    a:set(x,y)
  end
  print(point2d.length(a,b), point2d.degree(a,b))
  c = point2d.byDegree(a, degree, 100)
end
function love.wheelmoved( x , y )
end
function love.resize(w, h)
end


-- -- -- >>>

-- 
