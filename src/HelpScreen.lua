require("src/Screen")

HelpScreen = Screen:extends()

function  HelpScreen:__init()
	HelpScreen.super:__init( "HelpScreen" )
end

function HelpScreen:update( dt )
	gui.group.push{grow="down",pos={300,200}}
	gui.Label{text="Try to get a high score through killing unicorns, ships, and gnomes.\nHave a whale of a time.",
		size={2}}
	gui.Label{text="\nControls\nArrows: move\nSpace: shoot\nS: tri-shot\nB: bubble\nM: mute\nESC: return to the menu\nP: pause"}
	gui.Label{text=""}
	gui.Label{text=""}
	gui.Label{text=""}
	gui.Label{text=""}
	gui.Label{text=""}
	if gui.Button{id = "return", text = "Return"} then
		src_button:play()
		src1:pause()
		ActiveScreen = TitleScreen()
	end
	gui.group.pop{}
end

function HelpScreen:render()
	love.graphics.draw(img_instruction_back)
	love.graphics.setColor( 0, 0, 0 )
	love.graphics.rectangle("fill", 275,175,480,300)
	love.graphics.setColor( 255, 255, 255 )
end