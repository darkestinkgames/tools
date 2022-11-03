love.graphics.setBackgroundColor( .08, .08, .08 )

local point2d = require 'code/point2d'

local a = point2d.new(5,5)
local b = point2d.new(7,7)
local c = a + b - 2 * 2 / 2 ^ 2


-- -- -- >>>

function love.load(...)
end
function love.draw()
end
function love.update(dt)
end
function love.keypressed(key)
  if key == 'escape' then love.event.push('quit') end
end
function love.mousepressed(x, y, button, istouch, presses)
end
function love.wheelmoved( x , y )
end
function love.resize(w, h)
end


-- -- -- >>>

-- 
