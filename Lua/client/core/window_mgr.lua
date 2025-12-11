--window_mgr.lua

local log_err   = logger.err
local sformat   = string.format
local ABMgr     = CS.ABMgr
local GRoot     = CS.FairyGUI.GRoot
local UIPackage = CS.FairyGUI.UIPackage

local WindowMgr = singleton()
local prop = property(WindowMgr)
prop:reader("guis", {})
prop:reader("packages", {})

function WindowMgr:__init()
    self:add_package("common")
end

function WindowMgr:__release()
    for _, win in pairs(self.guis) do
        win:destory()
    end
    UIPackage.RemoveAllPackages()
    self.packages = {}
    self.guis = {}
end

function WindowMgr:add_package(name)
    if self.packages[name] then
        return
    end
    local ab = ABMgr.LoadAB(name)
    if not ab then
        log_err("[WindowMgr][add_package] load ab: {} failed!", name)
        return
    end
    local pkg = UIPackage.AddPackage(ab)
    if not pkg then
        log_err("[WindowMgr][add_package] add package: {} failed!", name)
        return
    end
    self.packages[name] = pkg
end

function WindowMgr:remove_package(name)
    local pkg = self.packages[name]
    if pkg then
        UIPackage.RemovePackage(name)
    end
end

function WindowMgr:load_layout(package, layout)
    self:add_package(package)
    return UIPackage.CreateObject(package, layout)
end

function WindowMgr:create_gui(name, parent)
    parent = parent or GRoot.inst
    local gui = self.guis[name]
    if not gui then
        local window = import(sformat("gui/%s.lua", name))
        gui = window(parent, name)
        self.guis[name] = gui
    end
    return gui
end

function WindowMgr:open_gui(name)
    local gui = self:create_gui(name)
    if gui then
        gui:open()
        return gui
    end
end

quanta.window_mgr = WindowMgr()

return WindowMgr

