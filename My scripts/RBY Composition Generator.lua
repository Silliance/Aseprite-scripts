-- an interesting generator for Mondrian-style composition works
-- many details to be improved
-- the color selection mode is yet to be finished

local function checkPossibility(x) return math.random() <= x end

local function devide(length, count)
	local ret = {}
	for i = 1, count - 1, 1 do
		ret[i] = math.random(2, length - 1)
	end
	table.sort(ret)
	return ret
end

local function getColor()
	if checkPossibility(DLG.data.rw / (DLG.data.rw + DLG.data.bw + DLG.data.yw + DLG.data.ww)) then return DLG.data.r
	elseif checkPossibility(DLG.data.bw / (DLG.data.bw + DLG.data.yw + DLG.data.ww)) then return DLG.data.b
	elseif checkPossibility(DLG.data.yw / (DLG.data.yw + DLG.data.ww)) then return DLG.data.y
	else return DLG.data.w end
end

local function create(rtg, mode)
	if rtg.isEmpty then return end
	local lineColor = DLG.data.lineColor
	if checkPossibility(math.sqrt(rtg.width * rtg.height / (app.activeSprite.width * app.activeSprite.height))) then
		--devide
		local devideCount
		if checkPossibility(0.5) then devideCount = 2
		elseif checkPossibility(0.5) then devideCount = 3
		else devideCount = 4 end

		if mode == 1 then
			local positions = devide(rtg.width, devideCount)
			for i = 1, #positions, 1 do
				local p1 = Point(rtg.x + positions[i] - 1, rtg.y)
				local p2 = Point(rtg.x + positions[i] - 1, rtg.y + rtg.height - 1)
				app.useTool { tool = "line", color = lineColor, brush = Brush(1), points = { p1, p2 } }
				if i == 1 then
					create(Rectangle(rtg.x, rtg.y, positions[i] - 1, rtg.height), 2)
				else
					create(Rectangle(rtg.x + positions[i - 1], rtg.y, positions[i] - positions[i - 1] - 1, rtg.height), 2)
					if i == #positions then create(Rectangle(rtg.x + positions[i], rtg.y, rtg.width - positions[i], rtg.height), 2) end
				end
			end
		else
			local positions = devide(rtg.height, devideCount)
			for i = 1, #positions, 1 do
				local p1 = Point(rtg.x, rtg.y + positions[i] - 1)
				local p2 = Point(rtg.x + rtg.width - 1, rtg.y + positions[i] - 1)
				app.useTool { tool = "line", color = lineColor, brush = Brush(1), points = { p1, p2 } }
				if i == 1 then
					create(Rectangle(rtg.x, rtg.y, rtg.width, positions[i] - 1), 1)
				else
					create(Rectangle(rtg.x, rtg.y + positions[i - 1], rtg.width, positions[i] - positions[i - 1] - 1), 1)
					if i == #positions then create(Rectangle(rtg.x, rtg.y + positions[i], rtg.width, rtg.height - positions[i]), 1) end
				end
			end
		end
	else
		local color = getColor()
		app.useTool { tool = "paint_bucket", color = color, points = { Point(rtg.x, rtg.y) } }
	end
end

math.randomseed(os.time())

DLG = Dialog("Mondrian Composition Generator")
DLG
	:color { id = "lineColor", label = "line color", color = Color { r = 0, g = 0, b = 0, a = 255 } }
	:button { text = "add color", onclick = function() end }
	:button { text = "create", onclick = function()
		app.command.Clear()
		if checkPossibility(0.5) then
			create(Rectangle(0, 0, app.activeSprite.width, app.activeSprite.height), 1)
		else
			create(Rectangle(0, 0, app.activeSprite.width, app.activeSprite.height), 2)
		end
		app.refresh()
	end }
	:separator { text = "fill color" }
	:color { id = "r", color = Color { r = 255, g = 0, b = 0, a = 255 } }
	:slider { id = "rw", min = 1, max = 100, value = 10 }
	:color { id = "b", color = Color { r = 0, g = 0, b = 255, a = 255 } }
	:slider { id = "bw", min = 1, max = 100, value = 10 }
	:color { id = "y", color = Color { r = 255, g = 255, b = 0, a = 255 } }
	:slider { id = "yw", min = 1, max = 100, value = 10 }
	:color { id = "w", color = Color { r = 255, g = 255, b = 255, a = 255 } }
	:slider { id = "ww", min = 1, max = 100, value = 70 }
	:show { wait = false }
