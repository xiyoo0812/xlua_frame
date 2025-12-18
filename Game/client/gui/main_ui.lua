--main_ui.lua

local Window = import("gui/Window.lua")

local MainUI = class(Window)

function MainUI:__init()
    self:load_layout("main_ui", "main_ui")
    self:set_child_url("ground", "Image/CG/1")
end

function MainUI:init_event()
end

function MainUI:init_component()
end

function MainUI:on_close()
end

return MainUI
