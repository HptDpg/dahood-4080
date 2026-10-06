-- 4080 DaHood Hub v4.0.8.0 | SINGLE FILE BUILD
-- paste this whole file into your executor. no readfile needed.
getgenv().DH4080 = getgenv().DH4080 or {}

-- ==================== Config.lua ====================
do
-- 4080 DaHood Hub | Config.lua
-- EVERY setting lives here. UI reads/writes live. Flags keyed for cfg save.
getgenv().DH4080 = getgenv().DH4080 or {}
local C = {}
C.Version = "4.0.8.0"
C.UIToggle = Enum.KeyCode.RightShift
C.Theme = { BG = Color3.fromRGB(10,10,12), Panel = Color3.fromRGB(16,16,20),
    Accent = Color3.fromRGB(255,255,255), Dim = Color3.fromRGB(120,120,130),
    Good = Color3.fromRGB(255,255,255), Bad = Color3.fromRGB(90,90,95) }

-- ============ LEGIT / AIMBOT ============
C.Aimbot = {
    Enabled = false,
    Key = Enum.UserInputType.MouseButton2, -- hold RMB default; rebindable via UI button
    KeyName = "MouseButton2",
    Mode = "Camera",        -- "Camera" | "Mouse" (mouse = robl mousemoverel pull)
    TargetPart = "Head",    -- Head|UpperTorso|HumanoidRootPart|Closest|Random
    TargetMode = "Closest", -- Closest|LowestHP|ClosestAngle|Threat
    FOV = 120, FOVVisible = true, Filled = false, FOVColor = Color3.fromRGB(255,255,255),
    Pull = 12,              -- strength of pull per tick (mouse mode)
    Smoothness = 8,         -- higher = smoother/slower (camera lerp divisor)
    Prediction = 0.13,      -- seconds of velocity lead
    Heartbeat = 60,         -- aim updates per second cap (30|60|120|uncapped->240)
    Sticky = true,          -- keep lock until key release / target death
    Stickiness = 0.6,       -- 0..1 how hard to hold vs swap to closer target
    Deadzone = 2,           -- px: don't move if already within this of target
    WallCheck = true, MaxDistance = 900,
    TeamCheck = false, ForcefieldCheck = true, KnockedCheck = true,
    ShakeX = 0, ShakeY = 0, -- humanize jitter px
    ScopeOnly = false, ADSOnly = false,
    YOffset = 0, XOffset = 0,
    HitChance = 100,        -- %: rolls per target acquisition, fail = keep old target
    ReactionMs = 0,         -- delay before snap starts after key press
    SecondStage = false, SecondFOV = 40, SecondSmooth = 16, -- tightens when close to crosshair
}

-- ============ TRIGGERBOT ============
C.Trigger = {
    Enabled = false,
    Key = Enum.KeyCode.T, KeyName = "T",
    ToggleMode = false,     -- false=hold, true=toggle
    Active = false,         -- runtime toggle state
    DelayMs = 60,           -- delay BEFORE first shot
    ConsecutiveDelayMs = 120, -- delay AFTER 1st shot before allowed again
    ShotsFired = 0,         -- runtime counter (resets on key release)
    TargetPart = "Head",    -- Head|Torso|Any
    FOV = 14, FOVVisible = true,
    WallCheck = true, TeamCheck = false, KnockedCheck = true,
    MaxDistance = 700, HitChance = 100,
    OnlyScoped = false, MoveBlocker = true, -- don't fire while WE move fast
    MoveThreshold = 28,     -- stud/s: above this, hold fire
    Blacklist = {},         -- player names never triggered
}

-- ============ SILENT AIM ============
C.Silent = {
    Enabled = false,
    FOV = 150, FOVVisible = true,
    HitChance = 85, Prediction = 0.13,
    TargetPart = "Head", TargetMode = "Closest",
    WallCheck = true, KnockedCheck = true, MaxDistance = 900,
    DotVisible = true,     -- shows picked point
    Method = "Raycast",    -- Raycast|Index (hook __index on mouse.Hit/UnitRay)
}

-- ============ RAGE ============
C.Rage = {
    Enabled = false,
    Orbit = { Enabled = false, Radius = 9, Height = 2, Speed = 6, TargetMode = "Closest",
        AutoSpin = true, HeightJitter = 1.2, Randomize = false },
    Spinbot = { Enabled = false, Speed = 40, XSpin = false },
    Jitter = { Enabled = false, Angle = 60, Ticks = 2 },
    AA = { Enabled = false, Pitch = "Up", YawBase = 180, YawJitter = 30 }, -- anti-aim
    RapidFire = { Enabled = false, Rate = 5 },  -- input spam multiplier
    NoRecoil = { Enabled = false, Strength = 100 }, -- % removed via camera kick cancel
    AutoStomp = { Enabled = false, Key = Enum.KeyCode.G },
    AutoReload = { Enabled = false, Threshold = 3 },
    AutoArmor = { Enabled = false },
    FakeLag = { Enabled = false, Ticks = 8 },
    SpeedShot = { Enabled = false }, -- fires tool immediately on equip
}

-- ============ VISUALS / ESP ============
C.ESP = {
    Enabled = false,
    Box = { Enabled = false, Style = "Cornered", -- Full|Cornered
        Fill = { Enabled = false, Color = Color3.fromRGB(255,255,255), Transparency = 0.75 },
        Outline = true, Color = Color3.fromRGB(255,255,255), TeamColor = false,
        Thickness = 1.5, Use3D = false },
    Health = { Enabled = false, Style = "Bar", -- Bar|Number|Both
        Position = "Left", ColorLow = Color3.fromRGB(255,60,60),
        ColorHigh = Color3.fromRGB(60,255,120), ShowDead = false },
    Name = { Enabled = false, Color = Color3.fromRGB(255,255,255), Size = 13,
        ShowDistance = true, ShowTool = false },
    Distance = { Enabled = false, Color = Color3.fromRGB(170,170,180), Suffix = "st" },
    Skeleton = { Enabled = false, Color = Color3.fromRGB(255,255,255), Thickness = 1 },
    Chams = { Enabled = false, FillColor = Color3.fromRGB(255,255,255),
        FillTrans = 0.5, OutlineColor = Color3.fromRGB(0,0,0), DepthMode = "AlwaysOnTop" },
    Tracer = { Enabled = false, From = "Bottom", -- Bottom|Top|Center|Mouse
        Color = Color3.fromRGB(255,255,255), Thickness = 1 },
    HeadDot = { Enabled = false, Color = Color3.fromRGB(255,50,50), Radius = 4 },
    Offscreen = { Enabled = false, Color = Color3.fromRGB(255,255,255), Radius = 120, Size = 8 },
    MaxDistance = 1500, TeamCheck = false, KnockedOnly = false,
    KnockedColor = Color3.fromRGB(255,150,0),
}

-- ============ WORLD ============
C.World = {
    Skybox = { Enabled = false, Style = "Night", -- Night|Sunset|Nebula|Anime|Custom
        CustomID = "rbxassetid://0" },
    Fog = { Enabled = false, Color = Color3.fromRGB(20,20,25), Start = 0, End = 500 },
    Ambience = { Enabled = false, Ambient = Color3.fromRGB(60,60,70),
        Outdoor = Color3.fromRGB(90,90,100), Brightness = 2, ClockTime = 14, LockTime = false },
    NoShadows = false, NoFog = false, Fullbright = false,
    GunChams = { Enabled = false, Color = Color3.fromRGB(255,255,255), Material = "Neon" },
    BulletTracer = { Enabled = false, Color = Color3.fromRGB(255,255,255), Lifetime = 0.4 },
    HitEffect = { Enabled = false, Style = "Bubble", Color = Color3.fromRGB(255,255,255) },
    HitSound = { Enabled = false, Style = "Skeet", Volume = 3 },
    DayOnly = false, NightOnly = false,
}

-- ============ MOVEMENT ============
C.Move = {
    Speed = { Enabled = false, Value = 28, Mode = "WalkSpeed" }, -- WalkSpeed|Velocity|CFrame
    Fly = { Enabled = false, Key = Enum.KeyCode.F, Speed = 50, Vertical = 40, Noclip = true },
    Noclip = { Enabled = false, Key = Enum.KeyCode.N },
    BunnyHop = { Enabled = false, Power = 35 },
    AutoJump = false, InfiniteJump = false,
    NoSlow = { Enabled = false },       -- cancels reload/shoot slowdown
    NoFall = { Enabled = false },       -- nulls fall damage state
    ClickTP = { Enabled = false, Key = Enum.KeyCode.B },
    Stamina = { Infinite = false },
}

-- ============ SETTINGS ============
C.Settings = {
    ConfigName = "default",
    StreamProof = false, -- hides UI from screenshots via Window shielding (best-effort)
    MenuBlur = true, AntiAFK = true, FPSCap = 240, ShowFPS = true,
    PanicKey = Enum.KeyCode.End, -- one press: kills ALL visuals + UI
}

getgenv().DH4080.Config = C

end

-- ==================== Utils.lua ====================
do
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
end

getgenv().DH4080.Utils = U

end

-- ==================== UILib.lua ====================
do
-- 4080 DaHood Hub | UILib.lua
-- Custom monochrome UI kit. Black & white, no external deps.
-- Controls: Toggle(+dots options), Slider, Dropdown, Color, Keybind, Button, Label.
-- Dots pattern: [Feature  ✓] [⋯] -> popup panel with Style dropdown, Fill toggle, etc.
getgenv().DH4080 = getgenv().DH4080 or {}
local LIB = {}
LIB.Popups = {}

local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")

local BG = Color3.fromRGB(8,8,10)
local PANEL = Color3.fromRGB(14,14,18)
local ROW = Color3.fromRGB(20,20,25)
local LINE = Color3.fromRGB(38,38,45)
local TXT = Color3.fromRGB(235,235,240)
local DIM = Color3.fromRGB(130,130,140)
local ON = Color3.fromRGB(240,240,245)
local OFF = Color3.fromRGB(70,70,78)

function LIB.mk(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Corner" and k ~= "Stroke" and k ~= "Pad" then
            pcall(function() o[k] = v end)
        end
    end
    if props.Corner then
        local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, props.Corner) c.Parent = o
    end
    if props.Stroke then
        local s = Instance.new("UIStroke") s.Color = props.Stroke s.Thickness = 1
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border s.Parent = o
    end
    if props.Pad then
        local p = Instance.new("UIPadding")
        p.PaddingLeft = UDim.new(0,8) p.PaddingRight = UDim.new(0,8)
        p.PaddingTop = UDim.new(0,4) p.PaddingBottom = UDim.new(0,4) p.Parent = o
    end
    o.Parent = parent
end

function LIB.ClosePopups(except)
    for _, p in ipairs(LIB.Popups) do
        if p ~= except and p.Parent then
            pcall(function() p.Visible = false end)
        end
    end
end

-- ===== WINDOW =====
function LIB.Window(title, size, pos)
    local CG = game:GetService("CoreGui")
    pcall(function() CG:FindFirstChild("DH4080"):Destroy() end)
    local gui = LIB.mk("ScreenGui", {Name = "DH4080", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 50}, CG)
    local main = LIB.mk("Frame", {Name = "Main", Size = size, Position = pos,
        BackgroundColor3 = BG, BorderSizePixel = 0, Corner = 8, Stroke = LINE}, gui)
    -- drag
    local head = LIB.mk("Frame", {Name = "Head", Size = UDim2.new(1,0,0,34),
        BackgroundColor3 = PANEL, BorderSizePixel = 0, Corner = 8}, main)
    LIB.mk("TextLabel", {Size = UDim2.new(1,-60,1,0), Position = UDim2.new(0,12,0,0),
        BackgroundTransparency = 1, Text = title, TextColor3 = TXT,
        Font = Enum.Font.GothamBlack, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left}, head)
    local x = LIB.mk("TextButton", {Size = UDim2.new(0,28,0,22), Position = UDim2.new(1,-34,0,6),
        BackgroundColor3 = ROW, TextColor3 = TXT, Font = Enum.Font.GothamBold, TextSize = 12,
        Text = "—", Corner = 5, Stroke = LINE}, head)
    x.MouseButton1Click:Connect(function()
        main.Visible = not main.Visible
    end)
    local drag, ds, sp = false, nil, nil
    head.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag, ds, sp = true, i.Position, main.Position end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - ds
            main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
    UIS.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Enum.KeyCode.LeftBracket then LIB.ClosePopups() end
    end)
    return gui, main, head
end

-- ===== TAB BAR + PAGES =====
function LIB.Tabs(main, names, y0)
    local bar = LIB.mk("Frame", {Size = UDim2.new(1,-16,0,30), Position = UDim2.new(0,8,0,y0),
        BackgroundTransparency = 1}, main)
    local body = LIB.mk("Frame", {Size = UDim2.new(1,-16,1,-(y0+46)), Position = UDim2.new(0,8,0,y0+36),
        BackgroundTransparency = 1}, main)
    local pages, btns = {}, {}
    for i, n in ipairs(names) do
        local b = LIB.mk("TextButton", {Size = UDim2.new(1/#names,-3,1,0),
            Position = UDim2.new((i-1)/#names, i == 1 and 0 or 2, 0, 0),
            BackgroundColor3 = i == 1 and ON or ROW,
            TextColor3 = i == 1 and BG or TXT,
            Font = Enum.Font.GothamBold, TextSize = 11, Text = n:upper(), Corner = 6,
            Stroke = LINE}, bar)
        local pg = LIB.mk("ScrollingFrame", {Name = n, Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1, ScrollBarThickness = 3,
            ScrollBarImageColor3 = ON, CanvasSize = UDim2.new(0,0,0,900),
            Visible = i == 1, AutomaticCanvasSize = Enum.AutomaticSize.Y}, body)
        local l = Instance.new("UIListLayout") l.Padding = UDim.new(0,5) l.Parent = pg
        pages[n], btns[n] = pg, b
        b.MouseButton1Click:Connect(function()
            for nn, p2 in pairs(pages) do p2.Visible = (nn == n) end
            for _, b2 in pairs(btns) do
                b2.BackgroundColor3 = ROW b2.TextColor3 = TXT
            end
            b.BackgroundColor3 = ON b.TextColor3 = BG
            LIB.ClosePopups()
        end)
    end
end

function LIB.Section(parent, title)
    local s = LIB.mk("Frame", {Size = UDim2.new(1,0,0,24), BackgroundTransparency = 1}, parent)
    LIB.mk("TextLabel", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
        Text = "— " .. title .. " —", TextColor3 = DIM, Font = Enum.Font.GothamBold,
        TextSize = 11}, s)
end

-- ===== TOGGLE + DOTS =====
-- opts = { {type="dropdown", label, options, get, set}, {type="toggle", label, get, set},
--          {type="slider", label, min, max, get, set, fmt}, {type="color", label, get, set} }
function LIB.Toggle(parent, label, get, set, opts)
    local row = LIB.mk("Frame", {Size = UDim2.new(1,0,0,30), BackgroundColor3 = ROW,
        BorderSizePixel = 0, Corner = 6, Stroke = LINE}, parent)
    LIB.mk("TextLabel", {Size = UDim2.new(1,-(opts and 64 or 40),1,0), Position = UDim2.new(0,10,0,0),
        BackgroundTransparency = 1, Text = label, TextColor3 = TXT, Font = Enum.Font.Gotham,
        TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left}, row)
    local sw = LIB.mk("TextButton", {
        Size = UDim2.new(0,34,0,18), Position = UDim2.new(1,-(opts and 58 or 42),0.5,-9),
        BackgroundColor3 = get() and ON or OFF, Text = "", Corner = 9}, row)
    local function ref() sw.BackgroundColor3 = get() and ON or OFF end
    sw.MouseButton1Click:Connect(function() set(not get()) ref() end)
    ref()
    if opts then
        local dots = LIB.mk("TextButton", {Size = UDim2.new(0,20,0,20),
            Position = UDim2.new(1,-24,0.5,-10), BackgroundColor3 = PANEL,
            TextColor3 = TXT, Font = Enum.Font.GothamBold, TextSize = 13,
            Text = "⋯", Corner = 5, Stroke = LINE}, row)
        local pop = LIB.mk("Frame", {Size = UDim2.new(0,220,0,30 + #opts*32),
            BackgroundColor3 = PANEL, BorderSizePixel = 0, Corner = 8, Stroke = ON,
            Visible = false, ZIndex = 100}, row.Parent and row.Parent.Parent and row.Parent.Parent.Parent or row.Parent)
        -- anchor popup near top-level so it floats above rows
        pop.AnchorPoint = Vector2.new(1, 0)
        pop.Position = UDim2.new(1, -8, 0, 60)
        pop.Parent = pop.Parent or row
        if not pop.Parent or not pop.Parent:IsA("GuiObject") then pop.Parent = row.Parent end
        LIB.mk("TextLabel", {Size = UDim2.new(1,0,0,24), BackgroundTransparency = 1,
            Text = label .. " — options", TextColor3 = TXT, Font = Enum.Font.GothamBold,
            TextSize = 12}, pop)
        table.insert(LIB.Popups, pop)
        local y = 28
        for _, o in ipairs(opts) do
            if o.type == "dropdown" then
                LIB.Dropdown(pop, o.label, o.options, o.get, o.set, UDim2.new(0,8,0,y))
            elseif o.type == "toggle" then
                LIB.MiniToggle(pop, o.label, o.get, o.set, UDim2.new(0,8,0,y))
            elseif o.type == "slider" then
                LIB.MiniSlider(pop, o.label, o.min, o.max, o.get, o.set, o.fmt, UDim2.new(0,8,0,y))
            elseif o.type == "color" then
                LIB.MiniColor(pop, o.label, o.get, o.set, UDim2.new(0,8,0,y))
            end
            y += (o.type == "slider" and 40 or 28)
        end
        pop.Size = UDim2.new(0, 220, 0, y + 8)
        dots.MouseButton1Click:Connect(function()
            local v = not pop.Visible
            LIB.ClosePopups(pop)
            pop.Visible = v
        end)
    end
end

function LIB.MiniToggle(parent, label, get, set, pos)
    local r = LIB.mk("Frame", {Size = UDim2.new(1,-16,0,24), Position = pos or UDim2.new(0,8,0,0),
        BackgroundTransparency = 1}, parent)
    LIB.mk("TextLabel", {Size = UDim2.new(1,-40,1,0), BackgroundTransparency = 1, Text = label,
        TextColor3 = DIM, Font = Enum.Font.Gotham, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left}, r)
    local b = LIB.mk("TextButton", {Size = UDim2.new(0,30,0,16), Position = UDim2.new(1,-32,0.5,-8),
        BackgroundColor3 = get() and ON or OFF, Text = "", Corner = 8}, r)
    local function ref() b.BackgroundColor3 = get() and ON or OFF end
    b.MouseButton1Click:Connect(function() set(not get()) ref() end)
    ref()
end

function LIB.MiniSlider(parent, label, min, max, get, set, fmt, pos)
    local r = LIB.mk("Frame", {Size = UDim2.new(1,-16,0,36), Position = pos or UDim2.new(0,8,0,0),
        BackgroundTransparency = 1}, parent)
    local top = LIB.mk("TextLabel", {Size = UDim2.new(1,0,0,15), BackgroundTransparency = 1,
        TextColor3 = DIM, Font = Enum.Font.Gotham, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left}, r)
    local bar = LIB.mk("TextButton", {Size = UDim2.new(1,0,0,12), Position = UDim2.new(0,0,0,20),
        BackgroundColor3 = ROW, Text = "", Corner = 6, Stroke = LINE}, r)
    local fill = LIB.mk("Frame", {Size = UDim2.new(0.5,0,1,0), BackgroundColor3 = ON,
        BorderSizePixel = 0, Corner = 6}, bar)
    local function ref()
        local v = get()
        local t = math.clamp((v - min) / math.max(max - min, 1e-4), 0, 1)
        fill.Size = UDim2.new(t, 0, 1, 0)
        top.Text = label .. ": " .. (fmt and fmt(v) or tostring(math.floor(v * 100) / 100))
    end
    local function apply(x)
        local t = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
        set(min + (max - min) * t) ref()
    end
    bar.MouseButton1Down:Connect(function() apply(UIS:GetMouseLocation().X) end)
    bar.MouseButton1Click:Connect(function() end)
    UIS.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement
            and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
            and bar.Visible and LIB._dragBar == bar then
            apply(i.Position.X)
        end
    end)
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then LIB._dragBar = bar end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then LIB._dragBar = nil end
    end)
    ref()
end

-- ===== SLIDER (full row) =====
function LIB.Slider(parent, label, min, max, get, set, fmt)
    local row = LIB.mk("Frame", {Size = UDim2.new(1,0,0,44), BackgroundColor3 = ROW,
        BorderSizePixel = 0, Corner = 6, Stroke = LINE, Pad = true}, parent)
    local top = LIB.mk("TextLabel", {Size = UDim2.new(1,0,0,16), BackgroundTransparency = 1,
        TextColor3 = TXT, Font = Enum.Font.Gotham, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left}, row)
    local bar = LIB.mk("TextButton", {Size = UDim2.new(1,0,0,13), Position = UDim2.new(0,0,0,22),
        BackgroundColor3 = BG, Text = "", Corner = 6, Stroke = LINE}, row)
    local fill = LIB.mk("Frame", {Size = UDim2.new(0.5,0,1,0), BackgroundColor3 = ON,
        BorderSizePixel = 0, Corner = 6}, bar)
    local function ref()
        local v = get()
        local t = math.clamp((v - min) / math.max(max - min, 1e-4), 0, 1)
        fill.Size = UDim2.new(t, 0, 1, 0)
        top.Text = label .. ": " .. (fmt and fmt(v) or tostring(math.floor(v * 100) / 100))
    end
    local function apply(x)
        local t = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
        set(min + (max - min) * t) ref()
    end
    bar.MouseButton1Down:Connect(function() LIB._dragBar = bar apply(UIS:GetMouseLocation().X) end)
    UIS.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement
            and LIB._dragBar == bar
            and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            apply(i.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then LIB._dragBar = nil end
    end)
    ref()
end

-- ===== DROPDOWN =====
function LIB.Dropdown(parent, label, options, get, set, pos, wide)
    local row = LIB.mk("Frame", {Size = wide and UDim2.new(1,0,0,44) or UDim2.new(1,0,0,30),
        Position = pos, BackgroundColor3 = wide and ROW or Color3.fromRGB(0,0,0,0),
        BackgroundTransparency = wide and 0 or 1, BorderSizePixel = 0, Corner = 6,
        Stroke = wide and LINE or nil}, parent)
    if wide then
        LIB.mk("TextLabel", {Size = UDim2.new(1,-16,0,15), Position = UDim2.new(0,8,0,2),
            BackgroundTransparency = 1, Text = label, TextColor3 = TXT,
            Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, row)
    else
        LIB.mk("TextLabel", {Size = UDim2.new(0.45,0,1,0), BackgroundTransparency = 1, Text = label,
            TextColor3 = DIM, Font = Enum.Font.Gotham, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left}, row)
    end
    local b = LIB.mk("TextButton", {
        Size = wide and UDim2.new(1,-16,0,20) or UDim2.new(0.55,-4,1,-4),
        Position = wide and UDim2.new(0,8,0,20) or UDim2.new(0.45,0,0,2),
        BackgroundColor3 = ROW, TextColor3 = TXT, Font = Enum.Font.GothamBold, TextSize = 12,
        Corner = 5, Stroke = LINE}, row)
    local function ref() b.Text = "◀ " .. tostring(get()) .. " ▶" end
    b.MouseButton1Click:Connect(function()
        local cur = get()
        local i = table.find(options, cur) or 1
        set(options[(i % #options) + 1]) ref()
    end)
    -- right-click goes backwards
    b.MouseButton2Click:Connect(function()
        local cur = get()
        local i = table.find(options, cur) or 1
        i = (i - 2) % #options + 1
        set(options[i]) ref()
    end)
    ref()
end

-- ===== COLOR (grayscale-friendly swatches + custom) =====
local SWATCHES = {
    Color3.fromRGB(255,255,255), Color3.fromRGB(200,200,205), Color3.fromRGB(140,140,150),
    Color3.fromRGB(80,80,88), Color3.fromRGB(0,0,0),
    Color3.fromRGB(255,60,60), Color3.fromRGB(255,150,40), Color3.fromRGB(60,255,120),
    Color3.fromRGB(80,140,255), Color3.fromRGB(190,90,255),
}
function LIB.ColorRow(parent, label, get, set)
    local row = LIB.mk("Frame", {Size = UDim2.new(1,0,0,30), BackgroundColor3 = ROW,
        BorderSizePixel = 0, Corner = 6, Stroke = LINE}, parent)
    LIB.mk("TextLabel", {Size = UDim2.new(0.4,0,1,0), Position = UDim2.new(0,10,0,0),
        BackgroundTransparency = 1, Text = label, TextColor3 = TXT, Font = Enum.Font.Gotham,
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, row)
    local cur = LIB.mk("TextButton", {Size = UDim2.new(0,60,0,18), Position = UDim2.new(1,-68,0.5,-9),
        BackgroundColor3 = get(), Text = "", Corner = 5, Stroke = LINE}, row)
    local function ref() cur.BackgroundColor3 = get() end
    local open = false
    cur.MouseButton1Click:Connect(function()
        open = not open
        if open then
            local pop = LIB.mk("Frame", {Size = UDim2.new(0,180,0,44),
                BackgroundColor3 = PANEL, BorderSizePixel = 0, Corner = 8, Stroke = ON,
                ZIndex = 100}, row)
            pop.Position = UDim2.new(1, -188, 1, 4)
            table.insert(LIB.Popups, pop)
            cur:SetAttribute("pop", "")
            pop:SetAttribute("owner", "color")
            for i, c in ipairs(SWATCHES) do
                local s = LIB.mk("TextButton", {Size = UDim2.new(0,28,0,28),
                    Position = UDim2.new(0, 6 + ((i-1) % 5) * 34, 0, 6 + math.floor((i-1)/5) * 34),
                    BackgroundColor3 = c, Text = "", Corner = 5, Stroke = LINE}, pop)
                s.MouseButton1Click:Connect(function() set(c) ref() pop:Destroy() open = false end)
            end
            LIB.ClosePopups(pop)
            pop.Visible = true
            -- store for toggle
            cur:GetPropertyChangedSignal("Visible") -- noop keep ref
            LIB._colorPop = pop
        else
            if LIB._colorPop then pcall(function() LIB._colorPop:Destroy() end) LIB._colorPop = nil end
        end
    end)
    ref()
end

function LIB.MiniColor(parent, label, get, set, pos)
    local r = LIB.mk("Frame", {Size = UDim2.new(1,-16,0,24), Position = pos or UDim2.new(0,8,0,0),
        BackgroundTransparency = 1}, parent)
    LIB.mk("TextLabel", {Size = UDim2.new(1,-40,1,0), BackgroundTransparency = 1, Text = label,
        TextColor3 = DIM, Font = Enum.Font.Gotham, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left}, r)
    local cur = LIB.mk("TextButton", {Size = UDim2.new(0,30,0,16), Position = UDim2.new(1,-32,0.5,-8),
        BackgroundColor3 = get(), Text = "", Corner = 5, Stroke = LINE}, r)
    cur.MouseButton1Click:Connect(function()
        local i = 1
        for k, c in ipairs(SWATCHES) do
            if c == get() then i = k break end
        end
        set(SWATCHES[(i % #SWATCHES) + 1])
        cur.BackgroundColor3 = get()
    end)
end

-- ===== KEYBIND BUTTON ("press next key") =====
function LIB.Keybind(parent, label, getName, setKey)
    local row = LIB.mk("Frame", {Size = UDim2.new(1,0,0,30), BackgroundColor3 = ROW,
        BorderSizePixel = 0, Corner = 6, Stroke = LINE}, parent)
    LIB.mk("TextLabel", {Size = UDim2.new(0.55,0,1,0), Position = UDim2.new(0,10,0,0),
        BackgroundTransparency = 1, Text = label, TextColor3 = TXT, Font = Enum.Font.Gotham,
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, row)
    local b = LIB.mk("TextButton", {Size = UDim2.new(0.45,-14,1,-6), Position = UDim2.new(0.55,0,0,3),
        BackgroundColor3 = PANEL, TextColor3 = TXT, Font = Enum.Font.GothamBold, TextSize = 12,
        Text = "[" .. getName() .. "]", Corner = 5, Stroke = LINE}, row)
    local listening = false
    b.MouseButton1Click:Connect(function()
        listening = true
        b.Text = "[...]"
    end)
    local conn
    conn = UIS.InputBegan:Connect(function(i, g)
        if listening and not g then
            listening = false
            local kc, text
            if i.UserInputType == Enum.UserInputType.MouseButton1 then kc, text = i.UserInputType, "MouseButton1"
            elseif i.UserInputType == Enum.UserInputType.MouseButton2 then kc, text = i.UserInputType, "MouseButton2"
            elseif i.UserInputType == Enum.UserInputType.MouseButton3 then kc, text = i.UserInputType, "MouseButton3"
            else kc, text = i.KeyCode, i.KeyCode.Name end
            setKey(kc, text)
            b.Text = "[" .. getName() .. "]"
        end
    end)
    return function() b.Text = "[" .. getName() .. "]" end
end

function LIB.Button(parent, text, cb, h)
    local b = LIB.mk("TextButton", {Size = UDim2.new(1,0,0,h or 32),
        BackgroundColor3 = ROW, TextColor3 = TXT, Font = Enum.Font.GothamBold, TextSize = 13,
        Text = text, Corner = 6, Stroke = LINE}, parent)
    b.MouseButton1Click:Connect(function() cb() end)
end

function LIB.Notify(gui, text)
    local stack = gui:FindFirstChild("Notifs")
    if not stack then return end
    local f = LIB.mk("TextLabel", {Size = UDim2.new(1,0,0,26), BackgroundColor3 = PANEL,
        TextColor3 = TXT, Font = Enum.Font.Gotham, TextSize = 12,
        Text = " 4080 ▸ " .. text, TextXAlignment = Enum.TextXAlignment.Left,
        Corner = 6, Stroke = LINE}, stack)
    task.delay(3, function() pcall(function() f:Destroy() end) end)
end

getgenv().DH4080.UILib = LIB

end

-- ==================== Aimbot.lua ====================
do
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

end

-- ==================== Trigger.lua ====================
do
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

end

-- ==================== Silent.lua ====================
do
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
                        end
                    end
                end
                return oldIdx(self, k)
            end)
        end)
    end
end

BB.Silent = S

end

-- ==================== Rage.lua ====================
do
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

end

-- ==================== Visuals.lua ====================
do
-- 4080 DaHood Hub | Visuals.lua
-- Full ESP suite on Drawing API: Box(Full/Cornered+Fill), Health(Bar/Number/Both),
-- Name, Distance, Skeleton, Chams, Tracer, HeadDot, Offscreen arrows.
getgenv().DH4080 = getgenv().DH4080 or {}
local BB = getgenv().DH4080
local V = {}
V.Cache = {} -- [player] = {box lines, bar, texts...}

local function C() return BB.Config.ESP end
local function U() return BB.Utils end

local function D(kind, props)
    local o = Drawing.new(kind)
    for k, v in pairs(props or {}) do pcall(function() o[k] = v end) end
end

function V.entry(pl)
    if V.Cache[pl] then return V.Cache[pl] end
    local e = {
        -- box: 4 edges full, or 8 corner segments
        lines = {D("Line"), D("Line"), D("Line"), D("Line")},
        corners = {D("Line"), D("Line"), D("Line"), D("Line"), D("Line"), D("Line"), D("Line"), D("Line")},
        fill = D("Square", {Filled = true}),
        hpBack = D("Square", {Filled = true}), hpBar = D("Square", {Filled = true}),
        hpText = D("Text", {Size = 13, Outline = true, Center = true}),
        name = D("Text", {Size = 13, Outline = true, Center = true}),
        dist = D("Text", {Size = 12, Outline = true, Center = true}),
        bones = {D("Line"), D("Line"), D("Line"), D("Line"), D("Line"), D("Line")},
        tracer = D("Line"),
        dot = D("Circle", {Filled = true}),
        arrow = D("Triangle", {Filled = true}),
        chamHl = nil,
    }
    V.Cache[pl] = e
end

function V.hide(e)
    for _, l in ipairs(e.lines) do l.Visible = false end
    for _, l in ipairs(e.corners) do l.Visible = false end
    e.fill.Visible = false
    e.hpBack.Visible = false e.hpBar.Visible = false e.hpText.Visible = false
    e.name.Visible = false e.dist.Visible = false
    for _, l in ipairs(e.bones) do l.Visible = false end
    e.tracer.Visible = false e.dot.Visible = false e.arrow.Visible = false
end

local function hideCham(e)
    if e.chamHl then pcall(function() e.chamHl:Destroy() end) e.chamHl = nil end
end

local BONES = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"UpperTorso", "RightUpperArm"},
    {"LowerTorso", "LeftUpperLeg"}, {"LowerTorso", "RightUpperLeg"},
}

function V.Tick()
    local CC, UU = C(), U()
    local cam = UU.Camera
    local vs = cam.ViewportSize
    for pl, e in pairs(V.Cache) do
        if not pl.Parent then V.hide(e) hideCham(e) V.Cache[pl] = nil end
    end
    if not CC.Enabled then
        for _, e in pairs(V.Cache) do V.hide(e) hideCham(e) end
        return
    end
    local myRoot = UU.Root()
    for _, p in ipairs(UU.Players:GetPlayers()) do
        if p == UU.LocalPlayer then
            if V.Cache[p] then V.hide(V.Cache[p]) end
        else
            local e = V.entry(p)
            local c = UU.Char(p)
            local root = UU.Root(p)
            local hum = UU.Hum(p)
            local show = c and root and hum and hum.Health > 0
            if CC.TeamCheck and UU.SameCrew(p, UU.LocalPlayer) then show = false end
            if show and myRoot and (root.Position - myRoot.Position).Magnitude > CC.MaxDistance then show = false end
            local knocked = show and UU.Knocked(p)
            if show and CC.KnockedOnly and not knocked then show = false end
            if not show then V.hide(e) hideCham(e) else
                -- project box from extremities
                local minX, minY, maxX, maxY = 1e9, 1e9, -1e9, -1e9
                local onAny = false
                for _, part in ipairs(c:GetChildren()) do
                    if part:IsA("BasePart") then
                        local v, on = cam:WorldToViewportPoint(part.Position)
                        if on and v.Z > 0 then
                            onAny = true
                            minX, minY = math.min(minX, v.X), math.min(minY, v.Y)
                            maxX, maxY = math.max(maxX, v.X), math.max(maxY, v.Y)
                        end
                    end
                end
                if not onAny then
                    V.hide(e)
                    -- offscreen arrow still possible
                    if CC.Offscreen.Enabled then
                        local sp = cam:WorldToViewportPoint(root.Position)
                        local center = vs / 2
                        local dir = (Vector2.new(sp.X, sp.Y) - center)
                        if dir.Magnitude > 1 then
                            dir = dir.Unit
                            local pos = center + dir * CC.Offscreen.Radius
                            local s = CC.Offscreen.Size
                            e.arrow.PointA = pos + dir * s
                            e.arrow.PointB = pos - dir.Unit.y and pos or pos
                            e.arrow.PointB = pos + Vector2.new(-dir.Y, dir.X) * s * 0.6
                            e.arrow.PointC = pos + Vector2.new(dir.Y, -dir.X) * s * 0.6
                            e.arrow.Color = CC.Offscreen.Color
                            e.arrow.Visible = true
                        else e.arrow.Visible = false end
                    else e.arrow.Visible = false end
                else
                    e.arrow.Visible = false
                    local boxCol = knocked and CC.KnockedColor
                        or (CC.Box.TeamColor and UU.SameCrew(p, UU.LocalPlayer)
                            and Color3.fromRGB(80,200,255) or CC.Box.Color)
                    -- BOX
                    if CC.Box.Enabled then
                        local th = CC.Box.Thickness
                        if CC.Box.Style == "Full" then
                            local pts = {Vector2.new(minX,minY), Vector2.new(maxX,minY),
                                         Vector2.new(maxX,maxY), Vector2.new(minX,maxY)}
                            for i = 1, 4 do
                                local a, b = pts[i], pts[(i % 4) + 1]
                                local l = e.lines[i]
                                l.From, l.To, l.Color, l.Thickness, l.Visible = a, b, boxCol, th, true
                            end
                            for _, l in ipairs(e.corners) do l.Visible = false end
                        else -- Cornered
                            local w, h = maxX - minX, maxY - minY
                            local cx, cy = w * 0.28, h * 0.22
                            local segs = {
                                {Vector2.new(minX,minY), Vector2.new(minX+cx,minY)},
                                {Vector2.new(minX,minY), Vector2.new(minX,minY+cy)},
                                {Vector2.new(maxX-cx,minY), Vector2.new(maxX,minY)},
                                {Vector2.new(maxX,minY), Vector2.new(maxX,minY+cy)},
                                {Vector2.new(minX,maxY-cy), Vector2.new(minX,maxY)},
                                {Vector2.new(minX,maxY), Vector2.new(minX+cx,maxY)},
                                {Vector2.new(maxX,maxY-cy), Vector2.new(maxX,maxY)},
                                {Vector2.new(maxX-cx,maxY), Vector2.new(maxX,maxY)},
                            }
                            for i, s in ipairs(segs) do
                                local l = e.corners[i]
                                l.From, l.To, l.Color, l.Thickness, l.Visible = s[1], s[2], boxCol, th, true
                            end
                            for _, l in ipairs(e.lines) do l.Visible = false end
                        end
                        -- outline underlay via thickness+1 black? Drawing has no layer; fake with second pass skipped.
                        if CC.Box.Fill.Enabled then
                            e.fill.Position = Vector2.new(minX, minY)
                            e.fill.Size = Vector2.new(maxX - minX, maxY - minY)
                            e.fill.Color = CC.Box.Fill.Color
                            e.fill.Transparency = CC.Box.Fill.Transparency
                            e.fill.Visible = true
                        else e.fill.Visible = false end
                    else
                        for _, l in ipairs(e.lines) do l.Visible = false end
                        for _, l in ipairs(e.corners) do l.Visible = false end
                        e.fill.Visible = false
                    end
                    -- HEALTH
                    local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    local hpCol = CC.Health.ColorLow:Lerp(CC.Health.ColorHigh, hp)
                    if knocked then hpCol = CC.KnockedColor end
                    if CC.Health.Enabled then
                        local st = CC.Health.Style
                        if st == "Bar" or st == "Both" then
                            local bw = 4
                            local bx = CC.Health.Position == "Left" and (minX - bw - 3) or (maxX + 3)
                            e.hpBack.Position = Vector2.new(bx, minY)
                            e.hpBack.Size = Vector2.new(bw, maxY - minY)
                            e.hpBack.Color = Color3.fromRGB(0,0,0)
                            e.hpBack.Transparency = 0.4 e.hpBack.Visible = true
                            local hh = (maxY - minY) * hp
                            e.hpBar.Position = Vector2.new(bx, maxY - hh)
                            e.hpBar.Size = Vector2.new(bw, hh)
                            e.hpBar.Color = hpCol e.hpBar.Visible = true
                        else e.hpBack.Visible = false e.hpBar.Visible = false end
                        if st == "Number" or st == "Both" then
                            e.hpText.Position = Vector2.new((minX+maxX)/2, maxY + 2)
                            e.hpText.Text = tostring(math.floor(hum.Health))
                            e.hpText.Color = hpCol e.hpText.Visible = true
                        else e.hpText.Visible = false end
                    else e.hpBack.Visible = false e.hpBar.Visible = false e.hpText.Visible = false end
                    -- NAME
                    if CC.Name.Enabled then
                        local txt = p.DisplayName
                        if CC.Name.ShowDistance and myRoot then
                            txt ..= string.format(" [%d]", math.floor((root.Position - myRoot.Position).Magnitude))
                        end
                        if CC.Name.ShowTool then
                            local t = c:FindFirstChildOfClass("Tool")
                            if t then txt ..= " [" .. t.Name .. "]" end
                        end
                        e.name.Position = Vector2.new((minX+maxX)/2, minY - 16)
                        e.name.Text = txt e.name.Color = CC.Name.Color
                        e.name.Size = CC.Name.Size e.name.Visible = true
                    else e.name.Visible = false end
                    -- DISTANCE (separate line under box)
                    if CC.Distance.Enabled and myRoot then
                        e.dist.Position = Vector2.new((minX+maxX)/2, maxY + (CC.Health.Style == "Both" and 16 or 2))
                        e.dist.Text = string.format("%d%s", math.floor((root.Position - myRoot.Position).Magnitude), CC.Distance.Suffix)
                        e.dist.Color = CC.Distance.Color e.dist.Visible = true
                    else e.dist.Visible = false end
                    -- SKELETON
                    if CC.Skeleton.Enabled then
                        for i, pair in ipairs(BONES) do
                            local a = c:FindFirstChild(pair[1])
                            local b = c:FindFirstChild(pair[2])
                            local l = e.bones[i]
                            if a and b then
                                local va, oa = cam:WorldToViewportPoint(a.Position)
                                local vb, ob = cam:WorldToViewportPoint(b.Position)
                                if oa and ob then
                                    l.From = Vector2.new(va.X, va.Y)
                                    l.To = Vector2.new(vb.X, vb.Y)
                                    l.Color = CC.Skeleton.Color
                                    l.Thickness = CC.Skeleton.Thickness
                                    l.Visible = true
                                else l.Visible = false end
                            else l.Visible = false end
                        end
                    else for _, l in ipairs(e.bones) do l.Visible = false end end
                    -- TRACER
                    if CC.Tracer.Enabled then
                        local from
                        if CC.Tracer.From == "Bottom" then from = Vector2.new(vs.X/2, vs.Y)
                        elseif CC.Tracer.From == "Top" then from = Vector2.new(vs.X/2, 0)
                        elseif CC.Tracer.From == "Center" then from = vs/2
                        else from = U().UIS:GetMouseLocation() end
                        e.tracer.From = from
                        e.tracer.To = Vector2.new((minX+maxX)/2, maxY)
                        e.tracer.Color = CC.Tracer.Color
                        e.tracer.Thickness = CC.Tracer.Thickness
                        e.tracer.Visible = true
                    else e.tracer.Visible = false end
                    -- HEADDOT
                    if CC.HeadDot.Enabled then
                        local head = c:FindFirstChild("Head")
                        if head then
                            local v, on = cam:WorldToViewportPoint(head.Position)
                            if on then
                                e.dot.Position = Vector2.new(v.X, v.Y)
                                e.dot.Radius = CC.HeadDot.Radius
                                e.dot.Color = CC.HeadDot.Color
                                e.dot.Visible = true
                            else e.dot.Visible = false end
                        else e.dot.Visible = false end
                    else e.dot.Visible = false end
                    -- CHAMS
                    if CC.Chams.Enabled then
                        if not e.chamHl or e.chamHl.Parent ~= c then
                            hideCham(e)
                            local hl = Instance.new("Highlight")
                            hl.FillColor = CC.Chams.FillColor
                            hl.FillTransparency = CC.Chams.FillTrans
                            hl.OutlineColor = CC.Chams.OutlineColor
                            hl.DepthMode = Enum.HighlightDepthMode[
                                CC.Chams.DepthMode == "AlwaysOnTop" and "Occluded" or "Occluded"]
                            hl.Parent = c
                            e.chamHl = hl
                        else
                            e.chamHl.FillColor = CC.Chams.FillColor
                            e.chamHl.FillTransparency = CC.Chams.FillTrans
                            e.chamHl.OutlineColor = CC.Chams.OutlineColor
                        end
                    else hideCham(e) end
                end
            end
        end
    end
end

function V.Cleanup()
    for _, e in pairs(V.Cache) do
        V.hide(e) hideCham(e)
        for _, l in ipairs(e.lines) do pcall(function() l:Remove() end) end
        for _, l in ipairs(e.corners) do pcall(function() l:Remove() end) end
        for _, l in ipairs(e.bones) do pcall(function() l:Remove() end) end
        for _, o in ipairs({e.fill, e.hpBack, e.hpBar, e.hpText, e.name, e.dist, e.tracer, e.dot, e.arrow}) do
            pcall(function() o:Remove() end)
        end
    end
    V.Cache = {}
end

BB.Visuals = V

end

-- ==================== World.lua ====================
do
-- 4080 DaHood Hub | World.lua
-- Calm-world kit: custom skyboxes, fog, ambience/lighting, fullbright,
-- gun chams, bullet tracers, hit effects + sounds.
getgenv().DH4080 = getgenv().DH4080 or {}
local BB = getgenv().DH4080
local W = {}
W.Orig = {}
W.TracerFolder = nil

local SKIES = {
    Night = {Bk="rbxassetid://9098989118", Ft="rbxassetid://9098989118", Dn="rbxassetid://9098989118",
             Up="rbxassetid://9098989118", Lf="rbxassetid://9098989118", Rt="rbxassetid://9098989118"},
    Sunset = {Bk="rbxassetid://9102206169", Ft="rbxassetid://9102206169", Dn="rbxassetid://9102206169",
              Up="rbxassetid://9102206169", Lf="rbxassetid://9102206169", Rt="rbxassetid://9102206169"},
    Nebula = {Bk="rbxassetid://9104972202", Ft="rbxassetid://9104972202", Dn="rbxassetid://9104972202",
              Up="rbxassetid://9104972202", Lf="rbxassetid://9104972202", Rt="rbxassetid://9104972202"},
    Anime = {Bk="rbxassetid://9104966001", Ft="rbxassetid://9104966001", Dn="rbxassetid://9104966001",
             Up="rbxassetid://9104966001", Lf="rbxassetid://9104966001", Rt="rbxassetid://9104966001"},
}
local HITS = {
    Skeet = "rbxassetid://5443801880",
    Neverlose = "rbxassetid://6937359330",
    Bell = "rbxassetid://6518811709",
    Pop = "rbxassetid://198598793",
}

local function C() return BB.Config.World end
local function L() return game:GetService("Lighting") end

function W.SaveOrig()
    if W.Orig.saved then return end
    local l = L()
    W.Orig = {saved = true, Ambient = l.Ambient, OutdoorAmbient = l.OutdoorAmbient,
        Brightness = l.Brightness, ClockTime = l.ClockTime, FogColor = l.FogColor,
        FogStart = l.FogStart, FogEnd = l.FogEnd, GlobalShadows = l.GlobalShadows}
end

function W.ApplySky()
    local S = C().Skybox
    W.SaveOrig()
    local l = L()
    local old = l:FindFirstChild("DH4080_Sky")
    if old then old:Destroy() end
    for _, s in ipairs(l:GetChildren()) do
        if s:IsA("Sky") and s.Name ~= "DH4080_Sky" then s:Destroy() end
    end
    if not S.Enabled then return end
    local sky = Instance.new("Sky")
    sky.Name = "DH4080_Sky"
    if S.Style == "Custom" then
        for _, f in ipairs({"SkyboxBk","SkyboxFt","SkyboxDn","SkyboxUp","SkyboxLf","SkyboxRt"}) do
            sky[f] = S.CustomID
        end
    else
        local t = SKIES[S.Style] or SKIES.Night
        sky.SkyboxBk, sky.SkyboxFt, sky.SkyboxDn = t.Bk, t.Ft, t.Dn
        sky.SkyboxUp, sky.SkyboxLf, sky.SkyboxRt = t.Up, t.Lf, t.Rt
        sky.CelestialBodiesShown = (S.Style ~= "Nebula")
    end
    sky.Parent = l
end

function W.Tick()
    local CC = C()
    local l = L()
    W.SaveOrig()
    -- fog
    if CC.Fog.Enabled then
        l.FogColor, l.FogStart, l.FogEnd = CC.Fog.Color, CC.Fog.Start, CC.Fog.End
    elseif CC.NoFog then l.FogStart, l.FogEnd = 0, 100000
    else l.FogColor, l.FogStart, l.FogEnd = W.Orig.FogColor, W.Orig.FogStart, W.Orig.FogEnd end
    -- ambience
    if CC.Ambience.Enabled then
        l.Ambient, l.OutdoorAmbient = CC.Ambience.Ambient, CC.Ambience.Outdoor
        l.Brightness = CC.Ambience.Brightness
        if CC.Ambience.LockTime then l.ClockTime = CC.Ambience.ClockTime end
    elseif CC.Fullbright then
        l.Ambient, l.OutdoorAmbient = Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)
        l.Brightness = 2
    elseif CC.DayOnly then l.ClockTime = 14
    elseif CC.NightOnly then l.ClockTime = 0
    else l.Ambient, l.OutdoorAmbient, l.Brightness = W.Orig.Ambient, W.Orig.OutdoorAmbient, W.Orig.Brightness end
    if CC.NoShadows then l.GlobalShadows = false
    elseif not CC.Fullbright then l.GlobalShadows = W.Orig.GlobalShadows end
    -- gun chams
    if CC.GunChams.Enabled then
        local tool = BB.Utils.EquippedTool()
        if tool then
            for _, p in ipairs(tool:GetDescendants()) do
                if p:IsA("BasePart") and not p:FindFirstChild("DH4080_GC") then
                    local h = Instance.new("Highlight")
                    h.Name = "DH4080_GC"
                    h.FillColor = CC.GunChams.Color
                    h.FillTransparency = 0.3
                    h.OutlineColor = Color3.fromRGB(0,0,0)
                    h.Parent = p
                    p.Material = Enum.Material[CC.GunChams.Material] or Enum.Material.Neon
                end
            end
        end
    end
end

-- bullet tracer: beam from gun tip to hit point, called by guns externally
function W.Beam(from, to)
    local CC = C()
    if not CC.BulletTracer.Enabled then return end
    if not W.TracerFolder then
        W.TracerFolder = Instance.new("Folder")
        W.TracerFolder.Name = "DH4080_Tracers"
        W.TracerFolder.Parent = workspace
    end
    local a0 = Instance.new("Attachment") a0.Position = from a0.Parent = W.TracerFolder
    local a1 = Instance.new("Attachment") a1.Position = to a1.Parent = W.TracerFolder
    local b = Instance.new("Beam")
    b.Attachment0, b.Attachment1 = a0, a1
    b.Color = ColorSequence.new(CC.BulletTracer.Color)
    b.Width0, b.Width1 = 0.15, 0.15
    b.FaceCamera = true
    b.Parent = W.TracerFolder
    task.delay(CC.BulletTracer.Lifetime, function()
        pcall(function() b:Destroy() a0:Destroy() a1:Destroy() end)
    end)
end

function W.Hitmarker()
    local CC = C()
    if CC.HitEffect.Enabled then
        -- floating bubble at target
        local t = BB.Silent and BB.Silent.Target
        local part = t and BB.Utils.Char(t) and BB.Utils.Char(t):FindFirstChild("Head")
        local pos = part and part.Position or BB.Utils.Camera.CFrame.Position + BB.Utils.Camera.CFrame.LookVector * 20
        local p = Instance.new("Part")
        p.Anchored, p.CanCollide, p.CanQuery = true, false, false
        p.Transparency, p.Shape = 1, Enum.PartType.Ball
        p.Size = Vector3.new(1,1,1)
        p.Position = pos
        p.Parent = workspace
        local g = Instance.new("BillboardGui")
        g.Size = UDim2.new(0,40,0,20) g.AlwaysOnTop = true g.Parent = p
        local tl = Instance.new("TextLabel")
        tl.Size = UDim2.new(1,0,1,0) tl.BackgroundTransparency = 1
        tl.Text = CC.HitEffect.Style == "Bubble" and "●" or "✕"
        tl.TextColor3 = CC.HitEffect.Color tl.TextScaled = true
        tl.Parent = g
        task.delay(0.5, function() pcall(function() p:Destroy() end) end)
    end
    if CC.HitSound.Enabled then
        local s = Instance.new("Sound")
        s.SoundId = HITS[CC.HitSound.Style] or HITS.Skeet
        s.Volume = CC.HitSound.Volume
        s.Parent = game:GetService("SoundService")
        s:Play()
        task.delay(2, function() pcall(function() s:Destroy() end) end)
    end
end

function W.Restore()
    local l = L()
    if not W.Orig.saved then return end
    l.Ambient, l.OutdoorAmbient = W.Orig.Ambient, W.Orig.OutdoorAmbient
    l.Brightness, l.ClockTime = W.Orig.Brightness, W.Orig.ClockTime
    l.FogColor, l.FogStart, l.FogEnd = W.Orig.FogColor, W.Orig.FogStart, W.Orig.FogEnd
    l.GlobalShadows = W.Orig.GlobalShadows
    local old = l:FindFirstChild("DH4080_Sky")
    if old then old:Destroy() end
end

BB.World = W

end

-- ==================== Movement.lua ====================
do
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

end

-- ==================== Cfg.lua ====================
do
-- 4080 DaHood Hub | Cfg.lua
-- JSON config save/load via writefile/readfile. Serializes plain tables only
-- (KeyCodes/UserInputTypes stored as .Name strings, restored on load).
getgenv().DH4080 = getgenv().DH4080 or {}
local BB = getgenv().DH4080
local G = {}
local HS = game:GetService("HttpService")

local function isKey(v) return typeof(v) == "EnumItem" end

local function enc(v)
    if isKey(v) then return {__key = v.EnumType.Name .. "." .. v.Name} end
    if typeof(v) == "Color3" then
        return {__col = {math.floor(v.R*255), math.floor(v.G*255), math.floor(v.B*255)}}
    end
    if typeof(v) == "table" then
        local t = {}
        for k, x in pairs(v) do t[k] = enc(x) end
    end
end
local function dec(v)
    if typeof(v) == "table" then
        if v.__key then
            local en, nm = v.__key:match("^(.-)%.(.+)$")
            local ok, e = pcall(function() return Enum[en][nm] end)
            return (ok and e) or Enum.KeyCode.T
        end
        if v.__col then return Color3.fromRGB(v.__col[1], v.__col[2], v.__col[3]) end
        local t = {}
        for k, x in pairs(v) do t[k] = dec(x) end
    end
end
-- UserInputType isn't in Enum; store as string tag
local function enc2(v)
    if typeof(v) == "EnumItem" and tostring(v.EnumType) == "UserInputType" then
        return {__uit = v.Name}
    end
    return enc(v)
end

local function deepCopy(t)
    if typeof(t) ~= "table" then return t end
    local o = {}
    for k, v in pairs(t) do o[k] = deepCopy(v) end
end

local function merge(dst, src)
    for k, v in pairs(src) do
        if typeof(v) == "table" and typeof(dst[k]) == "table"
            and not v.__key and not v.__col and not v.__uit then
            merge(dst[k], v)
        else
            dst[k] = v
        end
    end
end

function G.Path(name) return BB.Folder .. "\\cfg_" .. tostring(name) .. ".json" end

-- pre-encode: walk config, tag UIT specially
local function encodeCfg(cfg)
    local raw = deepCopy(cfg)
    local function walk(t)
        for k, v in pairs(t) do
            if typeof(v) == "table" and not v.__key and not v.__col then
                if tostring(v) and tostring(v):find("UserInputType") then
                    -- shouldn't happen (EnumItems aren't tables) — noop
                end
                walk(v)
            end
        end
    end
    -- handle Aimbot.Key / Trigger.Key which may be UserInputType
    local function tagUIT(t)
        for k, v in pairs(t) do
            if typeof(v) == "EnumItem" then
                local ok, etn = pcall(function() return v.EnumType.Name end)
                if ok and etn == "UserInputType" then t[k] = {__uit = v.Name} end
            elseif typeof(v) == "table" then tagUIT(v) end
        end
    end
    tagUIT(raw)
    return enc(raw)
end

local function decodeCfg(t)
    local function untag(x)
        if typeof(x) == "table" then
            if x.__uit then
                return Enum.UserInputType[x.__uit]
            end
            local o = {}
            for k, v in pairs(x) do o[k] = untag(v) end
            if x.__key or x.__col then return dec(x) end
        end
        return dec(x)
    end
    return untag(t)
end

function G.Save(name)
    local ok, err = pcall(function()
        local data = encodeCfg(BB.Config)
        -- KeyName strings ride along automatically (plain strings)
        writefile(G.Path(name), HS:JSONEncode(data))
    end)
end

function G.Load(name)
    local ok = pcall(function()
        local raw = readfile(G.Path(name))
        local data = decodeCfg(HS:JSONDecode(raw))
        merge(BB.Config, data)
    end)
end

BB.Cfg = G

end

-- ==================== UI.lua ====================
do
-- 4080 DaHood Hub | UI.lua
-- Black & white multi-tab UI: RAGE / LEGIT / TRIGGER / VISUALS / WORLD / MOVE / CFG.
-- Every major feature = Toggle + ⋯ dots popup (style dropdowns, fill, colors).
getgenv().DH4080 = getgenv().DH4080 or {}
local BB = getgenv().DH4080

local UI = {}
UI.Fovs = {}

local function L() return BB.UILib end
local function C() return BB.Config end
local function num(v) return string.format("%.2f", v) end
local function int(v) return string.format("%d", math.floor(v)) end

function UI.Build()
    local LIB = L()
    local CC = C()
    local gui, main = LIB.Window("4080 DAHOOD  ▸ v" .. CC.Version,
        UDim2.new(0, 560, 0, 480), UDim2.new(0.5, -280, 0.5, -240))
    LIB.mk("Frame", {Name = "Notifs", Size = UDim2.new(0, 280, 0, 200),
        Position = UDim2.new(1, -292, 0, 10), BackgroundTransparency = 1}, gui)
        :FindFirstChildOfClass("UIListLayout")
    local stack = gui:FindFirstChild("Notifs")
    local lay = Instance.new("UIListLayout") lay.Padding = UDim.new(0, 4) lay.Parent = stack

    -- status strip
    local strip = LIB.mk("Frame", {Size = UDim2.new(1,-16,0,24), Position = UDim2.new(0,8,0,40),
        BackgroundColor3 = Color3.fromRGB(14,14,18), BorderSizePixel = 0, Corner = 6,
        Stroke = Color3.fromRGB(38,38,45)}, main)
    UI._status = LIB.mk("TextLabel", {Size = UDim2.new(1,-16,1,0), Position = UDim2.new(0,8,0,0),
        BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(160,160,170),
        Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
        Text = "legit: off | rage: off | -- fps"}, strip)

    local P = LIB.Tabs(main, {"Rage", "Legit", "Trigger", "Visuals", "World", "Move", "Cfg"}, 70)
    local T, S, D, K, B = LIB.Toggle, LIB.Section, LIB.Dropdown, LIB.Keybind, LIB.Button

    -- ================= RAGE =================
    local R = CC.Rage
    T(P.Rage, "Enable Rage", function() return R.Enabled end, function(v) R.Enabled = v end)
    S(P.Rage, "Orbit (circle victim)")
    T(P.Rage, "Orbit", function() return R.Orbit.Enabled end, function(v) R.Orbit.Enabled = v end, {
        {type="dropdown", label="Target mode", options={"Closest","Lowest"}, get=function() return R.Orbit.TargetMode end, set=function(v) R.Orbit.TargetMode = v end},
        {type="toggle", label="Auto spin", get=function() return R.Orbit.AutoSpin end, set=function(v) R.Orbit.AutoSpin = v end},
        {type="toggle", label="Randomize radius", get=function() return R.Orbit.Randomize end, set=function(v) R.Orbit.Randomize = v end},
        {type="slider", label="Radius", min=3, max=25, get=function() return R.Orbit.Radius end, set=function(v) R.Orbit.Radius = v end, fmt=int},
        {type="slider", label="Height", min=-4, max=10, get=function() return R.Orbit.Height end, set=function(v) R.Orbit.Height = v end, fmt=num},
        {type="slider", label="Speed", min=1, max=20, get=function() return R.Orbit.Speed end, set=function(v) R.Orbit.Speed = v end, fmt=num},
    })
    S(P.Rage, "Spinbot / Jitter / AA")
    T(P.Rage, "Spinbot", function() return R.Spinbot.Enabled end, function(v) R.Spinbot.Enabled = v end, {
        {type="slider", label="Spin speed", min=1, max=100, get=function() return R.Spinbot.Speed end, set=function(v) R.Spinbot.Speed = v end, fmt=int},
        {type="toggle", label="X spin (sideways)", get=function() return R.Spinbot.XSpin end, set=function(v) R.Spinbot.XSpin = v end},
    })
    T(P.Rage, "Jitter", function() return R.Jitter.Enabled end, function(v) R.Jitter.Enabled = v end, {
        {type="slider", label="Angle", min=5, max=180, get=function() return R.Jitter.Angle end, set=function(v) R.Jitter.Angle = v end, fmt=int},
    })
    T(P.Rage, "Anti-Aim", function() return R.AA.Enabled end, function(v) R.AA.Enabled = v end, {
        {type="dropdown", label="Pitch", options={"Up","Down","Zero","Jitter"}, get=function() return R.AA.Pitch end, set=function(v) R.AA.Pitch = v end},
        {type="slider", label="Yaw base", min=0, max=360, get=function() return R.AA.YawBase end, set=function(v) R.AA.YawBase = v end, fmt=int},
        {type="slider", label="Yaw jitter", min=0, max=180, get=function() return R.AA.YawJitter end, set=function(v) R.AA.YawJitter = v end, fmt=int},
    })
    S(P.Rage, "Gun mods")
    T(P.Rage, "Rapid fire", function() return R.RapidFire.Enabled end, function(v) R.RapidFire.Enabled = v end, {
        {type="slider", label="Rate", min=1, max=12, get=function() return R.RapidFire.Rate end, set=function(v) R.RapidFire.Rate = v end, fmt=int},
    })
    T(P.Rage, "No recoil", function() return R.NoRecoil.Enabled end, function(v) R.NoRecoil.Enabled = v end, {
        {type="slider", label="Strength %", min=0, max=100, get=function() return R.NoRecoil.Strength end, set=function(v) R.NoRecoil.Strength = v end, fmt=int},
    })
    T(P.Rage, "Fake lag", function() return R.FakeLag.Enabled end, function(v) R.FakeLag.Enabled = v end, {
        {type="slider", label="Ticks", min=2, max=30, get=function() return R.FakeLag.Ticks end, set=function(v) R.FakeLag.Ticks = v end, fmt=int},
    })
    T(P.Rage, "Speed shot (fire on equip)", function() return R.SpeedShot.Enabled end, function(v) R.SpeedShot.Enabled = v end)
    S(P.Rage, "Automation")
    T(P.Rage, "Auto stomp", function() return R.AutoStomp.Enabled end, function(v) R.AutoStomp.Enabled = v end)
    T(P.Rage, "Auto reload", function() return R.AutoReload.Enabled end, function(v) R.AutoReload.Enabled = v end, {
        {type="slider", label="Threshold", min=0, max=12, get=function() return R.AutoReload.Threshold end, set=function(v) R.AutoReload.Threshold = v end, fmt=int},
    })

    -- ================= LEGIT =================
    local A = CC.Aimbot
    T(P.Legit, "Enable Aimbot", function() return A.Enabled end, function(v) A.Enabled = v end)
    K(P.Legit, "Aim key (click, press next)", function() return A.KeyName end,
        function(kc, name) A.Key = kc A.KeyName = name end)
    D(P.Legit, "Mode", {"Camera","Mouse"}, function() return A.Mode end, function(v) A.Mode = v end, nil, true)
    D(P.Legit, "Target part", {"Head","UpperTorso","HumanoidRootPart","Closest","Random"}, function() return A.TargetPart end, function(v) A.TargetPart = v end, nil, true)
    D(P.Legit, "Target mode", {"Closest","ClosestAngle","LowestHP","Threat"}, function() return A.TargetMode end, function(v) A.TargetMode = v end, nil, true)
    LIB.Slider(P.Legit, "FOV", 10, 600, function() return A.FOV end, function(v) A.FOV = v end, int)
    LIB.Slider(P.Legit, "Smoothness", 1, 40, function() return A.Smoothness end, function(v) A.Smoothness = v end, num)
    LIB.Slider(P.Legit, "Pull (mouse mode)", 1, 40, function() return A.Pull end, function(v) A.Pull = v end, num)
    LIB.Slider(P.Legit, "Prediction", 0, 0.3, function() return A.Prediction end, function(v) A.Prediction = v end,
        function(v) return string.format("%.3f", v) end)
    D(P.Legit, "Heartbeat (updates/s)", {30,60,120,240}, function() return A.Heartbeat end, function(v) A.Heartbeat = v end, nil, true)
    LIB.Slider(P.Legit, "Hit chance %", 1, 100, function() return A.HitChance end, function(v) A.HitChance = v end, int)
    LIB.Slider(P.Legit, "Reaction ms", 0, 500, function() return A.ReactionMs end, function(v) A.ReactionMs = v end, int)
    LIB.Slider(P.Legit, "X offset", -5, 5, function() return A.XOffset end, function(v) A.XOffset = v end, num)
    LIB.Slider(P.Legit, "Y offset", -5, 5, function() return A.YOffset end, function(v) A.YOffset = v end, num)
    LIB.Slider(P.Legit, "Shake X", 0, 20, function() return A.ShakeX end, function(v) A.ShakeX = v end, num)
    LIB.Slider(P.Legit, "Shake Y", 0, 20, function() return A.ShakeY end, function(v) A.ShakeY = v end, num)
    T(P.Legit, "Sticky lock", function() return A.Sticky end, function(v) A.Sticky = v end, {
        {type="slider", label="Stickiness", min=0, max=1, get=function() return A.Stickiness end, set=function(v) A.Stickiness = v end, fmt=num},
    })
    T(P.Legit, "Second stage (tighten)", function() return A.SecondStage end, function(v) A.SecondStage = v end, {
        {type="slider", label="Stage-2 FOV", min=5, max=200, get=function() return A.SecondFOV end, set=function(v) A.SecondFOV = v end, fmt=int},
        {type="slider", label="Stage-2 smooth", min=1, max=60, get=function() return A.SecondSmooth end, set=function(v) A.SecondSmooth = v end, fmt=num},
    })
    T(P.Legit, "Checks", true, function() end, { -- header row trick: static ON + dots hold the checks
        {type="toggle", label="Wall check", get=function() return A.WallCheck end, set=function(v) A.WallCheck = v end},
        {type="toggle", label="Knocked check", get=function() return A.KnockedCheck end, set=function(v) A.KnockedCheck = v end},
        {type="toggle", label="Forcefield check", get=function() return A.ForcefieldCheck end, set=function(v) A.ForcefieldCheck = v end},
        {type="toggle", label="Team (crew) check", get=function() return A.TeamCheck end, set=function(v) A.TeamCheck = v end},
    })
    S(P.Legit, "Silent aim")
    local SI = CC.Silent
    T(P.Legit, "Silent aim", function() return SI.Enabled end, function(v) SI.Enabled = v end, {
        {type="dropdown", label="Method", options={"Raycast","Index"}, get=function() return SI.Method end, set=function(v) SI.Method = v end},
        {type="dropdown", label="Target part", options={"Head","UpperTorso","HumanoidRootPart","Closest","Random"}, get=function() return SI.TargetPart end, set=function(v) SI.TargetPart = v end},
        {type="toggle", label="Silent FOV ring", get=function() return SI.FOVVisible end, set=function(v) SI.FOVVisible = v end},
        {type="slider", label="Silent FOV", min=10, max=600, get=function() return SI.FOV end, set=function(v) SI.FOV = v end, fmt=int},
        {type="slider", label="Hit chance %", min=1, max=100, get=function() return SI.HitChance end, set=function(v) SI.HitChance = v end, fmt=int},
        {type="slider", label="Prediction", min=0, max=0.3, get=function() return SI.Prediction end, set=function(v) SI.Prediction = v end, fmt=function(v) return string.format("%.3f", v) end},
    })

    -- ================= TRIGGER =================
    local TR = CC.Trigger
    T(P.Trigger, "Enable Trigger", function() return TR.Enabled end, function(v) TR.Enabled = v end)
    K(P.Trigger, "Trigger key (click, press next)", function() return TR.KeyName end,
        function(kc, name) TR.Key = kc TR.KeyName = name end)
    T(P.Trigger, "Toggle mode (else hold)", function() return TR.ToggleMode end, function(v) TR.ToggleMode = v end)
    LIB.Slider(P.Trigger, "Delay ms (before 1st)", 0, 500, function() return TR.DelayMs end, function(v) TR.DelayMs = v end, int)
    LIB.Slider(P.Trigger, "Consecutive delay ms (after 1st)", 0, 1000, function() return TR.ConsecutiveDelayMs end, function(v) TR.ConsecutiveDelayMs = v end, int)
    D(P.Trigger, "Target part", {"Head","Torso","Any"}, function() return TR.TargetPart end, function(v) TR.TargetPart = v end, nil, true)
    LIB.Slider(P.Trigger, "FOV px", 2, 120, function() return TR.FOV end, function(v) TR.FOV = v end, int)
    LIB.Slider(P.Trigger, "Hit chance %", 1, 100, function() return TR.HitChance end, function(v) TR.HitChance = v end, int)
    LIB.Slider(P.Trigger, "Max distance", 50, 2000, function() return TR.MaxDistance end, function(v) TR.MaxDistance = v end, int)
    T(P.Trigger, "Checks + options", true, function() end, {
        {type="toggle", label="Wall check", get=function() return TR.WallCheck end, set=function(v) TR.WallCheck = v end},
        {type="toggle", label="Knocked check", get=function() return TR.KnockedCheck end, set=function(v) TR.KnockedCheck = v end},
        {type="toggle", label="Team check", get=function() return TR.TeamCheck end, set=function(v) TR.TeamCheck = v end},
        {type="toggle", label="FOV ring", get=function() return TR.FOVVisible end, set=function(v) TR.FOVVisible = v end},
        {type="toggle", label="Don't fire while moving", get=function() return TR.MoveBlocker end, set=function(v) TR.MoveBlocker = v end},
        {type="slider", label="Move threshold", min=5, max=100, get=function() return TR.MoveThreshold end, set=function(v) TR.MoveThreshold = v end, fmt=int},
    })
    UI._trigState = LIB.mk("TextLabel", {Size = UDim2.new(1,0,0,22), BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.GothamBold, TextSize = 12,
        Text = "TRIGGER: OFF"}, P.Trigger)

    -- ================= VISUALS =================
    local E = CC.ESP
    T(P.Visuals, "Enable ESP", function() return E.Enabled end, function(v) E.Enabled = v end)
    LIB.Slider(P.Visuals, "Max distance", 100, 5000, function() return E.MaxDistance end, function(v) E.MaxDistance = v end, int)
    -- BOX with dots: style dropdown + fill toggle + colors
    T(P.Visuals, "Box", function() return E.Box.Enabled end, function(v) E.Box.Enabled = v end, {
        {type="dropdown", label="Style", options={"Full","Cornered"}, get=function() return E.Box.Style end, set=function(v) E.Box.Style = v end},
        {type="toggle", label="Fill", get=function() return E.Box.Fill.Enabled end, set=function(v) E.Box.Fill.Enabled = v end},
        {type="toggle", label="Outline", get=function() return E.Box.Outline end, set=function(v) E.Box.Outline = v end},
        {type="toggle", label="Team color", get=function() return E.Box.TeamColor end, set=function(v) E.Box.TeamColor = v end},
        {type="slider", label="Thickness", min=1, max=4, get=function() return E.Box.Thickness end, set=function(v) E.Box.Thickness = v end, fmt=num},
        {type="color", label="Box color", get=function() return E.Box.Color end, set=function(v) E.Box.Color = v end},
        {type="color", label="Fill color", get=function() return E.Box.Fill.Color end, set=function(v) E.Box.Fill.Color = v end},
        {type="slider", label="Fill transparency", min=0, max=1, get=function() return E.Box.Fill.Transparency end, set=function(v) E.Box.Fill.Transparency = v end, fmt=num},
    })
    LIB.ColorRow(P.Visuals, "Box color (quick)", function() return E.Box.Color end, function(v) E.Box.Color = v end)
    -- HEALTH with dots: style + position
    T(P.Visuals, "Health", function() return E.Health.Enabled end, function(v) E.Health.Enabled = v end, {
        {type="dropdown", label="Style", options={"Bar","Number","Both"}, get=function() return E.Health.Style end, set=function(v) E.Health.Style = v end},
        {type="dropdown", label="Bar position", options={"Left","Right"}, get=function() return E.Health.Position end, set=function(v) E.Health.Position = v end},
        {type="color", label="Full HP color", get=function() return E.Health.ColorHigh end, set=function(v) E.Health.ColorHigh = v end},
        {type="color", label="Low HP color", get=function() return E.Health.ColorLow end, set=function(v) E.Health.ColorLow = v end},
    })
    T(P.Visuals, "Name", function() return E.Name.Enabled end, function(v) E.Name.Enabled = v end, {
        {type="toggle", label="Show distance", get=function() return E.Name.ShowDistance end, set=function(v) E.Name.ShowDistance = v end},
        {type="toggle", label="Show tool", get=function() return E.Name.ShowTool end, set=function(v) E.Name.ShowTool = v end},
        {type="slider", label="Text size", min=8, max=24, get=function() return E.Name.Size end, set=function(v) E.Name.Size = v end, fmt=int},
        {type="color", label="Name color", get=function() return E.Name.Color end, set=function(v) E.Name.Color = v end},
    })
    T(P.Visuals, "Distance", function() return E.Distance.Enabled end, function(v) E.Distance.Enabled = v end, {
        {type="dropdown", label="Suffix", options={"st","m"}, get=function() return E.Distance.Suffix end, set=function(v) E.Distance.Suffix = v end},
        {type="color", label="Color", get=function() return E.Distance.Color end, set=function(v) E.Distance.Color = v end},
    })
    T(P.Visuals, "Skeleton", function() return E.Skeleton.Enabled end, function(v) E.Skeleton.Enabled = v end, {
        {type="slider", label="Thickness", min=1, max=4, get=function() return E.Skeleton.Thickness end, set=function(v) E.Skeleton.Thickness = v end, fmt=num},
        {type="color", label="Bone color", get=function() return E.Skeleton.Color end, set=function(v) E.Skeleton.Color = v end},
    })
    T(P.Visuals, "Chams", function() return E.Chams.Enabled end, function(v) E.Chams.Enabled = v end, {
        {type="dropdown", label="Depth", options={"AlwaysOnTop","Occluded"}, get=function() return E.Chams.DepthMode end, set=function(v) E.Chams.DepthMode = v end},
        {type="color", label="Fill", get=function() return E.Chams.FillColor end, set=function(v) E.Chams.FillColor = v end},
        {type="slider", label="Fill transparency", min=0, max=1, get=function() return E.Chams.FillTrans end, set=function(v) E.Chams.FillTrans = v end, fmt=num},
        {type="color", label="Outline", get=function() return E.Chams.OutlineColor end, set=function(v) E.Chams.OutlineColor = v end},
    })
    T(P.Visuals, "Tracer", function() return E.Tracer.Enabled end, function(v) E.Tracer.Enabled = v end, {
        {type="dropdown", label="From", options={"Bottom","Top","Center","Mouse"}, get=function() return E.Tracer.From end, set=function(v) E.Tracer.From = v end},
        {type="color", label="Color", get=function() return E.Tracer.Color end, set=function(v) E.Tracer.Color = v end},
    })
    T(P.Visuals, "Head dot", function() return E.HeadDot.Enabled end, function(v) E.HeadDot.Enabled = v end, {
        {type="slider", label="Radius", min=1, max=12, get=function() return E.HeadDot.Radius end, set=function(v) E.HeadDot.Radius = v end, fmt=int},
        {type="color", label="Color", get=function() return E.HeadDot.Color end, set=function(v) E.HeadDot.Color = v end},
    })
    T(P.Visuals, "Offscreen arrows", function() return E.Offscreen.Enabled end, function(v) E.Offscreen.Enabled = v end, {
        {type="slider", label="Radius", min=40, max=400, get=function() return E.Offscreen.Radius end, set=function(v) E.Offscreen.Radius = v end, fmt=int},
    })
    T(P.Visuals, "Filters", true, function() end, {
        {type="toggle", label="Team (crew) check", get=function() return E.TeamCheck end, set=function(v) E.TeamCheck = v end},
        {type="toggle", label="Knocked only", get=function() return E.KnockedOnly end, set=function(v) E.KnockedOnly = v end},
    })

    -- ================= WORLD =================
    local Wd = CC.World
    S(P.World, "Skybox")
    T(P.World, "Custom sky", function() return Wd.Skybox.Enabled end, function(v) Wd.Skybox.Enabled = v BB.World.ApplySky() end, {
        {type="dropdown", label="Style", options={"Night","Sunset","Nebula","Anime","Custom"}, get=function() return Wd.Skybox.Style end, set=function(v) Wd.Skybox.Style = v BB.World.ApplySky() end},
    })
    S(P.World, "Fog")
    T(P.World, "Custom fog", function() return Wd.Fog.Enabled end, function(v) Wd.Fog.Enabled = v end, {
        {type="color", label="Fog color", get=function() return Wd.Fog.Color end, set=function(v) Wd.Fog.Color = v end},
        {type="slider", label="Fog start", min=0, max=2000, get=function() return Wd.Fog.Start end, set=function(v) Wd.Fog.Start = v end, fmt=int},
        {type="slider", label="Fog end", min=50, max=5000, get=function() return Wd.Fog.End end, set=function(v) Wd.Fog.End = v end, fmt=int},
    })
    T(P.World, "No fog", function() return Wd.NoFog end, function(v) Wd.NoFog = v end)
    S(P.World, "Ambience / lighting")
    T(P.World, "Ambience", function() return Wd.Ambience.Enabled end, function(v) Wd.Ambience.Enabled = v end, {
        {type="color", label="Ambient", get=function() return Wd.Ambience.Ambient end, set=function(v) Wd.Ambience.Ambient = v end},
        {type="color", label="Outdoor", get=function() return Wd.Ambience.Outdoor end, set=function(v) Wd.Ambience.Outdoor = v end},
        {type="slider", label="Brightness", min=0, max=5, get=function() return Wd.Ambience.Brightness end, set=function(v) Wd.Ambience.Brightness = v end, fmt=num},
        {type="toggle", label="Lock time", get=function() return Wd.Ambience.LockTime end, set=function(v) Wd.Ambience.LockTime = v end},
        {type="slider", label="Clock time", min=0, max=24, get=function() return Wd.Ambience.ClockTime end, set=function(v) Wd.Ambience.ClockTime = v end, fmt=num},
    })
    T(P.World, "Fullbright", function() return Wd.Fullbright end, function(v) Wd.Fullbright = v end)
    T(P.World, "No shadows", function() return Wd.NoShadows end, function(v) Wd.NoShadows = v end)
    T(P.World, "Force day", function() return Wd.DayOnly end, function(v) Wd.DayOnly = v Wd.NightOnly = false end)
    T(P.World, "Force night", function() return Wd.NightOnly end, function(v) Wd.NightOnly = v Wd.DayOnly = false end)
    S(P.World, "Gun FX")
    T(P.World, "Gun chams", function() return Wd.GunChams.Enabled end, function(v) Wd.GunChams.Enabled = v end, {
        {type="dropdown", label="Material", options={"Neon","ForceField","Glass","SmoothPlastic"}, get=function() return Wd.GunChams.Material end, set=function(v) Wd.GunChams.Material = v end},
        {type="color", label="Color", get=function() return Wd.GunChams.Color end, set=function(v) Wd.GunChams.Color = v end},
    })
    T(P.World, "Bullet tracers", function() return Wd.BulletTracer.Enabled end, function(v) Wd.BulletTracer.Enabled = v end, {
        {type="color", label="Color", get=function() return Wd.BulletTracer.Color end, set=function(v) Wd.BulletTracer.Color = v end},
    })
    T(P.World, "Hit effect", function() return Wd.HitEffect.Enabled end, function(v) Wd.HitEffect.Enabled = v end, {
        {type="dropdown", label="Style", options={"Bubble","Cross"}, get=function() return Wd.HitEffect.Style end, set=function(v) Wd.HitEffect.Style = v end},
        {type="color", label="Color", get=function() return Wd.HitEffect.Color end, set=function(v) Wd.HitEffect.Color = v end},
    })
    T(P.World, "Hit sound", function() return Wd.HitSound.Enabled end, function(v) Wd.HitSound.Enabled = v end, {
        {type="dropdown", label="Style", options={"Skeet","Neverlose","Bell","Pop"}, get=function() return Wd.HitSound.Style end, set=function(v) Wd.HitSound.Style = v end},
        {type="slider", label="Volume", min=0, max=10, get=function() return Wd.HitSound.Volume end, set=function(v) Wd.HitSound.Volume = v end, fmt=num},
    })

    -- ================= MOVE =================
    local Mv = CC.Move
    T(P.Move, "Speed", function() return Mv.Speed.Enabled end, function(v) Mv.Speed.Enabled = v if not v then BB.Movement.SpeedOff() end end, {
        {type="dropdown", label="Mode", options={"WalkSpeed","Velocity","CFrame"}, get=function() return Mv.Speed.Mode end, set=function(v) Mv.Speed.Mode = v end},
        {type="slider", label="Value", min=16, max=200, get=function() return Mv.Speed.Value end, set=function(v) Mv.Speed.Value = v end, fmt=int},
    })
    T(P.Move, "Fly (F)", function() return Mv.Fly.Enabled end, function(v) Mv.Fly.Enabled = v end, {
        {type="slider", label="Speed", min=10, max=200, get=function() return Mv.Fly.Speed end, set=function(v) Mv.Fly.Speed = v end, fmt=int},
        {type="toggle", label="Noclip while flying", get=function() return Mv.Fly.Noclip end, set=function(v) Mv.Fly.Noclip = v end},
    })
    T(P.Move, "Noclip (N)", function() return Mv.Noclip.Enabled end, function(v) Mv.Noclip.Enabled = v end)
    T(P.Move, "Bunny hop", function() return Mv.BunnyHop.Enabled end, function(v) Mv.BunnyHop.Enabled = v end, {
        {type="slider", label="Power", min=5, max=100, get=function() return Mv.BunnyHop.Power end, set=function(v) Mv.BunnyHop.Power = v end, fmt=int},
    })
    T(P.Move, "Infinite jump", function() return Mv.InfiniteJump end, function(v) Mv.InfiniteJump = v end)
    T(P.Move, "Click TP (B)", function() return Mv.ClickTP.Enabled end, function(v) Mv.ClickTP.Enabled = v end)
    T(P.Move, "No slowdown", function() return Mv.NoSlow.Enabled end, function(v) Mv.NoSlow.Enabled = v end)
    T(P.Move, "No fall damage", function() return Mv.NoFall.Enabled end, function(v) Mv.NoFall.Enabled = v end)
    T(P.Move, "Infinite stamina", function() return Mv.Stamina.Infinite end, function(v) Mv.Stamina.Infinite = v end)

    -- ================= CFG =================
    local St = CC.Settings
    S(P.Cfg, "Menu")
    K(P.Cfg, "Menu toggle", function() return CC.UIToggle.Name end,
        function(kc, name) CC.UIToggle = kc end)
    K(P.Cfg, "Panic key (kill all)", function() return St.PanicKey.Name end,
        function(kc, name) St.PanicKey = kc end)
    T(P.Cfg, "Anti AFK", function() return St.AntiAFK end, function(v) St.AntiAFK = v end)
    T(P.Cfg, "Show FPS in strip", function() return St.ShowFPS end, function(v) St.ShowFPS = v end)
    LIB.Slider(P.Cfg, "FPS cap", 30, 360, function() return St.FPSCap end,
        function(v) St.FPSCap = v pcall(function() setfpscap(v) end) end, int)
    S(P.Cfg, "Config")
    local nameBox = LIB.mk("TextBox", {Size = UDim2.new(1,0,0,30), BackgroundColor3 = Color3.fromRGB(20,20,25),
        TextColor3 = Color3.fromRGB(235,235,240), Font = Enum.Font.Gotham, TextSize = 13,
        Text = St.ConfigName, PlaceholderText = "config name", Corner = 6,
        Stroke = Color3.fromRGB(38,38,45)}, P.Cfg)
    nameBox.FocusLost:Connect(function() St.ConfigName = nameBox.Text end)
    B(P.Cfg, "SAVE config", function()
        local ok = BB.Cfg.Save(St.ConfigName)
        LIB.Notify(gui, ok and ("saved " .. St.ConfigName) or "save failed")
    end)
    B(P.Cfg, "LOAD config", function()
        local ok = BB.Cfg.Load(nameBox.Text ~= "" and nameBox.Text or St.ConfigName)
        LIB.Notify(gui, ok and "loaded — reopen menu" or "load failed")
    end)
    B(P.Cfg, "UNLOAD hub", function() BB.Shutdown() end)

    -- FOV rings (aim / silent / trigger)
    UI.MkFov("aim", function() return A.FOVVisible end, function() return A.FOV end,
        function() return A.FOVColor end, function() return A.Filled end, function() return A.Enabled end)
    UI.MkFov("silent", function() return SI.FOVVisible end, function() return SI.FOV end,
        function() return Color3.fromRGB(160,160,170) end, function() return false end, function() return SI.Enabled end)
    UI.MkFov("trig", function() return TR.FOVVisible end, function() return TR.FOV end,
        function() return Color3.fromRGB(255,255,255) end, function() return false end, function() return TR.Enabled end)

    -- status ticker
    task.spawn(function()
        while gui.Parent do
            task.wait(0.5)
            if UI._status then
                local trig = TR.ToggleMode and (TR.Active and "armed" or "off")
                    or (TR.Enabled and "hold" or "off")
                UI._status.Text = string.format("aim:%s trig:%s silent:%s rage:%s | %d fps %dms | orbit:%s",
                    A.Enabled and (BB.Aimbot.Lock and BB.Aimbot.Lock.DisplayName or "on") or "off",
                    trig, SI.Enabled and "on" or "off", R.Enabled and "on" or "off",
                    math.floor(BB.Utils.FPS()), math.floor(BB.Utils.PingMs()),
                    R.Orbit.Enabled and "on" or "off")
            end
            if UI._trigState then
                UI._trigState.Text = "TRIGGER: " .. (BB.Trigger.Active() and "ARMED — shots " .. BB.Trigger.Shots or "OFF")
            end
        end
    end)

    LIB.Notify(gui, "4080 dahood live — nose twitching")
    UI.Gui = gui
end

function UI.MkFov(id, vis, radius, color, filled, enabled)
    local c = Drawing.new("Circle")
    c.Thickness = 1.2 c.NumSides = 64
    UI.Fovs[id] = {o = c, vis = vis, radius = radius, color = color, filled = filled, enabled = enabled}
end

function UI.FovTick()
    local mp = game:GetService("UserInputService"):GetMouseLocation()
    for _, f in pairs(UI.Fovs) do
        local show = f.vis() and f.enabled()
        f.o.Visible = show
        if show then
            f.o.Position = mp
            f.o.Radius = f.radius()
            f.o.Color = f.color()
            f.o.Filled = f.filled()
            f.o.Transparency = f.filled() and 0.85 or 1
        end
    end
end

BB.UI = UI

end

-- ==================== Init.lua ====================
do
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

end

