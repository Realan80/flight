local collision = require("collision")
local psystems = require("psystems")

local game = {}

local player_img = love.graphics.newImage("assets/fighter1.png")
local sheild_img = love.graphics.newImage("assets/sheild.png")
local font1 =  love.graphics.newFont("assets/6809 chargen.ttf",18)
local player_img2 = love.graphics.newImage("assets/player_img2.png")
local player_img3 = love.graphics.newImage("assets/player_img3.png")
local asteroid1 = love.graphics.newImage("assets/asteroid1.png")
local alien1 = love.graphics.newImage("assets/alienshiptex.png")
local missile = love.graphics.newImage("assets/missile.png")
local gui = love.graphics.newImage("assets/gui.png")
love.graphics.setFont(font1)

count = 0
local wave_form = 1
	  hp_meter = 299
local energy_meter = 299
local energy_multiplier = 10
local G = love.graphics
local pi = math.pi
local anim = 0
 damage = 0
 income = 0
 player = {
		shooting = {},
		 gun1 = {},
		 gun2 = {},
		 gun3 = {},
		 gun4 = {}
		}

player.shooting.cooloff = 0.17
player.shooting.time = 1
player.shooting.speed = 1000
player.speed = 300
player.size = 0.13
player.pos = {}
player.pos.x = G.getWidth() / 2
player.pos.y = G.getHeight() - 150
player.left = 0
player.right = 0
player.gun4.left = 1
player.gun1.damage = 10
player.gun2.damage = 10
player.gun3.damage = 150
player.gun4.damage = 75
player.gun4.area_x = 100
player.gun4.area_y = 100
player.gun4.energy_usage = 12.5
player.gun3.energy_usage = 50
player.gun1.energy_usage = 0.5
player.gun2.energy_usage = 0.5
player.gun4.hit_range = 1
player.hitbox_x = 15
player.hitbox_y = 20
player.sheild = 0
player.sheild_animation = 50
player.sheild_incr = 0
player.sheild_energy = 299
player.sheild_cooldown = 0
player.weapon = 1

	-- Stores explosions from exploding weapons
	 explosion = {}
	 draw_explosions = {}

	-- Creates a Table to put stars in
	local Stars = {}
	Stars.amount = G.getWidth() / 3 

	-- Creats a table for animating an asteroid
	local Asteroid = {
		pos = {},

		{animate = love.graphics.newQuad(0,0,72,72, asteroid1:getDimensions())},
		{animate = love.graphics.newQuad(72,0,72,72, asteroid1:getDimensions())},
		{animate = love.graphics.newQuad(144,0,72,72, asteroid1:getDimensions())},
		{animate = love.graphics.newQuad(216,0,72,72, asteroid1:getDimensions())},
		{animate = love.graphics.newQuad(288,0,72,72, asteroid1:getDimensions())},
		{animate = love.graphics.newQuad(0,72,72,72, asteroid1:getDimensions())},
		{animate = love.graphics.newQuad(72,72,72,72, asteroid1:getDimensions())},
		{animate = love.graphics.newQuad(144,72,72,72, asteroid1:getDimensions())},
		{animate = love.graphics.newQuad(216,72,72,72, asteroid1:getDimensions())},
		{animate = love.graphics.newQuad(288,72,72,72, asteroid1:getDimensions())},
		{animate = love.graphics.newQuad(0,144,72,72, asteroid1:getDimensions())},
		{animate = love.graphics.newQuad(72,144,72,72, asteroid1:getDimensions())},
		{animate = love.graphics.newQuad(144,144,72,72, asteroid1:getDimensions())},
		{animate = love.graphics.newQuad(216,144,72,72, asteroid1:getDimensions())},
		{animate = love.graphics.newQuad(288,144,72,72, asteroid1:getDimensions())},
		{animate = love.graphics.newQuad(0,216,72,72, asteroid1:getDimensions())},
		{animate = love.graphics.newQuad(72,216,72,72, asteroid1:getDimensions())},
		{animate = love.graphics.newQuad(144,216,72,72, asteroid1:getDimensions())},
		{animate = love.graphics.newQuad(216,216,72,72, asteroid1:getDimensions())}
		}
	
	Asteroid.angle = 0
	Asteroid.startpos_x = 0
	Asteroid.speed = G.getHeight() / 20
	Asteroid.rad = 0
	Asteroid.worth = 15
	local Alien = {
		pos = {}
	}
	
	Alien.angle = 0
	Alien.startpos_x = 0
	Alien.speed = G.getHeight() / 5
	Alien.rad = 0
	Alien.size = 0.1
	Alien.worth = 25
	enemy = {
	pos = {},
	id = {}
	}

function reset()  -- Resets all values and tables on player death
	for reset_loop = 1, #enemy do
		for i,j in ipairs(Asteroid.pos) do
			table.remove(Asteroid.pos,i)
		end
		for i,j in ipairs(Alien.pos) do
			table.remove(Alien.pos,i)
		end
		for i,j in ipairs(enemy.pos) do
			table.remove(enemy.pos,i)
		end
		for i,j in ipairs(enemy.id) do
			table.remove(enemy.id,i)
		end
		for i,j in ipairs(enemy) do
			table.remove(enemy,i)
		end
	end
	Asteroid.angle = 0
	Asteroid.startpos_x = 0
	Asteroid.speed = G.getHeight() / 20
	Asteroid.rad = 0
	Asteroid.worth = 15
	Alien.angle = 0
	Alien.startpos_x = 0
	Alien.speed = G.getHeight() / 5
	Alien.rad = 0
	Alien.size = 0.1
	Alien.worth = 25
	player.shooting.cooloff = 0.17
	player.shooting.time = 1
	player.shooting.speed = 1000
	player.speed = 300
	player.size = 0.13
	player.pos = {}
	player.pos.x = G.getWidth() / 2
	player.pos.y = G.getHeight() - 150
	player.left = 0
	player.right = 0
	player.gun1.damage = 10
	player.gun2.damage = 10
	player.gun3.damage = 150
	player.hitbox_x = 15
	player.hitbox_y = 20
	player.sheild = 0
	player.sheild_animation = 50
	player.sheild_incr = 0
	player.weapon = 1
	income = 0
	hp_meter = 299
	energy_meter = 299
end

function spawn_random_enemy(rate)

	local spawnRate = math.random(0,rate)
	
	if spawnRate > 0 and spawnRate < 100 then
		Hp = math.random(75,125)
		Asteroid.startpos_x = math.random(0,G.getWidth())
		Asteroid.endpos_x = math.random(0,G.getWidth())
		Asteroid.angle = math.atan2(G.getHeight(),Asteroid.endpos_x - Asteroid.startpos_x) 
		local Cos = math.cos(Asteroid.angle)
		local Sin = math.sin(Asteroid.angle)
		local Rnd = math.random(1,19)
		table.insert(enemy,{x = Asteroid.startpos_x, y = -30, r = 0,size = 1,cos = Cos, sin = Sin,hp = Hp,alive = 1,rnd = Rnd, dim_x = 34, dim_y = 32,gfx = asteroid1, quad = Asteroid[Rnd].animate, gfx_w = 36, gfx_h = 36, hp = Hp, alive = 1,id = "Asteroid", damage = 15,worth = math.floor(Hp / 10)} )
	end

	if spawnRate > 100 and spawnRate < 150 then
		Alien.startpos_x = math.random(0,G.getWidth())
	    Alien.angle = math.atan2(player.pos.y,player.pos.x - Alien.startpos_x) 
		local Cos = math.cos(Alien.angle)
		local Sin = math.sin(Alien.angle)
		local Hp = 50
		local Rnd = math.random(1,19)
		table.insert(enemy,{x = Alien.startpos_x, y = -30, r = Alien.angle,size = .1,cos = Cos, sin = Sin,hp = Hp,alive = 1,rnd = Rnd, dim_x = 34, dim_y = 32,gfx = alien1,gfx_w = alien1:getWidth() / 2, gfx_h = alien1:getHeight() / 2,  hp = Hp, alive = 1, id = "Alien", damage = 20,worth = math.floor(Hp / 10)} )
	end	
end



function player_input(dt) -- Handles the keyboard.isDown to make the player move

	if love.keyboard.isDown("lctrl") then
		if player.weapon == 1 then		
			player.shooting.time = player.shooting.time + dt
			if player.shooting.time > player.shooting.cooloff then
		 		table.insert(player.gun1,{x = player.pos.x - player_img:getWidth() / 6 * player.size, y = player.pos.y-player_img:getHeight()/90,lum = 255,can_hit = 1 })
		 		table.insert(player.gun2,{x = player.pos.x + player_img:getWidth() / 6 * player.size, y = player.pos.y-player_img:getHeight()/90,lum = 255,can_hit = 1 })
		 		player.shooting.time = 0
		 		energy_meter = energy_meter - player.gun1.energy_usage - player.gun2.energy_usage
			end
		elseif player.weapon == 2 and energy_meter > player.gun3.energy_usage then 
			player.shooting.time = player.shooting.time + dt /5
			if player.shooting.time > player.shooting.cooloff then
		 		table.insert(player.gun3,{x = player.pos.x , y = player.pos.y-player_img:getHeight()/90,lum = 255,can_hit = 1 })
		 		player.shooting.time = 0
		 		energy_meter = energy_meter - player.gun3.energy_usage 
			end
		elseif player.weapon == 3 and energy_meter > player.gun4.energy_usage then 
			player.shooting.time = player.shooting.time + dt /2
			if player.shooting.time > player.shooting.cooloff then
				if player.gun4.left == 1 then
		 			table.insert(player.gun4,{x = player.pos.x - 20 , y = player.pos.y-player_img:getHeight()/90,startpos_y = player.pos.y-player_img:getHeight()/90, lum = 255, can_hit = 1 })
		 			player.shooting.time = 0
		 			player.gun4.left = 0
		 		elseif player.gun4.left == 0 then
		 			table.insert(player.gun4,{x = player.pos.x + 20 , y = player.pos.y-player_img:getHeight()/90, startpos_y = player.pos.y-player_img:getHeight()/90, lum = 255, can_hit = 1 })
		 			player.shooting.time = 0
		 			player.gun4.left = 1
		 		end
			end
		end
	end

	if love.keyboard.isDown("a") or love.keyboard.isDown("left")  then 
		 
		if player.pos.x > player_img:getWidth() * 0.05  then
			player.pos.x = player.pos.x - dt * player.speed
			player.left = 1
		end	
	end
	
	if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
		if player.pos.x < G.getWidth() - player_img:getWidth() * 0.05  then
			player.pos.x = player.pos.x + dt * player.speed 
			player.right = 1
		end
	end

	if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
		
		psystem1:setLinearAcceleration(-1200,0,1200,15000)
		psystem2:setLinearAcceleration(-1500,0,1500,16000) 
		
		if player.pos.y > player_img:getHeight() * 0.16  then
			player.pos.y = player.pos.y - dt * player.speed 
		end
	end

	if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
		
		psystem1:setLinearAcceleration(-800,0,800,2500)
		psystem2:setLinearAcceleration(-900,0,900,4000) 

		if player.pos.y < G.getHeight() - 80 - player_img:getHeight() * 0.13  then
			player.pos.y = player.pos.y + dt * player.speed 
		end
	end

	if not love.keyboard.isDown("s") and not love.keyboard.isDown("down") and not love.keyboard.isDown("w") and not love.keyboard.isDown("up") then
		psystem1:setLinearAcceleration(-900,0,900,8000)
		psystem2:setLinearAcceleration(-1100,0,1100,9000) 
	end

	if love.keyboard.isDown("y") then
		Asteroid.startpos_x = math.random(0,G.getWidth())
		Asteroid.endpos_x = math.random(0,G.getWidth())
	    Asteroid.angle = math.atan2(G.getHeight(),Asteroid.endpos_x - Asteroid.startpos_x) 
		local Cos = math.cos(Asteroid.angle)
		local Sin = math.sin(Asteroid.angle)
		local Hp = 150
		local Rnd = math.random(1,19)
		table.insert(enemy,{x = Asteroid.startpos_x, y = -30, r = 0,size = 1,cos = Cos, sin = Sin,hp = Hp,alive = 1,rnd = Rnd, dim_x = 34, dim_y = 32,gfx = asteroid1, quad = Asteroid[Rnd].animate, gfx_w = 36, gfx_h = 36, hp = Hp, alive = 1,id = "Asteroid", damage = 15,worth = math.floor(Hp / 10)} )
	end
end

function addStars(amount)

	for i=1,amount do
			
		local Size = math.random(.4,1.5)
		local Speed = Size / 7
		local Color = math.random(200,500)
		table.insert(Stars,{x = math.random(1,G.getWidth()),y = math.random(1,G.getHeight()),size = Size,is_star = math.random(0,1),speed = Speed,color = Color})
	end
end

function drawPlayer()
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(psystem2, player.pos.x - player_img:getWidth() / 10.5 * player.size  , player.pos.y + player_img:getWidth()/2.5 * player.size)
	love.graphics.draw(psystem2, player.pos.x + player_img:getWidth() / 10.5 * player.size  , player.pos.y + player_img:getWidth()/2.5 * player.size)
	love.graphics.draw(psystem1, player.pos.x - player_img:getWidth() / 10.5 * player.size  , player.pos.y + player_img:getWidth()/2.5 * player.size)
	love.graphics.draw(psystem1, player.pos.x + player_img:getWidth() / 10.5 * player.size  , player.pos.y + player_img:getWidth()/2.5 * player.size)
	love.graphics.draw(player_img,player.pos.x,player.pos.y,math.pi*1.5,player.size,player.size,player_img:getWidth() /2,player_img:getHeight() /2 )
	
	if player.right == 1 then
		love.graphics.draw(player_img2,player.pos.x,player.pos.y,math.pi*1.5,player.size,player.size,player_img:getWidth() /2,player_img:getHeight() /2 )
	end

	if player.left == 1 then
		love.graphics.draw(player_img3,player.pos.x,player.pos.y,math.pi*1.5,player.size,player.size,player_img:getWidth() /2,player_img:getHeight() /2 )
	end

	if player.sheild == 1 then
		if player.sheild_incr == 1 then
			player.sheild_animation = player.sheild_animation + 0.7
		elseif player.sheild_incr == 0 then
			player.sheild_animation = player.sheild_animation - 0.7
		end

		if player.sheild_animation >= 75 and player.sheild_incr == 1 then
		player.sheild_incr = 0
		end

		if player.sheild_animation <= 25 and player.sheild_incr == 0 then
			player.sheild_incr = 1
		end
		
		love.graphics.setColor(90,90,205,player.sheild_animation)
		love.graphics.draw(sheild_img,player.pos.x - player_img:getWidth() / G.getWidth() / 2,player.pos.y - player_img:getHeight() / G.getHeight() /2,0,.75,.75,sheild_img:getWidth()/2,sheild_img:getHeight() /2 )
	end
end

function update_player_sheild(dt)
	
	if player.sheild_cooldown > 0 then
		player.sheild_cooldown = player.sheild_cooldown - dt
		if player.sheild_cooldown < 0 then
		player.sheild_cooldown = 0
		end
	end
	
	if player.sheild_energy <= 0 then
		player.sheild = 0
		player.sheild_energy = 299
		player.sheild_cooldown = 30
	end
	
	if player.sheild == 1 then
		player.sheild_energy = player.sheild_energy - 0.5
	end
end

function player_gui(gotDamage,hp)
	
	love.graphics.setColor(255,255,255)
	love.graphics.print("FPS: " .. love.timer.getFPS(), 1, 1,0) 
	hp_meter = hp_meter - gotDamage * 3
	if hp_meter <= 0 then
		hp_meter = 0
		deathscreen = love.graphics.newScreenshot()
		sh_img = love.graphics.newImage(deathscreen)
		reset()
		state = 3
	end

	if energy_meter >= 299 then
		energy_meter = 299
	
	elseif	energy_meter <= 0 then
		energy_meter = 0
	end

	if player.sheild == 1 then
		love.graphics.setColor(150,105,255,120)
		love.graphics.rectangle("fill",G.getWidth()-310,G.getHeight()/1.07,player.sheild_energy ,18)
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("Energy sheild (Active)",G.getWidth()-310,G.getHeight()/1.075)
	else
		love.graphics.setColor(50,50,50,120)
		love.graphics.rectangle("fill",G.getWidth()-310,G.getHeight()/1.07,player.sheild_energy ,18)
		if player.sheild_cooldown <= 0 then
			love.graphics.setColor(255,255,255,255)
			love.graphics.print("Energy sheild (Ready)",G.getWidth()-310,G.getHeight()/1.075)
		else 
			love.graphics.setColor(255,255,255,255)
			love.graphics.print("Energy sheild (Cooldown "..math.floor(player.sheild_cooldown)..")",G.getWidth()-310,G.getHeight()/1.075)
		end
	end

	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Credits " .. income,G.getWidth()/2 - string.len("Credits") * 6.5,G.getHeight()/1.03)
	love.graphics.setColor(255,255,255,120)
	love.graphics.rectangle("line",G.getWidth()-310,G.getHeight()/1.041,300,20)
	love.graphics.rectangle("line",G.getWidth()-310,G.getHeight()/1.071,300,20)
	love.graphics.rectangle("line",10,G.getHeight()/1.041,300,20)
	love.graphics.setColor(150,255,150,120)
	love.graphics.rectangle("fill",G.getWidth()-310,G.getHeight()/1.04,hp_meter ,18)
	love.graphics.setColor(150,105,255,120)
	love.graphics.rectangle("fill",10,G.getHeight()/1.04,energy_meter ,18)
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Player health",G.getWidth()-310,G.getHeight()/1.045)
	love.graphics.print("Weapon energy",10,G.getHeight()/1.045)
	love.graphics.draw(gui, 0,G.getHeight() - 100)
	love.graphics.print("Weapon system "..player.weapon .." active", 10,G.getHeight()/1.07 )
	damage = 0 
end

function updateEnemy(dt)

	for i,j in ipairs(enemy) do
		if enemy[i].id == "Asteroid" then
			enemy[i].r = enemy[i].r + 2 * dt
			enemy[i].x = enemy[i].x + Asteroid.speed * enemy[i].cos * dt
			enemy[i].y = enemy[i].y + Asteroid.speed * enemy[i].sin * dt
			if enemy[i].r > 628 then 
 	 		enemy[i].r = 0
 			end
 		elseif enemy[i].id == "Alien" then
			enemy[i].x = enemy[i].x + Alien.speed * enemy[i].cos * dt
			enemy[i].y = enemy[i].y + Alien.speed * enemy[i].sin * dt
		end
		
		if enemy[i].y > G.getHeight() + 30 or enemy[i].x < -30 or enemy[i].x > G.getWidth() + 30 then
			table.remove(enemy,i)
		end
	end
end

function drawEnemy()
	love.graphics.setColor(255,255,255,255)
	for i=1, #enemy do
		if enemy[i].id == "Asteroid" then
			love.graphics.draw(enemy[i].gfx,enemy[i].quad, enemy[i].x, enemy[i].y,enemy[i].r,enemy[i].size,enemy[i].size,enemy[i].gfx_w,enemy[i].gfx_h)
		else
			love.graphics.draw(enemy[i].gfx, enemy[i].x, enemy[i].y,enemy[i].r,enemy[i].size,enemy[i].size,enemy[i].gfx_w,enemy[i].gfx_h)
		end
		love.graphics.rectangle("line",enemy[i].x - enemy[i].hp /5 - 1, enemy[i].y-2, enemy[i].hp /2.5 + 1, 5,2)
		love.graphics.setColor(0,255,0,255)
		love.graphics.rectangle("fill",enemy[i].x - enemy[i].hp /5, enemy[i].y-1, enemy[i].hp /2.5, 3,2)
		love.graphics.setColor(255,255,255,255)
		love.graphics.print(enemy[i].hp, enemy[i].x - string.len(enemy[i].hp)*5, enemy[i].y)
		love.graphics.setColor(255,255,255)
	end
end

function draw_enemy_death()

	for i=1, #enemy.pos do
		if enemy.pos[i].typ == "Asteroid" then 
			psystem3:setColors(255,255,255, 255, 100, 100, 100, 0) 
			love.graphics.draw(psystem3,enemy.pos[i].x, enemy.pos[i].y)
			psystem4:setColors(200,200,200, 75, 100, 100, 100, 10) 
			love.graphics.draw(psystem4,enemy.pos[i].x, enemy.pos[i].y)
		end
		if enemy.pos[i].typ == "Alien" then
			psystem5:setColors(50,50,50, 150, 50, 50, 50, 100) 
			love.graphics.draw(psystem5,enemy.pos[i].x, enemy.pos[i].y)
			psystem6:setColors(255,200,50, 50, 255, 50, 50, 10) 
			love.graphics.draw(psystem6,enemy.pos[i].x, enemy.pos[i].y)
		end
	end
end 

function update_enemy_death(dt)
	
	for i,j in ipairs(enemy.pos) do
		enemy.pos[i].delay = enemy.pos[i].delay + dt
		if enemy.pos[i].delay > P_min3  then
			enemy.pos[i].delay = 0
			table.remove(enemy.pos,i)
		end
	end
end

function update_Player_gunfire(dt)
	if #player.gun1 ~= 0 and #player.gun2 ~= 0 then
		for i,j in ipairs(player.gun1,player.gun2) do
		player.gun1[i].y = player.gun1[i].y - player.shooting.speed * dt
		player.gun2[i].y = player.gun2[i].y - player.shooting.speed * dt
			if player.gun1[i].y < 0  then
				table.remove(player.gun1,i)
			end
		
			if player.gun2[i].y < 0  then 
			 table.remove(player.gun2,i)
			end
		end
	elseif #player.gun3 ~= 0 then 
		for i,j in ipairs(player.gun3) do
			player.gun3[i].y = player.gun3[i].y - player.shooting.speed * dt * 10
			if player.gun3[i].y < -1000  then
				table.remove(player.gun3,i)
			end
		end	
	elseif #player.gun4 ~= 0 then

		for i,j in ipairs(player.gun4) do
			player.gun4[i].y = player.gun4[i].y - player.shooting.speed * dt /3
			if player.gun4[i].y < (player.gun4[i].startpos_y - G.getWidth() / 10) then
				player.gun4[i].y = player.gun4[i].y - player.shooting.speed * dt 
			end		

			if player.gun4[i].y < 0 then
				table.remove(player.gun4,i)
			end
		end	
	end
end

function update_draw_explosion(dt)
	for i,j in ipairs(draw_explosions) do
		draw_explosions[i].delay = draw_explosions[i].delay + dt
		if draw_explosions[i].delay > P_min9  then
			draw_explosions[i].delay = 0
			table.remove(draw_explosions,i)
		end
	end
end

function draw_explosion()
	for i = 1, #draw_explosions do
	--	love.graphics.rectangle("line",explosion[u].x - explosion[u].area_x,explosion[u].y - explosion[u].area_y,explosion[u].area_x * 2,explosion[u].area_y*2)
	--	love.graphics.circle("line",explosion[u].x,explosion[u].y,explosion[u].area_x)
		love.graphics.draw(psystem9,draw_explosions[i].x,draw_explosions[i].y)
	end
end

function draw_Player_gunfire()
		
	for i,j in ipairs(player.gun1,player.gun2) do
		love.graphics.setLineStyle("smooth") 
		love.graphics.setLineWidth(1.5)
		love.graphics.setColor(255,100,100,player.gun1[i].lum)
		love.graphics.line(player.gun1[i].x,player.gun1[i].y,player.gun1[i].x,player.gun1[i].y+15)
		love.graphics.setColor(255,100,100,player.gun2[i].lum)
		love.graphics.line(player.gun2[i].x,player.gun2[i].y,player.gun2[i].x,player.gun2[i].y+15)
		love.graphics.setLineWidth(1)
	end	
	
	for i=1, #player.gun3 do
		
		if player.gun3[i].y > player.pos.y - 500 then
			love.graphics.setLineStyle("smooth") 	
			love.graphics.setLineWidth(10)
			love.graphics.setColor(100,150,100,player.gun3[i].lum)
			love.graphics.line(player.gun3[i].x,player.gun3[i].y,player.gun3[i].x,player.pos.y)
			love.graphics.setLineWidth(5)
			love.graphics.setColor(100,255,100,player.gun3[i].lum)
			love.graphics.line(player.gun3[i].x,player.gun3[i].y,player.gun3[i].x,player.pos.y)
			love.graphics.setLineWidth(1)
		else 
			love.graphics.setLineStyle("smooth") 
			love.graphics.setLineWidth(10)
			love.graphics.setColor(100,150,100,player.gun3[i].lum)
			love.graphics.line(player.gun3[i].x,player.gun3[i].y,player.gun3[i].x,player.gun3[i].y + 500)
			love.graphics.setLineWidth(5)
			love.graphics.setColor(100,255,100,player.gun3[i].lum)
			love.graphics.line(player.gun3[i].x,player.gun3[i].y,player.gun3[i].x,player.gun3[i].y + 500)
			love.graphics.setLineWidth(1)
		end
	end
	
	for i=1, #player.gun4 do
		--love.graphics.setColor(255,100,255,player.gun4[i].lum)
		--love.graphics.circle("fill",player.gun4[i].x,player.gun4[i].y,20)
		love.graphics.setColor(255,255,255,player.gun4[i].lum)
		love.graphics.draw(psystem8,player.gun4[i].x,player.gun4[i].y+20)
		love.graphics.draw(psystem7,player.gun4[i].x,player.gun4[i].y+20)
		love.graphics.draw(missile,player.gun4[i].x,player.gun4[i].y,0,0.07,0.07,missile:getWidth()/2,missile:getHeight()/2)
	end	
	love.graphics.setColor(255,255,255)
end

function drawStars()
	for i=1, #Stars do
		love.graphics.setColor(200,200,Stars[i].color,180)
		love.graphics.circle("fill",Stars[i].x,Stars[i].y,Stars[i].size)
	end
end

function updateStars(dt)
	for i=1, #Stars do
		Stars[i].y = Stars[i].y + Stars[i].speed
		if Stars[i].y > G.getHeight() then
			Stars[i].y = 1
		end
	end
end

function game:load()
addStars(Stars.amount)
psystems:load()
end

function game:update(dt)
	wave_form = wave_form + dt
	if wave_form > 180 / math.pi then
		wave_form = 0
	end
	energy_meter = energy_meter + dt * energy_multiplier
	updateStars(dt)
	psystem1:update(dt /2)
	psystem2:update(dt /2)
	psystem3:update(dt /2)
	psystem4:update(dt /2)
	psystem5:update(dt /2)
	psystem6:update(dt /2)
	psystem7:update(dt /2)
	psystem8:update(dt /2)
	psystem9:update(dt /2)
	psystem1:emit(40)
	psystem2:emit(40)
	psystem7:emit(40)
	psystem8:emit(40)
	psystem9:emit(1000)
	psystem3:emit(32)
	psystem4:emit(1000)
	psystem5:emit(32)
	psystem6:emit(1000)
	player_input(dt)
	spawn_random_enemy(20000)
	updateEnemy(dt)
	update_Player_gunfire(dt)
	update_enemy_death(dt)
	Collision:update(enemy,dt)
	--collision_detection(enemy)
	update_player_sheild(dt)
	update_draw_explosion(dt)
end	

function game:draw()
	
	 drawStars()
	 drawEnemy()
	 draw_enemy_death()
	 draw_Player_gunfire()
	 drawPlayer()
	 player_gui(damage)
	 draw_explosion()
end

function game:keyreleased(key)
	
	if key == "d" or "right" then
		player.right = 0 
	end

	if key == "a" or "left" then
		player.left = 0 
	end

	if key == ("lctrl") then
		player.shooting.time = 1
	end
end

function game:keypressed(key)
	
	if key == "z" then
		
		Asteroid.startpos_x = math.random(0,G.getWidth())
		Asteroid.endpos_x = math.random(0,G.getWidth())
	    Asteroid.angle = math.atan2(G.getHeight(),Asteroid.endpos_x - Asteroid.startpos_x) 
		local Cos = math.cos(Asteroid.angle)
		local Sin = math.sin(Asteroid.angle)
		local Hp = 150
		local Rnd = math.random(1,19)
		table.insert(enemy,{x = Asteroid.startpos_x, y = -30, r = 0,size = 1,cos = Cos, sin = Sin,hp = Hp,alive = 1,rnd = Rnd, dim_x = 34, dim_y = 32,gfx = asteroid1, quad = Asteroid[Rnd].animate, gfx_w = 36, gfx_h = 36, hp = Hp, alive = 1,id = "Asteroid", damage = 15,worth = math.floor(Hp / 10)} )
	end

	if key == "x" then
		
		Alien.startpos_x = math.random(0,G.getWidth())
	    Alien.angle = math.atan2(player.pos.y,player.pos.x - Alien.startpos_x) 
		local Cos = math.cos(Alien.angle)
		local Sin = math.sin(Alien.angle)
		local Hp = 50
		local Rnd = math.random(1,19)
		table.insert(enemy,{x = Alien.startpos_x, y = -30, r = Alien.angle,size = .1,cos = Cos, sin = Sin,hp = Hp,alive = 1,rnd = Rnd, dim_x = 34, dim_y = 32,gfx = alien1,gfx_w = alien1:getWidth() / 2, gfx_h = alien1:getHeight() / 2,  hp = Hp, alive = 1, id = "Alien", damage = 20,worth = math.floor(Hp / 10)} )
	end

	if key == "1" then
		player.weapon = 1
	elseif key == "2" then
		player.weapon = 2
	elseif key == "3" then
		player.weapon = 3
	elseif key == "4" then
		player.weapon = 4
	elseif key == "5" then
		player.weapon = 5
	end

	if key == "p" and state ~= 4 then
		state = 4
	elseif key == "p" and state == 4 then
		state = 2
	end

	if key == "f12" then
		local screenshot = love.graphics.newScreenshot();
    	screenshot:encode('png', os.time() .. '.png');
    end
    if key == "space" and player.sheild_cooldown == 0 then
    	player.sheild = 1
    end
	
	if key == "escape" then
		love.event.quit()
	end
end
return game