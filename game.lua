local game = {}


local player_img = love.graphics.newImage("assets/fighter1.png")
local sheild_img = love.graphics.newImage("assets/sheild.png")
--local sheild_img2 = love.graphics.newImage("assets/boll.png")
local font1 =  love.graphics.newFont("assets/6809 chargen.ttf",18)
local player_img2 = love.graphics.newImage("assets/player_img2.png")
local player_img3 = love.graphics.newImage("assets/player_img3.png")
local particle1 = love.graphics.newImage("assets/particle1.tga")
local particle2 = love.graphics.newImage("assets/particle2.png")
local asteroid1 = love.graphics.newImage("assets/asteroid1.png")
local broken_asteroid = love.graphics.newImage("assets/broken_asteroid.png")
local alien1 = love.graphics.newImage("assets/alienshiptex.png")
local gui = love.graphics.newImage("assets/gui.png")

love.graphics.setFont(font1)

	  hp_meter = 299
local energy_meter = 299
local energy_multiplier = 10
local G = love.graphics
local pi = math.pi
local anim = 0
local damage = 0
local income = 0

local player = {
		shooting = {},
		 gun1 = {},
		 gun2 = {},
		 gun3 = {},
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
player.gun1.damage = 10
player.gun2.damage = 10
player.gun3.damage = 150
player.gun3.energy_usage = 50
player.gun1.energy_usage = 0.5
player.gun2.energy_usage = 0.5
player.hitbox_x = 15
player.hitbox_y = 20
player.sheild = 0
player.sheild_animation = 50
player.sheild_incr = 0
player.weapon = 1

-- Creates a Table to put stars in
	local Stars = {}
	
	Stars.amount = G.getWidth() / 2 



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
	local enemy = {
	pos = {},
	id = {}
	}
			

-- Creates a particle system used for the jet effect
local psystem1 = love.graphics.newParticleSystem(particle2, 1000)
psystem1:setParticleLifetime(0.1,0.1 ) 
psystem1:setLinearAcceleration(-1200,0,1200,6400) 
psystem1:setLinearDamping(10, 100) 
psystem1:setColors(110,110,255, 50, 80, 80, 225, 0) 
psystem1:setSizes(.17)
psystem1:setRotation(0,6.28) 
psystem1:setSpinVariation(1)
psystem1:setRadialAcceleration(100)
psystem1:stop()
psystem1:start()

-- Creates a particle system used for the jet smoke effect
local psystem2 = love.graphics.newParticleSystem(particle2, 1000)
psystem2:setParticleLifetime(0.1,.19 ) 
psystem2:setLinearAcceleration(-1100,0,1100,9000) 
psystem2:setLinearDamping(10, 50) 
psystem2:setColors(40,40,40, 50, 30, 30, 30, 0) 
psystem2:setSizes(.2)
psystem2:setRotation(0,6.28) 
psystem2:setSpinVariation(1)
psystem2:setRadialAcceleration(1000)
psystem2:stop()
psystem2:start()

-- Creates a particle system used whem asteroides are destroyd
local psystem3 = love.graphics.newParticleSystem(broken_asteroid, 32)
psystem3:setParticleLifetime(.5,1 ) 
psystem3:setLinearAcceleration(-6000,-6000,6000,6000) 
psystem3:setLinearDamping(50, 100) 
psystem3:setColors(255,255,255, 255, 100, 100, 100, 0) 
psystem3:setSizes(1)
psystem3:setRadialAcceleration(500)
psystem3:setEmissionRate(32)
psystem3:setRotation(0,6.28) 
psystem3:setSpinVariation(1)
psystem3:setBufferSize(20)
psystem3:stop()
psystem3:start()

local P_min3, P_max3 = psystem3:getParticleLifetime( )


local psystem4 = love.graphics.newParticleSystem(particle2, 1000)
psystem4:setParticleLifetime(.5,1 ) 
psystem4:setLinearAcceleration(-2000,-2000,2000,2000) 
psystem4:setLinearDamping(100, 100) 
psystem4:setColors(255,200,50, 100, 255, 50, 50, 50) 
psystem4:setSizes(.3)
psystem4:setRadialAcceleration(2500)
psystem4:setEmissionRate(1000)
psystem4:setRotation(0,6.28) 
psystem4:setSpinVariation(1)
psystem4:setBufferSize(500)
psystem4:stop()
psystem4:start()

local P_min3, P_max3 = psystem4:getParticleLifetime( )

function reset()
	for i = 0, 1000 do
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



function spawn_random(rate)

	local spawnRate = math.random(1,rate)
	
	if spawnRate > 0 and spawnRate < 100 then
		Hp = math.random(75,125)
		Asteroid.startpos_x = math.random(0,G.getWidth())
		Asteroid.endpos_x = math.random(0,G.getWidth())
		Asteroid.angle = math.atan2(G.getHeight(),Asteroid.endpos_x - Asteroid.startpos_x) 
		local Cos = math.cos(Asteroid.angle)
		local Sin = math.sin(Asteroid.angle)
		local Rnd = math.random(1,19)
		table.insert(Asteroid.pos,{x = Asteroid.startpos_x, y = -30, r = 0,size = 1,cos = Cos, sin = Sin,hp = Hp,alive = 1,rnd = Rnd })
		table.insert(enemy.id,{id = Asteroid.pos, dim1 = 34, dim2 = 32, hp = Hp, alive = 1,typ = "Asteroid", damage = 15,worth = math.floor(Hp / 10)})
	end

	if spawnRate > 100 and spawnRate < 150 then
		Alien.startpos_x = math.random(0,G.getWidth())
	    Alien.angle = math.atan2(player.pos.y,player.pos.x - Alien.startpos_x) 
		local Cos = math.cos(Alien.angle)
		local Sin = math.sin(Alien.angle)
		local Hp = 50
		local Rnd = math.random(1,19)
		table.insert(Alien.pos,{x = Alien.startpos_x, y = -30, r = Alien.angle,size = 1,cos = Cos, sin = Sin,hp = Hp,alive = 1,rnd = Rnd })
		table.insert(enemy.id,{id = Alien.pos, dim1 = 34, dim2 = 32, hp = Hp, alive = 1, typ = "Alien", damage = 20,worth = math.floor(Hp / 10)})
	end	

end

function collision_detection(enemytype,x,y,hp,typ,dmg,worth)
	for i,j in ipairs(enemytype) do
		
		if enemytype[i].x + x > player.pos.x - player.hitbox_x 
		and enemytype[i].y + y > player.pos.y - player.hitbox_y 
		and enemytype[i].x - x < player.pos.x + player.hitbox_x 
		and enemytype[i].y - y < player.pos.y + player.hitbox_y 
		then
			--print("collision")
			enemytype[i].alive = 0
			enemytype[i].got_hit = 1
			damage = dmg
		
		end

		if #player.gun1 ~= 0 and #player.gun2 ~= 0 then
			for k,l in ipairs(player.gun1,player.gun2) do
			
				if player.gun1[k].y <= enemytype[i].y + y 
				and player.gun1[k].y >= enemytype[i].y - y
				and player.gun1[k].x >= enemytype[i].x - x  
				and player.gun1[k].x <= enemytype[i].x + x
				and player.gun1[k].can_hit == 1
				then
					player.gun1[k].lum = 0
					player.gun1[k].can_hit = 0
					enemytype[i].hp = enemytype[i].hp - player.gun1.damage
					if enemytype[i].hp <= 0 then
						enemytype[i].alive = 0
						enemytype[i].got_hit = 1
					end
				end
			
				if  player.gun2[k].y <= enemytype[i].y + y
				and player.gun2[k].y >= enemytype[i].y - y  
				and player.gun2[k].x >= enemytype[i].x - x 
				and player.gun2[k].x <= enemytype[i].x + x
				and player.gun2[k].can_hit == 1
				then
					player.gun2[k].lum = 0
					player.gun2[k].can_hit = 0	
					enemytype[i].hp = enemytype[i].hp - player.gun2.damage
					if enemytype[i].hp <= 0 then
						enemytype[i].alive = 0
						enemytype[i].got_hit = 1
					end	
				end
			end
		elseif #player.gun3 ~= 0 then
			for k,l in ipairs(player.gun3) do
			
				if player.gun3[k].y <= enemytype[i].y + y *5
				and player.gun3[k].y >= enemytype[i].y - y *5
				and player.gun3[k].x >= enemytype[i].x - x *1.5
				and player.gun3[k].x <= enemytype[i].x + x *1.5
				and player.gun3[k].can_hit == 1
				then
					--player.gun1[k].lum = 0
					--player.gun1[k].can_hit = 0
					enemytype[i].hp = enemytype[i].hp - player.gun3.damage
					if enemytype[i].hp <= 0 then
						enemytype[i].alive = 0
						enemytype[i].got_hit = 1
					end
				end
			end
		end
		if enemytype[i].alive == 0 then
			income = income + worth
			table.insert(enemy.pos,{x = enemytype[i].x, y = enemytype[i].y,delay = 0,typ = typ})
			table.remove(enemytype,i)
		end
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
end


function addStars(amount)

	for i=1,amount do
			
		local Size = math.random(0.3,1.5)
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

function player_gui(gotDamage,hp)
	hp_meter = hp_meter - gotDamage * 3
	if hp_meter <= 0 then
		hp_meter = 0
		sh = love.graphics.newScreenshot()
		sh_img = love.graphics.newImage(sh)
		reset()
		state = 3
	end

	if energy_meter >= 299 then
		energy_meter = 299
	
	elseif	energy_meter <= 0 then
		energy_meter = 0
	end

	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Credits " .. income,G.getWidth()-310,G.getHeight()/1.07)
	love.graphics.setColor(255,255,255,120)
	love.graphics.rectangle("line",G.getWidth()-310,G.getHeight()/1.041,300,20)
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


function drawAlien()

	love.graphics.setColor(255,255,255,255)
	
	for i,j in ipairs(Alien.pos) do
		Alien.pos[i].x = Alien.pos[i].x + Alien.speed * Alien.pos[i].cos * DT
		Alien.pos[i].y = Alien.pos[i].y + Alien.speed * Alien.pos[i].sin * DT
		love.graphics.draw(alien1, Alien.pos[i].x, Alien.pos[i].y,Alien.pos[i].r,Alien.size,Alien.size,alien1:getWidth() /2,alien1:getHeight() /2 )
		love.graphics.rectangle("line",Alien.pos[i].x - Alien.pos[i].hp /5 - 1, Alien.pos[i].y-2, Alien.pos[i].hp /2.5 + 1, 5,2)
		love.graphics.setColor(0,255,0,255)
		love.graphics.rectangle("fill",Alien.pos[i].x - Alien.pos[i].hp /5, Alien.pos[i].y-1, Alien.pos[i].hp /2.5, 3,2)
		love.graphics.setColor(255,255,255,255)
		
		love.graphics.print(Alien.pos[i].hp, Alien.pos[i].x - string.len(Alien.pos[i].hp)*5, Alien.pos[i].y)
		love.graphics.setColor(255,255,255)
			
		if Alien.pos[i].y > G.getHeight() + 30 or Alien.pos[i].x < -30 or Alien.pos[i].x > G.getWidth() + 30 then
				table.remove(Alien.pos,i)
			
		end
	end
end

function drawAsteroid(x,y,r)
		local hitpoints	
		Asteroid.rad = Asteroid.rad + 2 * DT
		
	 	
	 	love.graphics.setColor(255,255,255,255)
		for i,j in ipairs(Asteroid.pos) do
			Asteroid.pos[i].x = Asteroid.pos[i].x + Asteroid.speed * Asteroid.pos[i].cos * DT
			Asteroid.pos[i].y = Asteroid.pos[i].y + Asteroid.speed * Asteroid.pos[i].sin * DT
			


			
			love.graphics.draw(asteroid1,Asteroid[Asteroid.pos[i].rnd].animate, Asteroid.pos[i].x, Asteroid.pos[i].y, Asteroid.rad / Asteroid.pos[i].size, Asteroid.pos[i].size, Asteroid.pos[i].size, 36, 36)
			love.graphics.rectangle("line",Asteroid.pos[i].x - Asteroid.pos[i].hp /5 - 1, Asteroid.pos[i].y-2, Asteroid.pos[i].hp /2.5 + 1, 5,2)
			love.graphics.setColor(0,255,0,255)
			love.graphics.rectangle("fill",Asteroid.pos[i].x - Asteroid.pos[i].hp /5, Asteroid.pos[i].y-1, Asteroid.pos[i].hp /2.5, 3,2)
			love.graphics.setColor(255,255,255,255)

			love.graphics.print(Asteroid.pos[i].hp, Asteroid.pos[i].x - string.len(Asteroid.pos[i].hp)*5, Asteroid.pos[i].y)
			love.graphics.setColor(255,255,255)
			
			if Asteroid.pos[i].y > G.getHeight() + 30 or Asteroid.pos[i].x < -30 or Asteroid.pos[i].x > G.getWidth() + 30 then
				table.remove(Asteroid.pos,i)
			end
		end

		

 	if Asteroid.rad > 628 then 
 	 		Asteroid.rad = 0
 	end
end

function enemy_died()

	for k,l in ipairs(enemy.pos) do
		enemy.pos[k].delay = enemy.pos[k].delay + DT
		if enemy.pos[k].typ == "Asteroid" then 
		 	--love.graphics.print("Asteroid",100,100)
		 	psystem3:setColors(255,255,255, 255, 100, 100, 100, 0) 
			love.graphics.draw(psystem3,enemy.pos[k].x, enemy.pos[k].y)
			psystem4:setColors(200,200,200, 75, 100, 100, 100, 10) 
			love.graphics.draw(psystem4,enemy.pos[k].x, enemy.pos[k].y)
		elseif enemy.pos[k].typ == "Alien" then
			--love.graphics.print("Alien",100,100)
			psystem3:setColors(50,50,50, 150, 50, 50, 50, 100) 
			love.graphics.draw(psystem3,enemy.pos[k].x, enemy.pos[k].y)
			psystem4:setColors(255,200,50, 50, 255, 50, 50, 10) 
			love.graphics.draw(psystem4,enemy.pos[k].x, enemy.pos[k].y)
		end
					
		if enemy.pos[k].delay > P_min3  then
			enemy.pos[k].delay = 0
			table.remove(enemy.pos,k)
		end
	end
end

function is_shooting()
	if #player.gun1 ~= 0 and #player.gun2 ~= 0 then
		for i,j in ipairs(player.gun1,player.gun2) do
		player.gun1[i].y = player.gun1[i].y - player.shooting.speed * DT
		player.gun2[i].y = player.gun2[i].y - player.shooting.speed * DT
		
		love.graphics.setLineWidth(1.5)
		love.graphics.setColor(255,100,100,player.gun1[i].lum)
		love.graphics.line(player.gun1[i].x,player.gun1[i].y,player.gun1[i].x,player.gun1[i].y+15)
		love.graphics.setColor(255,100,100,player.gun2[i].lum)
		love.graphics.line(player.gun2[i].x,player.gun2[i].y,player.gun2[i].x,player.gun2[i].y+15)
		love.graphics.setLineWidth(1)

			if player.gun1[i].y < 0  then
				table.remove(player.gun1,i)
			end
			
			if player.gun2[i].y < 0  then
				 table.remove(player.gun2,i)
			end
		end
	elseif #player.gun3 ~= 0 then
		for i,j in ipairs(player.gun3) do
		player.gun3[i].y = player.gun3[i].y - player.shooting.speed * DT * 10
	
			if player.gun3[i].y > player.pos.y - 500 then 	
				love.graphics.setLineWidth(10)
				love.graphics.setColor(100,150,100,player.gun3[i].lum)
				love.graphics.line(player.gun3[i].x,player.gun3[i].y,player.gun3[i].x,player.pos.y)
				love.graphics.setLineWidth(5)
				love.graphics.setColor(100,255,100,player.gun3[i].lum)
				love.graphics.line(player.gun3[i].x,player.gun3[i].y,player.gun3[i].x,player.pos.y)
				love.graphics.setLineWidth(1)
			else 
				love.graphics.setLineWidth(10)
				love.graphics.setColor(100,150,100,player.gun3[i].lum)
				love.graphics.line(player.gun3[i].x,player.gun3[i].y,player.gun3[i].x,player.gun3[i].y + 500)
				love.graphics.setLineWidth(5)
				love.graphics.setColor(100,255,100,player.gun3[i].lum)
				love.graphics.line(player.gun3[i].x,player.gun3[i].y,player.gun3[i].x,player.gun3[i].y + 500)
				love.graphics.setLineWidth(1)

			end
			
			if player.gun3[i].y < -1000  then
				table.remove(player.gun3,i)
			end
		end

	end
	




	love.graphics.setColor(255,255,255)
end

function drawStars()
	--love.graphics.draw(space_bg1,0,-1500,0,0.7,1)	
	--for i,j in ipairs(Stars) do
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
end

function game:update(dt)
	--if state == 1 then
	--	hp_meter = 299
	--end
	energy_meter = energy_meter + dt * energy_multiplier
	updateStars(dt)
	DT = dt

	psystem1:update(dt /2)
	psystem2:update(dt /2 )
	psystem3:update(dt /2)
	psystem4:update(dt /2)
	psystem1:emit(100)
	psystem2:emit(100)
	psystem3:emit(32)
	psystem4:emit(1000)
	player_input(dt)
	spawn_random(20000)
	for i,j in ipairs(enemy.id) do
		collision_detection(enemy.id[i].id,enemy.id[i].dim1,enemy.id[i].dim2,enemy.id[i].hp,enemy.id[i].typ,enemy.id[i].damage,enemy.id[i].worth)
	end
end	

function game:draw()
	
	 drawStars()
	 drawAsteroid()
	 drawAlien()
	 enemy_died()
	 is_shooting()
	 drawPlayer()
	 player_gui(damage)
	love.graphics.setColor(255,255,255)
	love.graphics.print("FPS: " .. love.timer.getFPS(), 1, 1,0) 
	--love.graphics.print(Stars.amount,1,30)

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
		table.insert(Asteroid.pos,{x = Asteroid.startpos_x, y = -30, r = 0,size = 1,cos = Cos, sin = Sin,hp = Hp,alive = 1,rnd = Rnd })
		table.insert(enemy.id,{id = Asteroid.pos, dim1 = 34, dim2 = 32, hp = Hp, alive = 1, typ = "Asteroid", damage = 15,worth = math.floor(Hp / 10)})
	end

	if key == "x" then
		
		Alien.startpos_x = math.random(0,G.getWidth())
	    Alien.angle = math.atan2(player.pos.y,player.pos.x - Alien.startpos_x) 
		local Cos = math.cos(Alien.angle)
		local Sin = math.sin(Alien.angle)
		local Hp = 50
		local Rnd = math.random(1,19)
		table.insert(Alien.pos,{x = Alien.startpos_x, y = -30, r = Alien.angle,size = 1,cos = Cos, sin = Sin,hp = Hp,alive = 1,rnd = Rnd })
		table.insert(enemy.id,{id = Alien.pos, dim1 = 34, dim2 = 32, hp = Hp, alive = 1, typ = "Alien", damage = 20,worth = math.floor(Hp / 10)})
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


	if key == "escape" then
		love.event.quit()
	end
end
return game