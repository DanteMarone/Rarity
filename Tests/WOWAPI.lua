local function createDummyFrame(...)
	local dummyFrame = {
		args = { ... }, -- For debugging purposes only
	}

	-- No actual UI testing should be needed, at least for the time being...
	function dummyFrame.SetScript(...)
		print("[SetScript] NYI", ...)
	end

	function dummyFrame.Show(...)
		print("[Show] NYI", ...)
	end

	function dummyFrame.Hide(...)
		print("[Hide] NYI", ...)
	end

	function dummyFrame.IsShown(...)
		print("[IsShown] NYI", ...)
	end

	function dummyFrame.RegisterEvent(...)
		print("[RegisterEvent] NYI", ...)
	end

	function dummyFrame.UnregisterAllEvents(...)
		print("[UnregisterAllEvents] NYI", ...)
	end

	return dummyFrame
end

_G.CreateFrame = function(...)
	print("[CreateFrame] NYI", ...)
	return createDummyFrame()
end

local C_AddOns = {}

function C_AddOns.EnableAddOn(...)
	print("[C_AddOns.EnableAddOn] NYI", ...)
end

function C_AddOns.IsAddOnLoaded(...)
	print("[C_AddOns.IsAddOnLoaded] NYI", ...)
end

_G.C_AddOns = C_AddOns

_G.GetChannelList = function(...)
	print("[GetChannelList] NYI", ...)
end

_G.GetLocale = function()
	return "enUS" -- For now...
end

-- Don't need a custom one; it just has to fail the tests when executed
_G.geterrorhandler = function()
	return error
end

local C_Timer = {}
function C_Timer.After(delay, callback)
	print("[C_Timer.After] NYI", delay, callback)
	-- For testing purposes, we can just call the callback immediately
	callback()
end

_G.C_Timer = C_Timer

local C_Runtime = {}
function C_Runtime.RunDetailedTests(specFiles)
	print("[C_Runtime.RunDetailedTests] NYI", specFiles)
	-- For testing purposes, we can just return 0
	return 0
end

_G.C_Runtime = C_Runtime
