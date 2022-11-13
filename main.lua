love.graphics.setBackgroundColor( .08, .08, .08 )


local map = (require 'map/init')

-- -- -- >>>

function love.load(...)
  map = map.new(11,9)
end
function love.draw()
  map:draw()
end
function love.update(dt)
  map:update(dt)
end
function love.keypressed(key)
  if key == 'escape' then love.event.push('quit') end
end
function love.mousepressed(x, y, button, istouch, presses)
  if button == 1 then
  end
  if button == 2 then
  end
  map:click(x, y, button, istouch, presses)
end
function love.wheelmoved( x , y )
end
function love.resize(w, h)
end

-- -- -- >>>

-- local curv = require 'test/move_curva'
