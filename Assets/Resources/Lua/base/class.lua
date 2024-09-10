--class.lua
local type = type
local pcall = pcall
local rawset = rawset
local rawget = rawget
local tostring = tostring
local ssub = string.sub
local sformat = string.format
local dgetinfo = debug.getinfo

--类模板
local class_temples = class_temples or {}

local function rawnew(class, object, ...)
    if class.__super then
        rawnew(class.__super, object, ...)
    end
    if type(class.__init) == "function" then
        class.__init(object, ...)
    end
    return object
end

local function object_default(class, object)
    if class.__super then
        object_default(class.__super, object)
    end
    table.deep_copy(class.__default, object)
end

local function object_tostring(object)
    if type(object.tostring) == "function" then
        return object:tostring()
    end
    return sformat("class:%s(%s)", object.__moudle, object.__addr)
end

local function object_constructor(class, ...)
    local obj = {}	
    object_default(class, obj)
    obj.__addr = ssub(tostring(obj), 7)
    local object = setmetatable(obj, class.__vtbl)
    return rawnew(class, object, ...)
end

local function new(class, ...)	
    if class.__singleton then
        local inst_obj = rawget(class, "__inst")
        if not inst_obj then
            inst_obj = object_constructor(class, ...)
            --定义单例方法
            local inst_func = function()
                return inst_obj
            end
            rawset(class, "__inst", inst_obj)
            rawset(class, "inst", inst_func)
        end
        return inst_obj
    else
            return object_constructor(class, ...)
       end
end

local function index(class, field)
    return class.__vtbl[field]
end

local function newindex(class, field, value)
    class.__vtbl[field] = value
end

local classMT = {
    __call = new, 
    __index = index, 
    __newindex = newindex 
}

local function class_constructor(class, super)
    local info = dgetinfo(2, "S")
    local moudle = info.short_src
    local vtbl = {}
    local class_tpl = class_temples[moudle]
    if not class_tpl then
        vtbl.__index = vtbl
        vtbl.__moudle = moudle
        vtbl.__tostring = object_tostring
        if super then
            setmetatable(vtbl, {__index = super})
        end
        class.__vtbl = vtbl
        class.__super = super
        class.__default = {}
        class_tpl = setmetatable(class, classMT)
        class_temples[moudle] = class_tpl
    end
    return class_tpl
end

function class(super)
    return class_constructor({}, super)
end

function singleton(super)	
    return class_constructor({__singleton = true}, super)
end

function isclass(class)
    local mt = getmetatable(class)
    if mt == classMT then
        return true
    end
    return false
end

function superclass(class)
    return rawget(class, "__super")
end

function subclassof(class, super)
    while class do
        if class == super then
            return true
        end
        class = rawget(class, "__super")
    end
    return false
end

function instanceof(object, class)
    if object and class and isclass(object) then
        return subclassof(object, class)
    end
    return false
end

function convclass(str)
    local code, cls = pcall(load("local cls= ".. str .. " return cls"))
    if isclass(cls) then
        return cls
    end
end

