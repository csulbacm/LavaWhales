world=nil

gui = require "external/Quickie"
require 'src/GameObject'
require('assets/camera/camera')
require 'src/Screen'
require 'external/AnAL'
--Declare shooting sound
src_shoot = love.audio.newSource("assets/sounds/shoot.wav", "static")



function love.load()
	love.physics.setMeter( 64 )

	world = love.physics.newWorld( 0, 0, true )
	love.window.setMode( 800, 600 )
	love.graphics.setBackgroundColor( 0, 0, 255 )

	--set up quickie
	fonts = {
		[12] = love.graphics.newFont(12),
		[20] = love.graphics.newFont(20),
	}
	love.graphics.setFont(fonts[12])

	gui.group.default.size[1] = 150
	gui.group.default.size[2] = 25
	gui.group.default.spacing = 5

	ActiveScreen = TitleScreen()	
end

local start_button = false

function love.update( dt )
    ActiveScreen:update( dt )
end

function love.draw()
	gui.core.draw()
	ActiveScreen:render()
end

function love.keypressed( key, isrepeat )
	if key == ' ' and ActiveScreen:is( GameScreen ) and ActiveScreen.whale.amo > 0 then
		table.insert( ActiveScreen.objects, Shots( ActiveScreen.whale:getX() + ActiveScreen.whale:getWidth() / 2,
		ActiveScreen.whale:getY(), 500000 * 64 ) )
		ActiveScreen.whale.amo = ActiveScreen.whale.amo - 1
		ActiveScreen.whale.special_state = "shoot"
		ActiveScreen.whale.state_time = 0
		src_shoot:play()
	end
end