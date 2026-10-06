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
        TextXAlignment = Enum.TextXAlignment.Left}, pg)
    b.MouseButton1Click:Connect(function() show(tab) end)
end

UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

print("Modora live")
