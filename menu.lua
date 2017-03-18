local menu = {}
local planet = love.graphics.newImage("assets/planet.png")
local G = love.graphics
local Menu = {
	{i1 = "S",i2 = "t", i3 = "a", i4 = "r", i5 = "t",i6 = "",i7 = "",  x = 100, y = 100,active = 1},
	{i1 = "C",i2 = "r",i3 = "e",i4 = "d",i5 = "i",i6 = "t",i7 = "s", x = 100, y = 220,active = 0},
	{i1 = "Q",i2 = "u",i3 = "i",i4 = "t",i5 = "",i6 = "",i7 = "", x = 100, y = 330,active = 0},
}

local font1 =  love.graphics.newFont("assets/6809 chargen.ttf",18)
local font2 =  love.graphics.newFont("assets/6809 chargen.ttf",80)
local sine = 0 
local j = 0
local Stars_ = {}
Stars_.amount = G.getWidth() / 2 

function addStars_(amount)

	for i=1,amount do
			
		local Size = math.random(0.3,1.5)
		local Speed = Size / 7
		local Color = math.random(200,500)
		table.insert(Stars_,{x = math.random(-500,G.getWidth()),y = math.random(-500,G.getHeight()),size = Size,is_star = math.random(0,1),speed = Speed,color = Color})
			
	end
end



function drawStars_()
	
	for i,j in ipairs(Stars_) do
			
		
		love.graphics.circle("fill",Stars_[i].x,Stars_[i].y,Stars_[i].size)
	end
end

function menu:load()

addStars_(Stars_.amount)

end

function menu:update(dt)

sine = sine + 0.0002
hp_meter = 299

end
function menu:draw()
	drawStars_()
	love.graphics.setFont(font2)
	for i,j in ipairs(Menu) do
		if Menu[i].active == 1 then
			love.graphics.setColor(100,100,255)
			
		end
		love.graphics.print(Menu[i].i1..Menu[i].i2..Menu[i].i3..Menu[i].i4..Menu[i].i5..Menu[i].i6..Menu[i].i7,Menu[i].x,Menu[i].y)
		love.graphics.setColor(255,255,255)
		
	end
	love.graphics.setFont(font1)
 	love.graphics.draw(planet,0,G.getHeight(),sine,1,1,planet:getWidth()/1.959,planet:getHeight()/2)
end

function menu:keypressed(key)

	if key == "escape" then
		M = 0
	end

	if key == "up" then
		if Menu[1].active == 0 then
			if Menu[2].active == 0 then
				Menu[1].active = 0
				Menu[2].active = 1
				Menu[3].active = 0
			else
			Menu[1].active = 1
			Menu[2].active = 0
			Menu[3].active = 0
			end
		end

	elseif key == "down" then
		if Menu[3].active == 0 then
			if Menu[2].active == 0 then
				Menu[1].active = 0
				Menu[2].active = 1
				Menu[3].active = 0
			else
			Menu[1].active = 0
			Menu[2].active = 0
			Menu[3].active = 1
			end
		end
	end

	if key == "return" then
		if Menu[1].active == 1 then
			state = 2
		elseif Menu[2].active == 1 then

		elseif Menu[3].active == 1 then
			state = "Quit"
		end
	end
end

return menu