@echo off
setlocal enabledelayedexpansion
title Roxit Masterclass

set IMAGE=roxit-masterclass:0.3
set RELEASE_URL=https://github.com/likeahuman-ai/roxit-masterclass/releases/download/v0.3
set WORKDIR_HOST=%USERPROFILE%\roxit-workshop
set CLAUDE_VOLUME=roxit-claude-data
set ARCH=amd64
if /I "%PROCESSOR_ARCHITECTURE%"=="ARM64" set ARCH=arm64

echo.
echo   Roxit Masterclass - starting your sandbox...
echo.
echo   Eerste keer? Als Windows een SmartScreen-waarschuwing
echo   toonde: klik op "Meer info" en daarna op "Toch uitvoeren".
echo   Windows onthoudt de keuze; volgende keer geen waarschuwing.
echo.

where docker >nul 2>&1
if errorlevel 1 (
  echo   Docker Desktop is not installed.
  echo   Install it from https://www.docker.com/products/docker-desktop/
  start https://www.docker.com/products/docker-desktop/
  pause
  exit /b 1
)

docker info >nul 2>&1
if errorlevel 1 (
  echo   Starting Docker Desktop...
  start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
  for /l %%i in (1,1,40) do (
    timeout /t 2 /nobreak >nul
    docker info >nul 2>&1 && goto docker_ready
  )
  echo   Docker did not start in time. Open Docker Desktop, wait for "Engine running", then run Roxit again.
  pause
  exit /b 1
)
:docker_ready

docker image inspect %IMAGE% >nul 2>&1
if errorlevel 1 (
  echo   Image laden - eenmalige download ^(~420 MB^)...
  set "TARFILE=%TEMP%\roxit-%ARCH%.tar.gz"
  curl -fL --progress-bar "%RELEASE_URL%/roxit-masterclass-%ARCH%.tar.gz" -o "!TARFILE!"
  if errorlevel 1 (
    echo   Kon de Roxit-image niet downloaden. Check je internet en probeer opnieuw.
    pause
    exit /b 1
  )
  echo   Image laden in Docker...
  docker load -i "!TARFILE!"
  del "!TARFILE!"
)

if not exist "%WORKDIR_HOST%" mkdir "%WORKDIR_HOST%"
docker volume create %CLAUDE_VOLUME% >nul

docker run -it --rm ^
  -v "%WORKDIR_HOST%:/workspace" ^
  -v "%CLAUDE_VOLUME%:/home/dev/.claude" ^
  -e "ROXIT_HOST_WORKSHOP=%WORKDIR_HOST%" ^
  -e "ROXIT_HOST_OS=Windows" ^
  -p 3000:3000 ^
  -p 3001:3001 ^
  -p 8080:8080 ^
  %IMAGE%
