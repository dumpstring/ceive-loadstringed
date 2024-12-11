local env = getgenv()

local loadedmodules = {}

local function ceiverequire(path)
	if loadedmodules[path] then
		return loadedmodules[path]
	end

    loadedmodules[path] = loadstring(game:HttpGet("https://raw.githubusercontent.com/dumpstring/ceive-loadstringed/refs/heads/main/src/CeiveImGizmo/"..path))()

    return loadedmodules[path]
end

env.ceiverequire = ceiverequire

local Ceive = ceiverequire("init.lua")

