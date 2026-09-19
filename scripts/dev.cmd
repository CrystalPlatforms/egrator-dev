@echo off
rem === dev.cmd : komendy EgraTor ===
rem   dev.cmd        -> uruchom przegladarke (Ctrl+C = stop)
rem   dev.cmd craft  -> szybki build (mach build faster: UI/zasoby)
rem   dev.cmd build  -> pelny dlugi build
setlocal
rem Poprawny Python (omija store'owy stub python3 z WindowsApps) + narzedzia:
set "PATH=C:\Users\panad\AppData\Local\Programs\Python\Python312;C:\Program Files\7-Zip;C:\mozilla-build\bin;%PATH%"
set "MOZILLABUILD=C:\mozilla-build"
set "MACH_HIDE_DEV_DRIVE_SUGGESTION=1"
set "ACCEPTED_MAR_CHANNEL_IDS=egrator"
set "MAR_CHANNEL_ID=egrator"
cd /d "%~dp0..\engine"

if /i "%~1"=="craft" goto craft
if /i "%~1"=="build" goto build
if /i "%~1"=="css" goto css

:run
echo [dev] Uruchamiam EgraTor (Ctrl+C = stop)...
python3 .\mach run --noprofile
goto end

:css
echo [css] Wgrywam integrator.css do dist (bez builda)...
copy /Y "%~dp0..\src\browser\themes\shared\egrator.css" "%~dp0..\engine\o\dist\bin\browser\chrome\browser\skin\classic\browser\egrator.css" >nul
echo [css] Gotowe! Zrestartuj przegladarke (npm run dev), zeby zobaczyc zmiany.
goto end

:craft
echo [craft] Szybki build (najpotrzebniejsze: UI/zasoby)...
python3 .\mach build faster
goto end

:build
echo [build] Pelny dlugi build...
python3 .\mach build
if errorlevel 1 (
  echo [build] Build nieudany.
  exit /b 1
)
:end
