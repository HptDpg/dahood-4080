-- 4080 DaHood Hub | Aimbot.lua
-- Legit aimbot: hold-key, FOV-gated, velocity prediction, smoothing,
-- sticky lock, second-stage tighten, humanize shake, wall/knocked/ff checks.
getgenv().DH4080 = getgenv().DH4080 or {}
local BB = getgenv().DH4080
local A = {}
A.Holding = false
A.Lock = nil
A.ReactUntil = 0
A.LastTick = 0

local function C() return BB.Config.Aimbot end
local function U() return BB.Utils end
local mousemoverel = mousemoverel or (syn and syn.mousemoverel)

function A.KeyDown(input)
    local CC = C()
    if input.UserInputType == Enum.UserInputType.Keyboard then
        return input.KeyCode == CC.Key
    end
    return input.UserInputType == CC.Key
end

function A.Acquire()
    local CC, UU = C(), U()
    -- hit chance roll on acquisition only (not every frame = stable)
    if math.random(100) > CC.HitChance then return A.Lock end
    local o = {
        FOV = (CC.SecondStage and A.CloseToCross()) and CC.SecondFOV or CC.FOV,
        TargetMode = CC.TargetMode, TargetPart = CC.TargetPart,
        Prediction = CC.Prediction, WallCheck = CC.WallCheck,
        TeamCheck = CC.TeamCheck, ForcefieldCheck = CC.ForcefieldCheck,
        KnockedCheck = CC.KnockedCheck, MaxDistance = CC.MaxDistance,
    }
    local t = UU.PickTarget(o)
    if t then A.Lock = t end
    return A.Lock
end

function A.CloseToCross()
    local UU = U()
    if not A.Lock or not U().Char(A.Lock) then return false end
    local part = U().Char(A.Lock):FindFirstChild("Head")
    if not part then return false end
    return UU.DistToMouse(part.Position) < C().FOV * 0.35
end

function A.Validate()
    if not A.Lock then return false end
    local UU = U()
    if not UU.Char(A.Lock) or not UU.Alive(A.Lock) then A.Lock = nil return false end
    if C().KnockedCheck and UU.Knocked(A.Lock) then A.Lock = nil return false end
    if C().ForcefieldCheck and UU.Forcefield(A.Lock) then A.Lock = nil return false end
    if C().TeamCheck and UU.SameCrew(A.Lock, UU.LocalPlayer) then A.Lock = nil return false end
    local root = UU.Root()
    local er = UU.Root(A.Lock)
    if not root or not er then A.Lock = nil return false end
    if (er.Position - root.Position).Magnitude > C().MaxDistance then
        if C().Sticky and math.random() < C().Stickiness then return true end
        A.Lock = nil return false
    end
    return true
end

function A.Tick()
    local CC, UU = C(), U()
    if not CC.Enabled or not A.Holding then return end
    -- heartbeat cap: e.g. 60 => min 16.6ms between updates
    local budget = 1 / math.max(CC.Heartbeat, 1)
    local now = os.clock()
    if now - A.LastTick < budget then return end
    A.LastTick = now
    if now < A.ReactUntil then return end

    if not A.Validate() then
        -- sticky: don't instantly drop to a new target, keep trying old first
        if not (CC.Sticky and A.Lock) then A.Lock = nil end
        A.Acquire()
        if not A.Lock then return end
    else
        -- maybe swap if a much closer-angle target appeared (stickiness resists)
        if math.random() > CC.Stickiness then
            local fresh = UU.PickTarget({
                FOV = CC.FOV, TargetMode = CC.TargetMode, TargetPart = CC.TargetPart,
                Prediction = CC.Prediction, WallCheck = CC.WallCheck,
                TeamCheck = CC.TeamCheck, ForcefieldCheck = CC.ForcefieldCheck,
                KnockedCheck = CC.KnockedCheck, MaxDistance = CC.MaxDistance })
            if fresh and fresh ~= A.Lock then A.Lock = fresh end
        end
    end

    local CC2 = CC
    local smooth = CC2.Smoothness
    if CC2.SecondStage and A.CloseToCross() then smooth = CC2.SecondSmooth end

    local partName = UU.ResolvePart(A.Lock, CC2.TargetPart)
    local pt, part = UU.Predict(A.Lock, partName, CC2.Prediction, CC2.XOffset, CC2.YOffset)
    if not pt then return end
    if CC2.WallCheck and not UU.VisiblePart(A.Lock, part and part.Name or "Head") then return end

    local cam = UU.Camera
    if CC2.Mode == "Camera" then
        local cur = cam.CFrame
        local want = CFrame.new(cur.Position, pt)
        local t = math.clamp(1 / math.max(smooth, 0.01), 0, 1)
        -- deadzone: skip micro-adjusts
        local sp = UU.ScreenPoint(pt)
        local dpx = (sp - UU.UIS:GetMouseLocation()).Magnitude
        if dpx < CC2.Deadzone then return end
        -- humanize shake
        local shx = (math.random() - 0.5) * 2 * CC2.ShakeX * 0.001
        local shy = (math.random() - 0.5) * 2 * CC2.ShakeY * 0.001
        want = want * CFrame.Angles(shy, shx, 0)
        cam.CFrame = cur:Lerp(want, t)
    else -- Mouse pull via mousemoverel
        local sp = UU.ScreenPoint(pt)
        local mp = UU.UIS:GetMouseLocation()
        local dx, dy = sp.X - mp.X, sp.Y - mp.Y
        local dpx = math.sqrt(dx * dx + dy * dy)
        if dpx < CC2.Deadzone then return end
        if dpx > CC2.FOV then return end
        local pull = CC2.Pull / 10
        dx = dx * pull + (math.random() - 0.5) * CC2.ShakeX * 0.2
        dy = dy * pull + (math.random() - 0.5) * CC2.ShakeY * 0.2
        if mousemoverel then mousemoverel(dx, dy) end
    end
end

function A.Bind()
    local UIS = game:GetService("UserInputService")
    UIS.InputBegan:Connect(function(i, g)
        if g then return end
        if A.KeyDown(i) then
            A.Holding = true
            local CC = C()
            if CC.ReactionMs > 0 then A.ReactUntil = os.clock() + CC.ReactionMs / 1000 end
            A.Lock = nil
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if A.KeyDown(i) then A.Holding = false A.Lock = nil end
    end)
end

BB.Aimbot = A
return A
