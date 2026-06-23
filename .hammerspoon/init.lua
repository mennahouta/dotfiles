local bundleID = "com.mitchellh.ghostty"

hs.hotkey.bind({ "ctrl" }, "`", function()
	local app = hs.application.get(bundleID)

	if not app then
		hs.application.launchOrFocusByBundleID(bundleID)
		return
	end

	if app:isFrontmost() then
		app:hide()
	else
		app:activate(true)
	end
end)
