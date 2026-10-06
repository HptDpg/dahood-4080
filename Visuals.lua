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
    return o
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
    return e
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
return V
