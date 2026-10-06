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
        return t
    end
    return v
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
        return t
    end
    return v
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
    return o
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
            return o
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
    return ok
end

function G.Load(name)
    local ok = pcall(function()
        local raw = readfile(G.Path(name))
        local data = decodeCfg(HS:JSONDecode(raw))
        merge(BB.Config, data)
    end)
    return ok
end

BB.Cfg = G
return G
