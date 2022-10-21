love.graphics.setBackgroundColor( .08, .08, .08 )

local map = require 'code/map'

-- -- -- >>>

function love.load(...)
  map.new(10,8)
  map.addUnit(1, 4)
  map.addUnit(1, 5)
  map.addUnit(2, 4)
  map.addUnit(2, 5)
end
function love.draw()
  map.draw()
end
function love.update(dt)
  map.update(dt)
end
function love.keypressed(key)
  if key == 'escape' then love.event.push('quit') end
end
function love.mousepressed(x, y, button, istouch, presses)
  if button == 1 then map.select() end
  if button == 2 then map.deselect() end
end
function love.wheelmoved( x , y )
end
function love.resize(w, h)
end


-- -- -- >>>

-- 
