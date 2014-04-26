class = require "external/30log/30log"

GameObject = class()

function GameObject:__init( id )
	self.id = id
	self.dead = false
	self.toKill = false

	self.pos = {}
	self.pos.x = 0
	self.pos.y = 0
	self.pos.w = 0
	self.pos.h = 0
end

function GameObject:update()

end

function GameObject:render()

end

function GameObject:kill()
	if self.dead == false then
		self.fixture:destroy()
		self.body:destroy()
		dead = true
	end
end

ActingObj = GameObject:extends()

function ActingObj:__init( x, y, w, h, density )
	ActingObj.super:__init()

	self.body = love.physics.newBody( world, x, y, "dynamic")
	self.shape = love.physics.newRectangleShape( 0, 0, w, h )
	self.fixture = love.physics.newFixture( self.body, self.shape, density )
end

function ActingObj:update()

end

function ActingObj:render()
	love.graphics.polygon("fill", self.body:getWorldPoints( self.shape:getPoints() ))
end

function ActingObj:getX()
	return self.body:getX()
end

function ActingObj:getY()
	return self.body:getY()
end


Whale = ActingObj:extends()

function Whale:__init( x, y )
	self.image = love.graphics.newImage("assets/sprites/test_whale.png")
	Whale.super:__init( x, y, self.image:getWidth(), self.image:getHeight(), 10 )
end

function Whale:render()
	love.graphics.draw( self.image, self.body:getX(), self.body:getY() )
end


Dwarves = ActingObj:extends()

function Dwarves:__init( x, y )
	self.image = love.graphics.newImage("assets/sprites/test_dwarf.png")
	Dwarves.super:__init( x, y, self.image:getWidth(), self.image:getHeight(), 10 )
end

function Dwarves:render()
	love.graphics.draw( self.image, self.body:getX(), self.body:getY() )
end