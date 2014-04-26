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