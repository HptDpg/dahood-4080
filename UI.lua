-- 4080 UI v1 | from scratch, lunar-style, black & white
-- Sidebar tabs, subtab bar, two-column pages. Dummy state only.
-- Paste into executor. Toggle with RightShift.

local TABS = {
    {name = "Rage",   subs = {"Main", "Anti-Aim", "Guns"}},
    {name = "Legit",  subs = {"Aimbot", "Trigger"}},
    {name = "Visual", subs = {"ESP", "World"}},
    {name = "Move",   subs = {"Main"}},
    {name = "Cfg",    subs = {"Main"}},
}

local S = {} -- dummy state
local function bool(k, d) if S[k] == nil then S[k] = d end return S[k] end
local function num(k, d) if S[k] == nil then S[k] = d end return S[k] end
local function str(k, d) if S[k] == nil then S[k] = d end return S[k] end

local BG = Color3.fromRGB(12,12,14)
local PANEL = Color3.fromRGB(18,18,22)
local ROW = Color3.fromRGB(24,24,29)
local LINE = Color3.fromRGB(46,46,54)
local TXT = Color3.fromRGB(235,235,240)
local DIM = Color3.fromRGB(150,150,160)
local WHITE = Color3.fromRGB(245,245,248)
local GRAYB = Color3.fromRGB(80,80,88)
local UIS = game:GetService("UserInputService")

local function mk(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Corner" and k ~= "Stroke" then
            pcall(function() o[k] = v end)
        end
    end
    if props.Corner then
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, props.Corner)
        c.Parent = o
    end
    if props.Stroke then
        local s = Instance.new("UIStroke")
        s.Color = LINE s.Thickness = 1
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Parent = o
    end
    o.Parent = parent
    return o
end

local function toggle(parent, label, key, default, order)
    local row = mk("Frame", {Size = UDim2.new(1,0,0,24), BackgroundTransparency = 1, LayoutOrder = order}, parent)
    mk("TextLabel", {Size = UDim2.new(1,-44,1,0), BackgroundTransparency = 1, Text = label,
        TextColor3 = TXT, Font = Enum.Font.Gotham, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd}, row)
    local sw = mk("TextButton", {Size = UDim2.new(0,32,0,16), Position = UDim2.new(1,-34,0.5,-8),
        BackgroundColor3 = bool(key, default) and WHITE or GRAYB, Text = "", Corner = 8}, row)
    local knob = mk("Frame", {Size = UDim2.new(0,12,0,12),
        Position = bool(key, default) and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6),
        BackgroundColor3 = bool(key, default) and BG or WHITE, BorderSizePixel = 0, Corner = 6}, sw)
    local function ref()
        local v = bool(key, default)
        sw.BackgroundColor3 = v and WHITE or GRAYB
        knob.Position = v and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6)
        knob.BackgroundColor3 = v and BG or WHITE
    end
    sw.MouseButton1Click:Connect(function() S[key] = not bool(key, default) ref() end)
    ref()
end

local function slider(parent, label, key, default, min, max, fmt, order)
    local f = fmt or function(v) return string.format("%.1f", v) end
    local row = mk("Frame", {Size = UDim2.new(1,0,0,40), BackgroundTransparency = 1, LayoutOrder = order}, parent)
    mk("TextLabel", {Size = UDim2.new(1,-52,0,15), BackgroundTransparency = 1, Text = label,
        TextColor3 = TXT, Font = Enum.Font.Gotham, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd}, row)
    local box = mk("TextBox", {Size = UDim2.new(0,48,0,16), Position = UDim2.new(1,-48,0,0),
        BackgroundColor3 = ROW, TextColor3 = WHITE, Font = Enum.Font.Gotham, TextSize = 11,
        Text = f(num(key, default)), Corner = 4, Stroke = true}, row)
    local bar = mk("TextButton", {Size = UDim2.new(1,0,0,12), Position = UDim2.new(0,0,0,22),
        BackgroundColor3 = ROW, Text = "", Corner = 6, Stroke = true}, row)
    local fill = mk("Frame", {Size = UDim2.new(0.5,0,1,0), BackgroundColor3 = WHITE,
        BorderSizePixel = 0, Corner = 6}, bar)
    local function ref()
        local v = num(key, default)
        fill.Size = UDim2.new(math.clamp((v-min)/math.max(max-min,1e-4),0,1),0,1,0)
        box.Text = f(v)
    end
    local function apply(px)
        local t = math.clamp((px-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1)
        S[key] = min+(max-min)*t ref()
    end
    local drag = false
    bar.MouseButton1Down:Connect(function() drag = true apply(UIS:GetMouseLocation().X) end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement
            and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            apply(i.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
    box.FocusLost:Connect(function(enter)
        if enter then local n = tonumber(box.Text) if n then S[key] = math.clamp(n,min,max) end ref() end
    end)
    ref()
end

local popups = {}
local function closePopups(except)
    for _, p in ipairs(popups) do
        if p ~= except and p.Parent then pcall(function() p.Visible = false end) end
    end
end

local function dropdown(parent, label, key, default, options, order)
    local row = mk("Frame", {Size = UDim2.new(1,0,0,24), BackgroundTransparency = 1, LayoutOrder = order}, parent)
    mk("TextLabel", {Size = UDim2.new(1,-110,1,0), BackgroundTransparency = 1, Text = label,
        TextColor3 = TXT, Font = Enum.Font.Gotham, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd}, row)
    local b = mk("TextButton", {Size = UDim2.new(0,104,0,20), Position = UDim2.new(1,-104,0.5,-10),
        BackgroundColor3 = ROW, TextColor3 = WHITE, Font = Enum.Font.Gotham, TextSize = 11,
        Text = tostring(str(key, default)) .. "  +", Corner = 5, Stroke = true}, row)
    local list = mk("Frame", {Size = UDim2.new(0,130,0,#options*22+8), BackgroundColor3 = PANEL,
        BorderSizePixel = 0, Corner = 6, Stroke = true, Visible = false, ZIndex = 200}, row)
    list.Position = UDim2.new(1,-130,1,2)
    table.insert(popups, list)
    for i, opt in ipairs(options) do
        local ob = mk("TextButton", {Size = UDim2.new(1,-8,0,20), Position = UDim2.new(0,4,0,4+(i-1)*22),
            BackgroundColor3 = ROW, TextColor3 = TXT, Font = Enum.Font.Gotham, TextSize = 11,
            Text = tostring(opt), Corner = 4}, list)
        ob.MouseButton1Click:Connect(function() S[key] = opt b.Text = tostring(opt) .. "  +" list.Visible = false end)
    end
    b.MouseButton1Click:Connect(function()
        local v = not list.Visible closePopups(list) list.Visible = v
    end)
end

local function group(col, title, order)
    local g = mk("Frame", {Size = UDim2.new(1,0,0,26), BackgroundColor3 = PANEL,
        BorderSizePixel = 0, Corner = 6, Stroke = true, AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = order}, col)
    mk("TextLabel", {Size = UDim2.new(1,-16,0,20), Position = UDim2.new(0,8,0,2),
        BackgroundTransparency = 1, Text = title, TextColor3 = WHITE,
        Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, g)
    local body = mk("Frame", {Size = UDim2.new(1,-8,0,0), Position = UDim2.new(0,4,0,22),
        BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y}, g)
    local lay = Instance.new("UIListLayout") lay.Padding = UDim.new(0,4) lay.Parent = body
    mk("Frame", {Size = UDim2.new(1,0,0,4), BackgroundTransparency = 1, LayoutOrder = 9999}, body)
    return body
end

-- ===== window =====
local CG = game:GetService("CoreGui")
pcall(function() CG:FindFirstChild("DH4080"):Destroy() end)
local gui = mk("ScreenGui", {Name = "DH4080", ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 50}, CG)
local main = mk("Frame", {Name = "Main", Size = UDim2.new(0,640,0,460),
    Position = UDim2.new(0.5,-320,0.5,-230), BackgroundColor3 = BG,
    BorderSizePixel = 0, Corner = 8, Stroke = true}, gui)
local head = mk("Frame", {Size = UDim2.new(1,0,0,30), BackgroundColor3 = PANEL,
    BorderSizePixel = 0, Corner = 8}, main)
mk("TextLabel", {Size = UDim2.new(1,-70,1,0), Position = UDim2.new(0,12,0,0),
    BackgroundTransparency = 1, Text = "4080  ▸  v1", TextColor3 = TXT,
    Font = Enum.Font.GothamBlack, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left}, head)
local hideB = mk("TextButton", {Size = UDim2.new(0,26,0,20), Position = UDim2.new(1,-32,0,5),
    BackgroundColor3 = ROW, TextColor3 = TXT, Font = Enum.Font.GothamBold, TextSize = 12,
    Text = "_", Corner = 5, Stroke = true}, head)
hideB.MouseButton1Click:Connect(function() main.Visible = false end)

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

local side = mk("Frame", {Size = UDim2.new(0,110,1,-38), Position = UDim2.new(0,6,0,34),
    BackgroundColor3 = PANEL, BorderSizePixel = 0, Corner = 6}, main)
local slay = Instance.new("UIListLayout") slay.Padding = UDim.new(0,4) slay.Parent = side
mk("UIPadding", {PaddingLeft = UDim.new(0,6)}, side)
local spad = side:FindFirstChildOfClass("UIPadding")
spad.PaddingRight = UDim.new(0,6) spad.PaddingTop = UDim.new(0,6) spad.PaddingBottom = UDim.new(0,6)

local right = mk("Frame", {Size = UDim2.new(1,-124,1,-38), Position = UDim2.new(0,118,0,34),
    BackgroundTransparency = 1}, main)
local subbar = mk("Frame", {Size = UDim2.new(1,0,0,26), BackgroundTransparency = 1}, right)

local pages, sideBtns, subBtns, cols = {}, {}, {}, {}
local curTab, curSub = TABS[1].name, TABS[1].subs[1]

local function show(tab, sub)
    curTab, curSub = tab, sub
    for k, pg in pairs(pages) do pg.Visible = (k == tab.."/"..sub) end
    for k, b in pairs(sideBtns) do
        local on = (k == tab)
        b.BackgroundColor3 = on and WHITE or ROW
        b.TextColor3 = on and BG or TXT
    end
    for k, b in pairs(subBtns) do
        local on = (k == tab.."/"..sub)
        b.BackgroundColor3 = on and WHITE or PANEL
        b.TextColor3 = on and BG or DIM
    end
    closePopups()
end

for si, t in ipairs(TABS) do
    local sb = mk("TextButton", {LayoutOrder = si, Size = UDim2.new(1,0,0,30),
        BackgroundColor3 = si == 1 and WHITE or ROW,
        TextColor3 = si == 1 and BG or TXT,
        Font = Enum.Font.GothamBold, TextSize = 12, Text = t.name, Corner = 6}, side)
    sideBtns[t.name] = sb
    for ji, sub in ipairs(t.subs) do
        local key = t.name.."/"..sub
        local pg = mk("Frame", {Size = UDim2.new(1,0,1,-30), Position = UDim2.new(0,0,0,30),
            BackgroundTransparency = 1, Visible = (si == 1 and ji == 1)}, right)
        local L = mk("ScrollingFrame", {Size = UDim2.new(0.5,-3,1,0), BackgroundTransparency = 1,
            ScrollBarThickness = 2, ScrollBarImageColor3 = WHITE,
            AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0)}, pg)
        local ll = Instance.new("UIListLayout") ll.Padding = UDim.new(0,5) ll.Parent = L
        local R = mk("ScrollingFrame", {Size = UDim2.new(0.5,-3,1,0), Position = UDim2.new(0.5,3,0,0),
            BackgroundTransparency = 1, ScrollBarThickness = 2, ScrollBarImageColor3 = WHITE,
            AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0)}, pg)
        local rl = Instance.new("UIListLayout") rl.Padding = UDim.new(0,5) rl.Parent = R
        pages[key] = pg cols[key.."|L"] = L cols[key.."|R"] = R
    end
    sb.MouseButton1Click:Connect(function()
        for _, b in pairs(subBtns) do b:Destroy() end
        subBtns = {}
        for ji, sub in ipairs(t.subs) do
            local key = t.name.."/"..sub
            local b = mk("TextButton", {Size = UDim2.new(0,100,1,0),
                Position = UDim2.new(0,(ji-1)*104,0,0),
                BackgroundColor3 = ji == 1 and WHITE or PANEL,
                TextColor3 = ji == 1 and BG or DIM,
                Font = Enum.Font.GothamBold, TextSize = 11, Text = sub, Corner = 5, Stroke = true}, subbar)
            subBtns[key] = b
            b.MouseButton1Click:Connect(function() show(t.name, sub) end)
        end
        show(t.name, t.subs[1])
    end)
end
do
    local t = TABS[1]
    for ji, sub in ipairs(t.subs) do
        local key = t.name.."/"..sub
        local b = mk("TextButton", {Size = UDim2.new(0,100,1,0),
            Position = UDim2.new(0,(ji-1)*104,0,0),
            BackgroundColor3 = ji == 1 and WHITE or PANEL,
            TextColor3 = ji == 1 and BG or DIM,
            Font = Enum.Font.GothamBold, TextSize = 11, Text = sub, Corner = 5, Stroke = true}, subbar)
        subBtns[key] = b
        b.MouseButton1Click:Connect(function() show(t.name, sub) end)
    end
end

-- ===== demo content: Rage/Main =====
do
    local L = cols["Rage/Main|L"]
    local g1 = group(L, "Main", 1)
    toggle(g1, "Enabled", "rage_on", false, 1)
    toggle(g1, "Orbit", "orbit", false, 2)
    slider(g1, "Orbit radius", "orbit_r", 9, 3, 25, function(v) return string.format("%d", math.floor(v)) end, 3)
    slider(g1, "Orbit speed", "orbit_s", 6, 1, 20, nil, 4)
    dropdown(g1, "Orbit target", "orbit_t", "Closest", {"Closest", "Lowest"}, 5)
    local g2 = group(L, "Spin", 2)
    toggle(g2, "Spinbot", "spin", false, 1)
    slider(g2, "Spin speed", "spin_s", 40, 1, 100, function(v) return string.format("%d", math.floor(v)) end, 2)
    local R = cols["Rage/Main|R"]
    local g3 = group(R, "Gun mods", 1)
    toggle(g3, "Rapid fire", "rapid", false, 1)
    slider(g3, "Rate", "rapid_r", 5, 1, 12, function(v) return string.format("%d", math.floor(v)) end, 2)
    toggle(g3, "No recoil", "norec", false, 3)
end

UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightShift then
        closePopups()
        main.Visible = not main.Visible
    end
end)

print("4080 UI v1 live")
