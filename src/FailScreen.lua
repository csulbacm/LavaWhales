require("src/Screen")

GameOver = {}
GameOver.first = love.graphics.newImage("assets/sprites/loser_screen.png")
GameOver.second = love.graphics.newImage("assets/sprites/loser_screen_ver2.png")


FailScreen = Screen:extends()

function  FailScreen:__init()
	FailScreen.super:__init( "FailScreen" )
	src_lose:play()
	self.image = GameOver.first

	self.first = true
	self.switch_time = 0
end

function FailScreen:update( dt )
	gui.group.push{grow="down",pos={400,350}}
	gui.Label{text="You have failed whalekind.\nWhales they are now extinct. \n Good going\n Your score was: " .. score,
		size={2}}
	gui.Label{text=""}
	gui.Label{text=""}
	src1:pause()
	
	if gui.Button{id = "return", text = "Return"} then
		src1:pause()
		ActiveScreen = TitleScreen()
		src_button:play()
	end
	gui.group.pop{}

	self.switch_time = self.switch_time + dt
	if self.switch_time >= 0.5 then
		self.switch_time = 0
		if self.first then
			self.image = GameOver.first
		else
			self.image = GameOver.second
		end
		self.first = not self.first
	end
end

function FailScreen:render()
	love.graphics.draw( self.image, (love.graphics.getWidth() - self.image:getWidth() )/2, (love.graphics.getHeight() - self.image:getHeight() )/2 )
end