class = require "external/30log/30log"

Screen = class()



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
	gui.group.push{grow="down",pos={200,100}	}
	gui.Label{text="These will be instructions on how to not play the game"}
	if gui.Button{id = "return", text = "Return"} then
		ActiveScreen = TitleScreen()
	end
	gui.group.pop{}
end

GameScreen = Screen:extends()

function GameScreen:__init()
	GameScreen.super:__init( "GameScreen" )
	self.whale = Whale( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 )
	self.dwarf = Dwarves( 0, 0 )
	world:setCallbacks( beginContact, endContact, preSolve, postSolve )

	self.objects = {}
	for i = 1, 10 do
		table.insert( self.objects, Dwarves( love.graphics.getWidth() * math.random(), love.graphics.getHeight() * math.random() ) )
	end
end

function GameScreen:update( dt )
	self.whale:update()
	for k,v in ipairs( self.objects ) do
		v:update()
	end
	world:update( dt )


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
	self.whale:render()
	for k,v in ipairs( self.objects ) do
		v:render()
	end
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