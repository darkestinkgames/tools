love.graphics.setBackgroundColor( .08, .08, .08 )

local map = require 'code/map3'

-- -- -- >>>

function love.load(...)
  map.random(12,12)
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
