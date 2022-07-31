-- ABANDONED

JSON = dofile("JSON.lua")

local self = {}

function self:InitializeData(layer)
    local data = { clippingMask = false, singleColor = false }
    layer.data = JSON:encode(data)
end

function self:GetData(layer, key)
    if layer.data == "" then
        self:InitializeData(layer)
    end
    if key ~= nil then
        return JSON:decode(layer.data)[key]
    else
        return JSON:decode(layer.data)
    end
end

function self:SetData(layer, key, value)
    if layer.data == "" then
        self:InitializeData(layer)
    end
    local data = JSON:decode(layer.data)
    data[key] = value
    layer.data = JSON:encode(data)
end

return self
