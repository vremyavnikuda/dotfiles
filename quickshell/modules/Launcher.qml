import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

PanelWindow {
    id: win
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
        top: win.screen ? Math.round((win.screen.height - win.implicitHeight) / 2) : 140
    }
    implicitWidth: 620
    implicitHeight: 480
    visible: false
    focusable: true
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "quickshell:launcher"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    property string query: ""
    property var results: win.filteredApps()
    function toggle() {
        win.visible = !win.visible;
        if (win.visible) {
            win.query = "";
            searchField.text = "";
            listView.currentIndex = 0;
            searchField.forceActiveFocus();
        }
    }
    function filteredApps() {
        const q = win.query.trim().toLowerCase();
        const apps = Array.from(DesktopEntries.applications.values);
        if (!q)
            return apps.slice(0, 40);
        const scored = [];
        for (const app of apps) {
            const name = (app.name ?? "").toLowerCase();
            let score = -1;
            if (name.startsWith(q))
                score = 0;
            else if (name.includes(q))
                score = 1;
            else if ((app.genericName ?? "").toLowerCase().includes(q))
                score = 2;
            else if (Array.from(app.keywords ?? []).some(k => k.toLowerCase().includes(q)))
                score = 3;
            if (score >= 0)
                scored.push([score, name, app]);
        }
        scored.sort((a, b) => a[0] - b[0] || a[1].localeCompare(b[1]));
        return scored.map(s => s[2]).slice(0, 40);
    }
    Rectangle {
        anchors.fill: parent
        radius: 16
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
                placeholderText: "Поиск приложений…"
                placeholderTextColor: Theme.overlay0
                color: Theme.text
                font.family: Theme.font
                font.pointSize: 12
                selectedTextColor: Theme.crust
                selectionColor: Theme.lavender
                cursorVisible: true
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
                Keys.onEnterPressed: listView.launchCurrent()
                Keys.onReturnPressed: listView.launchCurrent()
            }
            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: win.results
                currentIndex: 0
                function launchCurrent() {
                    const app = win.results[currentIndex];
                    if (app) {
                        app.execute();
                        win.visible = false;
                    }
                }
                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    width: listView.width
                    height: 44
                    radius: 8
                    color: index === listView.currentIndex ? Theme.surface0 : "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        spacing: 12
                        IconImage {
                            implicitSize: 26
                            source: Quickshell.iconPath(modelData.icon, "application-x-executable")
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            Text {
                                Layout.fillWidth: true
                                text: modelData.name
                                color: Theme.text
                                font.family: Theme.font
                                font.pointSize: 10
                                elide: Text.ElideRight
                            }
                            Text {
                                Layout.fillWidth: true
                                text: modelData.genericName ?? ""
                                color: Theme.subtext0
                                font.family: Theme.font
                                font.pointSize: 8
                                elide: Text.ElideRight
                                visible: text.length > 0
                            }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: listView.currentIndex = index
                        onClicked: {
                            listView.currentIndex = index;
                            listView.launchCurrent();
                        }
                    }
                }
                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }
            }
        }
    }
}
