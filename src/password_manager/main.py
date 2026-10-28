import sys
from pathlib import Path
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

def main():
    app = QGuiApplication(sys.argv)
    app.setApplicationName("Vault Password Manager")
    engine = QQmlApplicationEngine()
    engine.load(Path(__file__).parent / "ui" / "Main.qml")
    if not engine.rootObjects():
        return 1
    return app.exec()

if __name__ == "__main__":
    raise SystemExit(main())
