from PySide6.QtCore import QObject, Slot

class VaultController(QObject):
    @Slot()
    def testConnection(self):
        print("QML successfully called Python!")