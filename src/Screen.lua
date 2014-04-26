class = require "external/30log/30log"

Screen = class()
require('assets/camera/camera')


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
	for i = 1, 10 do
		table.insert( self.objects, Dwarves( love.graphics.getWidth() * math.random(), love.graphics.getHeight() * math.random() ) )
	end

  camera:newLayer(1, function()
    self.whale:render()
		for k,v in ipairs( self.objects ) do
			v:render()
		end
  end)
end

function GameScreen:update( dt )
	self.whale:update()
	for k,v in ipairs( self.objects ) do
		v:update()
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
	end

	removals = nil
end

function GameScreen:render()
	
	camera:draw()
end


function beginContact( a, b, coll )
	--a:getUserData().toKill = true
	--b:getUserData().toKill = true
end

function endContact( a, b, coll )

end

function preSolve( a, b, coll )
	
end

function postSolve( a, b, coll )
  
end