-- ABANDONED
-- a clipping mask function
-- when a layer is set to be a clipping mask, any untransparent pixel(s), if the same position of those pixels on the first un-clipping-mask layer below it is transparent, they'll be set to transparent
-- low efficiency when the picture is large
-- failed because of app.activeSprite.events:'change' will likely cause an error which will lead Aseprite crashes immediately whenever user redo/undo something
-- (FUCK Aseprite API!!! how can you do this to me when I have gone so far!)

local self = {}

local CelData = dofile(".lib/Cel Data.lua")
local LayerData = dofile(".lib/Layer Data.lua")
local SelectContent = dofile(".lib/Select Content.lua")

local width = app.activeSprite.width
local height = app.activeSprite.height

local function selection2Mask(slt)
    local mask = ""
    local bound = slt.bounds
    local X = slt.origin.x
    local Y = slt.origin.y
    for y = 0, bound.height - 1, 1 do
        for x = 0, bound.width - 1, 1 do
            if slt:contains(X + x, Y + y) then
                local index = CelData:GetIndex(X + x, Y + y)
                mask = mask .. string.rep("0", index - #mask - 1, "") .. "1"
            end
        end
    end
    mask = mask .. string.rep("0", app.activeSprite.width * app.activeSprite.height - #mask, "")
    return mask
end

function self:CreateMask(cel)
    local frameNumber = cel.frameNumber
    local layer = cel.layer
    local parent = layer.parent
    local k = layer.stackIndex - 1
    while (k > 0 and (LayerData:GetData(parent.layers[k], "clippingMask"))) do k = k - 1 end
    if (k == 0) then return false end
    layer = parent.layers[k]
    CelData:SetMask(cel, selection2Mask(SelectContent:GetSelection(layer, frameNumber)))
    return true
end

function self:RenewContent(cel)
    if cel == nil then return end
    local image = cel.image
    if cel.data == "" then self:CreateMask(cel) end
    local mask = CelData:GetMask(cel)
    for pixel in image:pixels() do
        local index = CelData:GetIndex(pixel.x + cel.position.x, pixel.y + cel.position.y)
        if string.sub(mask, index, index) == "0" then pixel(app.pixelColor.rgba(255, 255, 255, 0)) end
    end
    app.refresh()
end

function self:RenewMask(layer, frame)
    local mask = selection2Mask(SelectContent:GetSelection(layer, frame))
    local parent = layer.parent
    for i = layer.stackIndex + 1, #parent.layers, 1 do
        if not LayerData:GetData(parent.layers[i], "clippingMask") then break end
        if parent.layers[i]:cel(frame) ~= nil then
            CelData:SetMask(parent.layers[i]:cel(frame), mask)
            -- self:RenewContent(parent.layers[i]:cel(frame))
        end
    end
    if pcall(function() local a = parent.isGroup end) then self:RenewMask(parent, frame) end
end

function self:event()
    pcall(function()
        local clippingMask = LayerData:GetData(app.activeLayer, "clippingMask")
        -- print("a")
        if clippingMask then
            self:RenewContent(app.activeCel)
        else
            self:RenewMask(app.activeLayer, app.activeFrame.frameNumber)
        end
    end)
end

return self
