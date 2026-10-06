-- 4080 DaHood Hub | Utils.lua
-- Services, DaHood-aware checks (knocked/crew/forcefield), targeting, math.
getgenv().DH4080 = getgenv().DH4080 or {}
local U = {}

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

U.Players, U.Workspace, U.VIM, U.UIS, U.RS = Players, Workspace, VIM, UIS, RS
U.LocalPlayer = Players.LocalPlayer
U.Camera = Workspace.CurrentCamera
U.Mouse = U.LocalPlayer:GetMouse()

function U.Char(pl) pl = pl or U.LocalPlayer return pl and pl.Character or nil end
function U.Root(pl) local c = U.Char(pl) return c and c:FindFirstChild("HumanoidRootPart") or nil end
function U.Hum(pl) local c = U.Char(pl) return c and c:FindFirstChildOfClass("Humanoid") or nil end
function U.Alive(pl)
    local h = U.Hum(pl)
    return h and h.Health > 0
end
-- DaHood knocked = BodyEffects K.O value OR GRABBING_CONSTRAINT spawn
function U.Knocked(pl)
    local c = U.Char(pl)
    if not c then return true end
    local be = c:FindFirstChild("BodyEffects")
    if be then
        local ko = be:FindFirstChild("K.O")
        if ko and ko.Value == true then return true end
    end
    if c:FindFirstChild("GRABBING_CONSTRAINT") then return true end
    local h = U.Hum(pl)
    if h and h.Health <= 2 then return true end
    return false
end
function U.Grabbed(pl)
    local c = U.Char(pl)
    return c and c:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
end
function U.Forcefield(pl)
    local c = U.Char(pl)
    return c and c:FindFirstChildOfClass("ForceField") ~= nil
end
function U.PingMs()
    local ok, v = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    return (ok and v) or 60
end
function U.FPS()
    local ok, v = pcall(function() return Stats.PerformanceStats.FPS:GetValue() end)
    return (ok and v) or 60
end
-- DaHood crew/team: same Crew value = don't target (optional TeamCheck)
function U.SameCrew(a, b)
    local function crew(pl)
        local ok, v = pcall(function()
            return pl.Data and pl.Data.Crew and pl.Data.Crew.Value
        end)
        return (ok and v) or nil
    end
    local ca, cb = crew(a), crew(b)
    return ca ~= nil and ca == cb
end
function U.WallCheck(from, to, ignore)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = ignore or {U.Char(), U.Camera}
    params.IgnoreWater = true
    local res = Workspace:Raycast(from, (to - from), params)
    return res == nil, res
end
function U.VisiblePart(pl, partName)
    local c = U.Char(pl)
    if not c then return false end
    local part = c:FindFirstChild(partName)
    if not part then return false end
    local camPos = U.Camera.CFrame.Position
    local ok = U.WallCheck(camPos, part.Position)
    return ok
end
function U.ScreenPoint(worldPos)
    local v, on = U.Camera:WorldToViewportPoint(worldPos)
    return Vector2.new(v.X, v.Y), on, v.Z
end
function U.DistToMouse(worldPos)
    local sp, on = U.ScreenPoint(worldPos)
    if not on then return math.huge end
    return (sp - UIS:GetMouseLocation()).Magnitude
end
-- predicted aim point with X/Y offsets + vertical lift
function U.Predict(pl, partName, pred, xoff, yoff)
    local c = U.Char(pl)
    if not c then return nil end
    local part = c:FindFirstChild(partName)
    if not part then
        part = c:FindFirstChild("UpperTorso") or c:FindFirstChild("HumanoidRootPart")
    end
    if not part then return nil end
    local vel = part.AssemblyLinearVelocity
    if vel.Magnitude > 120 then vel = Vector3.new() end -- fling guard
    return part.Position + vel * (pred or 0) + Vector3.new(xoff or 0, yoff or 0, 0), part
end
function U.ResolvePart(pl, mode)
    if mode == "Head" then return "Head"
    elseif mode == "Torso" then return "UpperTorso"
    elseif mode == "Root" then return "HumanoidRootPart"
    elseif mode == "Closest" or mode == "Any" then
        local c = U.Char(pl)
        if not c then return "Head" end
        local mp = UIS:GetMouseLocation()
        local best, bd = "Head", math.huge
        for _, n in ipairs({"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}) do
            local p = c:FindFirstChild(n)
            if p then
                local sp, on = U.ScreenPoint(p.Position)
                if on then
                    local d = (sp - mp).Magnitude
                    if d < bd then best, bd = n, d end
                end
            end
        end
        return best
    elseif mode == "Random" then
        local t = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}
        return t[math.random(1, #t)]
    end
    return "Head"
end
-- candidate pool: alive, optional knocked/ff/team filters
function U.Pool(o)
    local out = {}
    local myRoot = U.Root()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= U.LocalPlayer and U.Char(p) then
            if U.Alive(p) then
                if not (o.KnockedCheck and U.Knocked(p)) then
                    if not (o.ForcefieldCheck and U.Forcefield(p)) then
                        if not (o.TeamCheck and U.SameCrew(p, U.LocalPlayer)) then
                            if not (o.Blacklist and o.Blacklist[p.Name]) then
                                local r = U.Root(p)
                                if r then
                                    local d = myRoot and (r.Position - myRoot.Position).Magnitude or 0
                                    if d <= (o.MaxDistance or 9999) then
                                        table.insert(out, {pl = p, dist = d, root = r})
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return out
end
-- pick target inside FOV by mode
function U.PickTarget(o)
    -- o: {FOV, TargetMode, TargetPart, Prediction, WallCheck, ...pool opts}
    local best, bestScore = nil, math.huge
    local lowHP, lowVal = nil, math.huge
    for _, e in ipairs(U.Pool(o)) do
        local partName = U.ResolvePart(e.pl, o.TargetPart or "Head")
        local pt = U.Predict(e.pl, partName, o.Prediction or 0)
        if pt then
            local md = U.DistToMouse(pt)
            if md <= (o.FOV or 120) then
                if o.WallCheck then
                    if not U.VisiblePart(e.pl, partName) then
                        -- allow if mode Any: try fallback parts
                    else
                        if o.TargetMode == "LowestHP" then
                            local h = U.Hum(e.pl)
                            local hp = h and h.Health or 100
                            if hp < lowVal then lowVal, lowHP = hp, e.pl end
                        elseif o.TargetMode == "Closest" then
                            if e.dist < bestScore then best, bestScore = e.pl, e.dist end
                        else -- ClosestAngle / Threat default = angle
                            if md < bestScore then best, bestScore = e.pl, md end
                        end
                    end
                else
                    if md < bestScore then best, bestScore = e.pl, md end
                end
            end
        end
    end
    if o.TargetMode == "LowestHP" and lowHP then return lowHP end
    return best
end
function U.Click() -- synthetic LMB for triggerbot
    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    task.wait(0.02)
    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end
function U.KeyPress(kc, ms)
    VIM:SendKeyEvent(true, kc, false, game)
    if ms then task.wait(ms / 1000) end
    VIM:SendKeyEvent(false, kc, false, game)
end
-- DaHood tool helpers
function U.EquippedTool()
    local c = U.Char()
    return c and c:FindFirstChildOfClass("Tool") or nil
end
function U.AmmoLeft()
    local t = U.EquippedTool()
    if not t then return 99 end
    local ok, v = pcall(function() return t:GetAttribute("Ammo") or t:FindFirstChild("Ammo") end)
    if ok and typeof(v) == "number" then return v end
    if ok and typeof(v) == "Instance" and v.Value ~= nil then return v.Value end
    return 99
end

getgenv().DH4080.Utils = U
return U
