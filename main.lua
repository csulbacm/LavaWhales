require 'src/GameObject'
local gui = require "external/Quickie"

function love.load()
	love.physics.setMeter( 64 )
	world = love.physics.newWorld( 0, 9.81 * 64, true )
	love.window.setMode( 800, 600 )
	love.graphics.setBackgroundColor( 0, 0, 255 )
	--whale = Whale( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 )

	--set up quickie
	fonts = {
		[12] = love.graphics.newFont(12),
		[20] = love.graphics.newFont(20),
	}
	love.graphics.setFont(fonts[12])

	gui.group.default.size[1] = 150
	gui.group.default.size[2] = 25
	gui.group.default.spacing = 5

end

local start_button = false

function love.update( dt )
	if not start_button then
		if gui.Button{id = "start", text = "Start"} then
			start_button = true
			whale = Whale( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 )
		end
	end
	world:update( dt )
end

function love.draw()
	gui.core.draw()
	if start_button then
		whale:render()
	end
end