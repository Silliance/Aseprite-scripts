-- get the union selection of untransparent pixels of all selected layers/cels and layers/cels in selected folders and add it to current selection
-- if no layers/cels is selected, it will get the selection of untransparent pixels in the current cel and add it to current selection

local SelectContent = dofile(".lib/Select Content.lua")

local slt = Selection()
if app.range.isEmpty then
	slt = SelectContent:GetSelection(app.activeLayer, app.activeFrame.frameNumber)
else
	local mn = 998244353
	local mx = 0
	for i, cel in ipairs(app.range.cels) do
		slt:add(SelectContent:GetSelection(cel.layer, cel.frameNumber))
		if cel.frameNumber < mn then mn = cel.frameNumber end
		if cel.frameNumber > mx then mx = cel.frameNumber end
	end
	for i, lyr in ipairs(app.range.layers) do slt:add(SelectContent:GetSelection(lyr, mn, mx)) end
end
app.activeSprite.selection:add(slt)
