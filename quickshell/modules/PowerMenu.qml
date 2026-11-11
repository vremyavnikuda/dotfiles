import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../theme"

Item {
    id: root
    property var barScreen: null
    property bool open: false
    implicitWidth: 22
    implicitHeight: 22
    IconImage {
        anchors.centerIn: parent
        implicitSize: 18
        source: Quickshell.iconPath("system-shutdown", "system-shutdown")
    }
    MouseArea {
        anchors.fill: parent
        onClicked: root.open = !root.open
    }
    PanelWindow {
        id: menu
        screen: root.barScreen
        anchors {
            top: true
            right: true
        }
        margins {
            top: Theme.barHeight + 8
            right: 12
        }
        implicitWidth: 220
        implicitHeight: menuCol.implicitHeight + 16
        visible: root.open
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "quickshell:powermenu"
        Rectangle {
            anchors.fill: parent
            radius: 12
            color: Theme.base
            border.color: Theme.surface1
            border.width: 1
            ColumnLayout {
                id: menuCol
                anchors.fill: parent
                anchors.margins: 8
                spacing: 2
                Repeater {
                    model: [
                        { icon: "system-lock-screen", label: "Блокировать", cmd: ["hyprlock"], danger: false },
                        { icon: "system-log-out", label: "Выйти", cmd: ["hyprctl", "dispatch", "hl.dsp.exit()"], danger: false },
                        { icon: "system-reboot", label: "Перезагрузка", cmd: ["systemctl", "reboot"], danger: false },
                        { icon: "system-shutdown", label: "Выключение", cmd: ["systemctl", "poweroff"], danger: true },
                    ]
                    delegate: Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        height: 36
                        radius: 8
                        color: itemMa.containsMouse ? Theme.surface0 : "transparent"
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            spacing: 10
                            IconImage {
                                implicitSize: 18
                                source: Quickshell.iconPath(modelData.icon, "dialog-information")
                            }
                            Text {
                                text: modelData.label
                                color: modelData.danger ? Theme.red : Theme.text
                                font.family: Theme.font
                                font.pointSize: 10
                            }
                        }
                        MouseArea {
                            id: itemMa
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                Quickshell.execDetached(modelData.cmd);
                                root.open = false;
                            }
                        }
                    }
                }
            }
        }
    }
}
