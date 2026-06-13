# -*- mode: python ; coding: utf-8 -*-

from pathlib import Path


project_root = Path.cwd()
python_roots = sorted((project_root / ".uv-python").glob("cpython-3.13.*-windows-x86_64-none"))
if not python_roots:
    raise SystemExit("No uv-managed CPython 3.13 runtime found in .uv-python")
python_dlls = python_roots[-1] / "DLLs"
ssl_binaries = [
    (str(python_dlls / "_ssl.pyd"), "."),
    (str(python_dlls / "_hashlib.pyd"), "."),
    (str(python_dlls / "libssl-3-x64.dll"), "."),
    (str(python_dlls / "libcrypto-3-x64.dll"), "."),
]

a = Analysis(
    ['launcher_gui.py'],
    pathex=[],
    binaries=ssl_binaries,
    datas=[],
    hiddenimports=['ssl', '_ssl', '_hashlib'],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='BebraLandLauncher',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
