--MainUI.lua
require 'fairygui.Window'


MainUI = class(Window)

function MainUI:__init()
    self:loadLayout("main_ui", "main_ui")
    self:setChildUrl("ground", "Image/CG/1")
end

function MainUI:initEvent()
end

function MainUI:initComponent()
end

function MainUI:onClose()
end