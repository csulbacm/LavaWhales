class = require "external/30log/30log"

GameObject = class()

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

function GameObject:kill()
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
	self.secial_state = nil
	self.state_time = 0
	self.hurt_time = 0
	self.hurt_state = false

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
	self.airTicks = 0

	self.body = love.physics.newBody( world, self.pos.x, self.pos.y, "dynamic" )
	self.shape = love.physics.newCircleShape( 100 )
	self.fixture = love.physics.newFixture( self.body, self.shape, 10 )
	self.fixture:setUserData( self )
end

function Whale:setGhost()
	self.fixture:setMask(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
end

function Whale:update( dt )
	local x, y = self.body:getLinearVelocity()
	local seaLevel = self:getHeight()
	if love.keyboard.isDown('up') and  y > -self.maxVel then
		self.body:applyLinearImpulse( 0, -self.accel )
	end
	if love.keyboard.isDown('down') and y < self.maxVel then
		self.body:applyLinearImpulse( 0, self.accel )
	end
	if love.keyboard.isDown('left') and x > -self.maxVel then
		self.body:applyLinearImpulse( -self.accel, 0 )
	end
	if love.keyboard.isDown('right') and x < self.maxVel then
		self.body:applyLinearImpulse( self.accel, 0 )
	end

	if(self:getX() < self:getWidth() / 2) then
		self.body:setX(self:getWidth() / 2) 
		self.body:applyLinearImpulse(-1 * x, 0)
	end
	if(self:getX() > love.window.getWidth() * 2 - self:getWidth() / 2) then
		self.body:setX(love.window.getWidth() * 2 - self:getWidth() / 2) 
		self.body:applyLinearImpulse(-1 * x, 0)
	end
	if(self:getY() < self:getHeight() / 2) then
		self.body:setY(self:getHeight() / 2) 
		self.body:applyLinearImpulse(0, -1 * y)
	end
	if(self:getY() > love.window.getHeight() * 2 - self:getHeight() / 2) then
		self.body:setY(love.window.getHeight() * 2 - self:getHeight() / 2) 
		self.body:applyLinearImpulse(0, -1 * y)
	end

	if(self:getY() > seaLevel) then
		self.air = self.air - 6 * dt
		if(self.air <= 0) then
			self.air = 0
			self.health = self.health - 8 * dt
		end
	elseif(self:getY() <= seaLevel) then
		self.air = self.air + 16 * dt
		if(self.air >= 100) then
			self.air = 100
		end
	end

	if self.dwarf_col >= 1 then
		self.health = self.health - self.dwarf_col * 0
		self.dwarf_col = 0
		self.special_state = "hurt"
		self.hurt_time = 0
		self.state_time = 0
	end

	self.state_time = self.state_time + dt
	if(self.state_time > .5) then
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
		if(self.hurt_time > .125) then
			self.hurt_time = 0
			self.hurt_state = not self.hurt_state
		end
	end
end

function Whale:render()
	if(self.special_state ~= nil) then
		love.graphics.draw( self.spriteset[self.special_state], self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2 )
		if self.special_state == "hurt" then
			if self.hurt_state then
				love.graphics.draw( self.spriteset.ouch1, self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2 )
			else
				love.graphics.draw( self.spriteset.ouch2, self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2 )
			end
		end
	else
		love.graphics.draw( self.spriteset[self.norm_state], self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2 )
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
	self.image = love.graphics.newImage("assets/sprites/new_unicorn2.png")

	self.pos.x = x
	self.pos.y = y
	self.pos.w = self.image:getWidth()
	self.pos.h = self.image:getHeight()

	self.body = love.physics.newBody( world, self.pos.x, self.pos.y, "dynamic")
	self.shape = love.physics.newRectangleShape( 0, 0, self.pos.w, self.pos.h )
	self.fixture = love.physics.newFixture( self.body, self.shape, 10 )
	self.fixture:setUserData( self )
end

function Dwarves:update( dt )
	--unicorns will fall down
	--at the bottom, they will bounce to random hights
	x,y = self.body:getLinearVelocity()
	if(y < 1000) then
		self.body:applyLinearImpulse(0,5000)
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

	if(self:getY() > love.window.getHeight() * 2 - self:getHeight() / 2 - 10) then
		--we are at the bottom
		if love.math.random() > .7 then
			self.body:applyLinearImpulse(-2000, -50000 * (love.math.random() + .5))
		else
			self.body:applyLinearImpulse(-5000, -5000 * (love.math.random() + .5))
		end
	end
end

function Dwarves:render()
	love.graphics.draw( self.image, self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2 )
end

function Dwarves:getWidth()
	return self.image:getWidth()
end

function Dwarves:getHeight()
	return self.image:getHeight()
end



Shots = GameObject:extends()

function Shots:__init( x, y, vx )
	Shots.super:__init()
	self.image = love.graphics.newImage("assets/sprites/fireball.png")

	self.body = love.physics.newBody( world, x, y, "dynamic")
	self.shape = love.physics.newRectangleShape( 0, 0, self.image:getWidth(), self.image:getHeight() )
	self.fixture = love.physics.newFixture( self.body, self.shape, 1000 )
	self.fixture:setUserData( self )

	self.body:applyForce( vx, 0 )
end

function Shots:update( dt )
	if(self:getX() < self:getWidth() / 2 + 10) then
		self.toKill = true
	end
	x,y = self.body:getLinearVelocity()
	if(x < 1000) then
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
	love.graphics.polygon("fill", self.body:getWorldPoints( self.shape:getPoints() ))
end


Ammo = GameObject:extends()

function Ammo:__init( x, y )
	self.image = love.graphics.newImage("assets/sprites/new_crystal.png")
	self.body = love.physics.newBody( world, x, y, "dynamic" )
	self.shape = love.physics.newRectangleShape( 0, 0, self.image:getWidth(), self.image:getHeight() )
	self.fixture = love.physics.newFixture( self.body, self.shape, 1 )
	self.fixture:setUserData( self )
end

function Ammo:update( dt )
	if(self:getX() < self:getWidth() / 2 + 10) then
		self.toKill = true
	end
	x,y = self.body:getLinearVelocity()
	if(x > -10) then
		self.body:applyLinearImpulse(-100,0)
	end
end

function Ammo:render()
	love.graphics.draw( self.image, self:getX(), self:getY() )
end

Fish = GameObject:extends()

function Fish:__init( x, y )
	self.imageset = {}
	self.imageset[1] = love.graphics.newImage("assets/sprites/fish01l.png")
	self.imageset[2] = love.graphics.newImage("assets/sprites/fish02l.png")
	self.imageset[3] = love.graphics.newImage("assets/sprites/fish03l.png")
	self.imageset[4] = love.graphics.newImage("assets/sprites/fish04l.png")
	local num = math.floor( math.random(1,5))
	if(num == 5) then num = 4 end

	self.image = self.imageset[num]
	self.body = love.physics.newBody( world, x, y, "dynamic" )
	self.shape = love.physics.newRectangleShape( 0, 0, self.image:getWidth(), self.image:getHeight() )
	self.fixture = love.physics.newFixture( self.body, self.shape, 1 )
	self.fixture:setUserData( self )
end

function Fish:update( dt )
	if(self:getX() < self:getWidth() / 2 + 10) then
		self.toKill = true
	end
	x,y = self.body:getLinearVelocity()
	if(x > -10) then
		self.body:applyLinearImpulse(-100,0)
	end
end

function Fish:render()
	love.graphics.draw( self.image, self:getX(), self:getY() )
end
