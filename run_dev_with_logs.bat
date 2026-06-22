@echo off
setlocal EnableExtensions
cd /d "%~dp0"

if not exist "logs" mkdir "logs"

for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd-HHmmss"') do set "STAMP=%%I"
set "DEV_LOG=%CD%\logs\dev-%STAMP%.log"

set "UV_CACHE_DIR=%CD%\.uv-cache"
set "UV_PYTHON_INSTALL_DIR=%CD%\.uv-python"
set "QT_QUICK_CONTROLS_STYLE=Basic"
set "PYTHONFAULTHANDLER=1"
set "PYTHONUNBUFFERED=1"
set "QT_LOGGING_RULES=qt.qml.warning=true;qt.quick.warning=true;qt.scenegraph.general=true"

echo BebraLand Launcher dev run
echo Log: %DEV_LOG%
echo.

(
    echo ===== BebraLand Launcher dev run =====
    echo Time: %DATE% %TIME%
    echo CWD: %CD%
    echo UV_CACHE_DIR: %UV_CACHE_DIR%
    echo UV_PYTHON_INSTALL_DIR: %UV_PYTHON_INSTALL_DIR%
    echo QT_QUICK_CONTROLS_STYLE: %QT_QUICK_CONTROLS_STYLE%
    echo QT_QUICK_BACKEND: default (GPU)
    echo.
) > "%DEV_LOG%"

uv run --python 3.13 bebraland-launcher >> "%DEV_LOG%" 2>&1
set "EXIT_CODE=%ERRORLEVEL%"

type "%DEV_LOG%"

echo.
echo Exit code: %EXIT_CODE%
echo Exit code: %EXIT_CODE%>>"%DEV_LOG%"
echo Log saved: %DEV_LOG%
pause
exit /b %EXIT_CODE%
