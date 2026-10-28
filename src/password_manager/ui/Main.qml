import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: win
    visible: true
    width: 1380
    height: 850
    minimumWidth: 1000
    minimumHeight: 650
    title: "Vault — Password Manager"
    color: "#0e141b"

    property color ink: "#edf3fb"
    property color muted: "#96a8bc"
    property color panel: "#151f2a"
    property color panel2: "#1b2937"
    property color line: "#293a4b"
    property color blue: "#3984ff"
    property int selected: 0
    property string page: "All Entries"
    property bool reveal: false
    property int editIndex: -1

    ListModel {
        id: vaultEntries
        ListElement { site: "Google"; username: "user@gmail.com"; password: "GooglePassword123$"; website: "https://accounts.google.com"; notes: "Personal Google account."; favorite: true; category: "Personal" }
        ListElement { site: "GitHub"; username: "random6374"; password: "GithubPassword123$"; website: "https://github.com"; notes: "Code hosting account."; favorite: false; category: "Development" }
        ListElement { site: "Discord"; username: "user123"; password: "DiscordPassword123$"; website: "https://discord.com"; notes: "Community account."; favorite: false; category: "Personal" }
        ListElement { site: "Spotify"; username: "user@gmail.com"; password: "SpotifyPassword123$"; website: "https://spotify.com"; notes: "Music account."; favorite: false; category: "Personal" }
        ListElement { site: "Reddit"; username: "user123"; password: "RedditPassword123$"; website: "https://reddit.com"; notes: "Forums and communities."; favorite: false; category: "Personal" }
        ListElement { site: "Netflix"; username: "user@gmail.com"; password: "NetflixPassword123$"; website: "https://netflix.com"; notes: "Streaming account."; favorite: false; category: "Entertainment" }
    }

    function visibleIndices() {
        let out = []
        let q = search.text.toLowerCase().trim()
        for (let i = 0; i < vaultEntries.count; i++) {
            let e = vaultEntries.get(i)
            let match = q === "" || e.site.toLowerCase().includes(q) ||
                        e.username.toLowerCase().includes(q) || e.website.toLowerCase().includes(q)
            if (match && (page !== "Favorites" || e.favorite)) out.push(i)
        }
        return out
    }
    function symbolFor(s) { return s.length ? s[0].toUpperCase() : "?" }
    function demoPassword(n) {
        let chars = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789@#$"
        let result = ""
        for (let i = 0; i < n; i++) result += chars[Math.floor(Math.random() * chars.length)]
        return result
    }
    function startEntryDialog(edit) {
        editIndex = edit ? selected : -1
        if (edit && selected >= 0 && selected < vaultEntries.count) {
            let e = vaultEntries.get(selected)
            siteField.text = e.site; usernameField.text = e.username
            passwordField.text = e.password; urlField.text = e.website; notesField.text = e.notes
        } else {
            siteField.text = ""; usernameField.text = ""; passwordField.text = ""
            urlField.text = ""; notesField.text = ""
        }
        entryDialog.open()
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: 238
            Layout.fillHeight: true
            color: "#111922"
            border.color: "#1f2d3a"
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 17
                spacing: 12
                RowLayout {
                    Layout.topMargin: 16
                    Layout.bottomMargin: 28
                    spacing: 12
                    Rectangle {
                        width: 44; height: 44; radius: 13; color: "#203e62"
                        Text { anchors.centerIn: parent; text: "◆"; color: "#91c1ff"; font.pixelSize: 24 }
                    }
                    ColumnLayout {
                        spacing: 2
                        Text { text: "Vault"; color: ink; font.pixelSize: 22; font.bold: true }
                        Text { text: "Password Manager"; color: muted; font.pixelSize: 12 }
                    }
                }
                Repeater {
                    model: [{name:"All Entries", glyph:"▦"}, {name:"Favorites", glyph:"★"}, {name:"Generator", glyph:"✣"}, {name:"Settings", glyph:"⚙"}]
                    delegate: Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        height: 50; radius: 11
                        color: page === modelData.name ? "#203e62" : "transparent"
                        RowLayout {
                            anchors.fill: parent; anchors.leftMargin: 14; spacing: 14
                            Text { text: modelData.glyph; color: page === modelData.name ? "#83b8ff" : muted; font.pixelSize: 21 }
                            Text { text: modelData.name; color: ink; font.pixelSize: 14 }
                        }
                        TapHandler {
                            onTapped: {
                                page = modelData.name
                                if (page === "Generator") generatorDialog.open()
                                if (page === "Settings") settingsDialog.open()
                            }
                        }
                    }
                }
                Item { Layout.fillHeight: true }
                Rectangle {
                    Layout.fillWidth: true; height: 52; radius: 11
                    color: panel2; border.color: line
                    RowLayout {
                        anchors.fill: parent; anchors.leftMargin: 14; spacing: 12
                        Text { text: "▣"; color: "#a9c7f4"; font.pixelSize: 20 }
                        Text { text: "Lock Vault"; color: ink; font.pixelSize: 14 }
                    }
                    TapHandler { onTapped: lockDialog.open() }
                }
                Text { Layout.fillWidth: true; Layout.topMargin: 8; text: "LOCAL • OFFLINE VAULT"; color: "#64788d"; font.pixelSize: 10; horizontalAlignment: Text.AlignHCenter }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 25
            spacing: 20

            RowLayout {
                Layout.fillWidth: true
                Rectangle {
                    Layout.fillWidth: true; height: 52; radius: 12
                    color: panel; border.color: line
                    RowLayout {
                        anchors.fill: parent; anchors.leftMargin: 15; anchors.rightMargin: 12; spacing: 10
                        Text { text: "⌕"; color: muted; font.pixelSize: 28 }
                        TextField {
                            id: search
                            Layout.fillWidth: true
                            placeholderText: "Search entries..."
                            color: ink; placeholderTextColor: "#71859b"
                            background: Item {}
                            onTextChanged: entriesView.model = visibleIndices()
                        }
                    }
                }
                Button {
                    text: "＋  Add Entry"; Layout.preferredWidth: 150; Layout.preferredHeight: 52
                    onClicked: startEntryDialog(false)
                    background: Rectangle { radius: 11; color: parent.down ? "#246bd6" : blue }
                    contentItem: Text { text: parent.text; color: "white"; font: parent.font; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                }
            }

            RowLayout {
                Layout.fillWidth: true; Layout.fillHeight: true; spacing: 20

                ColumnLayout {
                    Layout.preferredWidth: 375; Layout.fillHeight: true; spacing: 10
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: page === "Favorites" ? "Favorites" : "Your Entries"; color: ink; font.pixelSize: 19; font.bold: true; Layout.fillWidth: true }
                        Text { text: visibleIndices().length + " items"; color: muted; font.pixelSize: 12 }
                    }
                    ListView {
                        id: entriesView
                        Layout.fillWidth: true; Layout.fillHeight: true
                        clip: true; spacing: 8
                        model: visibleIndices()
                        delegate: Rectangle {
                            required property int modelData
                            width: entriesView.width; height: 82; radius: 12
                            color: selected === modelData ? "#1c3551" : panel
                            border.color: selected === modelData ? "#2e6fb6" : "#202e3b"
                            RowLayout {
                                anchors.fill: parent; anchors.margins: 12; spacing: 12
                                Rectangle {
                                    width: 46; height: 46; radius: 12
                                    color: ["#e9eff7", "#20262e", "#465de8", "#103c2d", "#f05a28", "#28242a"][modelData % 6]
                                    Text { anchors.centerIn: parent; text: symbolFor(vaultEntries.get(modelData).site); color: modelData % 6 === 0 ? "#17202a" : "white"; font.pixelSize: 20; font.bold: true }
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true; spacing: 4
                                    Text { text: vaultEntries.get(modelData).site; color: ink; font.pixelSize: 15; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: vaultEntries.get(modelData).username; color: muted; font.pixelSize: 12; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                                ToolButton {
                                    text: vaultEntries.get(modelData).favorite ? "★" : "☆"
                                    font.pixelSize: 20
                                    palette.buttonText: vaultEntries.get(modelData).favorite ? "#f5c65b" : "#71869e"
                                    onClicked: vaultEntries.setProperty(modelData, "favorite", !vaultEntries.get(modelData).favorite)
                                }
                            }
                            TapHandler { onTapped: { selected = modelData; reveal = false } }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: 15
                    color: panel; border.color: "#202e3b"
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 23; spacing: 17
                        RowLayout {
                            Layout.fillWidth: true; spacing: 14
                            Rectangle {
                                width: 60; height: 60; radius: 16; color: "#e9eff7"
                                Text { anchors.centerIn: parent; text: selected >= 0 && selected < vaultEntries.count ? symbolFor(vaultEntries.get(selected).site) : "V"; color: "#18232e"; font.pixelSize: 27; font.bold: true }
                            }
                            ColumnLayout {
                                Layout.fillWidth: true; spacing: 4
                                Text { text: selected >= 0 && selected < vaultEntries.count ? vaultEntries.get(selected).site : "Select an entry"; color: ink; font.pixelSize: 22; font.bold: true }
                                Text { text: selected >= 0 && selected < vaultEntries.count ? vaultEntries.get(selected).category + " Account" : "Choose an account from the list"; color: muted; font.pixelSize: 13 }
                            }
                            ToolButton {
                                visible: selected >= 0 && selected < vaultEntries.count
                                text: selected >= 0 && selected < vaultEntries.count && vaultEntries.get(selected).favorite ? "★" : "☆"
                                font.pixelSize: 22; palette.buttonText: "#f5c65b"
                                onClicked: vaultEntries.setProperty(selected, "favorite", !vaultEntries.get(selected).favorite)
                            }
                            ToolButton { visible: selected >= 0 && selected < vaultEntries.count; text: "⋮"; font.pixelSize: 23; onClicked: actionsMenu.open()
                                Menu { id: actionsMenu
                                    MenuItem { text: "Edit entry"; onTriggered: startEntryDialog(true) }
                                    MenuItem { text: "Delete entry"; onTriggered: deleteDialog.open() }
                                }
                            }
                        }
                        Rectangle {
                            Layout.fillWidth: true; Layout.fillHeight: true; radius: 13
                            color: "#121b24"; border.color: line
                            visible: selected >= 0 && selected < vaultEntries.count
                            ColumnLayout {
                                anchors.fill: parent; anchors.margins: 18; spacing: 0
                                Text { text: "USERNAME"; color: muted; font.pixelSize: 10; font.letterSpacing: 1 }
                                RowLayout {
                                    Layout.fillWidth: true; Layout.topMargin: 6
                                    Text { text: selected >= 0 && selected < vaultEntries.count ? vaultEntries.get(selected).username : ""; color: ink; font.pixelSize: 15; Layout.fillWidth: true }
                                    ToolButton {
                                        text: "▢"
                                        onClicked: {
                                            noticeDialog.message = "Clipboard integration is a TODO for Python."
                                            noticeDialog.open()
                                        }
                                    }
                                }
                                Rectangle { Layout.fillWidth: true; height: 1; color: line; Layout.topMargin: 6; Layout.bottomMargin: 13 }
                                Text { text: "PASSWORD"; color: muted; font.pixelSize: 10; font.letterSpacing: 1 }
                                RowLayout {
                                    Layout.fillWidth: true; Layout.topMargin: 6
                                    Text { Layout.fillWidth: true; text: selected >= 0 && selected < vaultEntries.count ? (reveal ? vaultEntries.get(selected).password : "•".repeat(vaultEntries.get(selected).password.length)) : ""; color: ink; font.pixelSize: 15 }
                                    ToolButton { text: reveal ? "◉" : "◎"; onClicked: reveal = !reveal }
                                    ToolButton {
                                        text: "▢"
                                        onClicked: {
                                            noticeDialog.message = "Clipboard integration is a TODO for Python."
                                            noticeDialog.open()
                                        }
                                    }
                                }
                                Rectangle { Layout.fillWidth: true; height: 1; color: line; Layout.topMargin: 6; Layout.bottomMargin: 13 }
                                Text { text: "WEBSITE"; color: muted; font.pixelSize: 10; font.letterSpacing: 1 }
                                RowLayout {
                                    Layout.fillWidth: true; Layout.topMargin: 6
                                    Text { Layout.fillWidth: true; text: selected >= 0 && selected < vaultEntries.count ? vaultEntries.get(selected).website : ""; color: "#72b4ff"; font.pixelSize: 14; elide: Text.ElideRight }
                                    ToolButton {
                                        text: "▢"
                                        onClicked: {
                                            noticeDialog.message = "Clipboard integration is a TODO for Python."
                                            noticeDialog.open()
                                        }
                                    }
                                }
                                Rectangle { Layout.fillWidth: true; height: 1; color: line; Layout.topMargin: 6; Layout.bottomMargin: 13 }
                                Text { text: "NOTES"; color: muted; font.pixelSize: 10; font.letterSpacing: 1 }
                                Text { Layout.fillWidth: true; Layout.fillHeight: true; Layout.topMargin: 6; text: selected >= 0 && selected < vaultEntries.count ? vaultEntries.get(selected).notes : ""; color: "#c2cfdd"; font.pixelSize: 14; wrapMode: Text.WordWrap }
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true; visible: selected >= 0 && selected < vaultEntries.count; spacing: 12
                            Button {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 45
                                text: "Copy Username"
                                onClicked: {
                                    noticeDialog.message = "Clipboard integration is a TODO for Python."
                                    noticeDialog.open()
                                }
                                background: Rectangle { radius: 9; color: panel2; border.color: line }
                                contentItem: Text {
                                    text: parent.text
                                    color: ink
                                    font: parent.font
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                            Button {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 45
                                text: "Copy Password"
                                onClicked: {
                                    noticeDialog.message = "Clipboard integration is a TODO for Python."
                                    noticeDialog.open()
                                }
                                background: Rectangle { radius: 9; color: panel2; border.color: line }
                                contentItem: Text {
                                    text: parent.text
                                    color: ink
                                    font: parent.font
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                        }
                        Button {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 45
                            visible: selected >= 0 && selected < vaultEntries.count
                            text: "✎   Edit Entry"
                            onClicked: startEntryDialog(true)
                            background: Rectangle {
                                radius: 9
                                color: panel2
                                border.color: line
                            }
                            contentItem: Text {
                                text: parent.text
                                color: ink
                                font: parent.font
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }
            }
        }
    }

    Dialog {
        id: entryDialog
        modal: true; anchors.centerIn: parent; width: 440
        title: editIndex >= 0 ? "Edit Entry" : "Add Entry"
        standardButtons: Dialog.NoButton
        background: Rectangle { color: panel; radius: 14; border.color: line }
        contentItem: ColumnLayout {
            spacing: 11
            TextField { id: siteField; Layout.fillWidth: true; placeholderText: "Service / website name"; color: ink }
            TextField { id: usernameField; Layout.fillWidth: true; placeholderText: "Username or email"; color: ink }
            RowLayout { Layout.fillWidth: true
                TextField { id: passwordField; Layout.fillWidth: true; placeholderText: "Password"; color: ink; echoMode: TextInput.Password }
                Button { text: "Generate"; onClicked: passwordField.text = demoPassword(20) }
            }
            TextField { id: urlField; Layout.fillWidth: true; placeholderText: "Website URL"; color: ink }
            TextArea { id: notesField; Layout.fillWidth: true; placeholderText: "Notes"; color: ink; implicitHeight: 75; wrapMode: TextEdit.Wrap }
            RowLayout {
                Layout.fillWidth: true
                Item { Layout.fillWidth: true }
                Button { text: "Cancel"; onClicked: entryDialog.close() }
                Button {
                    text: editIndex >= 0 ? "Save Changes" : "Add Entry"
                    onClicked: {
                        if (!siteField.text.trim() || !usernameField.text.trim() || !passwordField.text) { validationDialog.open(); return }
                        if (editIndex >= 0) {
                            vaultEntries.setProperty(editIndex, "site", siteField.text)
                            vaultEntries.setProperty(editIndex, "username", usernameField.text)
                            vaultEntries.setProperty(editIndex, "password", passwordField.text)
                            vaultEntries.setProperty(editIndex, "website", urlField.text)
                            vaultEntries.setProperty(editIndex, "notes", notesField.text)
                            selected = editIndex
                        } else {
                            vaultEntries.append({site:siteField.text, username:usernameField.text, password:passwordField.text, website:urlField.text, notes:notesField.text, favorite:false, category:"Personal"})
                            selected = vaultEntries.count - 1
                        }
                        entryDialog.close()
                    }
                    background: Rectangle { radius: 8; color: blue }
                }
            }
        }
    }

    Dialog {
        id: generatorDialog
        modal: true; anchors.centerIn: parent; title: "Password Generator"; standardButtons: Dialog.NoButton
        background: Rectangle { color: panel; radius: 14; border.color: line }
        contentItem: ColumnLayout {
            spacing: 12
            Text { text: "Generate a strong password"; color: ink; font.pixelSize: 18; font.bold: true }
            RowLayout { Layout.fillWidth: true
                Text { text: "Length"; color: muted }
                Slider { id: passLength; from: 6; to: 64; value: 20; stepSize: 1; Layout.fillWidth: true }
                Text { text: Math.round(passLength.value); color: ink }
            }
            TextField { id: generatedPassword; Layout.fillWidth: true; readOnly: true; color: ink; text: demoPassword(20); selectByMouse: true }
            RowLayout { Layout.fillWidth: true
                Button { text: "Regenerate"; onClicked: generatedPassword.text = demoPassword(Math.round(passLength.value)) }
                Item { Layout.fillWidth: true }
                Button { text: "Close"; onClicked: generatorDialog.close() }
            }
            Text { text: "Prototype only: replace this demo generator with your Python secrets-based function."; color: "#e7bd69"; font.pixelSize: 11; wrapMode: Text.WordWrap }
        }
    }

    Dialog {
        id: settingsDialog; modal: true; anchors.centerIn: parent; title: "Settings"; standardButtons: Dialog.Ok
        background: Rectangle { color: panel; radius: 14; border.color: line }
        contentItem: Text { text: "Frontend prototype. Connect storage, auto-lock, and security settings through Python."; color: ink; wrapMode: Text.WordWrap }
    }
    Dialog {
        id: lockDialog; modal: true; anchors.centerIn: parent; title: "Lock Vault"; standardButtons: Dialog.Yes | Dialog.No
        background: Rectangle { color: panel; radius: 14; border.color: line }
        contentItem: Text { text: "Locking is not connected in this UI prototype yet."; color: ink; wrapMode: Text.WordWrap }
    }
    Dialog {
        id: deleteDialog; modal: true; anchors.centerIn: parent; title: "Delete Entry"; standardButtons: Dialog.Yes | Dialog.No
        background: Rectangle { color: panel; radius: 14; border.color: line }
        contentItem: Text { text: "Delete this entry from the in-memory demo list?"; color: ink }
        onAccepted: { if (selected >= 0 && selected < vaultEntries.count) { vaultEntries.remove(selected); selected = Math.min(selected, vaultEntries.count - 1) } }
    }
    Dialog {
        id: validationDialog; modal: true; anchors.centerIn: parent; title: "Required fields"; standardButtons: Dialog.Ok
        background: Rectangle { color: panel; radius: 14; border.color: line }
        contentItem: Text { text: "Service, username, and password are required."; color: ink }
    }
    Dialog {
        id: noticeDialog; property string message: ""; modal: true; anchors.centerIn: parent; title: "Integration placeholder"; standardButtons: Dialog.Ok
        background: Rectangle { color: panel; radius: 14; border.color: line }
        contentItem: Text { text: noticeDialog.message; color: ink; wrapMode: Text.WordWrap }
    }
}
