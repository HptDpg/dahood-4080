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
return W
