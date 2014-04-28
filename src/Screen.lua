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

img_title_back = love.graphics.newImage("assets/sprites/title_screen.png")
img_title_weed = {}
img_title_weed[1] = love.graphics.newImage("assets/sprites/left_seaweed03.png")
img_title_weed[2] = love.graphics.newImage("assets/sprites/left_seaweed01.png")
img_title_weed[3] = love.graphics.newImage("assets/sprites/left_seaweed02.png")
img_title_weed[4] = img_title_weed[2]
score = 0

title = {}
title.falling = love.graphics.newImage("assets/sprites/lavawhale_title01.png")
title.squash = love.graphics.newImage("assets/sprites/lavawhale_titlesquash.png")


dwarf_count = 0
dwarf_quota = 5
dwarf_probb = .2
ammo_count = 0
ammo_quota = 3
ammo_probb = .1
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

TitleScreen = Screen:extends()

function TitleScreen:__init()
	TitleScreen.super:__init( "TitleScreen" )
	self.start_button = false
	self.weed = 1
	self.weed_time = 0

	--Background Music Insert
	src1 = love.audio.newSource("assets/sounds/menu_music.mp3", "static")
	src2:pause()
	src1:pause()
	src1:play()
	src1:setLooping( true )
	
	titleText = FallingTitle()
end

function TitleScreen:update( dt )
	gui.group.push{grow="down",pos={200,100}	}
	if gui.Button{id = "start", text = "Start"} then
		self.start_button = true
				src_button:play()
		ActiveScreen = GameScreen()
	end
	if gui.Button{id = "help", text = "Instructions" } then
		ActiveScreen = HelpScreen()
		src_button:play()
	end

	self.weed_time = self.weed_time + dt
	if(self.weed_time > .5) then
		self.weed_time = 0
		self.weed = self.weed + 1
		if self.weed == 5 then
			self.weed = 1
		end
	end
	gui.group.pop{}
	titleText:update( dt )
end

function TitleScreen:render()
	love.graphics.draw(img_title_back)
	
	love.graphics.draw(img_title_weed[self.weed],100,0)
	titleText:render()
end

HelpScreen = Screen:extends()

function  HelpScreen:__init()
	HelpScreen.super:__init( "HelpScreen" )
end

function HelpScreen:update( dt )
	gui.group.push{grow="down",pos={200,100}}
	gui.Label{text="These will be instructions on how to not play the game.\nHave a whale of a time.\n\nMove with the arrow keys\nSpace to shoot\nm to mute\tesc to return to the menu\np to pause the game.",
		size={2}}
	gui.Label{text=""}
	if gui.Button{id = "return", text = "Return"} then
		src_button:play()
		src1:pause()
		ActiveScreen = TitleScreen()
	end
	gui.group.pop{}
end

FailScreen = Screen:extends()

function  FailScreen:__init()
	FailScreen.super:__init( "FailScreen" )
	src_lose:play()
	self.image = love.graphics.newImage("assets/sprites/dead_whale.png")
end

function FailScreen:update( dt )
	gui.group.push{grow="down",pos={200,100}}
	gui.Label{text="You have failed whalekind.\nWhales they are now extinct. \n Good going\n Your score was: " .. score,
		size={2}}
	gui.Label{text=""}
	src1:pause()
	
	if gui.Button{id = "return", text = "Return"} then
		src1:pause()
		ActiveScreen = TitleScreen()
		src_button:play()
	end
	gui.group.pop{}
end

function FailScreen:render()
	love.graphics.draw( self.image, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 )
end

GameScreen = Screen:extends()
dims = {}
function GameScreen:__init()
	world = love.physics.newWorld( -100, 0, true )
  	self.whale = Whale( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 )
	GameScreen.super:__init( "GameScreen" )

	world:setCallbacks( beginContact, endContact, preSolve, postSolve )

	self.gameOver = false
	score = 0
	dwarf_count = 0
	dwarf_quota = 5000
	dwarf_probb = 1
	ammo_count = 0
	ammo_quota = 3
	ammo_probb = .1
	airBubble_count = 0
	airBubble_quota = 3
	airBubble_probb = .1
	fish_count = 0
	fish_quota = 3000
	fish_probb = 1
	ship_count = 0
	ship_quota = 2000
	ship_probb = .1

	self.objects = {}

	for i = 1, 1 do
		spawnDwarf( self.objects )
	end

	for i = 1, 1 do
		spawnLava( self.objects )
		--table.insert( self.objects, Ammo(1000 * math.random(), 1000 * math.random()) )
	end

	for i = 1, 3 do
		spawnAirBubbles( self.objects )
	end	

	for i = 1, 1 do
		spawnFish( self.objects )
	end

	for i = 1, 1 do
		spawnShip( self.objects )
	end

	for i = 1, 1 do
		spawnBoss( self.objects )
	end

	dims = {}
	dims.w = love.window.getWidth() * 2
	dims.h = love.window.getHeight() * 2

	self.walls = {}
	table.insert( self.walls, Wall( dims.w / 2, 0, dims.w, 1 ) )
	table.insert( self.walls, Wall( dims.w, dims.h/2, 1, dims.h ) )
	table.insert( self.walls, Wall( dims.w/2, dims.h, dims.w, 1 ) )
	table.insert( self.walls, Wall( 0, dims.h/2, 1, dims.h ) )

	--Game Loop Music
	src1:pause()

	src2:play()
	src2:setLooping( true )

  bg = love.graphics.newImage("assets/sprites/new_background.png")
  camera:setBounds(0, 0, love.window.getWidth(), love.window.getHeight())
  imageWidth = bg:getWidth()
  posX1 = 0
  posX2 = imageWidth
  posX3 = imageWidth * 2
  love.graphics.setNewFont(14)
  self.whale:setGhost()
end

function GameScreen:update( dt )
	self.whale:update(dt)
	if not ActiveScreen:is( GameScreen ) or self.gameOver then
		ActiveScreen = FailScreen()
		return
	end

	for k,v in ipairs( self.objects ) do
		v:update(dt)
	end
	
	world:update( dt )
	
	camera:setPosition(self.whale:getX() - love.window.getWidth() / 2,
    self.whale:getY() - love.window.getHeight() / 2)

	local removals = {}
	for i, obj in ipairs( self.objects ) do
		if obj.toKill == true then
			table.insert( removals, 1, i )
			obj:kill()
		end
	end

	for i, index in ipairs( removals ) do
		local cur = self.objects[index]
		table.remove( self.objects, index )
		if cur:is( Dwarves ) then
			--spawnDwarf( ActiveScreen.objects )
			dwarf_count = dwarf_count - 1
		elseif cur:is( Fish ) then
			--spawnFish( self.objects )
			fish_count = fish_count - 1
		elseif cur:is( Ammo ) then
			--spawnLava( self.objects )
			ammo_count = ammo_count - 1
		elseif cur:is ( AirBubble ) then
			spawnAirBubbles( ActiveScreen.objects )
			airBubble_count = airBubble_count - 1
		elseif cur:is( Ships ) then
			--spawnShip( self.objects )
			ship_count = ship_count - 1
		end
	end
	if posX1 <= -imageWidth then posX1 = posX3 + imageWidth end
	if posX2 <= -imageWidth then posX2 = posX1 + imageWidth end
	if posX3 <= -imageWidth then posX3 = posX2 + imageWidth end
	if(self.whale:getX() >= love.window.getWidth() * 2 - self.whale:getWidth()) then
		posX1 = posX1 - 500 * dt
		posX2 = posX2 - 500 * dt
		posX3 = posX3 - 500 * dt
	else
		posX1 = posX1 - 250 * dt
		posX2 = posX2 - 250 * dt
		posX3 = posX3 - 250 * dt
	end
	removals = nil


	--respawn objects
	for i=1,1 do
		if dwarf_count < dwarf_quota and math.random() <= dwarf_probb * dt then
			spawnDwarf( self.objects )
		end

		if ammo_count < ammo_quota and math.random() <= ammo_probb * dt then
			spawnLava( self.objects )
		end

	if airBubble_count < airBubble_quota and math.random() <= airBubble_probb then
		spawnAirBubbles( self.objects )
	end

	if fish_count < fish_quota and math.random() <= fish_probb then
		spawnFish( self.objects )
	end

	if ship_count < ship_quota and math.random() <= ship_probb * dt then
			spawnShip( self.objects )
		end
	end
end

function GameScreen:render()
	camera:set()
   printBackground(posX1, posX2, posX3, imageWidth)
   self.whale:render()
   for k,v in ipairs( self.objects ) do
     v:render()
	 end
	 for k,v in ipairs( self.walls ) do
	 	v:render()
	 end
	healthBar(self.whale)
	bossHealth(boss)
	ammoBar(self.whale)
	airBar(self.whale)
	scoreBar()
	--love.graphics.print(math.floor(self.whale:getX()),camera._x,camera._y)
	--love.graphics.print(math.floor(self.whale:getY()),camera._x + 50,camera._y)
   camera:unset()
end


function beginContact( a, b, coll )
	local tempA = a:getUserData()
	local tempB = b:getUserData()
	if tempA:is( Whale ) and tempB:is( Dwarves ) then
		tempA.dwarf_col = tempA.dwarf_col + 1
		tempB.toKill = true
		src_hurt:play()
	elseif tempA:is( Dwarves ) and tempB:is( Whale ) then
		tempB.dwarf_col = tempB.dwarf_col + 1
		tempA.toKill = true
	elseif typesCollided( tempA, Shots, tempB, Dwarves ) then
		tempA.toKill = true
		tempB.toKill = true
		src_explosion:play()
		score = score + 10
	elseif typesCollided( tempA, Wall, tempB, Shots ) then
		tempA.toKill = true
		tempB.toKill = true
	elseif typesCollided( tempA, Whale, tempB, Ammo ) then
		tempA.toKill = true
		tempB.toKill = true
		ActiveScreen.whale.ammo = ActiveScreen.whale.ammo + 5
		if(ActiveScreen.whale.ammo >= 20) then
			ActiveScreen.whale.ammo = 20
		end
	elseif typesCollided( tempA, Whale, tempB, AirBubble ) then
		tempA.toKill = true
		tempB.toKill = true
		ActiveScreen.whale.air = ActiveScreen.whale.air + 10
		if(ActiveScreen.whale.air >= 100) then
			ActiveScreen.whale.air = 100
		end
	elseif typesCollided( tempA, Whale, tempB, Fish ) then
		tempA.toKill = true
		tempB.toKill = true
		ActiveScreen.whale.health = ActiveScreen.whale.health + 5
		if ActiveScreen.whale.health > 100 then
			ActiveScreen.whale.health = 100
		end
	elseif typesCollided( tempA, Shots, tempB, Ships ) then
		tempA.toKill = true
		tempB.toKill = true
		src_explosion:play()
		score = score + 10
	elseif typesCollided( tempA, Shots, tempB, Boss ) then
		local shot, boss = getCollided( tempA, Shots, tempB, Boss )
		shot.toKill = true
		boss.hits = 1
		if boss.health == 0 then
			src_victory:play()
			boss.toKill = true
		end
	elseif typesCollided( tempA, Shots, tempB, Ships ) then
		local shot, ship = getCollided( tempA, Shots, tempB, Ships )
		shot.toKill = true
		ship.toKill = true
	end

end

function endContact( a, b, coll )

end

function preSolve( a, b, coll )
	
end

function postSolve( a, b, coll )
  
end

function printBackground(posX1, posX2, posx3, imageWidth)
   love.graphics.draw(bg, posX1, 0) 
   love.graphics.draw(bg, posX2, 0) 
   love.graphics.draw(bg, posx3, 0)
end

function spawnDwarf( objects )
	dwarf_count = dwarf_count + 1
	table.insert( objects, Dwarves( love.graphics.getWidth() * 2, love.graphics.getHeight()/2 + love.graphics.getHeight() * math.random() * 0.75 + 300) )
	objects[ #objects ].body:applyForce(  -1000000 -100*math.random(), 0 )
end

function spawnShip( objects )
	ship_count = ship_count + 1
	table.insert( objects, Ships( love.graphics.getWidth() * 2-10, love.graphics.getHeight() / 2) )
	objects[ #objects ].body:applyForce( -1000, 0 )
end

function spawnLava( objects )
	ammo_count = ammo_count + 1
	table.insert( objects, Ammo(love.graphics.getWidth() * 2, love.graphics.getHeight() + love.graphics.getHeight() * math.random() * 0.75 + 300) )
end

function spawnFish( objects )
	fish_count = fish_count + 1
	table.insert( objects, Fish( love.graphics.getWidth() * 2, love.graphics.getHeight()/2 + love.graphics.getHeight() * math.random() * 0.75 + 300 ) )
	objects[ #objects ].body:applyForce(  -5000 -100*math.random(), 0 )
end

function spawnAirBubbles( objects )
	airBubble_count = airBubble_count + 1
	table.insert( objects, AirBubble(love.graphics.getWidth() * 2, love.graphics.getHeight() * 2 * math.random() + love.graphics.getHeight() / 2) )
end

function spawnBoss( objects )
	boss = Boss( love.graphics.getWidth() * 1.75, love.graphics.getHeight() * 2 * math.random() )
	table.insert( objects, boss )
	objects[ #objects ].body:applyForce( 0, 0 )
end

function bossHealth( boss ) 
	local bhealth = boss.health
	local x, y = camera._x + love.window.getWidth() / 2 - 100, boss.health * 2 + 2
	love.graphics.setColor(191,0,0)
	--love.graphics.print("Boss: " .. x , camera._y + 30, math.floor(x),  math.floor(y))
	if(boss.health > 0) then
		love.graphics.setColor(191,0,0)
		love.graphics.rectangle("line", x - 250 , camera._y + 40, boss.health * 2 + 2, 15)
		love.graphics.rectangle("fill", x - 249, camera._y + 40, boss.health * 2, 15)
	end
	love.graphics.setColor(255,255,255)
end

function healthBar(whale) 
	local health = whale.health
	local x, y = camera._x + love.window.getWidth() / 2 + 180, camera._y + love.window.getHeight() - 70
	love.graphics.setColor(0,0,0)
	love.graphics.print("Health: " .. math.floor(health), math.floor(x),  math.floor(y))
	if(health > 0) then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle("line", x + 80, y, whale.health * 2 + 2, 15)
		if(health > 0 and health < 33) then
			love.graphics.setColor(255,0,0)
		elseif(health >= 33 and health < 66) then
			love.graphics.setColor(255,102,0)
		elseif(health >= 66) then
			love.graphics.setColor(0,255,0)
		end
		love.graphics.rectangle("fill", x + 81, y, whale.health * 2, 15)
	end
	love.graphics.setColor(255,255,255)
end

function ammoBar(whale)
	local ammo = whale.ammo
	local x, y = camera._x + 10,  camera._y + love.window.getHeight() - 50

	love.graphics.setColor(0,0,0)
	love.graphics.print("Ammo: " .. ammo, math.floor(x),  math.floor(y))
	if(ammo > 0) then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle("line", x + 20, y - (ammo * 5 + 2 )- 10, 15 , ammo * 5 + 2)
		love.graphics.setColor(144,0,0)
		love.graphics.rectangle("fill", x + 20, y - (ammo * 5) - 11, 15, ammo * 5)
	end

	if(ammo == 0) then
		src_power:play()
	end
	love.graphics.setColor(255,255,255)
end

function airBar(whale)
	local air = whale.air
	local x, y = camera._x + love.window.getWidth() / 2 + 200, camera._y + love.window.getHeight() - 50
	love.graphics.setColor(0,0,0)
	love.graphics.print("Air: "..math.floor(air), x, y)
	if(air > 0) then
		love.graphics.setColor(0,204,204)
		love.graphics.rectangle("line", x + 60, y, air * 2 + 2, 15)
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle("fill", x + 61, y, air * 2, 15)
	end
	love.graphics.setColor(255,255,255)
end

function scoreBar()
	local x, y = camera._x + love.window.getWidth() / 2, camera._y + love.window.getHeight() - 50
	love.graphics.setColor(255,255,255)
	love.graphics.print("Score: "..score, x, y)
end

function typesCollided( a, ta, b, tb )
	return a:is( ta ) and b:is( tb ) or a:is( tb ) and b:is( ta )
end

function getCollided( a, ta, b, tb )
	local temp = {}
	if a:is( ta ) then
		temp.a = a
	elseif a:is( tb ) then
		temp.b = a
	end

	if b:is( tb ) then
		temp.b = b
	elseif b:is( ta ) then
		temp.a = b
	end
	return temp.a, temp.b
end
