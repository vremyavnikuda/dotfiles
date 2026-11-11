import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

PanelWindow {
    id: win
    property string query: ""
    property var items: []
    property var filtered: []
    onQueryChanged: win.filtered = win.applyFilter()
    function applyFilter() {
        const q = win.query.trim().toLowerCase();
        if (!q)
            return win.items;
        return win.items.filter(it => it.display.toLowerCase().includes(q));
    }
    function toggle() {
        win.visible = !win.visible;
        if (win.visible) {
            win.query = "";
            searchField.text = "";
            listProc.running = true;
            searchField.forceActiveFocus();
        }
    }
    function paste(index) {
        const item = win.filtered[index];
        if (item) {
            pasteProc.fullIndex = item.fullIndex;
            pasteProc.running = true;
            win.visible = false;
        }
    }
    property var focusedScreen: {
        const fm = Hyprland.focusedMonitor;
        if (!fm)
            return null;
        for (const s of Quickshell.screens) {
            if (s.name === fm.name)
                return s;
        }
        return null;
    }
    screen: focusedScreen
    anchors {
        top: true
    }
    margins {
        top: 140
    }
    implicitWidth: 560
    implicitHeight: 440
    visible: false
    focusable: true
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "quickshell:clipboard"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    Process {
        id: listProc
        command: ["cliphist", "list"]
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                const lines = this.text.split("\n");
                const arr = [];
                lines.forEach((l, i) => {
                    if (!l || l.length === 0)
                        return;
                    const isImage = /[\x00-\x08\x0e-\x1f]/.test(l);
                    arr.push({
                        fullIndex: i + 1,
                        display: isImage ? "[изображение]" : l.replace(/[\x00-\x1f]/g, " ").slice(0, 120),
                        isImage: isImage
                    });
                });
                win.items = arr;
                win.filtered = win.applyFilter();
            }
        }
    }
    Process {
        id: pasteProc
        property int fullIndex: 0
        command: ["sh", "-c", "cliphist list | sed -n '" + fullIndex + "p' | cliphist decode | wl-copy"]
    }
    Rectangle {
        anchors.fill: parent
        radius: 12
        color: Theme.base
        border.color: Theme.surface1
        border.width: 1
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10
            TextField {
                id: searchField
                Layout.fillWidth: true
                placeholderText: "Поиск по буферу…"
                placeholderTextColor: Theme.overlay0
                color: Theme.text
                font.family: Theme.font
                font.pointSize: 11
                selectedTextColor: Theme.crust
                selectionColor: Theme.lavender
                background: Rectangle {
                    radius: 8
                    color: Theme.surface0
                    border.color: searchField.activeFocus ? Theme.lavender : Theme.surface1
                    border.width: 1
                }
                onTextChanged: win.query = text
                Keys.onDownPressed: listView.incrementCurrentIndex()
                Keys.onUpPressed: listView.decrementCurrentIndex()
                Keys.onEscapePressed: win.visible = false
                Keys.onEnterPressed: win.paste(listView.currentIndex)
                Keys.onReturnPressed: win.paste(listView.currentIndex)
            }
            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: win.filtered
                currentIndex: 0
                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    width: listView.width
                    height: 32
                    radius: 6
                    color: index === listView.currentIndex ? Theme.surface0 : "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        spacing: 10
                        Text {
                            text: modelData.isImage ? "🖼" : "≡"
                            color: Theme.overlay0
                            font.family: Theme.font
                            font.pointSize: 10
                        }
                        Text {
                            Layout.fillWidth: true
                            text: modelData.display
                            color: Theme.text
                            font.family: Theme.font
                            font.pointSize: 9
                            elide: Text.ElideRight
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: listView.currentIndex = index
                        onClicked: win.paste(index)
                    }
                }
                Text {
                    anchors.centerIn: parent
                    visible: win.filtered.length === 0
                    text: "Буфер пуст или ничего не найдено"
                    color: Theme.overlay0
                    font.family: Theme.font
                    font.pointSize: 9
                }
            }
        }
    }
    IpcHandler {
        target: "clipboard"
        function toggle(): void {
            win.toggle();
        }
    }
}
