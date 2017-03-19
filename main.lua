local game = require("game")
local menu = require("menu")
local gameover = require("gameover")
state = 1 
math.randomseed(os.time())

function love.load()

	menu:load()
	game:load()

end

function love.update(dt)
	if state == 1 then 
		menu:update(dt)
	elseif state == 2 then 
		game:update(dt)
	elseif state == 3 then
		gameover:update(dt)
	elseif state == "Quit" then
		love.event.quit()
	end
end

function love.draw()
	if state == 1 then 
		menu:draw()
	elseif state == 2 then 
		game:draw()
	elseif state == 3 then
		gameover:draw()
	elseif state == 4 then
		game:draw()
	end
end
function love.keypressed(key)
	if state == 1 then 
		menu:keypressed(key)
	elseif state == 2 then
		game:keypressed(key)
	elseif state == 3 then
		gameover:keypressed(key)
	elseif state == 4 then
		game:keypressed(key)
	end
end
