class = require "external/30log/30log"

Screen = class()
require('assets/camera/camera')
src_explosion = love.audio.newSource("assets/sounds/explosion.wav")

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
	src1:pause()
	src1:play()
	src1:setLooping( true )
	
end

function TitleScreen:update( dt )
	gui.group.push{grow="down",pos={200,100}	}
	if gui.Button{id = "start", text = "Start"} then
		self.start_button = true
		ActiveScreen = GameScreen()
	end
	if gui.Button{id = "help", text = "Instructions" } then
		ActiveScreen = HelpScreen()
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
		src1:pause()
		ActiveScreen = TitleScreen()
	end
	gui.group.pop{}
end

GameScreen = Screen:extends()

function GameScreen:__init()
  self.whale = Whale( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 )
	GameScreen.super:__init( "GameScreen" )

	world:setCallbacks( beginContact, endContact, preSolve, postSolve )

	self.objects = {}
	for i = 1, 15 do
		spwanDwarf( self.objects )
	end

	dims = {}
	dims.w = 800 * 2
	dims.h = 600 * 2


	self.walls = {}
	table.insert( self.walls, Wall( dims.w / 2, 0, dims.w, 1 ) )
	table.insert( self.walls, Wall( dims.w, dims.h/2, 1, dims.h ) )
	table.insert( self.walls, Wall( dims.w/2, dims.h, dims.w, 1 ) )
	table.insert( self.walls, Wall( 0, dims.h/2, 1, dims.h ) )

	--Game Loop Music
	src1:pause()
	src2 = love.audio.newSource("assets/sounds/cave_theme.ogg", "static")
	src2:play()
	src2:setLooping( true )

  bg = love.graphics.newImage("assets/sprites/testBG.png")
  camera:setBounds(0, 0, love.window.getWidth(), love.window.getHeight())
  bg1 = love.graphics.newImage("assets/sprites/testBG.png")
  posX = 0 
  imageWidth = 1600
end

function GameScreen:update( dt )
	self.whale:update(dt)
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
		table.remove( self.objects, index )
		spwanDwarf( ActiveScreen.objects )
	end
	
	if posX <= -1 * imageWidth / 2 then posX = 0 end
	posX = posX - 1
	removals = nil
end

function GameScreen:render()
	camera:set()
   printBackground(posX, imageWidth)
   self.whale:render()
   for k,v in ipairs( self.objects ) do
     v:render()
	 end
	healthBar(self.whale)
   camera:unset()
end


function beginContact( a, b, coll )
	local tempA = a:getUserData()
	local tempB = b:getUserData()
	if tempA:is( Whale ) and tempB:is( Dwarves ) then
		tempA.dwarf_col = tempA.dwarf_col + 1
		tempB.toKill = true
	elseif tempA:is( Dwarves ) and tempB:is( Whale ) then
		tempB.dwarf_col = tempA.dwarf_col + 1
		tempA.toKill = true
	elseif tempA:is( Shots ) and tempB:is( Dwarves ) or
		tempA:is( Dwarves ) and tempB:is( Shots ) then
		tempA.toKill = true
		tempB.toKill = true
		src_explosion:play()
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

function spwanDwarf( objects )
	table.insert( objects, Dwarves( love.graphics.getWidth() * 1.75, love.graphics.getHeight() * math.random() * 1.8 ) )
	objects[ #objects ].body:applyForce( -100000 * 64 * math.random() -1000 * 64, 0 )
end

function healthBar(whale) 
	local health = whale.health
	love.graphics.setColor(0,0,0)
	love.graphics.print("Health: ", math.floor(camera._x + love.window.getWidth() / 2 - 150),  math.floor(camera._y + 10))
	if(health > 0 and health < 33) then
		love.graphics.setColor(255,0,0)
	elseif(health >= 33 and health < 66) then
		love.graphics.setColor(255,102,0)
	elseif(health >= 66) then
		love.graphics.setColor(0,255,0)
	end
	if(health > 0) then
		love.graphics.rectangle("fill", camera._x + love.window.getWidth() / 2 - 100, camera._y + 10, whale.health * 2, 15)
	end
	love.graphics.setColor(255,255,255)
end
