-- 4080 DaHood Hub | Loader.lua
-- Executor entry. Keeps load order deterministic.
-- All files live in C:\Users\heiss\Desktop\bbladeball
getgenv().DH4080 = getgenv().DH4080 or {}
getgenv().DH4080.Version = "4.0.8.0"
getgenv().DH4080.Folder = "C:\\Users\\heiss\\Desktop\\bbladeball"

local MODULES = {
    "Config.lua",
    "Utils.lua",
    "UILib.lua",
    "Aimbot.lua",
    "Trigger.lua",
    "Silent.lua",
    "Rage.lua",
    "Visuals.lua",
    "World.lua",
    "Movement.lua",
    "Cfg.lua",
    "UI.lua",
    "Init.lua",
}

local function loadLocal(name)
    local path = getgenv().DH4080.Folder .. "\\" .. name
    local src = readfile(path)
    local fn, err = loadstring(src, name)
    assert(fn, "4080 compile fail " .. name .. ": " .. tostring(err))
    return fn()
end

for _, m in ipairs(MODULES) do
    loadLocal(m)
end
