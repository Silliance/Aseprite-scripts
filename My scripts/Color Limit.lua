-- use FCM algorithm to reanalyze the colors in the picture to [cluster] different colors
-- the outcome isn't satisfying... maybe clasification in the RGB color space isn't the best choice

local matrix = dofile(".lib/matrix.lua")
local cluster = 32


local function FCM(data, cluster_n)
    local num_data = matrix.rows(data);
    local m = 3

    local U = matrix(cluster_n, num_data):random(0, 10000000, 10000000)
    local col_sum = matrix.sum(U, 2)
    -- print(col_sum)
    for i = 1, cluster_n, 1 do
        for j = 1, num_data, 1 do
            U[i][j] = U[i][j] / col_sum[1][j]
        end
    end
    -- print(matrix.sum(U,2))
    local C = matrix:new(cluster_n, matrix.columns(data))
    -- local J = {}
    for iter = 1, 10, 1 do
        for j = 1, cluster_n, 1 do
            local u_ij_m = matrix.dotpow(matrix { U[j] }, m) -- u_ij_m=U(j,:).^m;
            local sum_u_ij = matrix.sum(u_ij_m) -- sum_u_ij=sum(u_ij_m);
            -- local sum_ld = matrix.divnum(u_ij_m, sum_u_ij) -- sum_1d=u_ij_m./sum_u_ij;
            C[j] = matrix.divnum(matrix.mul(u_ij_m, data), sum_u_ij)[1] -- C(j,:)=u_ij_m*data_./sum_u_ij;
        end
        -- local templ = matrix:new(cluster_n, num_data, 0)
        -- for j = 1, cluster_n, 1 do
        --     for i = 1, num_data, 1 do
        --         templ[j][i] = U[j][i] ^ m * matrix.normf(matrix { data[i] } - matrix { C[j] }) -- temp1(j,k)=U(j,k)^m*(norm(data_(k,:)-C(j,:)))^2;
        --     end
        -- end
        -- J[iter] = matrix.sum(templ) -- J(i)=sum(sum(temp1));
        for j = 1, cluster_n, 1 do
            for k = 1, num_data, 1 do
                local suml = 0
                for jl = 1, cluster_n, 1 do
                    local temp = (matrix.normf(matrix { data[k] } - matrix { C[j] }) / matrix.normf(matrix { data[k] } - matrix { C[jl] })) ^ (2 / (m - 1)) -- temp = (norm(data_(k,:)-C(j,:))/norm(data_(k,:)-C(j1,:))).^(2/(m-1));
                    suml = suml + temp
                end
                U[j][k] = 1 / suml
            end
        end
    end
    local ret = {}
    -- print(U)
    for i = 1, num_data, 1 do
        local mx = 0
        local group = 0
        for j = 1, cluster_n, 1 do
            if U[j][i] > mx then
                group = j
                mx = U[j][i]
            end
        end
        ret[i] = group
    end
    return ret
end

local function work()
    local img = app.activeImage
    local colorid = {}
    for i = 1, app.activeSprite.width, 1 do
        colorid[i] = {}
        for j = 1, app.activeSprite.height, 1 do
            colorid[i][j] = 0
        end
    end
    local color2id = {}
    local id2color = {}
    local colorcnt = {}
    local colormatrix = {}
    local num = 0
    for px in img:pixels() do
        local x = px.x + app.activeCel.position.x + 1
        local y = px.y + app.activeCel.position.y + 1
        local c = px()
        local C = Color(c)
        local id = color2id[c]
        if id == nil then
            num = num + 1
            table.insert(colormatrix, { C.red, C.green, C.blue })
            colorid[x][y] = num
            color2id[c] = num
            colorcnt[num] = 1
        else
            colorcnt[id] = colorcnt[id] + 1
            colorid[x][y] = color2id[c]
        end
    end

    colormatrix = matrix(colormatrix)
    -- matrix.print(colormatrix)
    local group = FCM(colormatrix, cluster)
    -- print(matrix { group })
    -- print(#group)
    -- print(num)
    local newcolor = {}
    local divisor = {}
    for i = 1, cluster, 1 do
        newcolor[i] = { 0, 0, 0 }
        divisor[i] = 0
    end
    for i = 1, num, 1 do
        newcolor[group[i]][1] = newcolor[group[i]][1] + colormatrix[i][1] * colorcnt[i]
        newcolor[group[i]][2] = newcolor[group[i]][2] + colormatrix[i][2] * colorcnt[i]
        newcolor[group[i]][3] = newcolor[group[i]][3] + colormatrix[i][3] * colorcnt[i]
        divisor[group[i]] = divisor[group[i]] + colorcnt[i]
    end
    for i = 1, cluster, 1 do
        newcolor[i][1] = newcolor[i][1] / divisor[i]
        newcolor[i][2] = newcolor[i][2] / divisor[i]
        newcolor[i][3] = newcolor[i][3] / divisor[i]
    end

    local s = app.activeSprite
    local lyr = s:newLayer()
    s:newCel(lyr, 1)
    for i = 1, app.activeSprite.width, 1 do
        for j = 1, app.activeSprite.height, 1 do
            if colorid[i][j] ~= 0 then
                app.activeImage:drawPixel(i - 1, j - 1, app.pixelColor.rgba(newcolor[group[colorid[i][j]]][1], newcolor[group[colorid[i][j]]][2], newcolor[group[colorid[i][j]]][3]))
            end
        end
    end
end

work()
