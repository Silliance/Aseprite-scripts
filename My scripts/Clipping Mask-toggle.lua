-- ABANDONED

local main = dofile("Clipping Mask-main.lua")
local LayerData = dofile(".lib/Layer Data.lua")

local function toggle(layer)
    if LayerData:GetData(layer, "clippingMask") then
        LayerData:SetData(layer, "clippingMask", false)
        layer.name = string.sub(layer.name, 2, -1)
    else
        LayerData:SetData(layer, "clippingMask", true)
        layer.name = '@' .. layer.name
        for i, c in ipairs(layer.cels) do main:CreateMask(c) end
    end
end

if app.range.isEmpty then
    toggle(app.activeLayer)
else
    for i, l in ipairs(app.range.layers) do toggle(l) end
end
