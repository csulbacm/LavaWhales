require 'src/GameObject'

function love.load()
	love.physics.setMeter( 64 )
	world = love.physics.newWorld( 0, 9.81 * 64, true )
	love.window.setMode( 500, 500 )
end

function love.update( dt )
	world:update( dt )
end

function love.draw()
	love.graphics.setBackgroundColor(0,0,0)
end