--[[property.lua
    local Object = class()
    prop = property(Object)
    prop:reader("id", 0)
    prop:accessor("name", "")
    prop(object, name, value)
--]]
local type      = type
local stitle    = string.title

local ACCESSOR  = 1
local WRITER    = 2
local READER    = 3

local function prop_accessor(prop, class, name, default, mode, notify)
    --default
    class.__default[name] = default
    if mode <= WRITER then
        class["set" .. stitle(name)] = function(self, value)
            if self[name] == nil or self[name] ~= value then 
                self[name] = value
            end
        end
        mode = mode + 2
    end
    if mode <= READER then
        class["get" .. stitle(name)] = function(self)
            if self[name] == nil then
                self[name] = default
            end
            return self[name]
        end
        if type(default) == "boolean" then
            class["is" .. stitle(name)] = class["get" .. stitle(name)]
        end
    end
end

local property_reader = function(self, name, default)
    prop_accessor(self, self.__class, name, default, READER)
end
local property_writer = function(self, name, default, cb)
    prop_accessor(self, self.__class, name, default, WRITER)
end
local property_accessor = function(self, name, default, cb)
    prop_accessor(self, self.__class, name, default, ACCESSOR)
end

local classMT = {
    __call = function(prop, obj, name, value)
        obj[name] = value
    end,
}

function property(class)
    local prop = setmetatable({
        __class = class,
        reader = property_reader,
        writer = property_writer,
        accessor = property_accessor,
    }, classMT)
    return prop
end

