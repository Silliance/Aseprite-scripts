-- a perspective lines generator
-- firstly draw several dots as the anchor(s) in a new layer, and then use the buttons to generator lines

local function round(x) return math.floor(x + 0.5) end

local function max(x, y) if x > y then return x else return y end end

local function drawLine(x, y, color, angle)
	--print(angle)
	local length = max(app.activeSprite.width, app.activeSprite.height)
	local p1 = Point(x, y)
	local p2 = Point()
	if angle == 0 then p2 = Point(x + length, y)
	elseif angle == 30 then p2 = Point(x + 2 * length - 1, y + length - 1)
	elseif angle == 45 then p2 = Point(x + length, y + length)
	elseif angle == 60 then p2 = Point(x + length - 1, y + 2 * length - 1)
	elseif angle == 90 then p2 = Point(x, y + length)
	elseif angle == 120 then p2 = Point(x - length + 1, y + 2 * length - 1)
	elseif angle == 135 then p2 = Point(x - length, y + length)
	elseif angle == 150 then p2 = Point(x - 2 * length - 1, y + length - 1)
	elseif angle == 180 then p2 = Point(x - length, y)
	elseif angle == 210 then p2 = Point(x - 2 * length - 1, y - length + 1)
	elseif angle == 225 then p2 = Point(x - length, y - length)
	elseif angle == 240 then p2 = Point(x - length + 1, y - 2 * length + 1)
	elseif angle == 270 then p2 = Point(x, y - length)
	elseif angle == 300 then p2 = Point(x + length - 1, y - 2 * length + 1)
	elseif angle == 315 then p2 = Point(x + length, y - length)
	elseif angle == 330 then p2 = Point(x + 2 * length - 1, y - length + 1)
	else p2 = Point(x + math.cos(angle / 180 * math.pi) * length, y + math.sin(angle / 180 * math.pi) * length)
	end
	--print(p1.x.." "..p1.y.." "..p2.x.." "..p2.y)
	app.useTool { tool = "line", color = color, brush = Brush(1), points = { p1, p2 } }
end

local function newLayer(name)
	s = app.activeSprite
	lyr = s:newLayer()
	lyr.name = name
	s:newCel(lyr, 1)
	return lyr
end

local function drawAnchor(x, y, color, k, a)
	while (a < 360) do
		drawLine(x, y, color, a)
		a = a + k
	end
end

local dlg = Dialog("Perspective Lines")
dlg
	:slider { id = "angle", label = "Angle", min = 1, max = 180, value = 15 }
	:slider { id = "startangle", label = "Start Angle", min = 0, max = 180, value = 0 }
	:button { text = "Draw", onclick = function()
		pixels = app.activeImage:pixels()
		local X = app.activeCel.position.x
		local Y = app.activeCel.position.y
		newLayer("perspective lines")
		for pixel in pixels do
			local color = Color(pixel())
			if color.alpha ~= 0 then drawAnchor(X + pixel.x, Y + pixel.y, color, dlg.data.angle, dlg.data.startangle) end
		end
		app.refresh()
	end }
	:show { wait = false }
