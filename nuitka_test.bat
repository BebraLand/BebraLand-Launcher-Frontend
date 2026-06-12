@echo off
setlocal

cd /d "%~dp0"

set "UV_CACHE_DIR=%CD%\.uv-cache"
set "UV_PYTHON_INSTALL_DIR=%CD%\.uv-python"
set "NUITKA_CACHE_DIR=%CD%\.nuitka-cache"

where uv >nul 2>nul
if errorlevel 1 (
    echo ERROR: uv not found in PATH.
    echo Install uv first: https://docs.astral.sh/uv/getting-started/installation/
    exit /b 1
)

echo Sync build dependencies...
uv sync --extra build
if errorlevel 1 exit /b %ERRORLEVEL%

echo Build BebraLandLauncher.exe...
uv run python -m nuitka ^
    --onefile ^
    --assume-yes-for-downloads ^
    --enable-plugin=pyside6 ^
    --windows-console-mode=disable ^
    --output-filename=BebraLandLauncher.exe ^
    launcher_gui.py

if errorlevel 1 exit /b %ERRORLEVEL%

echo.
echo Done
