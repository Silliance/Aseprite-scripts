-- ABANDONED

JSON = dofile("JSON.lua")

local self = {}

function self:GetIndex(x, y) return y * app.activeSprite.width + x + 1 end

function self:InitializeMask(cel) cel.data = string.rep("0", app.activeSprite.width * app.activeSprite.height, "") end

function self:GetMask(cel, x, y)
    if cel.data == "" then self:InitializeMask(cel) end
    if x == nil then return cel.data
    else return cel.data[self:GetIndex(x, y)] end
end

function self:SetMask(cel, value, x, y)
    if cel.data == "" then self:InitializeMask(cel) end
    if x == nil then cel.data = value
    else cel.data[self:GetIndex(x, y)] = value end
end

return self
