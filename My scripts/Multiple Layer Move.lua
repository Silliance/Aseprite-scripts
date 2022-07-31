-- move the selected content in multiple layers
-- when a folder is selected, content in all its layers will be moved
-- unable to move content in different frames. when multiple frames are selected, only content on current frame will be moved

local function inverse(direction)
	if direction == "up" then return "down" end
	if direction == "down" then return "up" end
	if direction == "left" then return "right" end
	if direction == "right" then return "left" end
end

local function move(direction, distance, layer)
	if layer.layers ~= nil then
		for i, l in ipairs(layer.layers) do move(direction, distance, l) end
	else
		app.activeLayer = layer
		app.command.MoveMask { target = "content", direction = direction, units = "pixel", quantity = distance, wrap = false }
		app.command.MoveMask { target = "boundaries", direction = inverse(direction), units = "pixel", quantity = distance,
			wrap = false }
	end
end

local function buttonclick(direction, distance)
	local layer = app.activeLayer
	local range = app.range
	if range.isEmpty then
		move(direction, distance, app.activeLayer)
	else
		-- if #app.range.frames > 1 then
		-- 	print("unable to move contents in multiple frames")
		-- 	return
		-- end
		for i, l in ipairs(range.layers) do move(direction, distance, l) end
	end
	app.command.MoveMask { target = "boundaries", direction = direction, units = "pixel", quantity = distance, wrap = false }
	app.activeLayer = layer
	app.range = range
end

local dlg = Dialog("Layer Move")
dlg
	:number { id = dis, decimals = 0, text = "1" }
	:button { text = "↑", onclick = function() buttonclick("up", dlg.data.dis) end }
	:newrow()
	:button { text = "←", onclick = function() buttonclick("left", dlg.data.dis) end }
	:button { text = "↓", onclick = function() buttonclick("down", dlg.data.dis) end }
	:button { text = "→", onclick = function() buttonclick("right", dlg.data.dis) end }
	:show { wait = false }
