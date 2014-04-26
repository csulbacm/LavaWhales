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

function GameObject:getX()
	return self.pos.x
end

function GameObject:getY()
	return self.pos.y
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
	self.image = love.graphics.newImage("assets/sprites/test_whale.png")
	--Whale.super:__init( x, y, self.image:getWidth(), self.image:getHeight(), 10 )
	Whale.super:__init()
	self.pos.x = x
	self.pos.y = y

	self.pos.w = self.image:getWidth()
	self.pos.h = self.image:getHeight()

	self.body = love.physics.newBody( world, self.pos.x, self.pos.y, "dynamic")
	self.shape = love.physics.newRectangleShape( 0, 0, self.pos.w, self.pos.h )
	self.fixture = love.physics.newFixture( self.body, self.shape, 10 )
end

function Whale:render()
	love.graphics.draw( self.image, self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2 )
end


function Whale:getX()
	return self.body:getX()
end

function Whale:getY()
	return self.body:getY()
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
	self.image = love.graphics.newImage("assets/sprites/test_dwarf.png")

	self.pos.x = x
	self.pos.y = y
	self.pos.w = self.image:getWidth()
	self.pos.h = self.image:getHeight()

	self.body = love.physics.newBody( world, self.pos.x, self.pos.y, "dynamic")
	self.shape = love.physics.newRectangleShape( 0, 0, self.pos.w, self.pos.h )
	self.fixture = love.physics.newFixture( self.body, self.shape, 10 )
end

function Dwarves:render()
	love.graphics.draw( self.image, self.body:getX() - self:getWidth()/2, self.body:getY() - self:getHeight()/2 )
end


function Dwarves:getX()
	return self.body:getX()
end

function Dwarves:getY()
	return self.body:getY()
end

function Dwarves:getWidth()
	return self.image:getWidth()
end

function Dwarves:getHeight()
	return self.image:getHeight()
end