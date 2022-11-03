function love.conf(t)
  -- t.version = 11.4
  t.window.resizable = true
  t.window.title = ('NoName // %s / LÖVE %s'):format(_VERSION, t.version)
  -- t.window.width = nil
  -- t.window.height = nil
  t.window.minwidth = 400
  t.window.minheight = 200
end