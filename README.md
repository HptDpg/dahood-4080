# 4080 DAHOOD HUB — v4.0.8.0

Black & white HVH + legit hub for Da Hood. 7 tabs, ⋯ dots customization on
every major feature, zero external UI deps (custom monochrome kit + Drawing).

## FILES (~2,600 lines)

| File | What |
|---|---|
| `Loader.lua` | executor entry — run this |
| `Config.lua` | every setting, live-read |
| `Utils.lua` | DaHood checks (K.O / grabbing / crew / forcefield), targeting, prediction |
| `UILib.lua` | monochrome UI kit: Toggle+⋯, Slider, Dropdown, Color, Keybind |
| `Aimbot.lua` | legit aim: Camera/Mouse modes, prediction, smoothness, sticky, 2nd stage, shake |
| `Trigger.lua` | triggerbot: delay + consecutive delay, press-next-key rebind, hold/toggle |
| `Silent.lua` | silent aim: Raycast + Index hooks, hitchance, FOV |
| `Rage.lua` | orbit, spinbot, jitter, AA, rapid fire, no recoil, autostomp/reload, speedshot |
| `Visuals.lua` | box Full/Cornered + fill, health Bar/Number/Both, name, dist, skeleton, chams, tracer, headdot, offscreen |
| `World.lua` | skyboxes, fog, ambience, fullbright, gun chams, tracers, hit FX/sound |
| `Movement.lua` | speed 3 modes, fly, noclip, bhop, inf jump, click TP, no slow/fall, stamina |
| `Cfg.lua` | JSON save/load configs |
| `UI.lua` | 7-tab black&white window, FOV rings, status strip |
| `Init.lua` | boot + loops + panic key |

## INSTALL

```lua
loadstring(readfile("C:\\Users\\heiss\\Desktop\\bbladeball\\Loader.lua"))()
```

Needs `readfile/writefile`, Drawing API, `mousemoverel` (mouse-mode aim only),
`hookmetamethod` (silent aim only — everything else works without it).

## THE ⋯ DOTS SYSTEM

Every big toggle has a `⋯` button → popup panel:
- **Box ⋯** → Style dropdown (Full / Cornered), Fill on/off, Fill color +
  transparency, Outline, Team color, Thickness, Box color.
- **Health ⋯** → Style (Bar / Number / Both), Bar position (Left/Right), colors.
- **Name ⋯** → distance/tool suffixes, size, color. Same pattern for
  Distance / Skeleton / Chams / Tracer / HeadDot / Offscreen.
- **Orbit ⋯** → target mode, radius/height/speed sliders, randomize.
- **Trigger key** → button shows `[T]`; click it, press ANY key/mouse button,
  that becomes the activator. Delay = before 1st shot, Consecutive = after 1st.
- **Aim key** → same press-next-key button, defaults to MouseButton2 (RMB).

## TABS

- **RAGE** — master switch, orbit (radius/height/speed/jitter), spinbot,
  jitter, anti-aim (pitch/yaw), rapid fire, no recoil, fake lag, speed shot,
  auto stomp/reload.
- **LEGIT** — aimbot (mode/part/target-mode/FOV/smooth/pull/prediction/
  heartbeat/hitchance/reaction/offsets/shake/sticky/2nd-stage/checks) + silent.
- **TRIGGER** — key, toggle-vs-hold, delay, consecutive delay, part, FOV ring,
  hitchance, max dist, move-blocker, armed status readout.
- **VISUALS** — ESP master, box, health, name, distance, skeleton, chams,
  tracer, head dot, offscreen arrows, filters (crew / knocked-only).
- **WORLD** — sky (Night/Sunset/Nebula/Anime/Custom), fog + no-fog, ambience
  + fullbright + no-shadows + force day/night, gun chams, bullet tracers,
  hit effect + sound.
- **MOVE** — speed (WalkSpeed/Velocity/CFrame), fly (F), noclip (N), bhop,
  infinite jump, click TP (B), no slow/fall, infinite stamina.
- **CFG** — menu toggle key, panic key (END: kills ESP+rage+aim+UI instantly),
  anti-AFK, FPS cap, save/load JSON configs, unload.

## CUSTOMIZATION EXAMPLES

- Box: enable → ⋯ → Style=Cornered, Fill=ON white 0.75 → cornered boxes
  with see-through fill, exactly like the mockup asked.
- Trigger legit: Delay 90ms + Consecutive 180ms + hitchance 100 + FOV 10.
- Trigger ragey: Delay 0 + Consecutive 40 + Target Any + FOV 30.
- Aimbot clip-proof: Camera mode, smooth 14, shake 4/4, second-stage ON.
- Aimbot sticky HVH: Mouse mode, pull 18, sticky ON 0.8, prediction 0.14.

## GITHUB

Push:
```powershell
cd C:\Users\heiss\Desktop\bbladeball
git init; git add -A; git commit -m "4080 dahood v4.0.8.0"
gh repo create dahood-4080 --public --source=. --push
```
No `gh`? Create repo on github.com, then:
```powershell
git remote add origin https://github.com/YOU/dahood-4080.git
git branch -M main; git push -u origin main
```

Teeth sharp, stash open. I can make anything — you just need the right teeth for it.
