-- get the selection of untransparent pixels in the given cel(s)
-- usage:
-- local SelectContent = dofile(".lib/Select Content.lua")
-- SelectContent:GetSelection(layer)        get the union selection of all untransparent pixels in all cels in the layer
-- SelectContent:GetSelection(layer, idx)   get the selection of all untransparent pixels in the idx frame of the layer
-- SelectContent:GetSelection(layer, l, r)  get the selection of all untransparent pixels from l-th to r-th frame of the layer

local self = {}

local function getSelectionFromCel(cel)
    local slt = Selection()
    if cel == nil then return slt end
    local X = cel.position.x
    local Y = cel.position.y
    local img = cel.image
    for pixel in img:pixels() do
        if Color(pixel()).alpha ~= 0 then slt:add(Rectangle(X + pixel.x, Y + pixel.y, 1, 1)) end
    end
    return slt
end

function self:GetSelection(layer, l, r)
    local slt = Selection()
    if layer.isVisible == false then return slt end
    if layer.layers ~= nil then
        for i, lyr in ipairs(layer.layers) do slt:add(self:GetSelection(lyr), l, r) end
    else
        if l == nil then
            for i, c in ipairs(layer.cels) do slt:add(getSelectionFromCel(c)) end
        else
            if r == nil then r = l end
            for i = l, r, 1 do slt:add(getSelectionFromCel(layer:cel(i))) end
        end
    end
    return slt
end

return self
