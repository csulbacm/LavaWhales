require 'src/GameObject'

function love.load()
	love.physics.setMeter( 64 )
	world = love.physics.newWorld( 0, 0, true )
	love.window.setMode( 800, 600 )
	love.graphics.setBackgroundColor( 0, 0, 255 )

	whale = Whale( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 )
	dwarf = Dwarves( 0, 0 )
end

function love.update( dt )
	world:update( dt )
end

function love.draw()
	whale:render()
	dwarf:render()
end