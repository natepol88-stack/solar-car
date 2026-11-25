# setup_fluent_mcp.ps1
# Installs Ansys's official PyFluent MCP server (ansys-fluent-mcp) and registers it
# with the Claude desktop app, same way the SolidWorks connector was set up.
# Run in PowerShell:  powershell -ExecutionPolicy Bypass -File .\setup_fluent_mcp.ps1
$ErrorActionPreference = "Stop"

Write-Host "`n== 1. Find the Ansys install ==" -ForegroundColor Cyan
$awp = Get-ChildItem Env: | Where-Object { $_.Name -match '^AWP_ROOT\d+$' } |
       Sort-Object Name -Descending | Select-Object -First 1
if (-not $awp) { throw "No AWP_ROOTxxx environment variable found. Install Ansys (Student is fine) first, then rerun." }
Write-Host "Using $($awp.Name) = $($awp.Value)"
$fluentExe = Join-Path $awp.Value "fluent\ntbin\win64\fluent.exe"
if (Test-Path $fluentExe) { Write-Host "Found $fluentExe" } else { Write-Warning "fluent.exe not at $fluentExe (Fluent may not be installed in this Ansys version)" }

Write-Host "`n== 2. Find Python 3.12+ ==" -ForegroundColor Cyan
$pyExe = $null
foreach ($v in "3.13","3.12","3.14") {
  try { $p = & py "-$v" -c "import sys;print(sys.executable)" 2>$null
        if ($LASTEXITCODE -eq 0 -and $p) { $pyExe = $p.Trim(); break } } catch {}
}
if (-not $pyExe) {
  Write-Host "No Python 3.12+ found. Installing Python 3.12 with winget..."
  winget install -e --id Python.Python.3.12 --accept-package-agreements --accept-source-agreements
  $pyExe = (& py -3.12 -c "import sys;print(sys.executable)").Trim()
}
Write-Host "Python: $pyExe"

Write-Host "`n== 3. Create venv and install ansys-fluent-mcp ==" -ForegroundColor Cyan
$venv = Join-Path $env:USERPROFILE ".fluent-mcp-venv"
if (-not (Test-Path $venv)) { & $pyExe -m venv $venv }
$vpy = Join-Path $venv "Scripts\python.exe"
& $vpy -m pip install --upgrade pip
& $vpy -m pip install --upgrade "ansys-fluent-mcp[file-probe]"
$mcpExe = Join-Path $venv "Scripts\ansys-fluent-mcp.exe"
if (-not (Test-Path $mcpExe)) { throw "ansys-fluent-mcp.exe not found after install: $mcpExe" }
& $vpy -c "import ansys.fluent.core as pf; print('PyFluent', pf.__version__)"

Write-Host "`n== 4. Register with the Claude desktop app ==" -ForegroundColor Cyan
# Use whichever Claude config already holds the working SolidWorks server.
$candidates = @("$env:APPDATA\Claude\claude_desktop_config.json")
$candidates += Get-ChildItem "$env:LOCALAPPDATA\Packages" -Directory -Filter "Claude*" -ErrorAction SilentlyContinue |
  ForEach-Object { Join-Path $_.FullName "LocalCache\Roaming\Claude\claude_desktop_config.json" }
$cfgPath = $candidates | Where-Object { (Test-Path $_) -and ((Get-Content $_ -Raw) -match 'solidworks') } | Select-Object -First 1
if (-not $cfgPath) { $cfgPath = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1 }
if (-not $cfgPath) { throw "Couldn't find claude_desktop_config.json" }
Write-Host "Config: $cfgPath"
Copy-Item $cfgPath "$cfgPath.bak-$(Get-Date -Format yyyyMMdd-HHmmss)"

$cfg = Get-Content $cfgPath -Raw | ConvertFrom-Json
if (-not $cfg.PSObject.Properties['mcpServers']) { $cfg | Add-Member -NotePropertyName mcpServers -NotePropertyValue ([pscustomobject]@{}) }
$envObj = [pscustomobject]@{}
$envObj | Add-Member -NotePropertyName $awp.Name -NotePropertyValue $awp.Value
$entry = [pscustomobject]@{ command = $mcpExe; env = $envObj }
$cfg.mcpServers | Add-Member -NotePropertyName "ansys-fluent" -NotePropertyValue $entry -Force
$json = $cfg | ConvertTo-Json -Depth 30
[IO.File]::WriteAllText($cfgPath, $json, (New-Object Text.UTF8Encoding $false))   # no BOM

Write-Host "`nDone. Fully quit Claude (right-click tray icon > Quit) and reopen it." -ForegroundColor Green
Write-Host "Then tell Claude 'Fluent MCP installed' and it will check the connection."
