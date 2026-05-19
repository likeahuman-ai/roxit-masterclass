@echo off
setlocal enabledelayedexpansion
title Roxit Masterclass
set "SCRIPT_DIR=%~dp0"

REM ─────────────────────────────────────────────────────────────────────────
REM  Configuration
REM ─────────────────────────────────────────────────────────────────────────
REM Self-updating launcher: ask GitHub for the current "latest" release
REM (maintained automatically by `gh release create --latest`) so an OLD
REM launcher file still pulls the NEWEST image. Offline / unreachable ->
REM fall back to FALLBACK_VERSION so the workshop still runs.
set "RELEASES_BASE=https://github.com/likeahuman-ai/roxit-releases/releases"
set "LATEST_API=https://api.github.com/repos/likeahuman-ai/roxit-releases/releases/latest"
set "FALLBACK_VERSION=v0.5"
set "WORKDIR_HOST=%USERPROFILE%\Desktop\roxit-workshop"
set "CLAUDE_VOLUME=roxit-claude-data"
set ARCH=amd64
if /I "%PROCESSOR_ARCHITECTURE%"=="ARM64" set ARCH=arm64

REM Resolve active version: explicit override wins; else parse tag_name from
REM the GitHub API JSON; else fall back to the baked-in baseline.
set "VERSION="
if defined ROXIT_VERSION set "VERSION=%ROXIT_VERSION%"
if not defined VERSION (
  for /F "usebackq tokens=2 delims=:, " %%T in (`curl -fsSL --max-time 5 "%LATEST_API%" 2^>nul ^| findstr /C:"\"tag_name\""`) do (
    if not defined VERSION set "VERSION=%%~T"
  )
)
if not defined VERSION set "VERSION=%FALLBACK_VERSION%"
echo %VERSION% | findstr /I /R "^v[0-9]" >nul 2>&1 || set "VERSION=%FALLBACK_VERSION%"

set "VTAG=%VERSION:v=%"
set "RELEASE_URL=%RELEASES_BASE%/download/%VERSION%"
if defined ROXIT_RELEASE_URL set "RELEASE_URL=%ROXIT_RELEASE_URL%"
set "IMAGE=roxit-masterclass:%VTAG%-%ARCH%"
if defined ROXIT_IMAGE set "IMAGE=%ROXIT_IMAGE%"

REM ─────────────────────────────────────────────────────────────────────────
REM  Visuals — ANSI escape (Windows 10+)
REM ─────────────────────────────────────────────────────────────────────────
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
REM Roxit brand · forest #143f26 · accent #21683E · lime #26ad6a
set "R=%ESC%[0m"
set "B=%ESC%[1m"
set "D=%ESC%[2m"
set "FR=%ESC%[38;5;22m"
set "AC=%ESC%[38;5;35m"
set "LM=%ESC%[38;5;41m"
set "YE=%ESC%[38;5;220m"
set "RD=%ESC%[38;5;203m"
set "GY=%ESC%[38;5;245m"
set "CR=%ESC%[38;5;230m"

echo.
echo   %FR%+-----------------------------------------------+%R%
echo   %FR%^|%R%  %B%%AC%ROXIT MASTERCLASS%R%                            %FR%^|%R%
echo   %FR%^|%R%  %D%One-click Claude Code sandbox%R%                %FR%^|%R%
echo   %FR%^|%R%                                               %FR%^|%R%
echo   %FR%^|%R%  %LM%Like a Human - Amsterdam%R%                     %FR%^|%R%
echo   %FR%+-----------------------------------------------+%R%
echo.

REM ─────────────────────────────────────────────────────────────────────────
REM  1. Docker present?
REM ─────────────────────────────────────────────────────────────────────────
where docker >nul 2>&1
if errorlevel 1 (
  echo   %RD%X%R%  Docker not installed
  echo      %GY%Install: https://www.docker.com/products/docker-desktop/%R%
  start https://www.docker.com/products/docker-desktop/
  pause
  exit /b 1
)
for /F "tokens=*" %%v in ('docker --version 2^>nul') do set "DOCKER_VER=%%v"
echo   %LM%v%R%  Docker installed              %D%!DOCKER_VER!%R%

REM ─────────────────────────────────────────────────────────────────────────
REM  2. Docker daemon running?
REM ─────────────────────────────────────────────────────────────────────────
docker info >nul 2>&1
if errorlevel 1 (
  echo   %AC%o%R%  Starting Docker Desktop      %D%first launch ~30s%R%
  start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
  for /l %%i in (1,1,40) do (
    timeout /t 2 /nobreak >nul
    docker info >nul 2>&1 && goto docker_ready
  )
  echo   %RD%X%R%  Docker did not start in time
  echo      %GY%Open Docker Desktop, wait for "Engine running", retry.%R%
  pause
  exit /b 1
)
:docker_ready
echo   %LM%v%R%  Docker daemon                 %D%engine running%R%

REM ─────────────────────────────────────────────────────────────────────────
REM  3. Image present?
REM ─────────────────────────────────────────────────────────────────────────
REM Try resolved version, then FALLBACK_VERSION, so a half-published release
REM (latest marker flipped before tarballs uploaded) can't brick the room.
set "TARFILE=%TEMP%\roxit-%ARCH%.tar.gz"
call :fetch_and_load "%VERSION%"
if errorlevel 1 (
  if /I not "%VERSION%"=="%FALLBACK_VERSION%" (
    echo   %YE%!%R%  Latest unavailable            %D%falling back to %FALLBACK_VERSION%%R%
    call :fetch_and_load "%FALLBACK_VERSION%"
    if errorlevel 1 (
      echo   %RD%X%R%  Download failed              %D%check network and retry%R%
      pause
      exit /b 1
    )
  ) else (
    echo   %RD%X%R%  Download failed              %D%check network and retry%R%
    pause
    exit /b 1
  )
)

REM ─────────────────────────────────────────────────────────────────────────
REM  4. Workspace + Claude token volume
REM ─────────────────────────────────────────────────────────────────────────
if not exist "%WORKDIR_HOST%" mkdir "%WORKDIR_HOST%"
docker volume create %CLAUDE_VOLUME% >nul

REM Seed workspace from bundled starter\ on first run (host-side).
REM The image entrypoint has a fallback if this is skipped.
set "WS_EMPTY=1"
for /F %%f in ('dir /b "%WORKDIR_HOST%" 2^>nul') do set "WS_EMPTY=0"
if "!WS_EMPTY!"=="1" (
  if exist "%SCRIPT_DIR%starter\" (
    xcopy /s /e /h /q /y "%SCRIPT_DIR%starter\*" "%WORKDIR_HOST%\" >nul 2>&1
    echo   %LM%v%R%  Workspace seeded              %D%%WORKDIR_HOST%%R%
  ) else (
    echo   %LM%v%R%  Workspace                     %D%%WORKDIR_HOST%%R%
  )
) else (
  echo   %LM%v%R%  Workspace                     %D%%WORKDIR_HOST%%R%
)

REM ─────────────────────────────────────────────────────────────────────────
REM  5. Dynamic port allocation
REM ─────────────────────────────────────────────────────────────────────────
set "PORT_FLAGS="
set "PORT_DISPLAY="
set "PORT_REMAPPED=0"
set "ALLOCATED_HOST_PORTS= "

call :allocate_port 3000
call :allocate_port 3001
call :allocate_port 8080

if "!PORT_REMAPPED!"=="1" (
  echo   %YE%!%R%  Ports                         %D%!PORT_DISPLAY!%R%
  echo      %GY%Some ports were busy; reach container on yellow numbers.%R%
) else (
  echo   %LM%v%R%  Ports                         %D%!PORT_DISPLAY!%R%
)

echo.
echo   %D%-----------------------------------------------%R%
echo.
echo   %B%Launching sandbox...%R%   %D%^(Ctrl+D to exit^)%R%
echo.

REM Clean up stale container from a previous force-killed session.
docker rm -f roxit-masterclass >nul 2>&1

docker run -it --rm ^
  -v "%WORKDIR_HOST%:/workspace" ^
  -v "%CLAUDE_VOLUME%:/home/dev/.claude" ^
  -e "ROXIT_HOST_WORKSHOP=%WORKDIR_HOST%" ^
  -e "ROXIT_HOST_OS=Windows" ^
  !PORT_FLAGS! ^
  --name "roxit-masterclass" ^
  %IMAGE%
exit /b %errorlevel%

REM ─────────────────────────────────────────────────────────────────────────
REM  Subroutine: fetch_and_load <version-tag>
REM    Uses cached image if present, else downloads that version's tarball
REM    and loads it. Returns errorlevel 1 if the download fails.
REM ─────────────────────────────────────────────────────────────────────────
:fetch_and_load
set "FAL_VER=%~1"
set "FAL_VTAG=%FAL_VER:v=%"
set "FAL_IMAGE=roxit-masterclass:%FAL_VTAG%-%ARCH%"
if defined ROXIT_IMAGE set "FAL_IMAGE=%ROXIT_IMAGE%"
docker image inspect "%FAL_IMAGE%" >nul 2>&1
if not errorlevel 1 (
  set "IMAGE=%FAL_IMAGE%"
  echo   %LM%v%R%  Sandbox image                 %D%%FAL_IMAGE% ^(cached^)%R%
  exit /b 0
)
set "FAL_URL=%RELEASES_BASE%/download/%FAL_VER%"
if defined ROXIT_RELEASE_URL set "FAL_URL=%ROXIT_RELEASE_URL%"
echo   %AC%o%R%  Downloading sandbox image    %D%%FAL_VER% - ~420 MB - one time only%R%
curl -fL --progress-bar "%FAL_URL%/roxit-masterclass-%ARCH%.tar.gz" -o "%TARFILE%"
if errorlevel 1 exit /b 1
echo   %AC%o%R%  Loading image into Docker
docker load -i "%TARFILE%" >nul
del "%TARFILE%" >nul 2>&1
set "IMAGE=%FAL_IMAGE%"
echo   %LM%v%R%  Sandbox image                 %D%%FAL_IMAGE% ^(loaded^)%R%
exit /b 0

REM ─────────────────────────────────────────────────────────────────────────
REM  Subroutine: allocate_port <desired>
REM    Finds first free port in [desired, desired+100], appends -p flag,
REM    builds display string. Sets PORT_REMAPPED=1 if anything got moved.
REM ─────────────────────────────────────────────────────────────────────────
:allocate_port
set "DESIRED=%~1"
set "CANDIDATE=%DESIRED%"
set /a "MAX=DESIRED+100"
:port_loop
echo !ALLOCATED_HOST_PORTS! | findstr " !CANDIDATE! " >nul 2>&1
if not errorlevel 1 (
  set /a "CANDIDATE+=1"
  if !CANDIDATE! GEQ !MAX! goto port_none
  goto port_loop
)
netstat -ano | findstr /R /C:":!CANDIDATE! .*LISTENING" >nul 2>&1
if errorlevel 1 goto port_free
set /a "CANDIDATE+=1"
if !CANDIDATE! GEQ !MAX! goto port_none
goto port_loop
:port_free
set "ALLOCATED_HOST_PORTS=!ALLOCATED_HOST_PORTS!!CANDIDATE! "
set "PORT_FLAGS=!PORT_FLAGS! -p !CANDIDATE!:!DESIRED!"
if "!CANDIDATE!"=="!DESIRED!" (
  set "PORT_DISPLAY=!PORT_DISPLAY!!LM!!DESIRED!!R!!D!->!DESIRED!!R! "
) else (
  set "PORT_DISPLAY=!PORT_DISPLAY!!YE!!CANDIDATE!!R!!D!->!DESIRED!!R! "
  set "PORT_REMAPPED=1"
)
exit /b 0
:port_none
echo   %YE%!%R%  No free port near !DESIRED!     %D%not exposed%R%
exit /b 0
