-- 4080 UI v1 | lunar-style layout, black & white
-- Sidebar: Rage / Legit / Visuals / World / Movement / Settings
-- Row grammar from the reference:
--   toggle   = [checkbox] Label .................. [pill]
--   dropdown = Label (thin)  /  full-width box:  value   +
--   slider   = Label (thin)  /  full-width bar:  value centered inside
--   textbox  = Label (thin)  /  full-width box with typed value
--   section  = bold white header + hairline
-- Paste into executor. RightShift toggles.

local TABS = {"Rage", "Legit", "Visuals", "World", "Movement", "Settings"}

local BG      = Color3.fromRGB(8, 8, 10)
local WIN     = Color3.fromRGB(14, 14, 17)
local PANEL   = Color3.fromRGB(17, 17, 21)
local BOX     = Color3.fromRGB(22, 22, 27)
local LINE    = Color3.fromRGB(52, 52, 60)
local HAIR    = Color3.fromRGB(40, 40, 47)
local TXT     = Color3.fromRGB(232, 232, 238)
local DIM     = Color3.fromRGB(135, 135, 145)
local WHITE   = Color3.fromRGB(245, 245, 250)
local OFF     = Color3.fromRGB(72, 72, 80)

local UIS = game:GetService("UserInputService")
local S = {} -- state
local popups = {}

local function mk(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Corner" and k ~= "Stroke" then pcall(function() o[k] = v end) end
    end
    if props.Corner then
        local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, props.Corner) c.Parent = o
    end
    if props.Stroke then
        local s = Instance.new("UIStroke") s.Color = LINE s.Thickness = 1
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border s.Parent = o
    end
    o.Parent = parent
    return o
end

local function closePopups(except)
    for _, p in ipairs(popups) do
        if p ~= except and p.Parent then pcall(function() p.Visible = false) end
    end
end

-- ===== ROWS =====
local ROW_O = 0 -- auto order counter helper (LayoutOrder via caller)

local function section(col, title)
    local f = mk("Frame", {Size = UDim2.new(1,0,0,26), BackgroundTransparency = 1,
        LayoutOrder = ROW_O}, col)
    ROW_O += 1
    mk("TextLabel", {Size = UDim2.new(1,0,0,16), BackgroundTransparency = 1, Text = title,
        TextColor3 = WHITE, Font = Enum.Font.GothamBold, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left}, f)
    mk("Frame", {Size = UDim2.new(1,0,1,-16), Position = UDim2.new(0,0,0,17),
        BackgroundColor3 = HAIR, BorderSizePixel = 0}, f)
end

local function toggle(col, label, key, default)
    local row = mk("Frame", {Size = UDim2.new(1,0,0,22), BackgroundTransparency = 1,
        LayoutOrder = ROW_O}, col)
    ROW_O += 1
    -- checkbox
    local cb = mk("Frame", {Size = UDim2.new(0,13,0,13), Position = UDim2.new(0,2,0.5,-6),
        BackgroundColor3 = BOX, BorderSizePixel = 0, Corner = 2, Stroke = true}, row)
    local check = mk("Frame", {Size = UDim2.new(0,7,0,7), Position = UDim2.new(0.5,-3,0.5,-3),
        BackgroundColor3 = WHITE, BorderSizePixel = 0, Corner = 1, Visible = false}, cb)
    -- label
    mk("TextLabel", {Size = UDim2.new(1,-70,1,0), Position = UDim2.new(0,20,0,0),
        BackgroundTransparency = 1, Text = label, TextColor3 = TXT,
        Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd}, row)
    -- pill
    local pill = mk("TextButton", {Size = UDim2.new(0,26,0,13), Position = UDim2.new(1,-28,0.5,-6),
        BackgroundColor3 = OFF, Text = "", Corner = 7}, row)
    local knob = mk("Frame", {Size = UDim2.new(0,11,0,11), Position = UDim2.new(0,1,0.5,-5),
        BackgroundColor3 = WHITE, BorderSizePixel = 0, Corner = 6}, pill)
    local function val()
        if S[key] == nil then return default end
        return S[key]
    end
    local function ref()
        local v = val()
        check.Visible = v
        pill.BackgroundColor3 = v and WHITE or OFF
        knob.BackgroundColor3 = v and BG or WHITE
        knob.Position = v and UDim2.new(1,-12,0.5,-5) or UDim2.new(0,1,0.5,-5)
    end
    local hit = mk("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
        Text = ""}, row)
    hit.MouseButton1Click:Connect(function() S[key] = not val() ref() end)
    ref()
end

local function dropdown(col, label, key, default, options)
    local wrap = mk("Frame", {Size = UDim2.new(1,0,0,40), BackgroundTransparency = 1,
        LayoutOrder = ROW_O}, col)
    ROW_O += 1
    mk("TextLabel", {Size = UDim2.new(1,0,0,15), BackgroundTransparency = 1, Text = label,
        TextColor3 = TXT, Font = Enum.Font.Gotham, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left}, wrap)
    local box = mk("TextButton", {Size = UDim2.new(1,0,0,21), Position = UDim2.new(0,0,0,17),
        BackgroundColor3 = BOX, TextColor3 = WHITE, Font = Enum.Font.Gotham, TextSize = 12,
        Text = "", Corner = 3, Stroke = true}, wrap)
    local plus = mk("TextLabel", {Size = UDim2.new(0,20,1,0), Position = UDim2.new(1,-20,0,0),
        BackgroundTransparency = 1, Text = "+", TextColor3 = WHITE,
        Font = Enum.Font.Gotham, TextSize = 13}, box)
    local function cur() if S[key] == nil then return default end return S[key] end
    local function ref() box.Text = "   " .. tostring(cur()) end
    local list = mk("Frame", {Size = UDim2.new(1,0,0,#options*20+8), BackgroundColor3 = PANEL,
        BorderSizePixel = 0, Corner = 3, Stroke = true, Visible = false, ZIndex = 200}, wrap)
    list.Position = UDim2.new(0,0,0,40)
    table.insert(popups, list)
    for i, opt in ipairs(options) do
        local ob = mk("TextButton", {Size = UDim2.new(1,-6,0,19), Position = UDim2.new(0,3,0,4+(i-1)*20),
            BackgroundColor3 = BOX, TextColor3 = TXT, Font = Enum.Font.Gotham, TextSize = 11,
            Text = tostring(opt), Corner = 2}, list)
        ob.MouseButton1Click:Connect(function() S[key] = opt ref() list.Visible = false end)
    end
    box.MouseButton1Click:Connect(function()
        local v = not list.Visible closePopups(list) list.Visible = v
    end)
    ref()
end

local function slider(col, label, key, default, min, max, fmt)
    local f = fmt or function(v) return string.format("%.2f", v) end
    local wrap = mk("Frame", {Size = UDim2.new(1,0,0,40), BackgroundTransparency = 1,
        LayoutOrder = ROW_O}, col)
    ROW_O += 1
    mk("TextLabel", {Size = UDim2.new(1,0,0,15), BackgroundTransparency = 1, Text = label,
        TextColor3 = TXT, Font = Enum.Font.Gotham, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left}, wrap)
    local bar = mk("TextButton", {Size = UDim2.new(1,0,0,21), Position = UDim2.new(0,0,0,17),
        BackgroundColor3 = BOX, Text = "", Corner = 3, Stroke = true}, wrap)
    local fill = mk("Frame", {Size = UDim2.new(0.5,0,1,0), BackgroundColor3 = WHITE,
        BorderSizePixel = 0, Corner = 3}, bar)
    local val = mk("TextLabel", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
        Text = "0", TextColor3 = WHITE, Font = Enum.Font.Gotham, TextSize = 11}, bar)
    local function cur() if S[key] == nil then return default end return S[key] end
    local function ref()
        local v = cur()
        fill.Size = UDim2.new(math.clamp((v-min)/math.max(max-min,1e-4),0,1),0,1,0)
        val.Text = f(v)
        -- value text: dark over white fill, white over dark remainder
        val.TextColor3 = v > min + (max-min)*0.92 and BG or WHITE
    end
    local function apply(px)
        local t = math.clamp((px-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1)
        S[key] = min+(max-min)*t ref()
    end
    local dragging = false
    bar.MouseButton1Down:Connect(function() dragging = true apply(UIS:GetMouseLocation().X) end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement
            and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            apply(i.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    ref()
end

local function textbox(col, label, key, default, hint)
    local wrap = mk("Frame", {Size = UDim2.new(1,0,0,hint and 62 or 40), BackgroundTransparency = 1,
        LayoutOrder = ROW_O}, col)
    ROW_O += 1
    mk("TextLabel", {Size = UDim2.new(1,0,0,15), BackgroundTransparency = 1, Text = label,
        TextColor3 = TXT, Font = Enum.Font.Gotham, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left}, wrap)
    local box = mk("TextBox", {Size = UDim2.new(1,0,0,21), Position = UDim2.new(0,0,0,17),
        BackgroundColor3 = BOX, TextColor3 = WHITE, Font = Enum.Font.Gotham, TextSize = 11,
        Text = tostring(S[key] or default), PlaceholderText = "", ClearTextOnFocus = false,
        Corner = 3, Stroke = true}, wrap)
    box.FocusLost:Connect(function() S[key] = box.Text end)
    if hint then
        mk("TextLabel", {Size = UDim2.new(1,0,0,20), Position = UDim2.new(0,2,0,40),
            BackgroundTransparency = 1, Text = hint, TextColor3 = DIM,
            Font = Enum.Font.Gotham, TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true}, wrap)
    end
end

local function button(col, label, cb)
    local b = mk("TextButton", {Size = UDim2.new(1,0,0,24), BackgroundColor3 = BOX,
        TextColor3 = WHITE, Font = Enum.Font.GothamBold, TextSize = 12, Text = label,
        Corner = 3, Stroke = true, LayoutOrder = ROW_O}, col)
    ROW_O += 1
    b.MouseButton1Click:Connect(function() cb() end)
end

local function note(col, text)
    local f = mk("TextLabel", {Size = UDim2.new(1,0,0,16), BackgroundTransparency = 1,
        Text = text, TextColor3 = DIM, Font = Enum.Font.Gotham, TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = ROW_O}, col)
    ROW_O += 1
end

-- ===== WINDOW =====
local CG = game:GetService("CoreGui")
pcall(function() CG:FindFirstChild("DH4080"):Destroy() end)
local gui = mk("ScreenGui", {Name = "DH4080", ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 50}, CG)
local main = mk("Frame", {Name = "Main", Size = UDim2.new(0, 660, 0, 480),
    Position = UDim2.new(0.5, -330, 0.5, -240), BackgroundColor3 = WIN,
    BorderSizePixel = 0, Corner = 6, Stroke = true}, gui)

-- title bar
local head = mk("Frame", {Size = UDim2.new(1,0,0,28), BackgroundColor3 = PANEL,
    BorderSizePixel = 0, Corner = 6}, main)
mk("TextLabel", {Size = UDim2.new(1,-70,1,0), Position = UDim2.new(0,10,0,0),
    BackgroundTransparency = 1, Text = "4080", TextColor3 = TXT,
    Font = Enum.Font.GothamBlack, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left}, head)
local hideB = mk("TextButton", {Size = UDim2.new(0,24,0,18), Position = UDim2.new(1,-30,0,5),
    BackgroundColor3 = BOX, TextColor3 = TXT, Font = Enum.Font.GothamBold, TextSize = 11,
    Text = "_", Corner = 3, Stroke = true}, head)
hideB.MouseButton1Click:Connect(function() main.Visible = false end)

-- drag
local drag, ds, sp = false, nil, nil
head.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag, ds, sp = true, i.Position, main.Position end
end)
UIS.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - ds
        main.Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
end)

-- sidebar
local side = mk("Frame", {Size = UDim2.new(0, 112, 1, -36), Position = UDim2.new(0, 6, 0, 32),
    BackgroundColor3 = PANEL, BorderSizePixel = 0, Corner = 4}, main)
local slay = Instance.new("UIListLayout") slay.Padding = UDim.new(0,3) slay.Parent = side
local spad = mk("UIPadding", {PaddingLeft = UDim.new(0,6), PaddingRight = UDim.new(0,6),
    PaddingTop = UDim.new(0,6), PaddingBottom = UDim.new(0,6)}, side)

-- content area
local content = mk("Frame", {Size = UDim2.new(1, -126, 1, -36), Position = UDim2.new(0, 124, 0, 32),
    BackgroundTransparency = 1}, main)
local pages = {}
local sideBtns = {}

local function show(tab)
    for k, pg in pairs(pages) do pg.Visible = (k == tab) end
    for k, b in pairs(sideBtns) do
        local on = (k == tab)
        b.BackgroundColor3 = on and WHITE or BOX
        b.TextColor3 = on and BG or TXT
    end
    closePopups()
end

for i, tab in ipairs(TABS) do
    local b = mk("TextButton", {LayoutOrder = i, Size = UDim2.new(1,0,0,30),
        BackgroundColor3 = i == 1 and WHITE or BOX,
        TextColor3 = i == 1 and BG or TXT,
        Font = Enum.Font.GothamBold, TextSize = 12, Text = tab, Corner = 4}, side)
    sideBtns[tab] = b
    local pg = mk("ScrollingFrame", {Name = tab, Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1, ScrollBarThickness = 3, ScrollBarImageColor3 = WHITE,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0),
        Visible = i == 1}, content)
    local lay = Instance.new("UIListLayout") lay.Padding = UDim.new(0,3) lay.Parent = pg
    local pad = mk("UIPadding", {PaddingLeft = UDim.new(0,4), PaddingRight = UDim.new(0,6),
        PaddingTop = UDim.new(0,2)}, pg)
    pages[tab] = pg
    b.MouseButton1Click:Connect(function() show(tab) end)
end

-- ===== CONTENT =====
local function twoCol(tab)
    -- fixed-height page: each column scrolls independently
    local pg = pages[tab]
    local holder = mk("Frame", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1}, pg)
    local L = mk("ScrollingFrame", {Size = UDim2.new(0.5,-4,1,0), BackgroundTransparency = 1,
        ScrollBarThickness = 3, ScrollBarImageColor3 = WHITE,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0)}, holder)
    local ll = Instance.new("UIListLayout") ll.Padding = UDim.new(0,3) ll.Parent = L
    local R = mk("ScrollingFrame", {Size = UDim2.new(0.5,-4,1,0), Position = UDim2.new(0.5,4,0,0),
        BackgroundTransparency = 1, ScrollBarThickness = 3, ScrollBarImageColor3 = WHITE,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0)}, holder)
    local rl = Instance.new("UIListLayout") rl.Padding = UDim.new(0,3) rl.Parent = R
    return holder, L, R
end

-- RAGE
do
    local hold, L, R = twoCol("Rage")
    ROW_O = 1
    section(L, "combat")
    toggle(L, "Enabled", "rage_on", false)
    toggle(L, "Orbit", "orbit", false)
    dropdown(L, "Orbit target", "orbit_t", "Closest", {"Closest", "Lowest HP", "Threat"})
    slider(L, "Orbit radius", "orbit_r", 9, 3, 25, function(v) return string.format("%d", math.floor(v)) end)
    slider(L, "Orbit speed", "orbit_sp", 6, 1, 20, function(v) return string.format("%d", math.floor(v)) end)
    section(L, "movement")
    toggle(L, "Spinbot", "spin", false)
    slider(L, "Spin speed", "spin_sp", 40, 1, 100, function(v) return string.format("%d", math.floor(v)) end)
    toggle(L, "Jitter", "jit", false)
    ROW_O = 1
    section(R, "guns")
    toggle(R, "Rapid fire", "rapid", false)
    slider(R, "Rate", "rapid_r", 5, 1, 12, function(v) return string.format("%d", math.floor(v)) end)
    toggle(R, "No recoil", "norec", false)
    toggle(R, "Speed shot", "speedshot", false)
    section(R, "automation")
    toggle(R, "Auto stomp", "astomp", false)
    toggle(R, "Auto reload", "areload", false)
    slider(R, "Reload threshold", "ar_th", 3, 0, 12, function(v) return string.format("%d", math.floor(v)) end)
    toggle(R, "Auto armor", "aarmor", false)
end

-- LEGIT
do
    local hold, L, R = twoCol("Legit")
    ROW_O = 1
    section(L, "aimbot")
    toggle(L, "Enabled", "aim_on", false)
    dropdown(L, "Aim mode", "aim_mode", "Camera", {"Camera", "Mouse"})
    dropdown(L, "Target part", "aim_part", "Head", {"Head", "UpperTorso", "HumanoidRootPart", "Closest"})
    dropdown(L, "Target mode", "aim_tm", "Closest", {"Closest", "Closest angle", "Lowest HP"})
    slider(L, "FOV", "aim_fov", 120, 10, 600, function(v) return string.format("%d", math.floor(v)) end)
    slider(L, "Smoothness", "aim_sm", 8, 1, 40, function(v) return string.format("%.1f", v) end)
    slider(L, "Prediction", "aim_pred", 0.13, 0, 0.3, function(v) return string.format("%.3f", v) end)
    slider(L, "Hit chance", "aim_hc", 100, 1, 100, function(v) return string.format("%d%%", math.floor(v)) end)
    ROW_O = 1
    section(R, "triggerbot")
    toggle(R, "Enabled", "trig_on", false)
    slider(R, "Delay (1st shot)", "trig_d1", 60, 0, 500, function(v) return string.format("%dms", math.floor(v)) end)
    slider(R, "Consecutive delay", "trig_d2", 120, 0, 1000, function(v) return string.format("%dms", math.floor(v)) end)
    dropdown(R, "Target part", "trig_part", "Head", {"Head", "Torso", "Any"})
    slider(R, "FOV", "trig_fov", 14, 2, 120, function(v) return string.format("%d", math.floor(v)) end)
    toggle(R, "Wall check", "trig_wall", true)
    section(R, "silent")
    toggle(R, "Silent aim", "sil_on", false)
    slider(R, "Silent FOV", "sil_fov", 150, 10, 600, function(v) return string.format("%d", math.floor(v)) end)
    slider(R, "Hit chance", "sil_hc", 85, 1, 100, function(v) return string.format("%d%%", math.floor(v)) end)
end

-- VISUALS
do
    local hold, L, R = twoCol("Visuals")
    ROW_O = 1
    section(L, "players")
    toggle(L, "ESP enabled", "esp_on", false)
    toggle(L, "Box", "box", false)
    dropdown(L, "Box style", "box_style", "Cornered", {"Full", "Cornered"})
    toggle(L, "Box fill", "box_fill", false)
    slider(L, "Fill transparency", "box_ft", 0.75, 0, 1, function(v) return string.format("%.2f", v) end)
    toggle(L, "Health", "hp", true)
    dropdown(L, "Health style", "hp_style", "Bar", {"Bar", "Number", "Both"})
    toggle(L, "Name", "name", true)
    toggle(L, "Distance", "dist", false)
    toggle(L, "Skeleton", "skel", false)
    toggle(L, "Chams", "chams", false)
    ROW_O = 1
    section(R, "extras")
    toggle(R, "Tracer", "tracer", false)
    dropdown(R, "Tracer from", "tracer_from", "Bottom", {"Bottom", "Top", "Center", "Mouse"})
    toggle(R, "Head dot", "hdot", false)
    toggle(R, "Offscreen arrows", "oarr", false)
    toggle(R, "FOV ring", "fovring", true)
    section(R, "filters")
    toggle(R, "Team check", "esp_team", false)
    toggle(R, "Knocked only", "esp_ko", false)
    slider(R, "Max distance", "esp_max", 1500, 100, 5000, function(v) return string.format("%d", math.floor(v)) end)
end

-- WORLD
do
    local hold, L, R = twoCol("World")
    ROW_O = 1
    section(L, "sky & light")
    toggle(L, "Custom sky", "sky_on", false)
    dropdown(L, "Sky style", "sky_style", "Night", {"Night", "Sunset", "Nebula", "Custom"})
    toggle(L, "Fullbright", "fbright", false)
    toggle(L, "No shadows", "noshadow", false)
    toggle(L, "Force day", "fday", false)
    toggle(L, "Force night", "fnight", false)
    section(L, "fog")
    toggle(L, "Custom fog", "fog_on", false)
    slider(L, "Fog start", "fog_s", 0, 0, 2000, function(v) return string.format("%d", math.floor(v)) end)
    slider(L, "Fog end", "fog_e", 500, 50, 5000, function(v) return string.format("%d", math.floor(v)) end)
    ROW_O = 1
    section(R, "ambience")
    toggle(R, "Ambience", "amb_on", false)
    slider(R, "Brightness", "amb_br", 2, 0, 5, function(v) return string.format("%.1f", v) end)
    slider(R, "Clock time", "amb_ct", 14, 0, 24, function(v) return string.format("%.1f", v) end)
    section(R, "fx")
    toggle(R, "Gun chams", "gcham", false)
    toggle(R, "Bullet tracers", "btrac", false)
    toggle(R, "Hit effect", "hfx", false)
    toggle(R, "Hit sound", "hsnd", false)
    dropdown(R, "Hit sound style", "hsnd_s", "Skeet", {"Skeet", "Neverlose", "Bell", "Pop"})
end

-- MOVEMENT
do
    local hold, L, R = twoCol("Movement")
    ROW_O = 1
    section(L, "speed")
    toggle(L, "Speed", "spd_on", false)
    dropdown(L, "Speed mode", "spd_mode", "WalkSpeed", {"WalkSpeed", "Velocity", "CFrame"})
    slider(L, "Speed value", "spd_v", 28, 16, 200, function(v) return string.format("%d", math.floor(v)) end)
    section(L, "fly")
    toggle(L, "Fly (F)", "fly_on", false)
    slider(L, "Fly speed", "fly_sp", 50, 10, 200, function(v) return string.format("%d", math.floor(v)) end)
    toggle(L, "Noclip while flying", "fly_nc", true)
    ROW_O = 1
    section(R, "misc")
    toggle(R, "Noclip (N)", "nc_on", false)
    toggle(R, "Bunny hop", "bhop", false)
    slider(R, "Bhop power", "bhop_p", 35, 5, 100, function(v) return string.format("%d", math.floor(v)) end)
    toggle(R, "Infinite jump", "injump", false)
    toggle(R, "Click TP (B)", "ctp", false)
    toggle(R, "No slowdown", "noslow", false)
    toggle(R, "No fall damage", "nofall", false)
    toggle(R, "Infinite stamina", "stam", false)
end

-- SETTINGS
do
    local pg = pages["Settings"]
    ROW_O = 1
    section(pg, "menu")
    toggle(pg, "Anti AFK", "aafk", true)
    toggle(pg, "Show FPS strip", "showfps", true)
    slider(pg, "FPS cap", "fpscap", 240, 30, 360, function(v) return string.format("%d", math.floor(v)) end)
    section(pg, "config")
    textbox(pg, "Config name", "cfg_name", "default")
    button(pg, "SAVE CONFIG", function() print("4080: save") end)
    button(pg, "LOAD CONFIG", function() print("4080: load") end)
    note(pg, "RightShift toggles this menu. Right-click dropdowns to go back.")
end

UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightShift then
        closePopups()
        main.Visible = not main.Visible
    end
end)

print("4080 UI v1 live")
