# Build/wznowienie builda Zen Browsera.
# UWAGA: budujemy przez krotka sciezke junction C:\Users\panad\z,
# bo dlugie sciezki Windows (~220+ znakow) lamą make/python przy linkowaniu.
# Uruchom:  powershell -ExecutionPolicy Bypass -File C:\Users\panad\Documents\egrator-dev\build-zen.ps1
$ErrorActionPreference = 'Continue'
$env:MOZILLABUILD = 'C:\mozilla-build'
$env:MACH_HIDE_DEV_DRIVE_SUGGESTION = '1'
$env:ACCEPTED_MAR_CHANNEL_IDS = 'unofficial'
$env:MAR_CHANNEL_ID = 'unofficial'
Set-Location C:\Users\panad\z\engine
Write-Host '=== Build Zen (objdir: engine\o, log: C:\Users\panad\Documents\egrator-dev\build.log) ==='
python3 .\mach build 2>&1 | Tee-Object -FilePath C:\Users\panad\Documents\egrator-dev\build.log
Write-Host "=== KONIEC BUILD, kod wyjscia: $LASTEXITCODE ==="
