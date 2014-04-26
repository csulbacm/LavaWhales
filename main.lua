require 'src/GameObject'

function love.load()
	love.physics.setMeter( 64 )
	world = love.physics.newWorld( 0, 9.81 * 64, true )
	love.window.setMode( 800, 600 )

	whale = Whale( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 )
end

function love.update( dt )
	world:update( dt )
end

function love.draw()
	whale:render()
end