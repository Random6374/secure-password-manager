import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuickControls2 import QQuickStyle
from password_manager.controller import VaultController


def main():
    QQuickStyle.setStyle("Basic")  # Must happen before loading QML

    app = QGuiApplication(sys.argv)
    app.setApplicationName("Vault Password Manager")

    engine = QQmlApplicationEngine()
    controller=VaultController()
    engine.rootContext().setContextProperty("backend", controller)
    engine.load(Path(__file__).parent / "ui" / "Main.qml")

    if not engine.rootObjects():
        return 1

    return app.exec()


if __name__ == "__main__":
    raise SystemExit(main())