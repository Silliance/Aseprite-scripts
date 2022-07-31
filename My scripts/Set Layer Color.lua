-- set the most used color in the first frame of the layer as the background color of this layer
-- available for multi-layers
-- when a folder is selected, the operation will be applied to all the layers in it
-- convenient for single-color-layer lovers

local function setLayerBgcolor(layer)
	--print(#layer.cels)
	local image = layer.cels[1].image
	if image:isEmpty() then
		layer.color=Color{r=0,g=0,b=0,a=0}
		return
	end
	local findcolor = false
	local maincolor = ""
	for px in image:pixels() do
		local color = Color(px())
		if color.alpha ~= 0 then
			if findcolor == false then 
				findcolor = true
				maincolor = color
			else 
				if color ~= maincolor then
					-- print("This is not a simgle-color layer")
					return
				end
			end
		end
	end
	layer.color=maincolor
end

if app.range.isEmpty then
	setLayerBgcolor(app.activeLayer)
else
	for i,l in ipairs(app.range.layers) do setLayerBgcolor(l) end
end