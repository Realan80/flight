local game = require("game")
local menu = require("menu")
local gameover = require("gameover")


state = 1 
math.randomseed(os.time())

function love.load()
	
	min_dt = 1/60
    next_time = love.timer.getTime()

	menu:load()
	game:load()


end

function love.update(dt)
	
	next_time = next_time + min_dt
	
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

	local cur_time = love.timer.getTime()
    if next_time <= cur_time then
  	    next_time = cur_time
  		return
    end
    love.timer.sleep(next_time - cur_time)
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
function love.keyreleased(key)
	if state == 2 then
		game:keyreleased(key)
	end
end
