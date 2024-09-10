--[[string.lua
--]]

--------------------------------------------------------------------------------
function serialize(t)
    local mark={}
    local assign={}

    local function table2str(t, parent)
        mark[t] = parent
        local ret = {}

        if table.is_array(t) then
            for i, v in pairs(t) do
                local k = tostring(i)
                local dotkey = parent.."["..k.."]"
                local t = type(v)
                if t == "userdata" or t == "function" or t == "thread" or t == "proto" or t == "upval" then
                    --ignore
                elseif t == "table" then
                    if mark[v] then
                        table.insert(assign, dotkey.."="..mark[v])
                    else
                        table.insert(ret, table2str(v, dotkey))
                    end
                elseif t == "string" then
                    table.insert(ret, string.format("%q", v))
                elseif t == "number" then
                    if v == math.huge then
                        table.insert(ret, "math.huge")
                    elseif v == -math.huge then
                        table.insert(ret, "-math.huge")
                    else
                        table.insert(ret,  tostring(v))
                    end
                else
                    table.insert(ret,  tostring(v))
                end
            end
        else
            for f, v in pairs(t) do
                local k = type(f)=="number" and "["..f.."]" or f
                local dotkey = parent..(type(f)=="number" and k or "."..k)
                local t = type(v)
                if t == "userdata" or t == "function" or t == "thread" or t == "proto" or t == "upval" then
                    --ignore
                elseif t == "table" then
                    if mark[v] then
                        table.insert(assign, dotkey.."="..mark[v])
                    else
                        table.insert(ret, string.format("%s=%s", k, table2str(v, dotkey)))
                    end
                elseif t == "string" then
                    table.insert(ret, string.format("%s=%q", k, v))
                elseif t == "number" then
                    if v == math.huge then
                        table.insert(ret, string.format("%s=%s", k, "math.huge"))
                    elseif v == -math.huge then
                        table.insert(ret, string.format("%s=%s", k, "-math.huge"))
                    else
                        table.insert(ret, string.format("%s=%s", k, tostring(v)))
                    end
                else
                    table.insert(ret, string.format("%s=%s", k, tostring(v)))
                end
            end
        end

        return "{"..table.concat(ret,",").."}"
    end

    if type(t) == "table" then
        return string.format("%s%s",  table2str(t,"_"), table.concat(assign," "))
    else
        return tostring(t)
    end
end

--------------------------------------------------------------------------------
function unserialize(str)
    if str == nil then
        str = tostring(str)
    elseif type(str) ~= "string" then
        return {}
    elseif #str == 0 then
        return {}
    end

    local code, ret = pcall(load(string.format("do local _=%s return _ end", str)))

    if code then
        return ret
    else
        return {}
    end
end

function string.title(value)
    return string.upper(string.sub(value, 1, 1)) .. string.sub(value, 2, #value)
end

function string.untitle(value)
    return string.lower(string.sub(value, 1, 1)) .. string.sub(value, 2, #value)
end

function string.startwith(value, prefix, toffset)
    if value and prefix then
        toffset = (toffset or 1) > 0 and toffset or 1
        return string.sub(value, toffset, toffset + #prefix - 1) == prefix
    end
    return false
end

function string.endwith(value, suffix)
    if value and suffix then
        return string.sub(value, -#suffix) == suffix
    end
    return false
end

function string.split(str, token, trans)
    local t = {}
    while #str > 0 do
        local pos = str:find(token)
        if not pos then
            t[#t + 1] = trans and trans(str) or str
            break
        end

        if pos > 1 then
            local sstr = str:sub(1, pos - 1)
            t[#t + 1] = trans and trans(sstr) or sstr
        end
        str = str:sub(pos + 1, #str)
    end
    return t
end
