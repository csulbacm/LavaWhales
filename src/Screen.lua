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
	for i = 1, 100 do
		spwanDwarf( self.objects )
	end

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
   camera:unset()
end


function beginContact( a, b, coll )
	local tempA = a:getUserData()
	local tempB = b:getUserData()
	if tempA:is( Whale ) and tempB:is( Dwarves ) or
		tempA:is( Dwarves ) and tempB:is( Whale ) or
		tempA:is( Shots ) and tempB:is( Dwarves ) or
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
   love.graphics.print(posX, 400,300)
end

function spwanDwarf( objects )
	table.insert( objects, Dwarves( love.graphics.getWidth() * 2, love.graphics.getHeight() * math.random() * 3 ) )
	objects[ #objects ].body:applyForce( -15000 * 64 * math.random() -15000 * 64, 0 )
end