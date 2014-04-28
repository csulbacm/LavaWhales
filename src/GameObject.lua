class = require "external/30log/30log"

GameObject = class()

SpriteSet = {}
SpriteSet.dwarf = love.graphics.newImage("assets/sprites/new_unicorn2.png")
SpriteSet.ammo = love.graphics.newImage("assets/sprites/new_crystal.png")
SpriteSet.fireball = love.graphics.newImage("assets/sprites/fireball.png")
SpriteSet.airBubble = love.graphics.newImage("assets/sprites/air_bubble.png")
SpriteSet.boss_1 = love.graphics.newImage("assets/sprites/gnome01_2.png")
SpriteSet.boss_2 = love.graphics.newImage("assets/sprites/gnome02_2.png")
SpriteSet.boss_attack_1 = love.graphics.newImage("assets/sprites/gnome01_3.png")
SpriteSet.boss_attack_2 = love.graphics.newImage("assets/sprites/gnome02_3.png")

SpriteSet.fishes = {}
	SpriteSet.fishes[1] = love.graphics.newImage("assets/sprites/fish01l.png")
	SpriteSet.fishes[2] = love.graphics.newImage("assets/sprites/fish02l.png")
	SpriteSet.fishes[3] = love.graphics.newImage("assets/sprites/fish03l.png")
	SpriteSet.fishes[4] = love.graphics.newImage("assets/sprites/fish04l.png")


function GameObject:__init()
	self.dead = false
	self.toKill = false

	self.pos = {}
	self.pos.x = 0
	self.pos.y = 0
	self.pos.w = 0
	self.pos.h = 0
end

function GameObject:update( dt )

end

function GameObject:render()
	
end

function GameObject:getX()
	return self.body:getX()
end

function GameObject:getY()
	return self.body:getY()
end

function GameObject:getWidth()
	return self.pos.w
end

function GameObject:getHeight()
	return self.pos.h
end

function GameObject:getDirection()
	return self.direction
end

function GameObject:kill()
	if self.dead == false then
		self.fixture:destroy()
		self.body:destroy()
		dead = true
	end
end

function GameObject:damage()
	if self.dead == false then
		self.fixture:destroy()
		self.body:destroy()
		dead = true
	end
end



Whale = GameObject:extends()

function Whale:__init( x, y )
	self.spriteset = {}
	self.spriteset.down = love.graphics.newImage("assets/sprites/whale01.png")
	self.spriteset.up = love.graphics.newImage("assets/sprites/whale02.png")
	self.spriteset.hungry = love.graphics.newImage("assets/sprites/hungry_whale.png")
	self.spriteset.hurt = love.graphics.newImage("assets/sprites/hurt_whale.png")
	self.spriteset.shoot = love.graphics.newImage("assets/sprites/hungry_whale.png")
	self.spriteset.dead = love.graphics.newImage("assets/sprites/dead_whale.png")
	self.spriteset.ouch1 = love.graphics.newImage("assets/sprites/ouch01.png")
	self.spriteset.ouch2 = love.graphics.newImage("assets/sprites/ouch02.png")
	
	self.image = love.graphics.newImage("assets/sprites/whale01.png")
	self.norm_state = "down"
	self.direction = "right"
	self.secial_state = nil
	self.state_time = 0
	self.hurt_time = 0
	self.hurt_state = 0

	Whale.super:__init()
	self.pos.x = x
	self.pos.y = y

	self.pos.w = self.image:getWidth()
	self.pos.h = self.image:getHeight()

	self.maxVel = 500
	self.accel = 500

	self.dwarf_col = 0
	self.fish_col = 0

	self.health = 100
	self.ammo = 20
	self.air = 100

	self.body = love.physics.newBody( world, self.pos.x, self.pos.y, "dynamic" )
	self.shape = love.physics.newCircleShape( 100 )
	self.fixture = love.physics.newFixture( self.body, self.shape, 1 )
	self.fixture:setUserData( self )
end

function Whale:setGhost()
	self.fixture:setMask(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
end

function Whale:update( dt )
	if self.special_state ~= nil and self.special_state == "dead" then
		self.body:applyLinearImpulse( 0, 10 * 64 )
		if self:getY() >= dims.h then
			ActiveScreen.gameOver = true
		end
		return
	elseif self.health <= 0 then
		self.special_state = "dead"
		self:setGhost()
	end

	local x, y = self.body:getLinearVelocity()
	local seaLevel = love.window.getHeight() / 2	
	if love.keyboard.isDown('up') and  y > -self.maxVel then
		self.body:applyLinearImpulse( 0, -self.accel )
	end
	if love.keyboard.isDown('down') and y < self.maxVel then
		self.body:applyLinearImpulse( 0, self.accel )
	end
	if love.keyboard.isDown('left') and x > -self.maxVel then
		self.body:applyLinearImpulse( -self.accel, 0 )
		self.direction = "left"
	end
	if love.keyboard.isDown('right') and x < self.maxVel then
		self.body:applyLinearImpulse( self.accel, 0 )
		self.direction = "right"
	end

	if(self:getX() < self:getWidth() / 2) then
		self.body:setX(self:getWidth() / 2) 
		self.body:applyLinearImpulse(-1 * x, 0)
	end
	if(self:getX() > love.window.getWidth() * 2 - self:getWidth() / 2) then
		self.body:setX(love.window.getWidth() * 2- self:getWidth() / 2) 
		self.body:applyLinearImpulse(-1 * x, 0)
	end
	if(self:getY() < love.window.getHeight() / 2) then
		self.body:setY(love.window.getHeight() / 2) 
		self.body:applyLinearImpulse(0, -1 * y)
	end
	if(self:getY() > love.window.getHeight() * 2 - self:getHeight() / 2) then
		self.body:setY(love.window.getHeight() * 2 - self:getHeight() / 2) 
		self.body:applyLinearImpulse(0, -1 * y)
	end

	if(self:getY() > seaLevel + 50) then
		self.air = self.air - 6 * dt
		if(self.air <= 0) then
			self.air = 0
			self.health = self.health - 5 * dt
		end
	elseif(self:getY() <= seaLevel + 50) then
		self.air = self.air + 5 * dt
		if(self.air >= 100) then
			self.air = 100
		end
	end

	if self.dwarf_col >= 1 then
		self.health = self.health - self.dwarf_col * 5
		self.dwarf_col = 0
		self.special_state = "hurt"
		self.hurt_time = 1
		self.state_time = 1
	end

	self.state_time = self.state_time + dt
	if(self.state_time > .5 and self.special_state ~= "hurt") then
		self.state_time = 0
		self.special_state = nil
		if self.norm_state == "up" then
			self.norm_state = "down"
		else
		    self.norm_state = "up"
		end
	end

	if(self.special_state == "hurt") then
		self.hurt_time = self.hurt_time + dt
		if(self.hurt_time > .25) then
			self.hurt_time = 0
			self.hurt_state = self.hurt_state + 1
			if self.hurt_state >= 3 then
				self.special_state = nil
				self.hurt_state = 0
			end
		end
	end
end

function Whale:render()
	--love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
	if(self.special_state ~= nil) then
		if (self.direction == "right") then
			love.graphics.draw( self.spriteset[self.special_state], self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2 )
		else
		   love.graphics.draw( self.spriteset[self.special_state], self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2, 0, -1, 1, self:getWidth(), 0)
		end
		if self.special_state == "hurt" then
			if(self.direction == "right") then
				if self.hurt_state == 1 then
					love.graphics.draw( self.spriteset.ouch1, self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2 )
				elseif self.hurt_state == 2 then
					love.graphics.draw( self.spriteset.ouch2, self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2 )
				end
			else
				if self.hurt_state == 1 then
					love.graphics.draw( self.spriteset.ouch1, self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2, 0, -1, 1, self:getWidth(), 0)
				elseif self.hurt_state == 2 then
					love.graphics.draw( self.spriteset.ouch2, self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2, 0, -1, 1, self:getWidth(), 0)
				end 
			end
		end
	else
		if(self.direction == "right") then
			love.graphics.draw( self.spriteset[self.norm_state], self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2 )
		else
		   love.graphics.draw( self.spriteset[self.norm_state], self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2 , 0, -1, 1, self:getWidth(), 0)
		end
	end

end


function Whale:getWidth()
	return self.image:getWidth()
end

function Whale:getHeight()
	return self.image:getHeight()
end


Dwarves = GameObject:extends()

function Dwarves:__init( x, y )
	Dwarves.super:__init()
	self.image = SpriteSet.dwarf

	self.pos.x = x
	self.pos.y = y
	self.pos.w = 100
	self.pos.h = 120

	self.body = love.physics.newBody( world, self.pos.x, self.pos.y, "dynamic")
	self.shape = love.physics.newRectangleShape( 0, 0, self.pos.w, self.pos.h )
	self.fixture = love.physics.newFixture( self.body, self.shape, 10 )
	self.fixture:setUserData( self )
	self.body:setFixedRotation( true )
end

function Dwarves:update( dt )
	--unicorns will fall down
	--at the bottom, they will bounce to random hights
	x,y = self.body:getLinearVelocity()
	if(y < 500) then
		self.body:applyLinearImpulse(0,1000)
	end
	if(x > -10) then
		self.body:applyLinearImpulse(-100,0)
	end

	if(self:getX() < self:getWidth() / 2 + 100) then
		self.toKill = true
	end
	if(self:getY() < self:getHeight() / 2) then
		self.body:setY(self:getHeight() / 2) 
		self.body:applyLinearImpulse(0, -1.1 * y)
	end
	if(self:getY() > love.window.getHeight() * 2 - self:getHeight() / 2) then
		self.body:setY(love.window.getHeight() * 2 - self:getHeight() / 2) 
		self.body:applyLinearImpulse(0, -1.1 * y)
	end

	if(self:getY() > love.window.getHeight() * 2 - self:getHeight() / 2 - 20) then
		--we are at the bottom
		if math.random() > .7 then
			self.body:applyLinearImpulse(0, -50000)
		else
			self.body:applyLinearImpulse(0, -5000)
		end
	end
end

function Dwarves:render()
	--love.graphics.polygon("fill", self.body:getWorldPoints( self.shape:getPoints() ))
	love.graphics.draw( self.image, self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2 )
end

function Dwarves:getWidth()
	return self.image:getWidth()
end

function Dwarves:getHeight()
	return self.image:getHeight()
end

--Ships
Ships = GameObject:extends()

function Ships:__init( x, y )
	Ships.super:__init()
	self.image = love.graphics.newImage("assets/sprites/wtfduckboat.png")

	self.pos.x = x
	self.pos.y = y
	self.pos.w = 70
	self.pos.h = 50

	self.body = love.physics.newBody( world, self.pos.x, self.pos.y, "dynamic")
	self.shape = love.physics.newRectangleShape( 0, 0, self.pos.w + self.pos.w, self.pos.h )
	self.fixture = love.physics.newFixture( self.body, self.shape, 10 )
	self.fixture:setUserData( self )
	self.body:setFixedRotation( true )
end

function Ships:update( dt )
	local seaLevel = love.window.getHeight() / 2 - 50
	if(self:getX() < self:getWidth() / 2 + 100) then
		self.toKill = true
	end
	x,y = self.body:getLinearVelocity()
	dx = 0
	if(x > -10) then
		dx = math.random()*-100-100
	end
	if self:getY()  < seaLevel then
		self.body:applyLinearImpulse( dx, 640 )
	else 
		self.body:applyLinearImpulse( dx, -640 )
	end
end

function Ships:render()
	--love.graphics.polygon("fill", self.body:getWorldPoints( self.shape:getPoints() ))
	love.graphics.draw( self.image, self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2 , 0, -1, 1, self:getWidth(), 0)
end

function Ships:getWidth()
	return self.image:getWidth()
end

function Ships:getHeight()
	return self.image:getHeight()
end


Shots = GameObject:extends()

function Shots:__init( x, y, vx, vy, type )
	Shots.super:__init()
	self.type = type
	if type == "fire" then
		self.image = SpriteSet.fireball
	elseif type == "air" then
		self.image = SpriteSet.airBubble		
	end

	self.body = love.physics.newBody( world, x, y, "dynamic")
	self.shape = love.physics.newRectangleShape( 0, 0, self.image:getWidth(), self.image:getHeight() )
	self.fixture = love.physics.newFixture( self.body, self.shape, 1000 )
	self.fixture:setUserData( self )

	self.body:applyForce( vx, vy )
end

function Shots:update( dt )
	if(self:getX() < self:getWidth() / 2 + 20) then
		self.toKill = true
	end
	x,y = self.body:getLinearVelocity()
	if(x < 1000 and type == "fire") then
		self.body:applyLinearImpulse(100,0)
	end
end

function Shots:render()
	love.graphics.draw( self.image, self:getX(), self:getY() )
end

Wall = class()

function Wall:__init( x, y, w, h )
	self.body = love.physics.newBody( world, x, y, "static" )
	self.shape = love.physics.newRectangleShape( 0, 0, w, h )
	self.fixture = love.physics.newFixture( self.body, self.shape, 1000000 )
	self.fixture:setUserData( self )
end

function Wall:render()
	--love.graphics.polygon("fill", self.body:getWorldPoints( self.shape:getPoints() ))
end


Ammo = GameObject:extends()

function Ammo:__init( x, y )
	self.image = SpriteSet.ammo
	self.body = love.physics.newBody( world, x, y, "dynamic" )
	self.shape = love.physics.newRectangleShape( 0, 0, self.image:getWidth(), self.image:getHeight() )
	self.fixture = love.physics.newFixture( self.body, self.shape, 1 )
	self.fixture:setUserData( self )
end

function Ammo:update( dt )
	if(self:getX() < self:getWidth() / 2 + 20) then
		self.toKill = true
	end
	x,y = self.body:getLinearVelocity()
	if(x > -10) then
		self.body:applyLinearImpulse(-100,0)
	end
end

function Ammo:render()
	--love.graphics.polygon("fill", self.body:getWorldPoints( self.shape:getPoints() ))
	love.graphics.push()
	love.graphics.translate( self.body:getX(), self.body:getY() )
	love.graphics.rotate( self.body:getAngle() )
	love.graphics.draw( self.image, -self.image:getWidth()/2, -self.image:getHeight()/2 )
	love.graphics.pop()
end

AirBubble = GameObject:extends()

function AirBubble:__init( x, y )
	self.image = SpriteSet.airBubble
	self.body = love.physics.newBody( world, x, y, "dynamic" )
	self.shape = love.physics.newRectangleShape( 0, 0, self.image:getWidth(), self.image:getHeight() )
	self.fixture = love.physics.newFixture( self.body, self.shape, 1 )
	self.fixture:setUserData( self )
end

function AirBubble:update( dt )
	if(self:getX() < self:getWidth() / 2 + 20) then
		self.toKill = true
	end
	x,y = self.body:getLinearVelocity()
	if(x > -10) then
		self.body:applyLinearImpulse(-100,0)
	end
end

function AirBubble:render()
	--love.graphics.polygon("fill", self.body:getWorldPoints( self.shape:getPoints() ))
	love.graphics.push()
	love.graphics.translate( self.body:getX(), self.body:getY() )
	love.graphics.rotate( self.body:getAngle() )
	love.graphics.draw( self.image, -self.image:getWidth()/2, -self.image:getHeight()/2 )
	love.graphics.pop()
end

Fish = GameObject:extends()

function Fish:__init( x, y )
	self.imageset = {}
	self.imageset[1] =  SpriteSet.fishes[1]
	self.imageset[2] = 	SpriteSet.fishes[2]
	self.imageset[3] = 	SpriteSet.fishes[3]
	self.imageset[4] = 	SpriteSet.fishes[4]
	local num = math.floor( math.random(1,5))
	if(num == 5) then num = 4 end

	self.image = self.imageset[num]
	self.body = love.physics.newBody( world, x, y, "dynamic" )
	self.shape = love.physics.newRectangleShape( 0, 0, self.image:getWidth(), self.image:getHeight() )
	self.fixture = love.physics.newFixture( self.body, self.shape, 1 )
	self.fixture:setUserData( self )

	self.body:setFixedRotation( true )
end

function Fish:update( dt )
	if(self:getX() < self:getWidth() / 2 + 30) then
		self.toKill = true
	end
	local x,y = self.body:getLinearVelocity()
	if(x > -10) then
		self.body:applyLinearImpulse(-100,0)
	end
end

function Fish:render()
	--love.graphics.polygon("fill", self.body:getWorldPoints( self.shape:getPoints() ))
	love.graphics.push()
	love.graphics.translate( self.body:getX(), self.body:getY() )
	love.graphics.rotate( self.body:getAngle() )
	love.graphics.draw( self.image, -self.image:getWidth()/2, -self.image:getHeight()/2 )
	love.graphics.pop()
end


--Boss
Boss = GameObject:extends()

function Boss:__init( x, y )
	Boss.super:__init()
	self.image = SpriteSet.boss_1

	self.health = 240
	self.pos.x = x
	self.pos.y = y
	self.pos.w = self.image:getWidth()
	self.pos.h = self.image:getHeight()
	self.hits = 0

	self.state = true
	self.state_time = 0
	self.attack_time = 0
	self.maxVel = 300

	self.body = love.physics.newBody( world, self.pos.x, self.pos.y, "static")
	self.shape = love.physics.newRectangleShape( 0, 0, self.pos.w / 2, self.pos.h)
	self.fixture = love.physics.newFixture( self.body, self.shape, 50 )
	self.fixture:setUserData( self )
	self.body:setFixedRotation( true )
end

function Boss:update( dt )
	if self.hits >= 1 then
		self.health = self.health -5
		src_explosion:play()
		self.hits = 0
	end

	self.state_time = self.state_time + dt
	if(self.state_time > .5) then
		self.state_time = 0
		if(self.state) then
			self.image = SpriteSet.boss_2
		else
		   self.image = SpriteSet.boss_1
		end
		self.state = not self.state
	end

	self.attack_time = self.attack_time + dt
	if(self.attack_time > 1) then
		self.attack_time = 0
		self:attack()
	end
end

function Boss:render()
	love.graphics.polygon("fill", self.body:getWorldPoints( self.shape:getPoints() ))
	love.graphics.draw( self.image, self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2 )
end

function Boss:getWidth()
	return self.image:getWidth()
end

function Boss:getHeight()
	return self.image:getHeight()
end

function Boss:attack()
	spawnBossAttack(ActiveScreen.objects)
end

--Boss attack object
Boss_attack = GameObject:extends()

function Boss_attack:__init( x, y )
	Boss_attack.super:__init()
	self.image = SpriteSet.boss_attack_1

	self.health = 1
	self.pos.x = x
	self.pos.y = y
	self.pos.w = self.image:getWidth()
	self.pos.h = self.image:getHeight()
	self.hits = 0

	self.state = true
	self.state_time = 0
	self.maxVel = 300

	self.body = love.physics.newBody( world, self.pos.x, self.pos.y, "dynamic")
	self.shape = love.physics.newRectangleShape( 0, 0, self.pos.w, self.pos.h )
	self.fixture = love.physics.newFixture( self.body, self.shape, 50 )
	self.fixture:setUserData( self )
	self.body:setFixedRotation( true )
end

function Boss_attack:update( dt )
	if self.hits >= 1 then
		self.health = self.health -1
		src_explosion:play()
		self.hits = 0
	end

	self.state_time = self.state_time + dt
	if(self.state_time > .5) then
		self.state_time = 0
		if(self.state) then
			self.image = SpriteSet.boss_attack_2
		else
		   self.image = SpriteSet.boss_attack_1
		end
		self.state = not self.state
	end
	
	local x,y = self.body:getLinearVelocity()
	if(x > 10) then
		self.body:applyLinearImpulse(100,0)
	end

	if(self.body:getX() >= love.window.getWidth() * 2 - 200 or 
		self.body:getY() <= love.window.getWidth() / 2 - 200) then
		self.toKill = true
	end
end

function Boss_attack:render()
	--love.graphics.polygon("fill", self.body:getWorldPoints( self.shape:getPoints() ))
	love.graphics.draw( self.image, self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2 )
end

function Boss_attack:getX()
	return self:getX()
end

function Boss_attack:getY()
	return self:getY()
end

function Boss_attack:getWidth()
	return self.image:getWidth()
end

function Boss_attack:getHeight()
	return self.image:getHeight()
end

FallingTitle = GameObject:extends()

function FallingTitle:__init()
	self.state = "falling"
	self.image = title[ self.state ]

	self.pos = {}
	self.pos.x = ( love.graphics.getWidth() - self.image:getWidth() ) / 2
	self.pos.y = -10
	self.pos.w = self.image:getWidth()
	self.pos.h = self.image:getHeight()
end

function FallingTitle:update( dt )
	if self.state == "falling" then
		if self.pos.y > love.graphics.getHeight() - self.image:getHeight() then
			self.state = "squash"
			self.image = title[ self.state ]
			self.pos.x = ( love.graphics.getWidth() - self.image:getWidth() ) / 2
			self.pos.y = love.graphics.getHeight() - self.image:getHeight()
		else
			self.pos.y = self.pos.y + 1000 * dt
		end
	end
end

function FallingTitle:render()
	love.graphics.draw( self.image, self.pos.x, self.pos.y )
end