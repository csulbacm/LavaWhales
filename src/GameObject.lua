class = require "external/30log/30log"

SpriteSet = {}

title = {}
title.falling = love.graphics.newImage("assets/sprites/lavawhale_title01.png")
title.squash = love.graphics.newImage("assets/sprites/lavawhale_titlesquash.png")

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


Wall = class()

function Wall:__init( x, y, w, h )
	self.body = love.physics.newBody( world, x, y, "static" )
	self.shape = love.physics.newRectangleShape( 0, 0, w, h )
	self.fixture = love.physics.newFixture( self.body, self.shape, 1000000 )
	self.fixture:setUserData( self )
end

function Wall:render()

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