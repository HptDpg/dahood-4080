-- 4080 DaHood Hub | Init.lua
-- Boot: binds, builds UI, hooks silent, starts master loops, panic key.
getgenv().DH4080 = getgenv().DH4080 or {}
local BB = getgenv().DH4080
assert(BB.Config and BB.Utils and BB.UILib and BB.Aimbot and BB.Trigger
    and BB.Silent and BB.Rage and BB.Visuals and BB.World and BB.Movement
    and BB.Cfg and BB.UI, "4080: load order broken, use Loader.lua")

local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

BB.Aimbot.Bind()
BB.Trigger.Bind()
BB.Movement.Bind()
BB.UI.Build()
BB.Silent.Hook()
pcall(function() setfpscap(BB.Config.Settings.FPSCap) end)

-- anti AFK
if BB.Config.Settings.AntiAFK then
    local VU = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VU:CaptureController() VU:ClickButton2(Vector2.new())
    end)
end

-- panic key: kills visuals + UI + rage in one press
UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == BB.Config.Settings.PanicKey then
        BB.Config.ESP.Enabled = false
        BB.Config.Rage.Enabled = false
        BB.Config.Aimbot.Enabled = false
        BB.Config.Trigger.Enabled = false
        BB.Config.Silent.Enabled = false
        BB.Visuals.Cleanup()
        local g2 = game:GetService("CoreGui"):FindFirstChild("DH4080")
        if g2 then g2:FindFirstChild("Main").Visible = false end
    end
    if i.KeyCode == BB.Config.UIToggle then
        local g2 = game:GetService("CoreGui"):FindFirstChild("DH4080")
        local m = g2 and g2:FindFirstChild("Main")
        if m then
            BB.UILib.ClosePopups()
            m.Visible = not m.Visible
        end
    end
end)

-- master loops
local lastAim = 0
RS.Heartbeat:Connect(function(dt)
    pcall(function()
        BB.Aimbot.Tick()
        BB.Trigger.Tick()
        BB.Rage.Tick(dt)
        BB.Rage.UtilTick()
        BB.Rage.RapidTick()
        BB.Movement.Tick(dt)
        BB.World.Tick()
    end)
end)
RS.RenderStepped:Connect(function()
    pcall(function()
        BB.Visuals.Tick()
        BB.UI.FovTick()
        -- silent aim dot
        local SI = BB.Config.Silent
        -- (dot drawn via visuals head-dot; silent target uses same pipeline)
    end)
end)

getgenv().DH4080_Unload = function() BB.Shutdown() end
function BB.Shutdown()
    pcall(function() BB.Visuals.Cleanup() end)
    pcall(function() BB.World.Restore() end)
    for _, f in pairs(BB.UI.Fovs) do pcall(function() f.o:Remove() end) end
    pcall(function() game:GetService("CoreGui"):FindFirstChild("DH4080"):Destroy() end)
    BB.Movement.SpeedOff()
    print("4080 dahood unloaded")
end

print("4080 DaHood Hub v" .. BB.Config.Version .. " live — stashed")
