Collision = {}

function Collision:update(enemytype,dt)
	for i,j in ipairs(enemytype) do

		if enemytype[i].x + enemytype[i].dim_x > player.pos.x - player.hitbox_x 
		and enemytype[i].y + enemytype[i].dim_y > player.pos.y - player.hitbox_y 
		and enemytype[i].x - enemytype[i].dim_x < player.pos.x + player.hitbox_x 
		and enemytype[i].y - enemytype[i].dim_y < player.pos.y + player.hitbox_y 
		then
			if player.sheild == 0 then
				enemytype[i].alive = 0
				enemytype[i].got_hit = 1
				damage = enemytype[i].damage
			elseif player.sheild == 1 then
				enemytype[i].alive = 0
				enemytype[i].got_hit = 1
				player.sheild_energy = player.sheild_energy - enemytype[i].damage * 5
			end
		end

		if #player.gun1 ~= 0 and #player.gun2 ~= 0 then
			for k,l in ipairs(player.gun1,player.gun2) do
			
				if player.gun1[k].y <= enemytype[i].y + enemytype[i].dim_y 
				and player.gun1[k].y >= enemytype[i].y - enemytype[i].dim_y
				and player.gun1[k].x >= enemytype[i].x - enemytype[i].dim_x  
				and player.gun1[k].x <= enemytype[i].x + enemytype[i].dim_x
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
			
				if  player.gun2[k].y <= enemytype[i].y + enemytype[i].dim_y
				and player.gun2[k].y >= enemytype[i].y - enemytype[i].dim_y  
				and player.gun2[k].x >= enemytype[i].x - enemytype[i].dim_x 
				and player.gun2[k].x <= enemytype[i].x + enemytype[i].dim_x
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
			
				if player.gun3[k].y <= enemytype[i].y + enemytype[i].dim_y *5
				and player.gun3[k].y >= enemytype[i].y - enemytype[i].dim_y *5
				and player.gun3[k].x >= enemytype[i].x - enemytype[i].dim_x *1.5
				and player.gun3[k].x <= enemytype[i].x + enemytype[i].dim_x *1.5
				and player.gun3[k].can_hit == 1
				then
					enemytype[i].hp = enemytype[i].hp - player.gun3.damage
				
					if enemytype[i].hp <= 0 then
						enemytype[i].alive = 0
						enemytype[i].got_hit = 1
					end
				end
			end
		elseif #player.gun4 ~= 0 then
			for k,l in ipairs(player.gun4) do
			
				if player.gun4[k].y <= enemytype[i].y + enemytype[i].dim_y 
				and player.gun4[k].y >= enemytype[i].y - enemytype[i].dim_y 
				and player.gun4[k].x >= enemytype[i].x - enemytype[i].dim_x 
				and player.gun4[k].x <= enemytype[i].x + enemytype[i].dim_x 
				and player.gun4[k].can_hit == 1
				then
					player.gun4[k].lum = 0
					player.gun4[k].can_hit = 0	
					--enemytype[i].hp = enemytype[i].hp - player.gun4.damage
					table.insert(explosion,{x = player.gun4[k].x, y = player.gun4[k].y, area_x = player.gun4.area_x, area_y = player.gun4.area_y})
					table.insert(draw_explosions,{x = player.gun4[k].x, y = player.gun4[k].y,delay=0})
					table.remove(player.gun4,k)
					
					if enemytype[i].hp <= 0 then
						enemytype[i].alive = 0
						enemytype[i].got_hit = 1
					end
				end
			end	
		end
		
		if #explosion ~= 0 then
			count = count + 1
			for k,l in ipairs(explosion) do
				if enemytype[i].x < explosion[k].x + explosion[k].area_x
				and enemytype[i].x > explosion[k].x - explosion[k].area_x
				and enemytype[i].y < explosion[k].y + explosion[k].area_y
				and enemytype[i].y > explosion[k].y - explosion[k].area_y
				then
					enemytype[i].hp = enemytype[i].hp - player.gun4.damage
					if enemytype[i].hp <= 0 then
						enemytype[i].alive = 0
						enemytype[i].got_hit = 1
					end
				end
				if count >= #enemytype then 

					table.remove(explosion,1)
					count = 0
				end
			end				
		end
		if enemytype[i].alive == 0 then
			income = income + enemytype[i].worth
			table.insert(enemy.pos,{x = enemytype[i].x, y = enemytype[i].y,delay = 0,typ = enemytype[i].id})
			table.remove(enemytype,i)
		end
	end
end



return Collision
