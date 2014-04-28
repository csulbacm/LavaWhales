require("src/GameObject")


SpriteSet.ammo = love.graphics.newImage("assets/sprites/new_crystal.png")
SpriteSet.fireball = love.graphics.newImage("assets/sprites/fireball.png")
SpriteSet.airBubble = love.graphics.newImage("assets/sprites/air_bubble.png")
SpriteSet.fishes = {}
	SpriteSet.fishes[1] = love.graphics.newImage("assets/sprites/fish01l.png")
	SpriteSet.fishes[2] = love.graphics.newImage("assets/sprites/fish02l.png")
	SpriteSet.fishes[3] = love.graphics.newImage("assets/sprites/fish03l.png")
	SpriteSet.fishes[4] = love.graphics.newImage("assets/sprites/fish04l.png")


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