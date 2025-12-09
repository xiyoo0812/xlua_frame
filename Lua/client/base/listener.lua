--_listener.lua
local sformat   = string.format

Listener = class()
function Listener:__init()
	self._listeners = {}
end

function Listener:addListener(listener, event)
    if not self._listeners[event] then
        self._listeners[event] = {}
    end
    self._listeners[event][listener] = true
end

function Listener:removeListener(listener, event)
    if self._listeners[event] then
        self._listeners[event][listener] = nil
    end
end

function Listener:notifyListener(event, ...)
	for _listener, _ in pairs(self._listeners[event] or {}) do
		if _listener[event] then
            local ok, ret = xpcall(_listener[event], debug.traceback, _listener, ...)
            if not ok then
                print(sformat("notifyListener xpcall %s:%s failed, err : %s!", _listener, event, ret))
            end
		end
	end
end
