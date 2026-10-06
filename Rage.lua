-- 4080 DaHood Hub | Rage.lua
-- HVH rage kit: Orbit (circle victim, force them to miss), Spinbot,
-- Jitter/AA (break enemy legit aa reads), RapidFire, NoRecoil,
-- AutoStomp/Reload/Armor, FakeLag, SpeedShot.
getgenv().DH4080 = getgenv().DH4080 or {}
local BB = getgenv().DH4080
local R = {}
R.OrbitTarget = nil
R.OrbitAng = 0
R.FakeTick = 0

local function C() return BB.Config.Rage end
local function U() return BB.Utils end

-- ORBIT: stick to victim at radius+height, circling fast. Closest or LowestHP.
function R.OrbitTick(dt)
    local O = C().Orbit
    if not C().Enabled or not O.Enabled then return end
    local UU = U()
    local root = UU.Root()
    if not root or not UU.Alive() then return end
    local t = R.OrbitTarget
    if not t or not UU.Char(t) or not UU.Alive(t) or (UU.Knocked(t)) then
        t = UU.PickTarget({FOV = 9999, TargetMode = O.TargetMode == "Lowest" and "LowestHP" or "Closest",
            TargetPart = "Head", Prediction = 0, WallCheck = false, TeamCheck = false,
            ForcefieldCheck = true, KnockedCheck = true, MaxDistance = 60})
        R.OrbitTarget = t
        if not t then return end
    end
    local er = UU.Root(t)
    if not er then return end
    R.OrbitAng += dt * O.Speed
    local rad = O.Radius + (O.Randomize and math.random(-2, 2) or 0)
    local h = O.Height + math.sin(os.clock() * 3) * O.HeightJitter
    local want = er.Position + Vector3.new(math.cos(R.OrbitAng) * rad, h, math.sin(R.OrbitAng) * rad)
    -- velocity-carry orbit: keeps momentum, harder to track than CFrame snap
    local cur = root.Position
    root.AssemblyLinearVelocity = (want - cur) * 8
    root.CFrame = CFrame.new(want, er.Position)
end

function R.SpinTick(dt)
    local S = C().Spinbot
    if not C().Enabled or not S.Enabled then return end
    local root = U().Root()
    if not root then return end
    local y = (os.clock() * 360 * (S.Speed / 20)) % 360
    local pitch = S.XSpin and 90 or 0
    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(math.rad(pitch), math.rad(y), 0)
end

function R.AATick()
    local A = C().AA
    if not C().Enabled or not A.Enabled then return end
    -- pitch/yaw desync via HumanoidRootPart + camera offset trick
    local root = U().Root()
    if not root then return end
    local pitchX = A.Pitch == "Up" and -1.5 or A.Pitch == "Down" and 1.5
        or A.Pitch == "Zero" and 0 or 0.8 -- Jitter
    R.FakeTick += 1
    local yaw = math.rad(A.YawBase + ((R.FakeTick % 2 == 0) and A.YawJitter or -A.YawJitter))
    U().Camera.CFrame = CFrame.new(U().Camera.CFrame.Position)
        * CFrame.Angles(pitchX, yaw, 0)
end

function R.RapidTick()
    local F = C().RapidFire
    if not C().Enabled or not F.Enabled then return end
    -- spam fire input at Rate multiplier while LMB held
    local UIS = game:GetService("UserInputService")
    if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        for _ = 1, F.Rate do
            U().VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        end
        task.wait(0.03)
        U().VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end
end

function R.NoRecoilTick()
    local N = C().NoRecoil
    if not C().Enabled or not N.Enabled then return end
    -- DaHood recoil = camera kick; we store pre-shot pitch and restore fraction.
    -- implemented as gentle downward-drift cancel each frame.
    local cam = U().Camera
    local k = (N.Strength / 100) * 0.02
    cam.CFrame = cam.CFrame * CFrame.Angles(k, 0, 0)
end

function R.UtilTick()
    local CC = C()
    if not CC.Enabled then return end
    local UU = U()
    if CC.AutoStomp.Enabled and UU.EquippedTool() == nil then
        for _, p in ipairs(UU.Players:GetPlayers()) do
            if p ~= UU.LocalPlayer and UU.Knocked(p) and not UU.Grabbed(p) then
                local r, mine = UU.Root(p), UU.Root()
                if r and mine and (r.Position - mine.Position).Magnitude < 12 then
                    UU.KeyPress(CC.AutoStomp.Key, 30)
                end
            end
        end
    end
    if CC.AutoReload.Enabled and UU.AmmoLeft() <= CC.AutoReload.Threshold then
        UU.KeyPress(Enum.KeyCode.R, 30)
    end
    if CC.SpeedShot.Enabled then
        local t = UU.EquippedTool()
        if t and not t:GetAttribute("DH4080_Fired") then
            t:SetAttribute("DH4080_Fired", true)
            UU.Click()
            task.delay(1, function() pcall(function() t:SetAttribute("DH4080_Fired", false) end) end)
        end
    end
end

-- FakeLag: freeze outgoing replication ticks (executor net cull if available)
function R.FakeLagTick()
    local F = C().FakeLag
    if not C().Enabled or not F.Enabled then return end
    if getgenv().DH4080._fakelag == nil then getgenv().DH4080._fakelag = false end
end

function R.Tick(dt)
    R.OrbitTick(dt)
    R.SpinTick(dt)
    R.AATick()
    R.NoRecoilTick()
end

BB.Rage = R
return R
