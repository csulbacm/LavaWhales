require("src/Screen")

img_title_back = love.graphics.newImage("assets/sprites/title_screen.png")
img_instruction_back = love.graphics.newImage("assets/sprites/instruction_screen.png")
img_title_weed = {}
img_title_weed[1] = love.graphics.newImage("assets/sprites/left_seaweed03.png")
img_title_weed[2] = love.graphics.newImage("assets/sprites/left_seaweed01.png")
img_title_weed[3] = love.graphics.newImage("assets/sprites/left_seaweed02.png")
img_title_weed[4] = img_title_weed[2]

img_title_weed2 = {}
img_title_weed2[1] = love.graphics.newImage("assets/sprites/right_seaweed03.png")
img_title_weed2[2] = love.graphics.newImage("assets/sprites/right_seaweed01.png")
img_title_weed2[3] = love.graphics.newImage("assets/sprites/right_seaweed02.png")
img_title_weed2[4] = img_title_weed2[2]


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
	gui.group.push{grow="down",pos={ love.graphics.getWidth()/2 - 100,love.graphics.getHeight()/2 - 100 }	}
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
	love.graphics.draw(img_title_weed2[self.weed],100,0)
	titleText:render()
end