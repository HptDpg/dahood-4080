-- 4080 DaHood Hub | Silent.lua
-- Silent aim via raycast hook: rewrites bullet ray destination to predicted
-- target point. Method Raycast hooks game raycasts; Method Index hooks
-- mouse.Hit/UnitRay reads. No camera movement = invisible in clips.
getgenv().DH4080 = getgenv().DH4080 or {}
local BB = getgenv().DH4080
local S = {}
S.Target = nil
S.Hooked = false

local function C() return BB.Config.Silent end
local function U() return BB.Utils end

function S.Pick()
    local CC, UU = C(), U()
    if math.random(100) > CC.HitChance then return S.Target end
    local t = UU.PickTarget({
        FOV = CC.FOV, TargetMode = CC.TargetMode, TargetPart = CC.TargetPart,
        Prediction = CC.Prediction, WallCheck = CC.WallCheck,
        TeamCheck = false, ForcefieldCheck = false,
        KnockedCheck = CC.KnockedCheck, MaxDistance = CC.MaxDistance })
    if t then S.Target = t end
    return S.Target
end

function S.Point()
    local CC, UU = C(), U()
    local t = S.Target
    if not t or not UU.Char(t) or not UU.Alive(t) then return nil end
    if CC.KnockedCheck and UU.Knocked(t) then return nil end
    local partName = UU.ResolvePart(t, CC.TargetPart)
    local pt = UU.Predict(t, partName, CC.Prediction)
    return pt
end

function S.Hook()
    if S.Hooked then return end
    S.Hooked = true
    -- refresh target on heartbeat; hooks below consume S.Point()
    task.spawn(function()
        while true do
            task.wait(0.1)
            local CC = C()
            if CC.Enabled then S.Pick()
            else S.Target = nil end
        end
    end)
    -- Raycast method: hook workspace raycasts fired by gun scripts.
    -- We use namecall hook on Raycast if executor supports it.
    local ok = pcall(function()
        local old
        old = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if C().Enabled and C().Method == "Raycast" and method == "Raycast"
                and typeof(self) == "Instance" and self == workspace then
                local pt = S.Point()
                if pt then
                    local args = {...}
                    if #args >= 2 then
                        local origin = args[1]
                        args[2] = (pt - origin)
                        return old(self, unpack(args))
                    end
                end
            end
            return old(self, ...)
        end)
    end)
    if not ok then
        -- Index fallback: rewrite mouse.Hit for guns that read it
        pcall(function()
            local mouse = U().Mouse
            local oldIdx
            oldIdx = hookmetamethod(game, "__index", function(self, k)
                if C().Enabled and C().Method == "Index" and self == mouse
                    and (k == "Hit" or k == "Target") then
                    local pt = S.Point()
                    if pt then
                        if k == "Hit" then return CFrame.new(pt) end
                        if k == "Target" and S.Target then
                            local c = U().Char(S.Target)
                            local p = c and (c:FindFirstChild("Head") or c:FindFirstChild("UpperTorso"))
                            return p
                        end
                    end
                end
                return oldIdx(self, k)
            end)
        end)
    end
end

BB.Silent = S
return S
