$ErrorActionPreference = "Stop"
Set-Location "C:\Users\heiss\Desktop\bbladeball"
$order = @('Config.lua','Utils.lua','UILib.lua','Aimbot.lua','Trigger.lua','Silent.lua','Rage.lua','Visuals.lua','World.lua','Movement.lua','Cfg.lua','UI.lua','Init.lua')
$lines = New-Object System.Collections.Generic.List[string]
$lines.Add('-- 4080 DaHood Hub v4.0.8.0 | SINGLE FILE BUILD')
$lines.Add('-- paste this whole file into your executor. no readfile needed.')
foreach ($f in $order) {
  $lines.Add('')
  $lines.Add('-- ==================== ' + $f + ' ====================')
  $lines.Add([IO.File]::ReadAllText((Join-Path (Get-Location) $f)))
}
$lines.Add('')
[IO.File]::WriteAllLines((Join-Path (Get-Location) 'DH4080.lua'), $lines)
$li = (Get-Content './DH4080.lua' | Measure-Object -Line).Lines
$sz = (Get-Item './DH4080.lua').Length
Write-Output "LINES=$li BYTES=$sz"
