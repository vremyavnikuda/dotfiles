import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../theme"

Item {
    id: root
    property var barScreen: null
    implicitWidth: chipRow.implicitWidth
    implicitHeight: chipRow.implicitHeight
    property var updates: []
    visible: root.updates.length > 0 || updPopup.visible
    Timer {
        interval: 1800000 // 30 минут
        running: true
        repeat: true
        onTriggered: if (!updProc.running) updProc.running = true
    }
    Process {
        id: updProc
        command: ["checkupdates"]
        running: true
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                root.updates = this.text.trim().split("\n").filter(l => l.length > 0);
            }
        }
    }
    RowLayout {
        id: chipRow
        spacing: 5
        IconImage {
            implicitSize: 16
            source: Quickshell.iconPath("system-software-update", "system-software-update")
        }
        Text {
            text: root.updates.length
            color: Theme.yellow
            font.family: Theme.font
            font.pointSize: 9
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: updPopup.visible = !updPopup.visible
    }
    PanelWindow {
        id: updPopup
        screen: root.barScreen
        anchors {
            top: true
            right: true
        }
        margins {
            top: Theme.barHeight + 8
            right: 12
        }
        implicitWidth: 380
        implicitHeight: updCol.implicitHeight + 24
        visible: false
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        focusable: true
        WlrLayershell.namespace: "quickshell:updates"
        Rectangle {
            anchors.fill: parent
            radius: 12
            color: Theme.base
            border.color: Theme.surface1
            border.width: 1
            focus: true
            Keys.onEscapePressed: updPopup.visible = false
            ColumnLayout {
                id: updCol
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8
                Text {
                    Layout.fillWidth: true
                    text: "Доступно обновлений: " + root.updates.length
                    color: Theme.text
                    font.family: Theme.font
                    font.pointSize: 10
                    font.bold: true
                }
                ListView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.min(contentHeight, 300)
                    clip: true
                    model: root.updates
                    delegate: Text {
                        required property string modelData
                        width: ListView.view.width
                        text: modelData
                        color: Theme.subtext0
                        font.family: Theme.font
                        font.pointSize: 8
                        elide: Text.ElideRight
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 30
                    radius: 6
                    color: updMa.containsMouse ? Theme.blue : Theme.lavender
                    Text {
                        anchors.centerIn: parent
                        text: "Обновить систему"
                        color: Theme.crust
                        font.family: Theme.font
                        font.pointSize: 9
                    }
                    MouseArea {
                        id: updMa
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            Quickshell.execDetached(["kitty", "sh", "-c", "sudo pacman -Syu; echo; read -p 'Enter to close'"]);
                            updPopup.visible = false;
                        }
                    }
                }
            }
        }
    }
}
