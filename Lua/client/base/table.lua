
--------------------------------------------------------------------------------
function table.random(tab)
    local keys = {}
    for k in pairs(tab) do
        table.insert(keys, k)
    end
    if #keys > 0 then
        local key = keys[math.random(#keys)]
        return key, tab[key]
    end
end

--------------------------------------------------------------------------------
function table.random_array(tab)
    if #tab > 0 then
        return tab[math.random(#tab)]
    end
end

--------------------------------------------------------------------------------
function table.indexof(tab, val)
    for i, v in pairs(tab) do
        if v == val then
            return i
        end
    end
    return 0
end

--------------------------------------------------------------------------------
function table.is_array(tab)
    if not tab then
        return false
    end

    local ret = true
    local idx = 1
    for f, v in pairs(tab) do
        if type(f) == "number" then
            if f ~= idx then
                ret = false
            end
        else
            ret = false
        end
        if not ret then break end
        idx = idx + 1
    end
    return ret
end

--------------------------------------------------------------------------------
function table.size(t)
    local c = 0
    for _, v in pairs(t or {}) do
        c = c + 1
    end
    return c
end

--------------------------------------------------------------------------------
function table.copy(src, dst)
    local dst = dst or {}
    for field, value in pairs(src) do
        dst[field] = value
    end
    return dst
end

--------------------------------------------------------------------------------
function table.contains(t, val)
    for _, v in pairs(t or {}) do
        if v == val then
            return true
        end
    end
    return false
end

--------------------------------------------------------------------------------
function table.deep_copy(src, dst)
    local dst = dst or {}
    for key, value in pairs(src or {}) do
        if isclass(value) then
            dst[key] = value()
        elseif (type(value) == "table") then
            dst[key] = table.deep_copy(value)
        else
            dst[key] = value
        end
    end
    return dst
end

--------------------------------------------------------------------------------
function table.delete(stab, val, count)
    local count = count or 1
    for i = #stab, 1, -1 do
        if stab[i] == val then
            table.remove(stab, i)
            count = count - 1
        end
        if count == 0 then
            break
        end
    end
end
