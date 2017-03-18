local gameover = {}
local G = love.graphics
local go = "Game over!"
local font = G.getFont()
function gameover:update(dt)
end


function gameover:draw()
	love.graphics.draw(sh_img,0,0)
	love.graphics.print(go,G.getWidth() /2 - font:getWidth(go) , G.getHeight()/2)
	

end

function gameover:keypressed(key)
	if key == "escape" then
		state = 1
	end
end
return gameover