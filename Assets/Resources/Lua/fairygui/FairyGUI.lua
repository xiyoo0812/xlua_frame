EventContext = CS.FairyGUI.EventContext
EventListener = CS.FairyGUI.EventListener
EventDispatcher = CS.FairyGUI.EventDispatcher
InputEvent = CS.FairyGUI.InputEvent
NTexture = CS.FairyGUI.NTexture
Container = CS.FairyGUI.Container
Image = CS.FairyGUI.Image
Stage = CS.FairyGUI.Stage
Controller = CS.FairyGUI.Controller
GObject = CS.FairyGUI.GObject
GGraph = CS.FairyGUI.GGraph
GGroup = CS.FairyGUI.GGroup
GImage = CS.FairyGUI.GImage
GLoader = CS.FairyGUI.GLoader
GMovieClip = CS.FairyGUI.GMovieClip
TextFormat = CS.FairyGUI.TextFormat
GTextField = CS.FairyGUI.GTextField
GRichTextField = CS.FairyGUI.GRichTextField
GTextInput = CS.FairyGUI.GTextInput
GComponent = CS.FairyGUI.GComponent
GList = CS.FairyGUI.GList
GRoot = CS.FairyGUI.GRoot
GLabel = CS.FairyGUI.GLabel
GButton = CS.FairyGUI.GButton
GComboBox = CS.FairyGUI.GComboBox
GProgressBar = CS.FairyGUI.GProgressBar
GSlider = CS.FairyGUI.GSlider
PopupMenu = CS.FairyGUI.PopupMenu
ScrollPane = CS.FairyGUI.ScrollPane
Transition = CS.FairyGUI.Transition
UIPackage = CS.FairyGUI.UIPackage
Window = CS.FairyGUI.Window
GObjectPool = CS.FairyGUI.GObjectPool
Relations = CS.FairyGUI.Relations
RelationType = CS.FairyGUI.RelationType
UIPanel = CS.FairyGUI.UIPanel
UIPainter = CS.FairyGUI.UIPainter
TypingEffect = CS.FairyGUI.TypingEffect

local windows   = Global.windows
function Fairy_Create_GUI(name, parent)
    parent = parent or GRoot.inst
    local win = windows[name]
    if not win then
        require("fairygui." .. name)
        assert(_G[name] ~= nil, string.format("%s GUI not found.", name))
        win = _G[name](parent, name)
        windows[name] = win
    end
    return win
end

function Lua_Dispose()
    for _, win in pairs(windows) do
        win:destory()
    end
    windows = nil
end
