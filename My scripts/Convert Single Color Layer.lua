-- ABANDONED
-- set the layer(s) to single-color-layer
-- single-color-layer will be marked with a '#' before the name of layer
-- whenever the content of layer is changed, all the untransparent pixels in the layer will be reset to the color

local function changeName(layer)
	if string.sub(layer.name, -1, -1) == '#' then layer.name = string.sub(layer.name, 1, -2)
	else
		flag = false
		for i, c in ipairs(layer.cels) do
			if c.image:isEmpty() == false then flag = true end
		end
		if flag then layer.name = layer.name .. '#' end
	end
end

if app.range.isEmpty then
	changeName(app.activeLayer)
else
	for i, l in ipairs(app.range.layers) do changeName(l) end
end
