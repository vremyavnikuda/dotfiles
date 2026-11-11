import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../theme"

PanelWindow {
    id: menu
    property var barScreen: null
    property var workspace: null
    property bool pinned: false // мышь внутри меню — не закрывать
    readonly property var windows: workspace?.toplevels?.values ?? []
    function showFor(ws) {
        workspace = ws;
        hideTimer.stop();
        if (windows.length > 0)
            visible = true;
    }
    function scheduleHide() {
        hideTimer.restart();
    }
    Timer {
        id: hideTimer
        interval: 300
        onTriggered: if (!menu.pinned) menu.visible = false
    }
    screen: barScreen
    anchors {
        top: true
        left: true
    }
    margins {
        top: Theme.barHeight + 6
        left: 12
    }
    implicitWidth: 300
    implicitHeight: menuCol.implicitHeight + 16
    visible: false
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "quickshell:workspacemenu"
    onVisibleChanged: if (!visible) workspace = null
    Rectangle {
        anchors.fill: parent
        radius: 8
        color: Theme.base
        border.color: Theme.surface1
        border.width: 1
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: menu.pinned = true
            onExited: {
                menu.pinned = false;
                menu.scheduleHide();
            }
        }
        ColumnLayout {
            id: menuCol
            anchors.fill: parent
            anchors.margins: 8
            spacing: 2
            Text {
                Layout.fillWidth: true
                Layout.leftMargin: 6
                text: "Воркспейс " + (menu.workspace?.name ?? "") + " — " + menu.windows.length + " ок."
                color: Theme.subtext0
                font.family: Theme.font
                font.pointSize: 8
            }
            Repeater {
                model: menu.windows
                delegate: Rectangle {
                    id: winRow
                    required property var modelData
                    Layout.fillWidth: true
                    height: 32
                    radius: 6
                    color: rowMa.containsMouse ? Theme.surface0 : "transparent"
                    readonly property string winClass: modelData.lastIpcObject?.class ?? ""
                    readonly property var entry: DesktopEntries.heuristicLookup(winClass)
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        spacing: 8
                        IconImage {
                            implicitSize: 16
                            source: Quickshell.iconPath(winRow.entry?.icon ?? "application-x-executable", "application-x-executable")
                        }
                        Text {
                            Layout.fillWidth: true
                            text: modelData.title ?? ""
                            color: Theme.text
                            font.family: Theme.font
                            font.pointSize: 9
                            elide: Text.ElideRight
                        }
                    }
                    MouseArea {
                        id: rowMa
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            Hyprland.dispatch(`hl.dsp.focus({window = "address:${modelData.address}"})`);
                            menu.visible = false;
                        }
                    }
                }
            }
        }
    }
}
