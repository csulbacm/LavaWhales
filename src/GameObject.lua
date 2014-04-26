class = require 'external/30log/30log'

GameObject = class()

function GameObject:__init()
	self.dead = false
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

function GameObject:getX()
	return self.pos.x
end

function GameObject:getY()
	return self.pos.y
end

ActingObj = GameObject:extends()

function ActingObj:__init( x, y, w, h, density )
	ActingObj.super:__init()

	self.pos.x, self.pos.y, self.pos.w, self.pos.h = x, y, w, h

	self.body = love.physics.newBody( world, self.pos.x, self.pos.y, "dynamic")
	self.shape = love.physics.newRectangleShape( 0, 0, self.pos.w, self.pos.h )
	self.fixture = love.physics.newFixture( self.body, self.shape, density )
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
	Whale.super:__init( x, y, 64, 64, 10 )
	self.image = love.graphics.newImage("assets/sprites/test_whale.png")
end

function Whale:render()
	love.graphics.draw( self.image, self:getX(), self:getY() )
end


Dwarves = ActingObj:extends()

function Dwarves:__init( x, y, w, h )
	Dwarves.super:__init( x, y, w, h )
end

function Dwarves:render()
	love.graphics.setColor( 255, 128, 0 )
	Dwarves.super:render()
end