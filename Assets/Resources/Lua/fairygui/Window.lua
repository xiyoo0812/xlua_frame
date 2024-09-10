--Window.lua
local type      = type
local pairs     = pairs
local print     = print
local tinsert   = table.insert

Window = class()
local prop = property(Window)
prop:accessor("widget", nil)
prop:accessor("parent", nil)
prop:accessor("name", "")

function Window:__init(parent, name)
    self.name = name
    self.parent = parent
    self.callbacks = {}
end

function Window:destory()
    for _, click in pairs(self.callbacks) do
        click:Clear()
    end
end

--是否打开
function Window:isOpened()
    if self.widget and self.widget.parent then
        return true
    end
    return false
end

--打开窗口
function Window:openGUI(win_name, colse_self)
    local ui = Fairy_Create_GUI(win_name)
    if ui then
        ui:open()
        if colse_self then
            self:close()
        end
        return ui
    end
end


function Window:addCallback(callback)
    tinsert(self.callbacks, callback)
end

--加载UI配置文件
function Window:loadLayout(layout, package)
    if self.parent and layout then
        UIPackage.AddPackage("FairyGUI/" .. package)
        self.widget = UIPackage.CreateObject(package, layout)
        if self.widget then
            if type(self.initEvent) == "function" then
                self:initEvent()
            end
            self:createResponse("btn_close", function()
                self:close()
            end, "frame")
        else
            print(string.format("loadLayout Failed! layout = %s", layout))
        end
        return self.widget
    end
end

--tostring
function Window:tostring()
    return string.format("Window: {name=%s}", self.name)
end

--打开窗口
function Window:open()
    if self.parent and self.widget then
        if not self:isOpened() then
            if type(self.initComponent) == "function" then
                self:initComponent()
            end
            self.parent:AddChild(self.widget)
        end
    else
        print("Window:open() Failed! ", self.parent, self.widget)
    end
end

--关闭窗口
function Window:close()
    if self.parent and self.widget then
        if self:isOpened() then
            if type(self.onClose) == "function" then
                self:onClose()
            end
            self.parent:RemoveChild(self.widget)
        end
    else
        print("Window:close() Failed! ", self.parent, self.widget)
    end
end

--注册响应事件
function Window:createResponse(child_name, response, widgetName)
    local child = self:getChild(child_name, widgetName)
    if child then
        local function callback(context)
            response(context)
        end
        child.onClick:Add(callback)
        tinsert(self.callbacks, child.onClick)
    end
end

--注册响应事件
function Window:createWidgetResponse(widget, response, child_name)
    local child
    if child_name then
        child = widget:GetChild(child_name)
    end
    child = child or widget
    local function callback(context)
        response(context)
    end
    child.onClick:Add(callback)
    tinsert(self.callbacks, child.onClick)
end

--获取子窗口
function Window:getChild(childName, widgetName)
    if self.widget then
        if widgetName then
            local widget = self.widget:GetChild(widgetName)
            if widget then
                return widget:GetChild(childName)
            end
        end
        return self.widget:GetChild(childName)
    end
end

--获取控制器
function Window:getController(ctrlName, widgetName)
    if self.widget then
        if widgetName then
            local widget = self.widget:GetChild(widgetName)
            if widget then
                return widget:GetController(ctrlName)
            end
        end
        return self.widget:GetController(ctrlName)
    end
end

--获取控制器状态
function Window:getControllerStatus(ctrlName, widgetName)
    local controller = self:getController(ctrlName, widgetName)
    if controller then
        return controller:GetSelectedIndex()
    end
    return 0
end

--设置控制器状态
function Window:setControllerStatus(ctrlName, status, widgetName)
    local controller = self:getController(ctrlName, widgetName)
    if controller then
        controller:SetSelectedIndex(status)
    end
end

--设置控制器状态
function Window:setWidgetControllerStatus(widget, ctrlName, status)
    local controller = widget:GetController(ctrlName)
    if controller then
        controller:SetSelectedIndex(status)
    end
end

--获取trans
function Window:getTransition(transName, widgetName)
    if self.widget then
        if widgetName then
            local widget = self.widget:GetChild(widgetName)
            if widget then
                return widget:GetTransition(transName)
            end
        end
        return self.widget:GetTransition(transName)
    end
end

--play trans
function Window:playTransition(transName, widgetName)
    local trans = self:getTransition(transName, widgetName)
    if trans then
        trans:Play()
    end
end

--显示子窗口
function Window:showChild(childName, visible)
    local child = self:getChild(childName)
    if child then
        child.visible = visible
    end
end

--设置子窗口text
function Window:setChildText(childName, txt, widgetName)
    local child = self:getChild(childName, widgetName)
    if child then
        child.text = txt
    end
end

--子窗口text
function Window:getChildText(childName, widgetName)
    local child = self:getChild(childName, widgetName)
    if child then	
        return child.text
    end
end

--设置子窗口url
function Window:setChildUrl(childName, url, widgetName)
    local child = self:getChild(childName, widgetName)
    if child then
        child.url = url
    end
end

--子窗口url
function Window:getChildUrl(childName, widgetName)
    local child = self:getChild(childName, widgetName)
    if child then
        return child.url
    end
end

--孙窗口text
function Window:getWidgetText(widget, childName)
    local child = widget:GetChild(childName)
    if child then
        return child.text
    end
end

--孙窗口text
function Window:setWidgetText(widget, childName, text)
    local child = widget:GetChild(childName)
    if child then
        child.text = text
    end
end

--孙窗口text
function Window:setWidgetUrl(widget, childName, url)
    local child = widget:GetChild(childName)
    if child then
        child.url = url
    end
end
