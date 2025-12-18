--window.lua
local type          = type
local log_err       = logger.err
local sformat       = string.format

local window_mgr    = quanta.get("window_mgr")

local Window = class()
local prop = property(Window)
prop:accessor("widget", nil)
prop:accessor("parent", nil)
prop:accessor("name", "")

function Window:__init(parent, name)
    self.name = name
    self.parent = parent
end

--是否打开
function Window:is_opened()
    if self.widget and self.widget.parent then
        return true
    end
    return false
end

--打开窗口
function Window:open_gui(win_name, colse_self)
    local ui = window_mgr:open_gui(win_name)
    if ui then
        if colse_self then
            self:close()
        end
        return ui
    end
end

--加载UI配置文件
function Window:load_layout(package, layout)
    if self.parent and layout then
        self.widget = window_mgr:load_layout(package, layout)
        if self.widget then
            if type(self.init_event) == "function" then
                self:init_event()
            end
        else
            log_err("[Window][loadLayout] load {} failed!", layout)
        end
        return self.widget
    end
end

--tostring
function Window:tostring()
    return sformat("Window: {name=%s}", self.name)
end

--打开窗口
function Window:open()
    if self.parent and self.widget then
        if not self:is_opened() then
            if type(self.init_component) == "function" then
                self:init_component()
            end
            self.parent:AddChild(self.widget)
        end
    end
end

--关闭窗口
function Window:close()
    if self.parent and self.widget then
        if self:is_opened() then
            if type(self.on_close) == "function" then
                self:on_close()
            end
            self.parent:RemoveChild(self.widget)
        end
    end
end

--注册响应事件
function Window:register_click(child_name, response, widget_name)
    local child = self:get_child(child_name, widget_name)
    if child then
        child.onClick:Add(response)
    end
end

--注册响应事件
function Window:register_widget_click(widget, response, child_name)
    local child
    if child_name then
        child = widget:GetChild(child_name)
    end
    child = child or widget
    child.onClick:Add(response)
end

--获取子窗口
function Window:get_child(child_name, widget_name)
    if self.widget then
        if widget_name then
            local widget = self.widget:GetChild(widget_name)
            if widget then
                return widget:GetChild(child_name)
            end
        end
        return self.widget:GetChild(child_name)
    end
end

--获取控制器
function Window:get_controller(ctrl_name, widget_name)
    if self.widget then
        if widget_name then
            local widget = self.widget:GetChild(widget_name)
            if widget then
                return widget:GetController(ctrl_name)
            end
        end
        return self.widget:GetController(ctrl_name)
    end
end

--获取控制器状态
function Window:get_controller_status(ctrl_name, widget_name)
    local controller = self:get_controller(ctrl_name, widget_name)
    if controller then
        return controller:GetSelectedIndex()
    end
    return 0
end

--设置控制器状态
function Window:set_controller_status(ctrl_name, status, widget_name)
    local controller = self:get_controller(ctrl_name, widget_name)
    if controller then
        controller:SetSelectedIndex(status)
    end
end

--设置控制器状态
function Window:set_widget_controller_status(widget, ctrl_name, status)
    local controller = widget:GetController(ctrl_name)
    if controller then
        controller:SetSelectedIndex(status)
    end
end

--获取trans
function Window:get_transition(trans_name, widget_name)
    if self.widget then
        if widget_name then
            local widget = self.widget:GetChild(widget_name)
            if widget then
                return widget:GetTransition(trans_name)
            end
        end
        return self.widget:GetTransition(trans_name)
    end
end

--play trans
function Window:play_transition(trans_name, widget_name)
    local trans = self:get_transition(trans_name, widget_name)
    if trans then
        trans:Play()
    end
end

--显示子窗口
function Window:show_child(child_name, visible)
    local child = self:get_child(child_name)
    if child then
        child.visible = visible
    end
end

--设置子窗口text
function Window:set_child_text(child_name, txt, widget_name)
    local child = self:get_child(child_name, widget_name)
    if child then
        child.text = txt
    end
end

--子窗口text
function Window:get_child_text(child_name, widget_name)
    local child = self:get_child(child_name, widget_name)
    if child then
        return child.text
    end
end

--设置子窗口url
function Window:set_child_url(child_name, url, widget_name)
    local child = self:get_child(child_name, widget_name)
    if child then
        child.url = url
    end
end

--子窗口url
function Window:get_child_url(child_name, widget_name)
    local child = self:get_child(child_name, widget_name)
    if child then
        return child.url
    end
end

--孙窗口text
function Window:get_widget_text(widget, child_name)
    local child = widget:GetChild(child_name)
    if child then
        return child.text
    end
end

--孙窗口text
function Window:set_widget_text(widget, child_name, text)
    local child = widget:GetChild(child_name)
    if child then
        child.text = text
    end
end

--孙窗口text
function Window:set_widget_url(widget, child_name, url)
    local child = widget:GetChild(child_name)
    if child then
        child.url = url
    end
end

return Window
