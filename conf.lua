function love.conf(t)
  	t.identity = "flight"
  	t.externalstorage = true
  	t.accelerometerjoystick = true
  	t.window.width = 1280    																		
    t.window.height = 960
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.modules.touch = true 
    t.window.title = "Flight" 
    t.window.msaa = 6
    t.console = true

end