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
	if gui.Button{id = "start", text = "Start"} then
		self.start_button = true
		ActiveScreen = GameScreen()
	end
end

GameScreen = Screen:extends()

function GameScreen:__init()
  self.whale = Whale( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 )
  self.dwarf = Dwarves( 0, 0 )
	GameScreen.super:__init( "GameScreen" )
  camera:newLayer(1, function()
    self.whale:render()
    self.dwarf:render()
   -- love.graphics.print(self.whale:getX(), camera.x, camera.y)
   -- love.graphics.print(self.whale:getY(), camera.x + 50, camera.y)
   love.graphics.print(camera.x, camera.x, camera.y)
   love.graphics.print(camera.y, camera.x + 50, camera.y)
  end)
end

function GameScreen:update( dt )
	world:update( dt )
  camera:setPosition(self.whale:getX() - love.window.getWidth() / 2, self.whale:getY() - love.window.getHeight() / 2)
  --camera:setPosition(love.mouse.getX() * 2, love.mouse.getY() * 2)
end

function GameScreen:render()
  camera:draw()
end