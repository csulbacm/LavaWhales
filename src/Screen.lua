class = require "external/30log/30log"

Screen = class()
require('assets/camera/camera')
src_explosion = love.audio.newSource("assets/sounds/explosion.wav")
src_hurt = love.audio.newSource("assets/sounds/arr.wav")
src_button = love.audio.newSource("assets/sounds/button_click.wav")
src_power = love.audio.newSource("assets/sounds/drain.ogg")
src_lose = love.audio.newSource("assets/sounds/lose.wav")
src2 = love.audio.newSource("assets/sounds/cave_theme.ogg", "static")
function Screen:__init( name )
	self.name = name
end

function Screen:update( dt )

end

function Screen:render()

end

TitleScreen = Screen:extends()

function TitleScreen:__init()
	TitleScreen.super:__init( "TitleScreen" )
	self.start_button = false

	--Background Music Insert
	src1 = love.audio.newSource("assets/sounds/menu_music.mp3", "static")
	src2:pause()
	src1:pause()
	src1:play()
	src1:setLooping( true )
	
end

function TitleScreen:update( dt )
	gui.group.push{grow="down",pos={200,100}	}
	if gui.Button{id = "start", text = "Start"} then
		self.start_button = true
				src_button:play()
		ActiveScreen = GameScreen()
	end
	if gui.Button{id = "help", text = "Instructions" } then
		ActiveScreen = HelpScreen()
		src_button:play()
	end
	gui.group.pop{}
end

HelpScreen = Screen:extends()

function  HelpScreen:__init()
	HelpScreen.super:__init( "HelpScreen" )
end

function HelpScreen:update( dt )
	gui.group.push{grow="down",pos={200,100}}
	gui.Label{text="These will be instructions on how to not play the game.\nHave a whale of a time.",
		size={2}}
	gui.Label{text=""}
	if gui.Button{id = "return", text = "Return"} then
		src_button:play()
		src1:pause()
		ActiveScreen = TitleScreen()
	end
	gui.group.pop{}
end

FailScreen = Screen:extends()

function  FailScreen:__init()
	FailScreen.super:__init( "FailScreen" )
	src_lose:play()
end

function FailScreen:update( dt )
	gui.group.push{grow="down",pos={200,100}}
	gui.Label{text="You have failed whalekind.\nWhales they are now extinct. \n Good going",
		size={2}}
	gui.Label{text=""}
	src1:pause()
	
	if gui.Button{id = "return", text = "Return"} then
		src1:pause()
		ActiveScreen = TitleScreen()
		src_button:play()
	end
	gui.group.pop{}
end

GameScreen = Screen:extends()

function GameScreen:__init()
	world = love.physics.newWorld( 0, 0, true )
  	self.whale = Whale( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 )
	GameScreen.super:__init( "GameScreen" )

	world:setCallbacks( beginContact, endContact, preSolve, postSolve )

	self.objects = {}

	for i = 1, 10 do
		spawnDwarf( self.objects )
	end

	for i = 1, 5 do
		table.insert( self.objects, Ammo(1000 * math.random(), 1000 * math.random()) )
	end	

	for i = 1, 5 do
		spawnFish( self.objects )
	end

	dims = {}
	dims.w = 1000 * 2
	dims.h = 600 * 2


	self.walls = {}
	table.insert( self.walls, Wall( dims.w / 2, 0, dims.w, 1 ) )
	table.insert( self.walls, Wall( dims.w, dims.h/2, 1, dims.h ) )
	table.insert( self.walls, Wall( dims.w/2, dims.h, dims.w, 1 ) )
	table.insert( self.walls, Wall( 0, dims.h/2, 1, dims.h ) )

	--Game Loop Music
	src1:pause()

	src2:play()
	src2:setLooping( true )

  bg = love.graphics.newImage("assets/sprites/backgroundtest.png")
  camera:setBounds(0, 0, love.window.getWidth(), love.window.getHeight())
  bg1 = love.graphics.newImage("assets/sprites/backgroundtest.png")
  posX = 0 
  imageWidth = 1600
  --self.whale:setGhost()
end

function GameScreen:update( dt )
	self.whale:update(dt)

	if self.whale.health <= 0 then
		ActiveScreen = FailScreen()
		return
	end

	for k,v in ipairs( self.objects ) do
		v:update(dt)
	end
	
	world:update( dt )
	
	camera:setPosition(self.whale:getX() - love.window.getWidth() / 2,
    self.whale:getY() - love.window.getHeight() / 2)

	local removals = {}
	for i, obj in ipairs( self.objects ) do
		if obj.toKill == true then
			table.insert( removals, 1, i )
			obj:kill()
		end
	end

	for i, index in ipairs( removals ) do
		local cur = self.objects[index]
		table.remove( self.objects, index )
		if cur:is( Dwarves ) then
			spawnDwarf( ActiveScreen.objects )
		elseif cur:is( Fish ) then
			spawnFish( ActiveScreen.objects )
		elseif cur:is( Ammo ) then
			spawnLava( ActiveScreen.objects )
		end
	end
	
	if posX <= -1 * imageWidth / 2 then posX = 0 end
	if(self.whale:getX() >= imageWidth / 2) then
		posX = posX - 5
	else
		posX = posX - 1
	end
	removals = nil
end

function GameScreen:render()
	camera:set()
   printBackground(posX, imageWidth)
   self.whale:render()
   for k,v in ipairs( self.objects ) do
     v:render()
	 end
	 for k,v in ipairs( self.walls ) do
	 	v:render()
	 end
	healthBar(self.whale)
	ammoBar(self.whale)
	airBar(self.whale)
   camera:unset()
end


function beginContact( a, b, coll )
	local tempA = a:getUserData()
	local tempB = b:getUserData()
	if tempA:is( Whale ) and tempB:is( Dwarves ) then
		tempA.dwarf_col = tempA.dwarf_col + 1
		tempB.toKill = true
		src_hurt:play()
	elseif tempA:is( Dwarves ) and tempB:is( Whale ) then
		tempB.dwarf_col = tempB.dwarf_col + 1
		tempA.toKill = true
	elseif typesCollided( tempA, Shots, tempB, Dwarves ) then
		tempA.toKill = true
		tempB.toKill = true
		src_explosion:play()
	elseif typesCollided( tempA, Wall, tempB, Shots ) then
		tempA.toKill = true
		tempB.toKill = true
	elseif typesCollided( tempA, Whale, tempB, Ammo ) then
		tempA.toKill = true
		tempB.toKill = true
		ActiveScreen.whale.ammo = ActiveScreen.whale.ammo + 5
		if(ActiveScreen.whale.ammo >= 20) then
			ActiveScreen.whale.ammo = 20
		end
	elseif typesCollided( tempA, Whale, tempB, Fish ) then
		tempA.toKill = true
		tempB.toKill = true
		ActiveScreen.whale.health = ActiveScreen.whale.health + 5
		if ActiveScreen.whale.health > 100 then
			ActiveScreen.whale.health = 100
		end
	end
end

function endContact( a, b, coll )

end

function preSolve( a, b, coll )
	
end

function postSolve( a, b, coll )
  
end

function printBackground(posX, imageWidth)
   love.graphics.draw(bg1, posX, 0) -- this is the original image
   love.graphics.draw(bg1, posX + imageWidth, 0) -- this is the copy that we draw to the original's right
end

function spawnDwarf( objects )
	table.insert( objects, Dwarves( love.graphics.getWidth() * 1.75, love.graphics.getHeight() * math.random() * 1.8 ) )
	objects[ #objects ].body:applyForce( -100000 * 64 * math.random() -1000 * 64, 0 )
end

function spawnLava( objects )
	table.insert( objects, Ammo(1000 * math.random(), 1000 * math.random()) )
end

function spawnFish( objects )
	table.insert( objects, Fish( love.graphics.getWidth() * 1.75, love.graphics.getHeight() * math.random() * 1.8 ) )
	objects[ #objects ].body:applyForce( -64000 * math.random() -64000, 0 )
end

function healthBar(whale) 
	local health = whale.health
	local x, y = camera._x + love.window.getWidth() / 2 - 200, camera._y + 10
	love.graphics.setColor(0,0,0)
	love.graphics.print("Health: " .. math.floor(health), math.floor(x),  math.floor(y))
	if(health > 0) then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle("line", x + 80, camera._y + 10, whale.health * 2 + 2, 15)
		if(health > 0 and health < 33) then
			love.graphics.setColor(255,0,0)
		elseif(health >= 33 and health < 66) then
			love.graphics.setColor(255,102,0)
		elseif(health >= 66) then
			love.graphics.setColor(0,255,0)
		end
		love.graphics.rectangle("fill", x + 81, camera._y + 10, whale.health * 2, 15)
	end
	love.graphics.setColor(255,255,255)
end

function ammoBar(whale)
	local ammo = whale.ammo
	local x, y = camera._x + love.window.getWidth() / 2 - 400, camera._y + 10

	love.graphics.setColor(0,0,0)
	love.graphics.print("Ammo: " .. ammo, math.floor(x),  math.floor(y))
	if(ammo > 0) then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle("line", x + 70, y, ammo * 5 + 2, 15)
		love.graphics.setColor(32,32,32)
		love.graphics.rectangle("fill", x + 71, y, ammo * 5, 15)
	end

	if(ammo == 0) then
		src_power:play()
	end
	love.graphics.setColor(255,255,255)
end

function airBar(whale)
	local air = whale.air
	local x, y = camera._x + love.window.getWidth() / 2 + 100, camera._y + 10
	love.graphics.setColor(0,0,0)
	love.graphics.print("Air: "..math.floor(air), x, y)
	if(air > 0) then
		love.graphics.setColor(0,204,204)
		love.graphics.rectangle("line", x + 60, y, air * 2 + 2, 15)
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle("fill", x + 61, y, air * 2, 15)
	end
	love.graphics.setColor(255,255,255)
end

function typesCollided( a, ta, b, tb )
	return a:is( ta ) and b:is( tb ) or a:is( tb ) and b:is( ta )
end
