import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../theme"

PanelWindow {
    id: bar
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: Theme.barHeight
    exclusiveZone: Theme.barHeight
    color: "transparent"
    WlrLayershell.namespace: "quickshell:bar"
    Rectangle {
        anchors.fill: parent
        color: Theme.crust
        RowLayout {
            anchors {
                left: parent.left
                leftMargin: 12
                verticalCenter: parent.verticalCenter
            }
            spacing: 14
            Workspaces {
                barScreen: bar.screen
            }
            Text {
                Layout.maximumWidth: 420
                text: {
                    const t = Hyprland.activeToplevel?.title ?? "";
                    return t.length > 60 ? t.slice(0, 60) + "…" : t;
                }
                color: Theme.subtext0
                font.family: Theme.font
                font.pointSize: 9
                elide: Text.ElideRight
            }
        }
        Clock {
            anchors.centerIn: parent
            barScreen: bar.screen
        }
        RowLayout {
            anchors {
                right: parent.right
                rightMargin: 12
                verticalCenter: parent.verticalCenter
            }
            spacing: 14
            Tray {}
            MediaPlayer {}
            SystemStats {
                barScreen: bar.screen
            }
            KeyboardLayout {}
            Network {
                barScreen: bar.screen
            }
            Volume {}
            Battery {}
            UpdateChecker {}
            PowerMenu {
                barScreen: bar.screen
            }
        }
    }
}
