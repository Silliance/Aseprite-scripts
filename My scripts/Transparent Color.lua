-- ABANDONED
-- failed because of the bug of app.bgColor and app.fgColor

local function changecolor()
	app.bgColor=Color{h=(app.bgColor.hue+1)%360,s=0,v=100,a=0} 
end

app.events:on("fgcolorchange",
	function() 
		if app.fgColor ~= Color{h=0,s=0,v=100,a=0} then 
			--print("a")
			changecolor()
			--app.refresh()
		end
	end
)