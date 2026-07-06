#!/usr/bin/env pwsh
# Agent Profile Pack — Windows installer
# Run as Administrator

$ErrorActionPreference = "Stop"
$AgentDir = "$env:USERPROFILE\.claude"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$BackupDir = "$AgentDir\backups\agent-profile-pack-$(Get-Date -Format 'yyyyMMdd_HHmmss')"

Write-Host "[agent-profile-pack] Installing on Windows..." -ForegroundColor Cyan

New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null

# 1. Memory layer
Write-Host "  [1/5] Installing memory layer..."
$ClaudeMd = Join-Path $AgentDir "CLAUDE.md"
if (Test-Path $ClaudeMd) { Copy-Item $ClaudeMd $BackupDir }
Copy-Item "$ScriptDir\memory-layer\CLAUDE.md" $AgentDir -Force
New-Item -ItemType Directory -Path "$AgentDir\rules" -Force | Out-Null
Copy-Item "$ScriptDir\memory-layer\rules\comet-phase-guard.md" "$AgentDir\rules\" -Force

# 2. Skills
Write-Host "  [2/5] Installing skills..."
New-Item -ItemType Directory -Path "$AgentDir\skills" -Force | Out-Null
Get-ChildItem "$ScriptDir\skills\*" -Directory | ForEach-Object {
  $name = $_.Name
  if ($name -in @("openspec","commands","reference","scripts")) { return }
  $dest = "$AgentDir\skills\$name"
  if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue }
  Copy-Item $_.FullName $dest -Recurse -Force -ErrorAction SilentlyContinue
  Write-Host "    skill: $name"
}

# Comet sub-skills
@("open","design","build","verify","archive","hotfix","tweak") | ForEach-Object {
  $src = "$ScriptDir\skills\comet-$_"
  if (Test-Path $src) {
    $dest = "$AgentDir\skills\comet-$_"
    Copy-Item $src $dest -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "    sub-skill: comet-$_"
  }
}

# OpenSpec skills
Get-ChildItem "$ScriptDir\skills\openspec-*" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
  $dest = "$AgentDir\skills\$($_.Name)"
  Copy-Item $_.FullName $dest -Recurse -Force -ErrorAction SilentlyContinue
  Write-Host "    openspec: $($_.Name)"
}

# Other top-level skills
@("brainstorming","dispatching-parallel-agents","docx","pptx","xlsx","pdf-converter","web-access","pua","teach","grill-me","neat-freak") | ForEach-Object {
  $src = "$ScriptDir\skills\$_"
  if (Test-Path $src) {
    $dest = "$AgentDir\skills\$_"
    Copy-Item $src $dest -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "    skill: $_"
  }
}

# 3. Plugins — enable in settings.json
Write-Host "  [3/5] Enabling plugins..."
$SettingsPath = Join-Path $AgentDir "settings.json"
$Settings = @{}
if (Test-Path $SettingsPath) {
  Copy-Item $SettingsPath $BackupDir
  try { $Settings = Get-Content $SettingsPath -Raw | ConvertFrom-Json -ErrorAction Stop } catch {}
}
if (-not $Settings.enabledPlugins) { $Settings | Add-Member -Type NoteProperty -Name "enabledPlugins" -Value @{} }
$Settings.enabledPlugins | Add-Member -Type NoteProperty -Name "caveman@caveman" -Value $true -Force
$Settings.enabledPlugins | Add-Member -Type NoteProperty -Name "planning-with-files@planning-with-files" -Value $true -Force
$Settings | ConvertTo-Json -Depth 10 | Set-Content $SettingsPath -Force
Write-Host "  plugins enabled: caveman, planning-with-files"

# 4. Comet hook guard (PowerShell stub)
Write-Host "  [4/5] Configuring hooks..."
$LocalSettingsPath = Join-Path $AgentDir "settings.local.json"
$LocalSettings = @{}
if (Test-Path $LocalSettingsPath) {
  try { $LocalSettings = Get-Content $LocalSettingsPath -Raw | ConvertFrom-Json -ErrorAction Stop } catch {}
}
if (-not $LocalSettings.hooks) { $LocalSettings | Add-Member -Type NoteProperty -Name "hooks" -Value @{} }
$HookCmd = "pwsh -NoProfile -File `"$AgentDir\skills\comet\scripts\comet-hook-guard.ps1`""
$LocalSettings.hooks | Add-Member -Type NoteProperty -Name "PreToolUse" -Value $HookCmd -Force
$LocalSettings | ConvertTo-Json -Depth 10 | Set-Content $LocalSettingsPath -Force
Write-Host "  hook configured: comet-hook-guard"

# 5. MCP
Write-Host "  [5/5] MCP config..."
Write-Host "  headroom, codegraph are env-provided. See mcp/README.md."

Write-Host "`n✓ Installation complete!" -ForegroundColor Green
Write-Host "  Backup: $BackupDir"
Write-Host ""
Write-Host "Capabilities enabled:"
Write-Host "  - Memory layer (CLAUDE.md + rules)"
Write-Host "  - Comet workflow (comet + 6 phases + 2 presets)"
Write-Host "  - OpenSpec change management (11 skills)"
Write-Host "  - AnySearch (cross-platform search)"
Write-Host "  - Plugins: caveman, planning-with-files"
Write-Host "  - Hook guard (phase enforcement)"
