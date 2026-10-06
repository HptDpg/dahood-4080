-- Modora v1 | big cornered UI shell, black & white, no functions
-- Sidebar: Rage / Legit / Visuals / World / Movement / Config / Settings
-- Paste into executor. RightShift toggles.

local TABS = {"Rage", "Legit", "Visuals", "World", "Movement", "Config", "Settings"}

local BG    = Color3.fromRGB(10, 10, 12)
local WIN   = Color3.fromRGB(14, 14, 17)
local PANEL = Color3.fromRGB(18, 18, 22)
local BOX   = Color3.fromRGB(24, 24, 29)
local LINE  = Color3.fromRGB(48, 48, 56)
local TXT   = Color3.fromRGB(235, 235, 240)
local DIM   = Color3.fromRGB(140, 140, 150)
local WHITE = Color3.fromRGB(246, 246, 250)

local UIS = game:GetService("UserInputService")
local S = {}
local popups = {}

local function closePopups(except)
    for _, p in ipairs(popups) do
        if p ~= except and p.Parent then pcall(function() p.Visible = false end) end
    end
end

local function section(col, title, order)
    local f = mk("Frame", {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1,
        LayoutOrder = order}, col)
    mk("TextLabel", {Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1,
        Text = title, TextColor3 = WHITE,
        Font = Enum.Font.GothamBold, TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left}, f)
    mk("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 24),
        BackgroundColor3 = LINE, BorderSizePixel = 0}, f)
end

local function toggle(col, label, key, default, order)
    local row = mk("Frame", {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1,
        LayoutOrder = order}, col)
    local cb = mk("Frame", {Size = UDim2.new(0, 17, 0, 17),
        Position = UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = BOX, BorderSizePixel = 0, Corner = 4, Stroke = true}, row)
    local check = mk("Frame", {Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(0.5, -5, 0.5, -5),
        BackgroundColor3 = WHITE, BorderSizePixel = 0, Corner = 2, Visible = false}, cb)
    mk("TextLabel", {Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 27, 0, 0),
        BackgroundTransparency = 1, Text = label, TextColor3 = TXT,
        Font = Enum.Font.Gotham, TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd}, row)
    local pill = mk("TextButton", {Size = UDim2.new(0, 38, 0, 19),
        Position = UDim2.new(1, -42, 0.5, -9),
        BackgroundColor3 = OFF or BOX, Text = "", Corner = 10}, row)
    local knob = mk("Frame", {Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new(0, 2, 0.5, -7),
        BackgroundColor3 = WHITE, BorderSizePixel = 0, Corner = 8}, pill)
    local OFFC = Color3.fromRGB(72, 72, 80)
    local function val()
        if S[key] == nil then return default end
        return S[key]
    end
    local function ref()
        local v = val()
        check.Visible = v
        pill.BackgroundColor3 = v and WHITE or OFFC
        knob.BackgroundColor3 = v and BG or WHITE
        knob.Position = v and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    end
    local hit = mk("TextButton", {Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, Text = ""}, row)
    hit.MouseButton1Click:Connect(function() S[key] = not val(); ref() end)
    ref()
end

local function dropdown(col, label, key, default, options, order)
    local wrap = mk("Frame", {Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1,
        LayoutOrder = order}, col)
    mk("TextLabel", {Size = UDim2.new(1, 0, 0, 19), BackgroundTransparency = 1,
        Text = label, TextColor3 = TXT, Font = Enum.Font.Gotham, TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left}, wrap)
    local box = mk("TextButton", {Size = UDim2.new(1, 0, 0, 28),
        Position = UDim2.new(0, 0, 0, 21),
        BackgroundColor3 = BOX, TextColor3 = WHITE,
        Font = Enum.Font.Gotham, TextSize = 14, Corner = 9, Stroke = true}, wrap)
    local plus = mk("TextLabel", {Size = UDim2.new(0, 26, 1, 0),
        Position = UDim2.new(1, -26, 0, 0), BackgroundTransparency = 1,
        Text = "+", TextColor3 = WHITE, Font = Enum.Font.Gotham, TextSize = 16}, box)
    local function cur()
        if S[key] == nil then return default end
        return S[key]
    end
    local function ref() box.Text = "   " .. tostring(cur()) end
    local list = mk("Frame", {Size = UDim2.new(1, 0, 0, #options * 30 + 10),
        BackgroundColor3 = PANEL, BorderSizePixel = 0, Corner = 9,
        Stroke = true, Visible = false, ZIndex = 200}, wrap)
    list.Position = UDim2.new(0, 0, 0, 51)
    table.insert(popups, list)
    for i, opt in ipairs(options) do
        local ob = mk("TextButton", {Size = UDim2.new(1, -10, 0, 28),
            Position = UDim2.new(0, 5, 0, 5 + (i - 1) * 30),
            BackgroundColor3 = BOX, TextColor3 = TXT,
            Font = Enum.Font.Gotham, TextSize = 14,
            Text = tostring(opt), Corner = 7}, list)
        ob.MouseButton1Click:Connect(function() S[key] = opt; ref(); list.Visible = false end)
    end
    box.MouseButton1Click:Connect(function()
        local v = not list.Visible; closePopups(list); list.Visible = v
    end)
    ref()
end

-- yes/no segmented button
local function yesno(col, label, key, default, order)
    local row = mk("Frame", {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1,
        LayoutOrder = order}, col)
    mk("TextLabel", {Size = UDim2.new(1, -110, 1, 0), BackgroundTransparency = 1,
        Text = label, TextColor3 = TXT, Font = Enum.Font.Gotham, TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd}, row)
    local seg = mk("Frame", {Size = UDim2.new(0, 100, 0, 24),
        Position = UDim2.new(1, -100, 0.5, -12),
        BackgroundColor3 = BOX, BorderSizePixel = 0, Corner = 8, Stroke = true}, row)
    local yb = mk("TextButton", {Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundColor3 = BOX, TextColor3 = TXT,
        Font = Enum.Font.GothamBold, TextSize = 13, Text = "Yes", Corner = 8}, seg)
    local nb = mk("TextButton", {Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundColor3 = BOX, TextColor3 = TXT,
        Font = Enum.Font.GothamBold, TextSize = 13, Text = "No", Corner = 8}, seg)
    local function ref()
        local v = S[key]
        if v == nil then v = default end
        yb.BackgroundColor3 = v and WHITE or BOX
        yb.TextColor3 = v and BG or TXT
        nb.BackgroundColor3 = (not v) and WHITE or BOX
        nb.TextColor3 = (not v) and BG or TXT
    end
    yb.MouseButton1Click:Connect(function() S[key] = true; ref() end)
    nb.MouseButton1Click:Connect(function() S[key] = false; ref() end)
    ref()
end

local function slider(col, label, key, default, min, max, fmt, order)
    local f = fmt or function(v) return string.format("%.1f", v) end
    local wrap = mk("Frame", {Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1,
        LayoutOrder = order}, col)
    mk("TextLabel", {Size = UDim2.new(1, 0, 0, 19), BackgroundTransparency = 1,
        Text = label, TextColor3 = TXT, Font = Enum.Font.Gotham, TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left}, wrap)
    local bar = mk("TextButton", {Size = UDim2.new(1, 0, 0, 28),
        Position = UDim2.new(0, 0, 0, 21),
        BackgroundColor3 = BOX, Text = "", Corner = 9, Stroke = true}, wrap)
    local fill = mk("Frame", {Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundColor3 = WHITE, BorderSizePixel = 0, Corner = 9}, bar)
    local val = mk("TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Text = "0", TextColor3 = WHITE, Font = Enum.Font.Gotham, TextSize = 13}, bar)
    local function cur()
        if S[key] == nil then return default end
        return S[key]
    end
    local function ref()
        local v = cur()
        fill.Size = UDim2.new(math.clamp((v - min) / math.max(max - min, 1e-4), 0, 1), 0, 1, 0)
        val.Text = f(v)
        val.TextColor3 = v > min + (max - min) * 0.9 and BG or WHITE
    end
    local function apply(px)
        local t = math.clamp((px - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
        S[key] = min + (max - min) * t; ref()
    end
    local dragging = false
    bar.MouseButton1Down:Connect(function() dragging = true; apply(UIS:GetMouseLocation().X) end)
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

local function mk(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Corner" and k ~= "Stroke" then pcall(function() o[k] = v end) end
    end
    if props.Corner then
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, props.Corner)
        c.Parent = o
    end
    if props.Stroke then
        local s = Instance.new("UIStroke")
        s.Color = LINE
        s.Thickness = 1
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Parent = o
    end
    o.Parent = parent
    return o
end

local CG = game:GetService("CoreGui")
pcall(function() CG:FindFirstChild("Modora"):Destroy() end)
local gui = mk("ScreenGui", {Name = "Modora", ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 50}, CG)

local main = mk("Frame", {Name = "Main",
    Size = UDim2.new(0, 920, 0, 640),
    Position = UDim2.new(0.5, -460, 0.5, -320),
    BackgroundColor3 = WIN, BorderSizePixel = 0, Corner = 18, Stroke = true}, gui)

local head = mk("Frame", {Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = PANEL, BorderSizePixel = 0, Corner = 18}, main)
mk("TextLabel", {Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 16, 0, 0),
    BackgroundTransparency = 1, Text = "Modora",
    TextColor3 = WHITE, Font = Enum.Font.GothamBlack, TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left}, head)
local hideB = mk("TextButton", {Size = UDim2.new(0, 34, 0, 26),
    Position = UDim2.new(1, -44, 0, 7),
    BackgroundColor3 = BOX, TextColor3 = TXT,
    Font = Enum.Font.GothamBold, TextSize = 14, Text = "—", Corner = 9, Stroke = true}, head)
hideB.MouseButton1Click:Connect(function() main.Visible = false end)

local drag, ds, sp = false, nil, nil
head.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag, ds, sp = true, i.Position, main.Position
    end
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

local side = mk("Frame", {Size = UDim2.new(0, 160, 1, -52),
    Position = UDim2.new(0, 8, 0, 46),
    BackgroundColor3 = PANEL, BorderSizePixel = 0, Corner = 14}, main)
local slay = Instance.new("UIListLayout")
slay.Padding = UDim.new(0, 6)
slay.Parent = side
mk("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
    PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8)}, side)

local content = mk("Frame", {Size = UDim2.new(1, -186, 1, -58),
    Position = UDim2.new(0, 178, 0, 46),
    BackgroundTransparency = 1}, main)

local pages, sideBtns = {}, {}

local function show(tab)
    for k, pg in pairs(pages) do pg.Visible = (k == tab) end
    for k, b in pairs(sideBtns) do
        local on = (k == tab)
        b.BackgroundColor3 = on and WHITE or BOX
        b.TextColor3 = on and BG or TXT
    end
end

for i, tab in ipairs(TABS) do
    local b = mk("TextButton", {LayoutOrder = i, Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = i == 1 and WHITE or BOX,
        TextColor3 = i == 1 and BG or TXT,
        Font = Enum.Font.GothamBold, TextSize = 15, Text = tab, Corner = 11}, side)
    sideBtns[tab] = b
    local pg = mk("ScrollingFrame", {Name = tab, Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, ScrollBarThickness = 3,
        ScrollBarImageColor3 = WHITE,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = i == 1}, content)
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 6)
    lay.Parent = pg
    pages[tab] = pg
    mk("TextLabel", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1,
        Text = tab, TextColor3 = DIM,
        Font = Enum.Font.GothamBold, TextSize = 22,
        TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 0}, pg)
    b.MouseButton1Click:Connect(function() show(tab) end)
end

-- ===== VISUALS: box esp =====
do
    local pg = pages["Visuals"]
    section(pg, "Box ESP", 10)
    toggle(pg, "Enabled", "box_on", false, 11)
    dropdown(pg, "Style", "box_style", "Cornered", {"Full", "Cornered"}, 12)
    yesno(pg, "Fill", "box_fill", false, 13)
    yesno(pg, "Outline", "box_outline", true, 14)
    slider(pg, "Thickness", "box_thick", 1.5, 1, 4, function(v)
        return string.format("%.1f", v)
    end, 15)
end

UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

print("Modora live")
