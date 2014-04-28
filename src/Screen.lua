class = require "external/30log/30log"

Screen = class()
require('assets/camera/camera')
src_explosion = love.audio.newSource("assets/sounds/explosion.wav")
src_hurt = love.audio.newSource("assets/sounds/arr.wav")
src_button = love.audio.newSource("assets/sounds/button_click.wav")
src_power = love.audio.newSource("assets/sounds/drain.ogg")
src_lose = love.audio.newSource("assets/sounds/lose.wav")
src_victory = love.audio.newSource("assets/sounds/victory.wav")
src2 = love.audio.newSource("assets/sounds/cave_theme.ogg", "static")

boss_img = love.graphics.newImage("assets/sprites/gnome01_3.png")
src_pop = love.audio.newSource("assets/sounds/pop.ogg")
--src_eat = love.audio.newSource("assets/sounds/eat.wav")

score = 0

dwarf_count = 0
dwarf_quota = 4
dwarf_probb = .1
ammo_count = 0
ammo_quota = 10
ammo_probb = .5
airBubble_count = 0
airBubble_quota = 3
airBubble_probb = .1
fish_count = 0
fish_quota = 3
fish_probb = .1
ship_count = 0
ship_quota = 2
ship_probb = .1



function Screen:__init( name )
	self.name = name
end

function Screen:update( dt )

end

function Screen:render()

end