require 'base.base'

--全局数据
Global = {
    windows = {},
}

require 'fairygui.FairyGUI'

local a = {
    sss = 3,
    bbb = 4
}

require("ljson")
require("luapb")

print(json.encode(a))

function Update()
end

print("main gage start!")
UIPackage.AddPackage("FairyGUI/common");
local main_ui = Fairy_Create_GUI("MainUI")
main_ui:open()
