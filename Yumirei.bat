@echo off
setlocal DisableDelayedExpansion
chcp 65001 >nul
title Yumirei - Launcher
cd /d "%~dp0"
echo ========================================
echo          YUMIREI - START
echo ========================================
if not exist "logs" mkdir "logs"
set "LOG=%CD%\logs\launcher.log"
echo [%date% %time%] Start >> "%LOG%"
where node >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Node.js not found. Install Node.js LTS: https://nodejs.org/
  echo Node.js missing >> "%LOG%"
  pause
  exit /b 1
)
where npm.cmd >nul 2>&1
if errorlevel 1 (
  echo [ERROR] npm not found.
  pause
  exit /b 1
)
if not exist "package.json" (
  echo [ERROR] package.json not found. Application has not been initialized.
  echo Missing package.json >> "%LOG%"
  pause
  exit /b 1
)
if not exist "node_modules" (
  echo Installing dependencies...
  call npm.cmd install --no-audit --no-fund >> "%LOG%" 2>&1
  if errorlevel 1 (
    echo [ERROR] Dependency installation failed. See logs\launcher.log
    pause
    exit /b 1
  )
)
echo Starting Yumirei...
call npm.cmd run dev
set "EXIT_CODE=%errorlevel%"
echo [%date% %time%] Exit code %EXIT_CODE% >> "%LOG%"
if not "%EXIT_CODE%"=="0" pause
exit /b %EXIT_CODE%
