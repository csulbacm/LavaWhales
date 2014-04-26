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
	if gui.Button{id = "start", text = "Start"} then
		self.start_button = true
		ActiveScreen = GameScreen()
	end
end

GameScreen = Screen:extends()

function GameScreen:__init()
	GameScreen.super:__init( "GameScreen" )
	self.whale = Whale( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 )
	self.dwarf = Dwarves( 0, 0 )
end

function GameScreen:update( dt )
	world:update( dt )
end

function GameScreen:render()
	self.whale:render()
	self.dwarf:render()
end