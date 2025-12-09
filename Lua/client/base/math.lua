--math.lua
local mfloor = math.floor
local mrandom = math.random

--四舍五入
function math.round(n)
    return mfloor(0.5 + n)
end

--随机
function math.rand(n1, n2)
    return mrandom(n1 * 1000000, n2 * 1000000) / 1000000
end

--clamp
function math.clamp(value, min, max)
    if value < min then
        return min
    end
    if value > max then
        return max
    end
    return value
end
