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
return UI
