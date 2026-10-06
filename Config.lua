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
return C
