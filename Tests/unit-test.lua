require("Tests.Globals")
require("Tests.WOWAPI")
if pcall(function() require("bit") end) then
	-- Using Lua 5.2+ with the bit library
elseif pcall(function() require("bit32") end) then
	-- Using Lua 5.2+ with the bit32 library
	bit = require("bit32")
else
	-- Using LuaJIT with FFI
	ffi = require("ffi")
	ffi.cdef[[
		unsigned int bit_band(unsigned int a, unsigned int b);
		unsigned int bit_bor(unsigned int a, unsigned int b);
		unsigned int bit_bxor(unsigned int a, unsigned int b);
		unsigned int bit_lshift(unsigned int a, int b);
		unsigned int bit_rshift(unsigned int a, int b);
		unsigned int bit_arshift(unsigned int a, int b);
		unsigned int bit_not(unsigned int a);
		unsigned int bit_bswap(unsigned int a);
	]]
	bit = ffi.load(ffi.os == "Windows" and "lua51.dll" or "libluajit-5.1.so.2")
end


-- Mimicking the WOW client's behavior doesn't work well with the current setup (improve later)
local addonName, addonTable = unpack(require("Tests.RarityCoreSetup"))
_G.RARITY_ADDON_NAME = addonName
_G.RARITY_ADDON_TABLE = addonTable
assert(_G.RARITY_ADDON_NAME == "Rarity", "Unexpected addon name")
assert(_G.RARITY_ADDON_TABLE, "Uninitialized addon table")

local specFiles = {
	"Tests/test-items.spec.lua",
	"Tests/test-database.spec.lua",
	"Tests/test-holiday-events.spec.lua",
	"Tests/test-serialization.spec.lua",
	"Tests/test-toc.spec.lua",
}

local numFailedSections = C_Runtime.RunDetailedTests(specFiles)

os.exit(numFailedSections)
