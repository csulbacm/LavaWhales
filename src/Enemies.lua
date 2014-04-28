require("src/GameObject")

SpriteSet.dwarf = love.graphics.newImage("assets/sprites/new_unicorn2.png")

SpriteSet.squid = {}
	SpriteSet.squid[1] = love.graphics.newImage("assets/sprites/squid01.png")
	SpriteSet.squid[2] = love.graphics.newImage("assets/sprites/squid02.png")
	SpriteSet.squid[3] = love.graphics.newImage("assets/sprites/squid03.png")
	SpriteSet.squid[4] = love.graphics.newImage("assets/sprites/squid04.png")
	SpriteSet.squid[5] = love.graphics.newImage("assets/sprites/squid05.png")

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
	love.graphics.draw( self.image, self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2 , 0, -1, 1, self:getWidth(), 0)
end

function Ships:getWidth()
	return self.image:getWidth()
end

function Ships:getHeight()
	return self.image:getHeight()
end




Squid = GameObject:extends()

function Squid:__init( x, y )
	Squid.super:__init()
	self.imageIndex = 1
	self.switchTime = 0

	self.pos.x = x
	self.pos.y = y
	self.pos.w = SpriteSet.squid[1]:getWidth()
	self.pos.h = SpriteSet.squid[1]:getHeight()

	self.body = love.physics.newBody( world, self.pos.x, self.pos.y, "dynamic")
	self.shape = love.physics.newRectangleShape( 0, 0, self.pos.w, self.pos.h )
	self.fixture = love.physics.newFixture( self.body, self.shape, 0 )
	self.fixture:setUserData( self )
	self.body:setFixedRotation( true )

	self.accel = 200
	self.movement = 1
end

function Squid:update( dt )
	self.switchTime = self.switchTime + dt 
	if self.switchTime > 0.05 then
		
		self.switchTime = 0
		self.imageIndex = self.imageIndex + 1
		if self.imageIndex >= 5 then
			self.imageIndex = 1
		end

	end

	if self:getX() < self:getWidth() then
		self.movement = 1
	elseif self:getX() + self:getWidth() > love.graphics.getWidth() * 2 then
		self.movement = -1
	end
	self.body:setLinearVelocity( self.movement * self.accel, 0 )
end

function Squid:render()
	love.graphics.draw( SpriteSet.squid[ self.imageIndex ], self:getX() - SpriteSet.squid[ self.imageIndex ]:getWidth()/2, self:getY() - SpriteSet.squid[ self.imageIndex ]:getHeight()/2 )
end

function Squid:getWidth()
	return SpriteSet.squid[ self.imageIndex ]:getWidth()
end

function Squid:getHeight()
	return SpriteSet.squid[ self.imageIndex ]:getHeight()
end