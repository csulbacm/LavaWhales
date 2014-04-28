require("src/GameObject")

SpriteSet.boss_1 = love.graphics.newImage("assets/sprites/gnome01_2.png")
SpriteSet.boss_2 = love.graphics.newImage("assets/sprites/gnome02_2.png")
SpriteSet.boss_attack_1 = love.graphics.newImage("assets/sprites/gnome01_3.png")
SpriteSet.boss_attack_2 = love.graphics.newImage("assets/sprites/gnome02_3.png")

--Boss
Boss = GameObject:extends()

function Boss:__init( x, y )
	Boss.super:__init()
	self.image = SpriteSet.boss_1

	self.health = 200
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
	self.shape = love.physics.newRectangleShape( 0, 0, self.pos.w / 2, self.pos.h * .75)
	self.fixture = love.physics.newFixture( self.body, self.shape, 50 )
	self.fixture:setUserData( self )
	self.body:setFixedRotation( true )
end

function Boss:update( dt )
	if self.hits >= 1 then
		self.health = self.health - 5 * self.hits
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
	if(self.attack_time > 1.5) then
		self.attack_time = 0
		self:attack()
	end
end

function Boss:render()
	--love.graphics.polygon("fill", self.body:getWorldPoints( self.shape:getPoints() ))
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

	self.fx, self.fy = ActiveScreen.whale:getX() - x, ActiveScreen.whale:getY() - y
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
	
	self.body:applyLinearImpulse(self.fx,self.fy)

	if(self.body:getX() <= self:getWidth() or 
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
