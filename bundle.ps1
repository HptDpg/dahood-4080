$ErrorActionPreference = "Stop"
Set-Location "C:\Users\heiss\Desktop\bbladeball"
$order = @('Config.lua','Utils.lua','UILib.lua','Aimbot.lua','Trigger.lua','Silent.lua','Rage.lua','Visuals.lua','World.lua','Movement.lua','Cfg.lua','UI.lua','Init.lua')
$lines = New-Object System.Collections.Generic.List[string]
$lines.Add('-- 4080 DaHood Hub v4.0.8.0 | SINGLE FILE BUILD')
$lines.Add('-- paste this whole file into your executor. no readfile needed.')
$lines.Add('getgenv().DH4080 = getgenv().DH4080 or {}')
foreach ($f in $order) {
  $lines.Add('')
  $lines.Add('-- ==================== ' + $f + ' ====================')
  $lines.Add('do')
  $src = [IO.File]::ReadAllText((Join-Path (Get-Location) $f))
  # strip module return lines (bare returns kill concatenated chunks)
  $filtered = $src -split "`r?`n" | Where-Object { $_ -notmatch '^\s*return\s+\w+\s*$' }
  foreach ($l in $filtered) { $lines.Add($l) }
  $lines.Add('end')
}
$lines.Add('')
[IO.File]::WriteAllLines((Join-Path (Get-Location) 'DH4080.lua'), $lines)
$li = (Get-Content './DH4080.lua' | Measure-Object -Line).Lines
Write-Output "LINES=$li"
