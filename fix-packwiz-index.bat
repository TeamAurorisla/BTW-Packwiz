@echo off
setlocal

set "PACKWIZ_DIR=%~1"
if not defined PACKWIZ_DIR set "PACKWIZ_DIR=%~dp0"

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference = 'Stop';" ^
  "$dir = [System.IO.Path]::GetFullPath($env:PACKWIZ_DIR);" ^
  "if (-not [System.IO.Directory]::Exists($dir)) { throw ('Packwiz directory not found: ' + $dir) };" ^
  "$utf8 = New-Object System.Text.UTF8Encoding($false);" ^
  "$files = @(Get-ChildItem -LiteralPath $dir -Recurse -File -Filter '*.pw.toml');" ^
  "$changed = 0;" ^
  "foreach ($file in $files) {" ^
  "  $text = [System.IO.File]::ReadAllText($file.FullName);" ^
  "  $fixed = [regex]::Replace($text, '(?m)^(\s*side\s*=\s*)(?:''server''|''''|\"server\"|\"\")(\s*)$', '$1''both''$2');" ^
  "  if ($fixed -match '(?m)^\s*\[update\.curseforge\]\s*$') {" ^
  "    $fixed = [regex]::Replace($fixed, '(?m)^\s*url\s*=.*(?:\r?\n|$)', '');" ^
  "  }" ^
  "  if ($fixed -cne $text) {" ^
  "    [System.IO.File]::WriteAllText($file.FullName, $fixed, $utf8);" ^
  "    $changed++;" ^
  "    Write-Host ('Fixed: ' + $file.FullName.Substring($dir.Length).TrimStart('\'));" ^
  "  }" ^
  "}" ^
  "Write-Host ('Done. Scanned {0} file(s), changed {1}.' -f $files.Count, $changed);"

if errorlevel 1 (
  echo Failed to fix Packwiz metadata files.
  pause
  exit /b 1
)

pause
exit /b 0
