-- 4080 DaHood Hub | Trigger.lua
-- Triggerbot: when crosshair sits on target part inside FOV, auto-click.
-- DelayMs = wait BEFORE 1st shot. ConsecutiveDelayMs = wait AFTER 1st shot
-- before next allowed (anti-spray). Key rebindable via UI "press next key".
-- ToggleMode = press once to arm, press again to disarm.
getgenv().DH4080 = getgenv().DH4080 or {}
local BB = getgenv().DH4080
local T = {}
T.Holding = false
T.Armed = false       -- toggle-mode state
T.FirstShotAt = 0
T.LastShotAt = 0
T.Shots = 0

local function C() return BB.Config.Trigger end
local function U() return BB.Utils end

function T.KeyDown(input)
    local CC = C()
    if input.UserInputType == Enum.UserInputType.Keyboard then
        return input.KeyCode == CC.Key
    end
    return input.UserInputType == CC.Key
end

function T.Active()
    local CC = C()
    if CC.ToggleMode then return CC.Active end
    return T.Holding
end

function T.TargetUnderCross()
    local CC, UU = C(), U()
    local mp = UU.UIS:GetMouseLocation()
    local best, bd = nil, CC.FOV
    for _, e in ipairs(UU.Pool({KnockedCheck = CC.KnockedCheck, TeamCheck = CC.TeamCheck,
        ForcefieldCheck = false, MaxDistance = CC.MaxDistance, Blacklist = CC.Blacklist})) do
        local parts = {}
        if CC.TargetPart == "Any" then parts = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}
        elseif CC.TargetPart == "Torso" then parts = {"UpperTorso", "LowerTorso"}
        else parts = {"Head"} end
        for _, pn in ipairs(parts) do
            local c = UU.Char(e.pl)
            local part = c and c:FindFirstChild(pn)
            if part then
                local sp, on = UU.ScreenPoint(part.Position)
                if on then
                    -- radius check: use part size projected, min 4px, max FOV
                    local d = (sp - mp).Magnitude
                    local pr = math.clamp(1200 / (UU.Camera.CFrame.Position - part.Position).Magnitude, 4, 26)
                    if d <= math.max(pr, 4) and d < bd then
                        if CC.WallCheck and not UU.VisiblePart(e.pl, pn) then
                            -- blocked, skip
                        else
                            best, bd = e.pl, d
                        end
                    end
                end
            end
        end
    end
    return best
end

function T.Tick()
    local CC, UU = C(), U()
    if not CC.Enabled or not T.Active() then return end
    if CC.OnlyScoped then
        -- DaHood guns zoom FOV; cheap check: camera FOV dropped
        if UU.Camera.FieldOfView > 68 then return end
    end
    if CC.MoveBlocker then
        local r = UU.Root()
        if r and r.AssemblyLinearVelocity.Magnitude > CC.MoveThreshold then return end
    end
    local tgt = T.TargetUnderCross()
    if not tgt then
        -- crosshair left target: reset consecutive chain after gap
        if os.clock() - T.LastShotAt > 0.6 then T.Shots = 0 end
        return
    end
    if math.random(100) > CC.HitChance then return end

    local now = os.clock()
    if T.Shots == 0 then
        if (now - T.FirstShotAt) * 1000 < CC.DelayMs and T.FirstShotAt > 0 and (now - T.FirstShotAt) < 2 then
            return
        end
        -- first shot path
        if T.FirstShotAt == 0 or (now - T.FirstShotAt) > 2 then
            T.FirstShotAt = now
            task.wait(CC.DelayMs / 1000)
            if not T.Active() then return end
            if not T.TargetUnderCross() then return end
        end
    else
        if (now - T.LastShotAt) * 1000 < CC.ConsecutiveDelayMs then return end
    end
    UU.Click()
    T.LastShotAt = os.clock()
    T.Shots += 1
end

function T.Bind()
    local UIS = game:GetService("UserInputService")
    UIS.InputBegan:Connect(function(i, g)
        if g then return end
        if T.KeyDown(i) then
            local CC = C()
            if CC.ToggleMode then
                CC.Active = not CC.Active
            else
                T.Holding = true
            end
            T.FirstShotAt = 0 -- re-arm delay chain on fresh press
        end
    end)
    UIS.InputEnded:Connect(function(i)
        local CC = C()
        if not CC.ToggleMode and T.KeyDown(i) then
            T.Holding = false
            T.Shots = 0
            T.FirstShotAt = 0
        end
    end)
end

BB.Trigger = T
return T
