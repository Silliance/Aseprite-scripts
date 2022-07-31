-- local main = dofile("Clipping Mask-main.lua")
--     -- dofile("./Clipping Mask-events.lua")
-- app.activeSprite.events:on('change',
--     function()
--     main:event()
-- end)
-- debug.debug()

-- last_call_time = 0
-- local t = {}
-- function t:event()
--     local time = os.time()
--     if time - last_call_time > 1 then
--         print(last_call_time)
--         app.activeLayer.name = app.activeLayer.name .. "1"
--         last_call_time = time
--     end
-- end

-- app.activeSprite.events:on('change',
--     function()
--     -- print(os.clock() - tonumber(app.activeLayer.data))
--     if os.clock() - tonumber(app.activeLayer.name) > 0.5 then
--         print(app.activeLayer.name)
--         app.activeLayer.name = app.activeLayer.name .. "1"
--         app.activeLayer.name = tostring(os.clock())
--     end
-- end)

-- print(os.clock())

-- local dlg = Dialog{on}


-- while (true) do t:event() end


-- print(os.time())
-- app.activeLayer.name=app.activeLayer.name .. "1"

-- local matrix = dofile(".lib/matrix.lua")
-- mtx = matrix {{1,2},{3,4}}
-- assert( tostring(mtx) == "1\t2\n3\t4" )
-- m1 = matrix{{8,4,1},{6,8,3}}
-- m2 = matrix{{3,1},{2,5},{7,4}}
-- assert(m1 * m2 == matrix{{39,32},{55,58}})

dofile("Color Limit.lua")

-- os.execute("pause")

-- s = app.activeSprite
--   lyr = s:newLayer()
--   s:newCel(lyr, 1)
-- print(app.activeImage)
-- local matrix = dofile(".lib/matrix.lua")
-- local t = matrix(5, 5):random(0, 3, 1)
-- print(t)
-- print(matrix{t[1]})
-- print(matrix.sum(matrix{t[1]}))
-- print(matrix.sum(t,2))
-- print(matrix.sum(t))
-- print(matrix:random())
-- local table = {}
-- print(nil == nil)
-- print(app.activeCel.position)