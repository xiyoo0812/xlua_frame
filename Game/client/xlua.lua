--xlua.lua
import("kernel.lua")

quanta.startup(function()
    import("core/window_mgr.lua")
    quanta.window_mgr:open_gui("main_ui")
end)
