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
    return o
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
    return pages
end

function LIB.Section(parent, title)
    local s = LIB.mk("Frame", {Size = UDim2.new(1,0,0,24), BackgroundTransparency = 1}, parent)
    LIB.mk("TextLabel", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
        Text = "— " .. title .. " —", TextColor3 = DIM, Font = Enum.Font.GothamBold,
        TextSize = 11}, s)
    return s
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
    return ref
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
    return ref
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
    return b
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
return LIB
