-- ABANDONED

local LayerData = dofile(".lib/Layer Data.lua")
local main = dofile("Clipping Mask-main.lua")

local clippingMask = LayerData:GetData(app.activeLayer, "clippingMask")
if clippingMask then
    main:RenewContent(app.activeCel)
else
    main:RenewMask(app.activeLayer, app.activeFrame.frameNumber)
end
