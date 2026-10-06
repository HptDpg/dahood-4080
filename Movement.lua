-- 4080 DaHood Hub | Movement.lua
-- Speed (3 modes), Fly, Noclip, BunnyHop, InfiniteJump, NoSlow, NoFall,
-- ClickTP, Infinite stamina.
getgenv().DH4080 = getgenv().DH4080 or {}
local BB = getgenv().DH4080
local M = {}
M.Flying = false
M.Noclipping = false
M.BhopConn = nil

local function C() return BB.Config.Move end
local function U() return BB.Utils end

function M.SpeedTick(dt)
    local S = C().Speed
    if not S.Enabled then return end
    local UU = U()
    local root, hum = UU.Root(), UU.Hum()
    if not root or not hum then return end
    if M.Flying then return end
    if S.Mode == "WalkSpeed" then
        hum.WalkSpeed = S.Value
    elseif S.Mode == "Velocity" then
        local dir = hum.MoveDirection
        if dir.Magnitude > 0.1 then
            root.AssemblyLinearVelocity = Vector3.new(dir.X * S.Value, root.AssemblyLinearVelocity.Y, dir.Z * S.Value)
        end
    elseif S.Mode == "CFrame" then
        local dir = hum.MoveDirection
        if dir.Magnitude > 0.1 then
            root.CFrame = root.CFrame + dir * (S.Value * dt)
        end
    end
end
function M.SpeedOff()
    local hum = U().Hum()
    if hum then hum.WalkSpeed = 16 end
end

function M.FlyTick(dt)
    local F = C().Fly
    local UU = U()
    local root = UU.Root()
    if not F.Enabled or not root then
        if M.Flying and root then
            root.Anchored = false
            for _, p in ipairs(UU.Char():GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
        M.Flying = false
        return
    end
    M.Flying = true
    local hum = UU.Hum()
    local dir = hum and hum.MoveDirection or Vector3.new()
    local UIS = game:GetService("UserInputService")
    local up = 0
    if UIS:IsKeyDown(Enum.KeyCode.Space) then up = 1
    elseif UIS:IsKeyDown(Enum.KeyCode.LeftControl) then up = -1 end
    local cam = UU.Camera
    local move = (cam.CFrame.LookVector * -dir.Z * 0 + dir * 0) -- base on move dir
    -- fly along camera-relative wish dir
    local wish = Vector3.new()
    if hum and hum.MoveDirection.Magnitude > 0.1 then
        local f = cam.CFrame.LookVector wish = Vector3.new(f.X, 0, f.Z).Unit * 0 -- placeholder
        wish = hum.MoveDirection
    end
    root.AssemblyLinearVelocity = wish * F.Speed + Vector3.new(0, up * F.Vertical, 0)
    if F.Noclip then
        for _, p in ipairs(UU.Char():GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end

function M.NoclipTick()
    local N = C().Noclip
    local UU = U()
    if not N.Enabled then
        if M.Noclipping then
            local c = UU.Char()
            if c then for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end end
        end
        M.Noclipping = false
        return
    end
    M.Noclipping = true
    local c = UU.Char()
    if c then for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end end
end

function M.Bind()
    local UIS = game:GetService("UserInputService")
    UIS.InputBegan:Connect(function(i, g)
        if g then return end
        local CC = C()
        if i.KeyCode == CC.Fly.Key then CC.Fly.Enabled = not CC.Fly.Enabled end
        if i.KeyCode == CC.Noclip.Key then CC.Noclip.Enabled = not CC.Noclip.Enabled end
        if i.KeyCode == CC.ClickTP.Key and CC.ClickTP.Enabled then
            local mouse = U().Mouse
            local t = mouse.Hit
            local root = U().Root()
            if t and root then root.CFrame = CFrame.new(t.Position + Vector3.new(0, 3, 0)) end
        end
        if i.KeyCode == Enum.KeyCode.Space then
            if CC.InfiniteJump then
                local hum = U().Hum()
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
            if CC.BunnyHop.Enabled then
                local root = U().Root()
                if root then
                    root.AssemblyLinearVelocity += Vector3.new(0, CC.BunnyHop.Power, 0)
                end
            end
        end
    end)
    -- NoSlow: restore walkspeed each frame while shooting/reloading
    game:GetService("RunService").Heartbeat:Connect(function()
        local CC = C()
        if CC.NoSlow.Enabled then
            local hum = U().Hum()
            if hum and CC.Speed.Enabled and CC.Speed.Mode == "WalkSpeed" then
                hum.WalkSpeed = CC.Speed.Value
            end
        end
        if CC.NoFall.Enabled then
            local hum = U().Hum()
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
                if hum:GetState() == Enum.HumanoidStateType.Freefall then
                    hum:ChangeState(Enum.HumanoidStateType.Landed)
                end
                hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            end
        end
        if CC.Stamina.Infinite then
            -- DaHood stamina lives in player scripts; best-effort: max energy values
            pcall(function()
                local c = U().Char()
                local be = c and c:FindFirstChild("BodyEffects")
                local st = be and (be:FindFirstChild("Stamina") or be:FindFirstChild("Energy"))
                if st and st.Value ~= nil then st.Value = 1000 end
            end)
        end
    end)
end

function M.Tick(dt)
    M.SpeedTick(dt)
    M.FlyTick(dt)
    M.NoclipTick()
end

BB.Movement = M
return M
