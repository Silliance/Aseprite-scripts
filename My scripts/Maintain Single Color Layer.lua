-- ABANDONED
-- used together with Convert Single Color Layer

local function changeLayerColor()
	layer=app.activeLayer
	if string.sub(layer.name,-1,-1) ~= '#' then return end
	color = layer.color
	pixelcolor = app.pixelColor.rgba(color.red, color.green, color.blue, color.alpha)
	--print(pixelcolor)
	for i,cel in ipairs(layer.cels) do
		image=cel.image
		for pixel in image:pixels() do
			--print(pixel())
			if Color(pixel()).alpha ~= 0 and pixel() ~= pixelcolor then pixel(pixelcolor) end
		end
	end
	app.refresh()
end




--changeLayerColor()
app.activeSprite.events:on("change", changeLayerColor)
