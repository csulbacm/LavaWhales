require("src/GameObject")

Whale = GameObject:extends()

function Whale:__init( x, y )
	self.spriteset = {}
	self.spriteset.down = love.graphics.newImage("assets/sprites/whale01.png")
	self.spriteset.up = love.graphics.newImage("assets/sprites/whale02.png")
	self.spriteset.hungry = love.graphics.newImage("assets/sprites/hungry_whale.png")
	self.spriteset.hurt = love.graphics.newImage("assets/sprites/hurt_whale.png")
	self.spriteset.shoot = love.graphics.newImage("assets/sprites/hungry_whale.png")
	self.spriteset.dead = love.graphics.newImage("assets/sprites/dead_whale.png")
	self.spriteset.drowning = love.graphics.newImage("assets/sprites/choking_whale01.png")
	self.spriteset.ouch1 = love.graphics.newImage("assets/sprites/ouch01.png")
	self.spriteset.ouch2 = love.graphics.newImage("assets/sprites/ouch02.png")
	self.spriteset.choke1 = love.graphics.newImage("assets/sprites/choking_whale01.png")
	self.spriteset.choke2 = love.graphics.newImage("assets/sprites/choking_whale02.png")

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
		self.body:setLinearVelocity( x, -self.accel )
	end
	if love.keyboard.isDown('down') and y < self.maxVel then
		self.body:setLinearVelocity( x, self.accel )
	end
	if love.keyboard.isDown('left') and x > -self.maxVel then
		self.body:setLinearVelocity( -self.accel, y )
		self.direction = "left"
	end
	if love.keyboard.isDown('right') and x < self.maxVel then
		self.body:setLinearVelocity( self.accel, y )
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
		if self.air > 0 then
			if self.norm_state == "up" then
				self.norm_state = "down"
			else
			    self.norm_state = "up"
			end
		else
			if self.norm_state == "choke1" then
				self.norm_state = "choke2"
			else
				self.norm_state = "choke1"
			end
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