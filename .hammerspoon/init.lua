local application = require("hs.application")
local hotkey = require("hs.hotkey")

local openApp = function(name)
	local app = application.get(name)

	if app then
		if app:isFrontmost() then
			app:hide()
		else
			app:activate()
		end
	else
		application.launchOrFocusByBundleID(name)
	end
end

hotkey.bind({ "cmd" }, "§", function()
	openApp("net.kovidgoyal.kitty")
end)
