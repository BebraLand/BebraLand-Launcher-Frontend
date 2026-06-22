"""Bundle only the QML modules used by the launcher.

PyInstaller's stock PySide6 QtQml hook copies every QML module installed by
PySide6. That includes WebEngine, PDF, 3D, multimedia, and every Qt Quick
Controls style. The launcher imports QtQuick, QtQuick.Controls, and the
Skin3D viewer through QtWebEngine, and explicitly selects the lightweight
Basic style at startup.
"""

from pathlib import Path, PurePath

from PyInstaller.utils.hooks.qt import add_qt6_dependencies, pyside6_library_info


hiddenimports, binaries, datas = add_qt6_dependencies(__file__)

qml_root = Path(pyside6_library_info.location["QmlImportsPath"])
qml_dest_root = PurePath(pyside6_library_info.qt_rel_dir) / "qml"

# Keep this list synchronized with the imports discovered in resources/qml.
REQUIRED_QML_MODULES = (
    ("QtQml", False),
    ("QtQml/Models", True),
    ("QtQml/WorkerScript", True),
    ("QtQuick", False),
    ("QtQuick/Window", True),
    ("QtQuick/Templates", True),
    ("QtQuick/Controls", False),
    ("QtQuick/Controls/Basic", True),
    ("QtQuick/Controls/Basic/impl", True),
    ("QtQuick/Controls/impl", True),
    ("QtWebEngine", True),
)

for module, recursive in REQUIRED_QML_MODULES:
    source_dir = qml_root / module
    sources = source_dir.rglob("*") if recursive else source_dir.glob("*")
    for source in sources:
        if not source.is_file():
            continue
        destination = qml_dest_root / source.relative_to(qml_root).parent
        target = (str(source), str(destination))
        if source.suffix.lower() in {".dll", ".pyd"}:
            binaries.append(target)
        else:
            datas.append(target)
